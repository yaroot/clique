--[[---------------------------------------------------------------------------------
  Clique by Cladhaire <cladhaire@gmail.com>
----------------------------------------------------------------------------------]]

Clique = {Locals = {}}

assert(DongleStub, string.format("Clique requires DongleStub."))
assert(DongleStub:GetVersion() == "DongleStub-Beta0", 
	string.format("Clique requires DongleStub-Beta0.  You are using an older version."))
assert(DongleStub("Dongle-Beta0"), 
	string.format("Clique requires Dongle-Beta0.  You are using an older version."))

DongleStub("Dongle-Beta0"):New("Clique", Clique)

local L = Clique.Locals

function Clique:Enable()
	-- Grab the localisation header
	L = Clique.Locals
	self.ooc = {}

	self.defaults = {
		profile = {
			clicksets = {
				[L.CLICKSET_DEFAULT] = {},
				[L.CLICKSET_HARMFUL] = {},
				[L.CLICKSET_HELPFUL] = {},
				[L.CLICKSET_OOC] = {},
			},
			blacklist = {
			},
		}
	}
	
	self.db = self:InitializeDB("CliqueDB", self.defaults)
	self.profile = self.db.profile
	self.clicksets = self.profile.clicksets

    self.editSet = self.clicksets[L.CLICKSET_DEFAULT]

	ClickCastFrames = ClickCastFrames or {}
	self.ccframes = ClickCastFrames

    local newindex = function(t,k,v)
		if v == nil then
			Clique:UnregisterFrame(k)
			rawset(self.ccframes, k, nil)
		else
			Clique:RegisterFrame(k)
			rawset(self.ccframes, k, v)
		end
    end
    
	ClickCastFrames = setmetatable({}, {__newindex=newindex})

    Clique:OptionsOnLoad()
    Clique:EnableFrames()

	-- Register for dongle events
	self:RegisterMessage("DONGLE_PROFILE_CHANGED")
	self:RegisterMessage("DONGLE_PROFILE_DELETED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	self:UpdateClicks()

    -- Register all frames that snuck in before we did =)
    for frame in pairs(self.ccframes) do
		self:RegisterFrame(frame)
    end

    -- Securehook CreateFrame to catch any new raid frames
    local raidFunc = function(type, name, parent, template)
		if template == "RaidPulloutButtonTemplate" then
			ClickCastFrames[getglobal(name.."ClearButton")] = true
		end
	end
		 
    hooksecurefunc("CreateFrame", raidFunc)
end

function Clique:EnableFrames()
    local tbl = {
		PlayerFrame,
		PetFrame,
		PartyMemberFrame1,
		PartyMemberFrame2,
		PartyMemberFrame3,
		PartyMemberFrame4,
		PartyMemberFrame1PetFrame,
		PartyMemberFrame2PetFrame,
		PartyMemberFrame3PetFrame,
		PartyMemberFrame4PetFrame,
		TargetFrame,
		TargetofTargetFrame,
    }
    
    for i,frame in pairs(tbl) do
		rawset(self.ccframes, frame, true)
    end
end	   

function Clique:SpellBookButtonPressed()
    local id = SpellBook_GetSpellID(this:GetParent():GetID());
    local texture = GetSpellTexture(id, SpellBookFrame.bookType)
    local name, rank = GetSpellName(id, SpellBookFrame.bookType)
	    
    if rank == L.RACIAL_PASSIVE or rank == L.PASSIVE then
		StaticPopup_Show("CLIQUE_PASSIVE_SKILL")
		return
    else
		rank = select(3, string.find(rank, L.RANK_PATTERN))
		if rank then rank = tonumber(rank) end
    end
    
    local type = "spell"
	local button

	if self.editSet == self.clicksets[L.CLICKSET_HARMFUL] then
		button = string.format("%s%d", "harmbutton", self:GetButtonNumber())
	elseif self.editSet == self.clicksets[L.CLICKSET_HELPFUL] then
		button = string.format("%s%d", "helpbutton", self:GetButtonNumber())
	else
		button = self:GetButtonNumber()
	end
    
    -- Build the structure
    local t = {
		["button"] = button,
		["modifier"] = self:GetModifierText(),
		["texture"] = GetSpellTexture(id, SpellBookFrame.bookType),
		["type"] = type,
		["arg1"] = name,
		["arg2"] = rank,
    }
    
    local key = t.modifier .. t.button
    
    if self:CheckBinding(key) then
		StaticPopup_Show("CLIQUE_BINDING_PROBLEM")
	return
    end
    
    self.editSet[key] = t
    self:ListScrollUpdate()
end

function Clique:PLAYER_REGEN_ENABLED()
	self:ApplyClickSet(L.CLICKSET_DEFAULT)
	self:RemoveClickSet(L.CLICKSET_HARMFUL)
	self:RemoveClickSet(L.CLICKSET_HELPFUL)
	self:ApplyClickSet(self.ooc, frame)
end

function Clique:PLAYER_REGEN_DISABLED()
	self:RemoveClickSet(self.ooc)
	self:ApplyClickSet(L.CLICKSET_DEFAULT)
	self:ApplyClickSet(L.CLICKSET_HARMFUL)
	self:ApplyClickSet(L.CLICKSET_HELPFUL)
end

function Clique:UpdateClicks()
	local ooc = self.clicksets[L.CLICKSET_OOC]
	local harm = self.clicksets[L.CLICKSET_HARMFUL]
	local help = self.clicksets[L.CLICKSET_HELPFUL]

	self.ooc = {}

	for modifier,entry in pairs(harm) do
		local button = string.gsub(entry.button, "harmbutton", "")
		button = string.gsub(button, "helpbutton", "")
		button = tonumber(button)
		local mask = false

		for k,v in pairs(ooc) do
			if button == v.button then
				mask = true
			end
		end

		if not mask then
			table.insert(self.ooc, entry)
		end
	end

	for modifier,entry in pairs(help) do
		local button = string.gsub(entry.button, "harmbutton", "")
		button = string.gsub(button, "helpbutton", "")
		button = tonumber(button)
		local mask = false

		for k,v in pairs(ooc) do
			if button == v.button then
				mask = true
			end
		end

		if not mask then
			table.insert(self.ooc, entry)
		end
	end

	for modifier,entry in pairs(ooc) do
		table.insert(self.ooc, entry)
	end
end

function Clique:RegisterFrame(frame)
	local name = frame:GetName()

	if self.profile.blacklist[name] then 
		rawset(self.ccframes, frame, false)
		return 
	end

	if not ClickCastFrames[frame] then 
		rawset(self.ccframes, frame, true)
		if CliqueTextListFrame then
			Clique:TextListScrollUpdate()
		end
	end

	frame:RegisterForClicks("AnyUp")

	if frame:CanChangeProtectedState() then
		if InCombatLockdown() then
			self:ApplyClickSet(L.CLICKSET_DEFAULT, frame)
			self:ApplyClickSet(L.CLICKSET_HOSTILE, frame)
			self:ApplyClickSet(L.CLICKSET_HARMFUL, frame)
		else
			self:ApplyClickSet(L.CLICKSET_DEFAULT, frame)
			self:ApplyClickSet(self.ooc, frame)
		end
	end
end

function Clique:ApplyClickSet(name, frame)
	if not self.clicksets then
		Clique:Print(name, frame, debugstack())
	end
	local set = self.clicksets[name] or name

	if frame then
		for modifier,entry in pairs(set) do
			self:SetAttribute(entry, frame)
		end
	else
		for modifier,entry in pairs(set) do
			self:SetAction(entry)
		end
	end					
end

function Clique:RemoveClickSet(name, frame)
	local set = self.clicksets[name] or name

	if frame then
		for modifier,entry in pairs(set) do
			self:DeleteAttribute(entry, frame)
		end
	else
		for modifier,entry in pairs(set) do
			self:DeleteAction(entry)
		end
	end					
end

function Clique:UnregisterFrame(frame)
	assert(not InCombatLockdown(), "An addon attempted to unregister a frame from Clique while in combat.")
	for name,set in pairs(self.clicksets) do
		for modifier,entry in pairs(set) do
			self:DeleteAttribute(entry, frame)
		end
	end
end

function Clique:DONGLE_PROFILE_CHANGED(event, db, parent, svname, profileKey)
	if db == self.db then
		self:PrintF(L.PROFILE_CHANGED, profileKey)

		for name,set in pairs(self.clicksets) do
			for modifier,entry in pairs(set) do
				self:DeleteAction(entry)
			end
		end

		self.profile = self.db.profile
		self.clicksets = self.profile.clicksets
		self.editSet = self.clicksets[L.CLICKSET_DEFAULT]
		self.profileKey = profileKey
	
		-- Refresh the profile editor if it exists
		self.textlistSelected = nil
		self:TextListScrollUpdate()
		self:ListScrollUpdate()

		for frame in pairs(self.ccframes) do
			self:RegisterFrame(frame)
		end
	end
end

function Clique:DONGLE_PROFILE_DELETED(event, db, parent, svname, profileKey)
	if db == self.db then
		self:PrintF(L.PROFILE_DELETED, profileKey)
	
		self.textlistSelected = nil
		self:TextListScrollUpdate()
		self:ListScrollUpdate()
	end
end

function Clique:SetAttribute(entry, frame)
	local name = frame:GetName()
	if	self.profile.blacklist and self.profile.blacklist[name] then
		return
	end

	-- Set up any special attributes
	local type,button,value

	if not tonumber(entry.button) then
		type,button = select(3, string.find(entry.button, "(%a+)button(%d+)"))
		frame:SetAttribute(entry.modifier..entry.button, type..button)
		assert(frame:GetAttribute(entry.modifier..entry.button, type..button))
		button = string.format("-%s%s", type, button)
	end

	button = button or entry.button

	if entry.type == "actionbar" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."action"..button, entry.arg1)		
	elseif entry.type == "action" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."action"..button, entry.arg1)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg2)
	elseif entry.type == "pet" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."action"..button, entry.arg1)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg2)
	elseif entry.type == "spell" then
		local rank = tonumber(entry.arg2)
		local cast = string.format(rank and L.CAST_FORMAT or "%s", entry.arg1, rank)
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."spell"..button, cast)

		frame:SetAttribute(entry.modifier.."bag"..button, entry.arg2)
		frame:SetAttribute(entry.modifier.."slot"..button, entry.arg3)
		frame:SetAttribute(entry.modifier.."item"..button, entry.arg4)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg5)
	elseif entry.type == "item" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."bag"..button, entry.arg1)
		frame:SetAttribute(entry.modifier.."slot"..button, entry.arg2)
		frame:SetAttribute(entry.modifier.."item"..button, entry.arg3)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg4)
	elseif entry.type == "macro" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."macro"..button, entry.arg1)
		frame:SetAttribute(entry.modifier.."macrotext"..button, entry.arg2)
	elseif entry.type == "stop" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
	elseif entry.type == "target" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg1)
	elseif entry.type == "focus" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg1)
	elseif entry.type == "assist" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."unit"..button, entry.arg1)
	elseif entry.type == "click" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
		frame:SetAttribute(entry.modifier.."clickbutton"..button, getglobal(entry.arg1))
	elseif entry.type == "menu" then
		frame:SetAttribute(entry.modifier.."type"..button, entry.type)
	end
end

function Clique:DeleteAttribute(entry, frame)
	local name = frame:GetName()
	if	self.profile.blacklist and self.profile.blacklist[name] then
		return
	end

	local type,button,value

	if not tonumber(entry.button) then
		type,button = select(3, string.find(entry.button, "(%a+)button(%d+)"))
		frame:SetAttribute(entry.modifier..entry.button, nil)
		button = string.format("-%s%s", type, button)
	end

	button = button or entry.button

	entry.delete = true

	frame:SetAttribute(entry.modifier.."type"..button, nil)
	frame:SetAttribute(entry.modifier..entry.type..button, nil)
end

function Clique:SetAction(entry)
	for frame,enabled in pairs(self.ccframes) do
		if enabled then
			self:SetAttribute(entry, frame)
		end
	end
end

function Clique:DeleteAction(entry)
	for frame in pairs(self.ccframes) do
		self:DeleteAttribute(entry, frame)
	end
end

local mods = {"Shift", "Ctrl", "Alt"}
local buttonsraw = {1,2,3,4,5}
local buttonmods = {"-help", "-harm"}

local buttons = {}
for idx,button in pairs(buttonsraw) do
	for k,v in pairs(buttonmods) do
		table.insert(buttons, v..button)
	end
end
for k,v in pairs(buttonsraw) do
	table.insert(buttons, v)
end

--collectgarbage("setpause", 100)
--collectgarbage("setstepmul", 2000)

--[[
local tbl = {}

local min 
local max
local elapsed = 0
local frame = CreateFrame("Frame", "gctest")
frame:SetScript("OnUpdate", function(f, t)
	elapsed = elapsed + t
	if elapsed >= 0.3 then
		local count = collectgarbage("count")
		if not min then
			min = count
			max = count
		end
	
		if count > max then max = count end
		if count < min then min = count end
		Clique:Print(string.format("%2.f (min %2.f, max %2.f)", count, min, max), count < max and "Cycle" or "")
		elapsed = 0
		for i=1,500 do
			table.insert(tbl, {1,2,3,4,5})
		end
		tbl = {}
	end
end)
--]]

-- pause, mul
-- 100,200
-- min: 16096
-- max: 20993
-- cycle: 19794

-- 100,500
-- min: 16096
-- max: 18292
-- cycle: 16500

-- 100,1000
-- min: 16095
-- max: 17225
-- cycle: 16500

-- 100,2000
-- min: 16095
-- max: 16722
-- cycle: 16300

-- Default Settings
-- min: 16095
-- max: 36114
-- cycle: 18600

-- 100 pause, default mult
-- min: 16095
-- max: 20052
-- cycle: 17857