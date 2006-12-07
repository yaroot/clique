local L = Clique.Locals

local NUM_ENTRIES = 10
local ENTRY_SIZE = 35
local work = {}

function Clique:OptionsOnLoad()
    -- Create a set of buttons to hook the SpellbookFrame
    self.spellbuttons = {}
    local onclick = function() Clique:SpellBookButtonPressed() end
    local onleave = function()
        this.updateTooltip = nil
        GameTooltip:Hide()
    end
	
	self.special = CreateFrame("Frame", UIParent)
	self.special:SetFrameStrata("DIALOG")
	self.special:SetHeight(32)
	self.special:SetWidth(32)
	self.special.texture = self.special:CreateTexture("ARTWORK")
	self.special.texture:SetTexture("Interface\\AddOns\\Clique\\Images\\myborder")
	self.special.texture:SetAllPoints()
	self.special:SetAlpha(1.0)

	CreateFrame("Button", "CliqueSpecialButton")
	
	CliqueSpecialButton:SetScript("OnClick", function()
		if not self.sequence then self.sequence = 1 end
		ClearOverrideBindings(CliqueSpecialButton)
		if self.sequence == 1 then
			SetOverrideBindingClick(CliqueSpecialButton, true, "O", "CliqueSpecialButton")
		elseif self.sequence == 2 then
			SetOverrideBindingClick(CliqueSpecialButton, true, "L", "CliqueSpecialButton")
		elseif self.sequence == 3 then
			SetOverrideBindingClick(CliqueSpecialButton, true, "E", "CliqueSpecialButton")
		elseif self.sequence == 4 then
			self:Print("Special mode activated")
			for k,v in pairs(self.ccframes) do
				k:SetScript("PostClick", function()
					self.special:SetPoint("CENTER", k, "CENTER", 0, 0)
				end)
			end		
		end
		self.sequence = self.sequence + 1
	end)

    for i=1,12 do
        local parent = getglobal("SpellButton"..i)
        local button = CreateFrame("Button", nil, parent)
        button:SetID(parent:GetID())
        button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        button:RegisterForClicks("LeftButtonUp","RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
        button:SetAllPoints(parent)
        button:SetScript("OnClick", onclick)
        button:SetScript("OnEnter", SpellButton_OnEnter)
        button:SetScript("OnLeave", onleave)
		button:Hide()
        self.spellbuttons[i] = button
    end

    CreateFrame("CheckButton", "CliquePulloutTab", SpellBookFrame, "SpellBookSkillLineTabTemplate")
    CliquePulloutTab:SetNormalTexture("Interface\\AddOns\\Clique\\Images\\CliqueIcon")
    CliquePulloutTab:SetScript("OnClick", function() Clique:Toggle() end)
    CliquePulloutTab:SetScript("OnEnter", function() local i = 1 end)
    CliquePulloutTab:SetScript("OnShow", function()
		Clique.inuse = nil
        for k,v in pairs(self.clicksets) do
            if next(v) then
                Clique.inuse = true
            end
        end
        if not Clique.inuse then
            CliqueFlashFrame.texture:Show()
            UIFrameFlash(CliqueFlashFrame, 0.5, 0.5, 30, nil)
        end
    end)
   
    local frame = CreateFrame("Frame", "CliqueFlashFrame", CliquePulloutTab)
    frame:SetWidth(10) frame:SetHeight(10)
    frame:SetPoint("CENTER", 0, 0)
            
    local texture = frame:CreateTexture(nil, "OVERLAY")
    texture:SetTexture("Interface\\Buttons\\CheckButtonGlow")
    texture:SetHeight(64) texture:SetWidth(64)
    texture:SetPoint("CENTER", 0, 0)
    texture:Hide()
    CliqueFlashFrame.texture = texture

    CliquePulloutTab:Show()

    local num = GetNumSpellTabs()
    CliquePulloutTab:ClearAllPoints()
    CliquePulloutTab:SetPoint("TOPLEFT","SpellBookSkillLineTab"..(num),"BOTTOMLEFT",0,-17)			

	-- Hook the container buttons
	local containerFunc = function(button)
		if IsShiftKeyDown() and CliqueCustomArg1 then
			if CliqueCustomArg1:HasFocus() then
				CliqueCustomArg1:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
			elseif CliqueCustomArg2:HasFocus() then
				CliqueCustomArg2:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
			elseif CliqueCustomArg3:HasFocus() then
				CliqueCustomArg3:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
			elseif CliqueCustomArg4:HasFocus() then
				CliqueCustomArg4:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
			elseif CliqueCustomArg5:HasFocus() then
				CliqueCustomArg5:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
			end
		end
	end

	hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", containerFunc)

	-- Hook the bank buttons
	local bankFunc = function(button)
		if IsShiftKeyDown() and CliqueCustomArg1 then
			if CliqueCustomArg1:HasFocus() then
				CliqueCustomArg1:Insert(GetContainerItemLink(BANK_CONTAINER, this:GetID()))
			elseif CliqueCustomArg2:HasFocus() then
				CliqueCustomArg2:Insert(GetContainerItemLink(BANK_CONTAINER, this:GetID()))
			elseif CliqueCustomArg3:HasFocus() then
				CliqueCustomArg3:Insert(GetContainerItemLink(BANK_CONTAINER, this:GetID()))
			elseif CliqueCustomArg4:HasFocus() then
				CliqueCustomArg4:Insert(GetContainerItemLink(BANK_CONTAINER, this:GetID()))
			elseif CliqueCustomArg5:HasFocus() then
				CliqueCustomArg5:Insert(GetContainerItemLink(BANK_CONTAINER, this:GetID()))
			end
		end
	end

	hooksecurefunc("BankFrameItemButtonGeneric_OnModifiedClick", bankFunc)

	-- Hook the paper doll frame buttons
	local dollFunc = function(button)
		if IsShiftKeyDown() and CliqueCustomArg1 then
			if CliqueCustomArg1:HasFocus() then
				CliqueCustomArg1:Insert(GetInventoryItemLink("player", this:GetID()))
			elseif CliqueCustomArg2:HasFocus() then
				CliqueCustomArg2:Insert(GetInventoryItemLink("player", this:GetID()))
			elseif CliqueCustomArg3:HasFocus() then
				CliqueCustomArg3:Insert(GetInventoryItemLink("player", this:GetID()))
			elseif CliqueCustomArg4:HasFocus() then
				CliqueCustomArg4:Insert(GetInventoryItemLink("player", this:GetID()))
			elseif CliqueCustomArg5:HasFocus() then
				CliqueCustomArg5:Insert(GetInventoryItemLink("player", this:GetID()))
			end
		end
	end
	hooksecurefunc("PaperDollItemSlotButton_OnModifiedClick", dollFunc)		
end

function Clique:ToggleSpellBookButtons()
   local method = CliqueFrame:IsVisible() and "Show" or "Hide"
   local buttons = self.spellbuttons
   for i=1,12 do
      buttons[i][method](buttons[i])
   end
end

function Clique:Toggle()
    if not CliqueFrame then
        Clique:CreateOptionsFrame()
		CliqueFrame:Hide()
		CliqueFrame:Show()
		SetOverrideBindingClick(CliqueSpecialButton, true, "M", "CliqueSpecialButton")
		CliqueFrame:SetScript("OnHide", function()
			ClearOverrideBindings(CliqueSpecialButton)
		end)			
	else
        if CliqueFrame:IsVisible() then
            CliqueFrame:Hide()
			CliquePulloutTab:SetChecked(nil)
        else
            CliqueFrame:Show()
			CliquePulloutTab:SetChecked(true)
			SetOverrideBindingClick(CliqueSpecialButton, true, "M", "CliqueSpecialButton")
        end
    end    

    Clique:ToggleSpellBookButtons()
    self:ListScrollUpdate()
end

-- This code is contributed with permission from Beladona
local ondragstart = function()
	this:GetParent():StartMoving()
end

local ondragstop = function()
	this:GetParent():StopMovingOrSizing()
	this:GetParent():SetUserPlaced()
end

function Clique:SkinFrame(frame)
	frame:SetBackdrop({
		bgFile = "Interface\\AddOns\\Clique\\images\\backdrop.tga", 
		edgeFile = "Interface\\AddOns\\Clique\\images\\borders.tga", tile = true,
		tileSize = 32, edgeSize = 16, 
		insets = {left = 16, right = 16, top = 16, bottom = 16}
	});

	frame:EnableMouse()
	frame:SetClampedToScreen(true)

	frame.titleBar = CreateFrame("Button", nil, frame)
	frame.titleBar:SetHeight(32)
	frame.titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	frame.titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
	frame:SetMovable(true)
	frame:SetFrameStrata("MEDIUM")
	frame.titleBar:RegisterForDrag("LeftButton")
	frame.titleBar:SetScript("OnDragStart", ondragstart)
	frame.titleBar:SetScript("OnDragStop", ondragstop)

	frame.headerLeft = frame.titleBar:CreateTexture(nil, "ARTWORK");
	frame.headerLeft:SetTexture("Interface\\AddOns\\Clique\\images\\headCorner.tga");
	frame.headerLeft:SetWidth(32); frame.headerLeft:SetHeight(32);
	frame.headerLeft:SetPoint("TOPLEFT", 0, 0);

	frame.headerRight = frame.titleBar:CreateTexture(nil, "ARTWORK");
	frame.headerRight:SetTexture("Interface\\AddOns\\Clique\\images\\headCorner.tga");
	frame.headerRight:SetTexCoord(1,0,0,1);
	frame.headerRight:SetWidth(32); frame.headerRight:SetHeight(32);
	frame.headerRight:SetPoint("TOPRIGHT", 0, 0);

	frame.header = frame.titleBar:CreateTexture(nil, "ARTWORK");
	frame.header:SetTexture("Interface\\AddOns\\Clique\\images\\header.tga");
	frame.header:SetPoint("TOPLEFT", frame.headerLeft, "TOPRIGHT");
	frame.header:SetPoint("BOTTOMRIGHT", frame.headerRight, "BOTTOMLEFT");
		
	frame.title = frame.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
	frame.title:SetWidth(200); frame.title:SetHeight(16);
	frame.title:SetPoint("TOP", 0, -2);
		
	frame.footerLeft = frame:CreateTexture(nil, "ARTWORK");
	frame.footerLeft:SetTexture("Interface\\AddOns\\Clique\\images\\footCorner.tga");
	frame.footerLeft:SetWidth(48); frame.footerLeft:SetHeight(48);
	frame.footerLeft:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2);

	frame.footerRight = frame:CreateTexture(nil, "ARTWORK");
	frame.footerRight:SetTexture("Interface\\AddOns\\Clique\\images\\footCorner.tga");
	frame.footerRight:SetTexCoord(1,0,0,1);
	frame.footerRight:SetWidth(48); frame.footerRight:SetHeight(48);
	frame.footerRight:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);

	frame.footer = frame:CreateTexture(nil, "ARTWORK");
	frame.footer:SetTexture("Interface\\AddOns\\Clique\\images\\footer.tga");
	frame.footer:SetPoint("TOPLEFT", frame.footerLeft, "TOPRIGHT");
	frame.footer:SetPoint("BOTTOMRIGHT", frame.footerRight, "BOTTOMLEFT");
end

function Clique:CreateOptionsFrame()
    local frames = {}
    self.frames = frames
    
    local frame = CreateFrame("Frame", "CliqueFrame", SpellBookFrame)
    frame:SetHeight(415)
    frame:SetWidth(400)
    frame:SetPoint("LEFT", SpellBookFrame, "RIGHT", 15, 30)
	self:SkinFrame(frame)
	frame.title:SetText("Clique (BC) v0.1");
	frame:SetScript("OnShow", function()
		if Clique.inuse then
			CliqueHelpText:Hide()
		else
			CliqueHelpText:Show()
		end
	end)

	CliqueFrame:SetScript("OnShow", function() 
		if InCombatLockdown() then
			CliqueFrame:Hide()
		end
		Clique:ToggleSpellBookButtons()
	end)

	CliqueFrame:SetScript("OnHide", function() Clique:ToggleSpellBookButtons() end)
    
    local frame = CreateFrame("Frame", "CliqueListFrame", CliqueFrame)
    frame:SetAllPoints()
    
    local onclick = function()
    local offset = FauxScrollFrame_GetOffset(CliqueListScroll)
        self.listSelected = offset + this.id
        Clique:ListScrollUpdate()
    end
    
    local onenter = function() this:SetBackdropBorderColor(1, 1, 1) end
    local onleave = function()
        local selected = FauxScrollFrame_GetOffset(CliqueListScroll) + this.id
        if selected == self.listSelected then
            this:SetBackdropBorderColor(1, 1, 0)
        else
            this:SetBackdropBorderColor(0.3, 0.3, 0.3)
        end
    end

    for i=1,NUM_ENTRIES do
        local entry = CreateFrame("Button", "CliqueList"..i, frame)
        entry.id = i
        entry:SetHeight(ENTRY_SIZE)
        entry:SetWidth(390)
        entry:SetBackdrop({
          bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
          edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
          tile = true, tileSize = 8, edgeSize = 16, 
          insets = {left = 2, right = 2, top = 2, bottom = 2}})

        entry:SetBackdropBorderColor(0.3, 0.3, 0.3)
        entry:SetBackdropColor(0.1, 0.1, 0.1, 0.3)
        entry:SetScript("OnClick", onclick)
        entry:SetScript("OnEnter", onenter)
        entry:SetScript("OnLeave", onleave)

        entry.icon = entry:CreateTexture(nil, "ARTWORK")
        entry.icon:SetHeight(24)
        entry.icon:SetWidth(24)
        entry.icon:SetPoint("LEFT", 5, 0)

        entry.name = entry:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        entry.name:SetPoint("LEFT", entry.icon, "RIGHT", 5, 0)

        entry.binding = entry:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        entry.binding:SetPoint("RIGHT", entry, "RIGHT", -5, 0)
        frames[i] = entry
    end

    frames[1]:SetPoint("TOPLEFT", 5, -55)
    for i=2,NUM_ENTRIES do
        frames[i]:SetPoint("TOP", frames[i-1], "BOTTOM", 0, 2)
    end
    
    local endButton = getglobal("CliqueList"..NUM_ENTRIES)
    CreateFrame("ScrollFrame", "CliqueListScroll", CliqueListFrame, "FauxScrollFrameTemplate")
    CliqueListScroll:SetPoint("TOPLEFT", CliqueList1, "TOPLEFT", 0, 0)
    CliqueListScroll:SetPoint("BOTTOMRIGHT", endButton, "BOTTOMRIGHT", 0, 0)
    
    local texture = CliqueListScroll:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    texture:SetPoint("TOPLEFT", CliqueListScroll, "TOPRIGHT", 14, 0)
    texture:SetPoint("BOTTOMRIGHT", CliqueListScroll, "BOTTOMRIGHT", 23, 0)
    texture:SetGradientAlpha("HORIZONTAL", 0.5, 0.25, 0.05, 0, 0.15, 0.15, 0.15, 1)

    local texture = CliqueListScroll:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    texture:SetPoint("TOPLEFT", CliqueListScroll, "TOPRIGHT", 4, 0)
    texture:SetPoint("BOTTOMRIGHT", CliqueListScroll, "BOTTOMRIGHT", 14, 0)
    texture:SetGradientAlpha("HORIZONTAL", 0.15, 0.15, 0.15, 0.15, 1, 0.5, 0.25, 0.05, 0)
    
    local update = function() Clique:ListScrollUpdate() end

    CliqueListScroll:SetScript("OnVerticalScroll", function() FauxScrollFrame_OnVerticalScroll(ENTRY_SIZE, update) end)
    CliqueListScroll:SetScript("OnShow", update)

    local frame = CreateFrame("Frame", "CliqueTextListFrame", CliqueFrame)
    frame:SetHeight(300)
    frame:SetWidth(250)
    frame:SetPoint("BOTTOMLEFT", CliqueFrame, "BOTTOMRIGHT", 0, 0)
	self:SkinFrame(frame)
	frame:SetFrameStrata("HIGH")

    local onclick = function()
	    local offset = FauxScrollFrame_GetOffset(CliqueTextListScroll)
		if self.textlistSelected == offset + this.id then
			self.textlistSelected = nil
		else
			self.textlistSelected = offset + this.id
		end
		if self.textlist == "FRAMES" then
			local name = this.name:GetText()
			local frame = getglobal(name)
			if this:GetChecked() then
				self.profile.blacklist[name] = nil
				self:RegisterFrame(getglobal(name))
			else
				self.profile.blacklist[name] = true
				self:UnregisterFrame(frame)
			end
		end
        Clique:TextListScrollUpdate()
    end
    
    local onenter = function() this:SetBackdropBorderColor(1, 1, 1) end
    local onleave = function()
        local selected = FauxScrollFrame_GetOffset(CliqueTextListScroll) + this.id
		this:SetBackdropBorderColor(0.3, 0.3, 0.3)
    end

	local frames = {}

	for i=1,12 do
		local entry = CreateFrame("CheckButton", "CliqueTextList"..i, frame)
		entry.id = i
		entry:SetHeight(22)
		entry:SetWidth(240)
        entry:SetBackdrop({
--          bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
--          edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
--          tile = true, tileSize = 8, edgeSize = 16, 
          insets = {left = 2, right = 2, top = 2, bottom = 2}})
		
        entry:SetBackdropBorderColor(0.3, 0.3, 0.3)
        entry:SetBackdropColor(0.1, 0.1, 0.1, 0.3)
        entry:SetScript("OnClick", onclick)
        entry:SetScript("OnEnter", onenter)
        entry:SetScript("OnLeave", onleave)

		local texture = entry:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\Buttons\\UI-CheckBox-Up")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		entry:SetNormalTexture(texture)

		local texture = entry:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		texture:SetBlendMode("ADD")
		entry:SetHighlightTexture(texture)

		local texture = entry:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		entry:SetCheckedTexture(texture)

		entry.name = entry:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		entry.name:SetPoint("LEFT", 25, 0)
		entry.name:SetJustifyH("LEFT")
		entry.name:SetText("Profile Name")
		frames[i] = entry
	end

	frames[1]:SetPoint("TOPLEFT", 5, -25)
	for i=2,12 do
		frames[i]:SetPoint("TOP", frames[i-1], "BOTTOM", 0, 2)
	end

    local endButton = CliqueTextList12
    CreateFrame("ScrollFrame", "CliqueTextListScroll", CliqueTextListFrame, "FauxScrollFrameTemplate")
    CliqueTextListScroll:SetPoint("TOPLEFT", CliqueTextList1, "TOPLEFT", 0, 0)
    CliqueTextListScroll:SetPoint("BOTTOMRIGHT", endButton, "BOTTOMRIGHT", 0, 0)
    
    local texture = CliqueTextListScroll:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    texture:SetPoint("TOPLEFT", CliqueTextListScroll, "TOPRIGHT", 14, 0)
    texture:SetPoint("BOTTOMRIGHT", CliqueTextListScroll, "BOTTOMRIGHT", 23, 0)
    texture:SetGradientAlpha("HORIZONTAL", 0.5, 0.25, 0.05, 0, 0.15, 0.15, 0.15, 1)

    local texture = CliqueTextListScroll:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    texture:SetPoint("TOPLEFT", CliqueTextListScroll, "TOPRIGHT", 4, 0)
    texture:SetPoint("BOTTOMRIGHT", CliqueTextListScroll, "BOTTOMRIGHT", 14, 0)
    texture:SetGradientAlpha("HORIZONTAL", 0.15, 0.15, 0.15, 0.15, 1, 0.5, 0.25, 0.05, 0)
    
    local update = function()
		Clique:TextListScrollUpdate()
	end

    CliqueTextListScroll:SetScript("OnVerticalScroll", function() FauxScrollFrame_OnVerticalScroll(22, update) end)
    CliqueTextListFrame:SetScript("OnShow", update)
	CliqueTextListFrame:Hide()

	-- Dropdown Frame
	CreateFrame("Frame", "CliqueDropDown", CliqueFrame, "UIDropDownMenuTemplate")
	CliqueDropDown:SetID(1)
	CliqueDropDown:SetPoint("TOPRIGHT", -115, -25)
	CliqueDropDown:SetScript("OnShow", function() Clique:DropDown_OnShow() end)

	local font = CliqueDropDown:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	font:SetText("Click Set:")
	font:SetPoint("RIGHT", CliqueDropDown, "LEFT", 5, 3)
	-- Button Creations
    local buttonFunc = function() Clique:ButtonOnClick() end

	local button = CreateFrame("Button", "CliqueButtonClose", CliqueFrame.titleBar, "UIPanelCloseButton")
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetPoint("TOPRIGHT", -5, 3)
	button:SetScript("OnClick", buttonFunc)
    
    local button = CreateFrame("Button", "CliqueButtonCustom", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Custom")
    button:SetPoint("BOTTOMLEFT", CliqueFrame, "BOTTOMLEFT", 10, 5)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonOptions", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Options")
    button:SetPoint("LEFT", CliqueButtonCustom, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonProfiles", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Profiles")
    button:SetPoint("LEFT", CliqueButtonOptions, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonDelete", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Delete")
    button:SetPoint("LEFT", CliqueButtonProfiles, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonEdit", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Edit")
    button:SetPoint("LEFT", CliqueButtonDelete, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonMax", CliqueFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Max")
    button:SetPoint("LEFT", CliqueButtonEdit, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

	-- Buttons for text list scroll frame

	local button = CreateFrame("Button", "CliqueTextButtonClose", CliqueTextListFrame.titleBar, "UIPanelCloseButton")
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetPoint("TOPRIGHT", -5, 3)
	button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonDeleteProfile", CliqueTextListFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Delete")
    button:SetPoint("BOTTOMLEFT", CliqueTextListFrame, "BOTTOMLEFT", 30, 5)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonSetProfile", CliqueTextListFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("Set")
    button:SetPoint("LEFT", CliqueButtonDeleteProfile, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueButtonNewProfile", CliqueTextListFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(60)
    button:SetText("New")
    button:SetPoint("LEFT", CliqueButtonSetProfile, "RIGHT", 3, 0)
    button:SetScript("OnClick", buttonFunc)

	self.customEntry = {}    
    local frame = CreateFrame("Frame", "CliqueCustomFrame", CliqueFrame)
    frame:SetHeight(375)
	frame:SetWidth(450)
	frame:SetPoint("CENTER", 70, -50)
	self:SkinFrame(frame)
	frame.title:SetText("Clique Custom Editor");
	frame:SetFrameStrata("HIGH")
    frame:Hide()

	-- Help text for Custom screen

	local font = frame:CreateFontString("CliqueCustomHelpText", "OVERLAY", "GameFontHighlight")
	font:SetWidth(260) font:SetHeight(100)
	font:SetPoint("TOPRIGHT", -10, -25)
	font:SetText(L.CUSTOM_HELP)

	local checkFunc = function() Clique:CustomRadio() end
	self.radio = {}

	local buttons = {
		{type = "actionbar", name = L.ACTION_ACTIONBAR},
		{type = "action", name = L.ACTION_ACTION},
		{type = "pet", name = L.ACTION_PET},
		{type = "spell", name = L.ACTION_SPELL},
		{type = "item", name = L.ACTION_ITEM},
		{type = "macro", name = L.ACTION_MACRO},
		{type = "stop", name = L.ACTION_STOP},
		{type = "target", name = L.ACTION_TARGET},
		{type = "focus", name = L.ACTION_FOCUS},
		{type = "assist", name = L.ACTION_ASSIST},
		{type = "click", name = L.ACTION_CLICK},
		{type = "menu", name = L.ACTION_MENU},
	}

	for i=1,#buttons do
		local entry = buttons[i]

		local name = "CliqueRadioButton"..entry.type
		local button = CreateFrame("CheckButton", name, CliqueCustomFrame)
		button:SetHeight(20)
		button:SetWidth(150)

		local texture = button:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\AddOns\\Clique\\images\\RadioEmpty")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		button:SetNormalTexture(texture)

		local texture = button:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\AddOns\\Clique\\images\\RadioChecked")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		texture:SetBlendMode("ADD")
		button:SetHighlightTexture(texture)

		local texture = button:CreateTexture("ARTWORK")
		texture:SetTexture("Interface\\AddOns\\Clique\\images\\RadioChecked")
		texture:SetPoint("LEFT", 0, 0)
		texture:SetHeight(26)
		texture:SetWidth(26)
		button:SetCheckedTexture(texture)

		button.name = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		button.name:SetPoint("LEFT", 25, 0)
		button.name:SetJustifyH("LEFT")
		
		local entry = buttons[1]
		local name = "CliqueRadioButton"..entry.type
		local button = CreateFrame("CheckButton", name, CliqueCustomFrame)
		button:SetHeight(22)
		button:SetWidth(150)
	end

	local entry = buttons[1]
	local button = getglobal("CliqueRadioButton"..entry.type)
	button.type = entry.type
	button.name:SetText(entry.name)
	button:SetPoint("TOPLEFT", 5, -30)	
	button:SetScript("OnClick", checkFunc)
	self.radio[button] = true

	local prev = button

	for i=2,#buttons do
		local entry = buttons[i]
		local name = "CliqueRadioButton"..entry.type
		local button = getglobal(name)
	
		button.type = entry.type
		button.name:SetText(entry.name)
		button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, 0)	
		button:SetScript("OnClick", checkFunc)
		self.radio[button] = true
		prev = button
	end

	-- Button to set the binding

    local button = CreateFrame("Button", "CliqueCustomButtonBinding", CliqueCustomFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(30)
    button:SetWidth(175)
    button:SetText("Set Click Binding")
    button:SetPoint("TOP", CliqueCustomHelpText, "BOTTOM", 40, -10)
    button:SetScript("OnClick", function() Clique:CustomBinding_OnClick() end )
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")

	-- Button for icon selection
	
	local button = CreateFrame("Button", "CliqueCustomButtonIcon", CliqueCustomFrame)
	button.icon = button:CreateTexture(nil, "BORDER")
	button.icon:SetAllPoints()
	button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:GetHighlightTexture():SetBlendMode("ADD")
	button:SetHeight(30)
	button:SetWidth(30)
	button:SetPoint("RIGHT", CliqueCustomButtonBinding, "LEFT", -15, 0)

    local func = function()
        GameTooltip:SetOwner(button, "ANCHOR_TOPLEFT")
		GameTooltip:SetText("Click here to set icon")
        GameTooltip:Show()
    end
    
    button:SetScript("OnEnter", func)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", function() CliqueIconSelectFrame:Show() end)

	-- Create the editboxes for action arguments

	local edit = CreateFrame("EditBox", "CliqueCustomArg1", CliqueCustomFrame, "InputBoxTemplate")
	edit:SetHeight(30)
	edit:SetWidth(200)
	edit:SetMultiLine(true)
	edit:SetPoint("TOPRIGHT", CliqueCustomFrame, "TOPRIGHT", -10, -190)
	edit:SetAutoFocus(nil)
	edit:SetScript("OnTabPressed", function()
		if CliqueCustomArg2:IsVisible() then
			CliqueCustomArg2:SetFocus()
		end
	end)

	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	edit.label:SetText("Spell Name:")
	edit.label:SetPoint("RIGHT", edit, "LEFT", -10, 0)
	edit.label:SetJustifyH("RIGHT")
	edit:Hide()

	-- Argument 2

	local edit = CreateFrame("EditBox", "CliqueCustomArg2", CliqueCustomFrame, "InputBoxTemplate")
	edit:SetHeight(30)
	edit:SetWidth(200)
	edit:SetPoint("TOPRIGHT", CliqueCustomArg1, "BOTTOMRIGHT", 0, 0)
	edit:SetAutoFocus(nil)
	edit:SetScript("OnTabPressed", function()
		if CliqueCustomArg3:IsVisible() then
			CliqueCustomArg3:SetFocus()
		end
	end)

	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	edit.label:SetText("Spell Name:")
	edit.label:SetPoint("RIGHT", edit, "LEFT", -10, 0)
	edit.label:SetJustifyH("RIGHT")
	edit:Hide()

	-- Multi line edit box

	local edit = CreateFrame("ScrollFrame", "CliqueMulti", CliqueCustomFrame, "CliqueEditTemplate")
	edit:SetPoint("TOPRIGHT", CliqueCustomArg1, "BOTTOMRIGHT", -10, -27)
	
	local name = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	name:SetText("Macro Text:")
	name:SetJustifyH("RIGHT")
	name:SetPoint("RIGHT", CliqueCustomArg2.label)

	local grabber = CreateFrame("Button", "CliqueFocusGrabber", edit)
	grabber:SetPoint("TOPLEFT", 8, -8)
	grabber:SetPoint("BOTTOMRIGHT", -8, 8)
	grabber:SetScript("OnClick", function() CliqueMultiScrollFrameEditBox:SetFocus() end)

	-- Argument 3

	local edit = CreateFrame("EditBox", "CliqueCustomArg3", CliqueCustomFrame, "InputBoxTemplate")
	edit:SetHeight(30)
	edit:SetWidth(200)
	edit:SetPoint("TOPRIGHT", CliqueCustomArg2, "BOTTOMRIGHT", 0, 0)
	edit:SetAutoFocus(nil)
	edit:SetScript("OnTabPressed", function()
		if CliqueCustomArg4:IsVisible() then
			CliqueCustomArg4:SetFocus()
		end
	end)

	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	edit.label:SetText("Spell Name:")
	edit.label:SetPoint("RIGHT", edit, "LEFT", -10, 0)
	edit.label:SetJustifyH("RIGHT")
	edit:Hide()

	-- Argument 4

	local edit = CreateFrame("EditBox", "CliqueCustomArg4", CliqueCustomFrame, "InputBoxTemplate")
	edit:SetHeight(30)
	edit:SetWidth(200)
	edit:SetPoint("TOPRIGHT", CliqueCustomArg3, "BOTTOMRIGHT", 0, 0)
	edit:SetAutoFocus(nil)
	edit:SetScript("OnTabPressed", function()
		if CliqueCustomArg5:IsVisible() then
			CliqueCustomArg5:SetFocus()
		end
	end)

	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	edit.label:SetText("Spell Name:")
	edit.label:SetPoint("RIGHT", edit, "LEFT", -10, 0)
	edit.label:SetJustifyH("RIGHT")
	edit:Hide()

	-- Argument 5

	local edit = CreateFrame("EditBox", "CliqueCustomArg5", CliqueCustomFrame, "InputBoxTemplate")
	edit:SetHeight(30)
	edit:SetWidth(200)
	edit:SetPoint("TOPRIGHT", CliqueCustomArg4, "BOTTOMRIGHT", 0, 0)
	edit:SetAutoFocus(nil)
	edit:SetScript("OnTabPressed", function()
		if CliqueCustomArg1:IsVisible() then
			CliqueCustomArg1:SetFocus()
		end
	end)

	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	edit.label:SetText("Spell Name:")
	edit.label:SetPoint("RIGHT", edit, "LEFT", -10, 0)
	edit.label:SetJustifyH("RIGHT")
	edit:Hide()

	-- Bottom buttons

    local button = CreateFrame("Button", "CliqueCustomButtonCancel", CliqueCustomFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(70)
    button:SetText("Cancel")
    button:SetPoint("BOTTOM", 65, 4)
    button:SetScript("OnClick", buttonFunc)

    local button = CreateFrame("Button", "CliqueCustomButtonSave", CliqueCustomFrame, "UIPanelButtonGrayTemplate")
    button:SetHeight(24)
    button:SetWidth(70)
    button:SetText("Save")
    button:SetPoint("LEFT", CliqueCustomButtonCancel, "RIGHT", 6, 0)
    button:SetScript("OnClick", buttonFunc)

	-- Create the macro icon frame

	CreateFrame("Frame", "CliqueIconSelectFrame", CliqueCustomFrame)
	CliqueIconSelectFrame:SetWidth(296)
	CliqueIconSelectFrame:SetHeight(250)
	CliqueIconSelectFrame:SetPoint("CENTER",0,0)
	self:SkinFrame(CliqueIconSelectFrame)
	CliqueIconSelectFrame:SetFrameStrata("DIALOG")
	CliqueIconSelectFrame.title:SetText("Select an icon")
	CliqueIconSelectFrame:Hide()

	CreateFrame("CheckButton", "CliqueIcon1", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon1:SetID(1)
	CliqueIcon1:SetPoint("TOPLEFT", 25, -35)

	CreateFrame("CheckButton", "CliqueIcon2", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon2:SetID(2)
	CliqueIcon2:SetPoint("LEFT", CliqueIcon1, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon3", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon3:SetID(3)
	CliqueIcon3:SetPoint("LEFT", CliqueIcon2, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon4", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon4:SetID(4)
	CliqueIcon4:SetPoint("LEFT", CliqueIcon3, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon5", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon5:SetID(5)
	CliqueIcon5:SetPoint("LEFT", CliqueIcon4, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon6", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon6:SetID(6)
	CliqueIcon6:SetPoint("TOPLEFT", CliqueIcon1, "BOTTOMLEFT", 0, -10)

	CreateFrame("CheckButton", "CliqueIcon7", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon7:SetID(7)
	CliqueIcon7:SetPoint("LEFT", CliqueIcon6, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon8", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon8:SetID(8)
	CliqueIcon8:SetPoint("LEFT", CliqueIcon7, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon9", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon9:SetID(9)
	CliqueIcon9:SetPoint("LEFT", CliqueIcon8, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon10", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon10:SetID(10)
	CliqueIcon10:SetPoint("LEFT", CliqueIcon9, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon11", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon11:SetID(11)
	CliqueIcon11:SetPoint("TOPLEFT", CliqueIcon6, "BOTTOMLEFT", 0, -10)

	CreateFrame("CheckButton", "CliqueIcon12", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon12:SetID(12)
	CliqueIcon12:SetPoint("LEFT", CliqueIcon11, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon13", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon13:SetID(13)
	CliqueIcon13:SetPoint("LEFT", CliqueIcon12, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon14", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon14:SetID(14)
	CliqueIcon14:SetPoint("LEFT", CliqueIcon13, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon15", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon15:SetID(15)
	CliqueIcon15:SetPoint("LEFT", CliqueIcon14, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon16", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon16:SetID(16)
	CliqueIcon16:SetPoint("TOPLEFT", CliqueIcon11, "BOTTOMLEFT", 0, -10)

	CreateFrame("CheckButton", "CliqueIcon17", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon17:SetID(17)
	CliqueIcon17:SetPoint("LEFT", CliqueIcon16, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon18", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon18:SetID(18)
	CliqueIcon18:SetPoint("LEFT", CliqueIcon17, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon19", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon19:SetID(19)
	CliqueIcon19:SetPoint("LEFT", CliqueIcon18, "RIGHT", 10, 0)

	CreateFrame("CheckButton", "CliqueIcon20", CliqueIconSelectFrame, "CliqueIconTemplate")
	CliqueIcon20:SetID(20)
	CliqueIcon20:SetPoint("LEFT", CliqueIcon19, "RIGHT", 10, 0)

	CreateFrame("ScrollFrame", "CliqueIconScrollFrame", CliqueIconSelectFrame, "FauxScrollFrameTemplate")
	CliqueIconScrollFrame:SetPoint("TOPLEFT", CliqueIcon1, "TOPLEFT", 0, 0)
	CliqueIconScrollFrame:SetPoint("BOTTOMRIGHT", CliqueIcon20, "BOTTOMRIGHT", 10, 0)

	local texture = CliqueIconScrollFrame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	texture:SetPoint("TOPLEFT", CliqueIconScrollFrame, "TOPRIGHT", 14, 0)
	texture:SetPoint("BOTTOMRIGHT", 23, 0)
	texture:SetVertexColor(0.3, 0.3, 0.3)

	local texture = CliqueIconScrollFrame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	texture:SetPoint("TOPLEFT", CliqueIconScrollFrame, "TOPRIGHT", 4, 0)
	texture:SetPoint("BOTTOMRIGHT", 14,0)
	texture:SetVertexColor(0.3, 0.3, 0.3)

	CliqueIconScrollFrame:SetScript("OnVerticalScroll", function()
															local MACRO_ICON_ROW_HEIGHT = 36
															FauxScrollFrame_OnVerticalScroll(MACRO_ICON_ROW_HEIGHT, function() Clique:UpdateIconFrame() end)
														end)

	CliqueIconSelectFrame:SetScript("OnShow", function() Clique:UpdateIconFrame() end)

	-- Create the CliqueHelpText
	CliqueFrame:CreateFontString("CliqueHelpText", "OVERLAY", "GameFontHighlight")
	CliqueHelpText:SetText(L.HELP_TEXT)
	CliqueHelpText:SetPoint("TOPLEFT", 10, -10)
	CliqueHelpText:SetPoint("BOTTOMRIGHT", -10, 10)
	CliqueHelpText:SetJustifyH("CENTER")
	CliqueHelpText:SetJustifyV("CENTER")
	CliqueHelpText:SetPoint("CENTER", 0, 0)
    
    self.sortList = {}
    self.listSelected = 0
end

function Clique:ListScrollUpdate()
	if not CliqueListScroll then return end

    local idx,button
    Clique:SortList()
    local clickCasts = self.sortList
    local offset = FauxScrollFrame_GetOffset(CliqueListScroll)
    FauxScrollFrame_Update(CliqueListScroll, table.getn(clickCasts), NUM_ENTRIES, ENTRY_SIZE)

    if not CliqueListScroll:IsShown() then 
        CliqueFrame:SetWidth(400)
    else
        CliqueFrame:SetWidth(425)
    end
	
    for i=1,NUM_ENTRIES do
        idx = offset + i
        button = getglobal("CliqueList"..i)
        if idx <= table.getn(clickCasts) then
            Clique:FillListEntry(button,idx)
            button:Show()
            if idx == self.listSelected then
                button:SetBackdropBorderColor(1,1,0)
            else
                button:SetBackdropBorderColor(0.3, 0.3, 0.3)
            end
        else
            button:Hide()
        end
    end
    Clique:ValidateButtons()
end

local sortFunc = function(a,b)
    local numA = a.button
    local numB = b.button 

    if numA == numB then
        return a.modifier < b.modifier
    else
        return tostring(numA) < tostring(numB)
    end
end

function Clique:SortList()
    self.sortList = {}
    for k,v in pairs(self.editSet) do
        table.insert(self.sortList, v)
    end
    table.sort(self.sortList, sortFunc)
end

function Clique:ValidateButtons()
    local entry = self.sortList[self.listSelected]
    
    if entry then
        CliqueButtonDelete:Enable()
        CliqueButtonEdit:Enable()
        if entry.type == "spell" and entry.arg2 then
            CliqueButtonMax:Enable()
        else
            CliqueButtonMax:Disable()
        end
    else
        CliqueButtonDelete:Disable()
        CliqueButtonEdit:Disable()
        CliqueButtonMax:Disable()
    end
    
    -- This should always be enabled
    CliqueButtonCustom:Enable()

	-- Disable the help text
	Clique.inuse = nil
	for k,v in pairs(self.clicksets) do
		if next(v) then
			Clique.inuse = true
		end
	end
	if Clique.inuse then
		CliqueHelpText:Hide()
	else
		CliqueHelpText:Show()
	end
end

function Clique:FillListEntry(frame, idx)
    local entry = self.sortList[idx]
    local rank = string.format(" (Rank %d)", entry.rank or 0)
    local type = string.format("%s%s", string.upper(string.sub(entry.type, 1, 1)), string.sub(entry.type, 2))
	local button = tonumber(string.sub(entry.button, -1, -1))
    
    frame.icon:SetTexture(entry.texture or "Interface\\Icons\\INV_Misc_QuestionMark")
	frame.binding:SetText(entry.modifier..self:GetButtonText(button))


	if entry.type == "action" then
		frame.name:SetText(string.format("Action Button %d%s", entry.arg1, entry.arg2 and " on "..entry.arg2 or ""))
	elseif entry.type == "actionbar" then
		frame.name:SetText(string.format("Action Bar: %s", entry.arg1))
	elseif entry.type == "pet" then
		frame.name:SetText(string.format("Pet Action %d%s", entry.arg1, entry.arg2 and " on "..entry.arg2 or ""))
	elseif entry.type == "spell" then
		if entry.arg2 then
			frame.name:SetText(string.format("%s (%s %d)%s", entry.arg1, L.RANK, entry.arg2,
				entry.arg5 and " on "..entry.arg5 or ""))
		else
			frame.name:SetText(string.format("%s%s", entry.arg1, entry.arg5 and " on "..entry.arg5 or ""))
		end
	elseif entry.type == "menu" then
		frame.name:SetText("Show Menu")
	elseif entry.type == "stop" then
		frame.name:SetText("Stop Casting")
	elseif entry.type == "target" then
		frame.name:SetText(string.format("Target Unit: %s", entry.arg1 and entry.arg1 or ""))
	elseif entry.type == "focus" then
		frame.name:SetText(string.format("Set Focus Unit: %s", entry.arg1 and entry.arg1 or ""))
	elseif entry.type == "assist" then
		frame.name:SetText(string.format("Assist Unit: %s", entry.arg1 and entry.arg1 or ""))
	elseif entry.type == "item" then
		if entry.arg1 then
			frame.name:SetText(string.format("Item: %d,%d", entry.arg1, entry.arg2))
		elseif entry.arg3 then
			frame.name:SetText(string.format("Item: %s", entry.arg3))
		end
	elseif entry.type == "macro" then
		frame.name:SetText(string.format("Macro: %s", entry.arg1 and entry.arg1 or string.sub(entry.arg2, 1, 20)))
	end

    frame:Show()
end

function Clique:ButtonOnClick(button)
    local entry = self.sortList[self.listSelected]
	local this = button or this

    if this == CliqueButtonDelete then
        if InCombatLockdown() then
            StaticPopup_Show("CLIQUE_COMBAT_LOCKDOWN")
            return
        end

        self.editSet[entry.modifier..entry.button] = nil
        local len = table.getn(self.sortList) - 1
        
        if self.listSelected > len then
            self.listSelected = len
        end
	
		self:DeleteAction(entry)
		entry = nil
        
        self:ListScrollUpdate()
	elseif this == CliqueButtonClose then
		self:Toggle()
	elseif this == CliqueTextButtonClose then
		CliqueTextListFrame:Hide()
    elseif this == CliqueButtonMax then
        entry.arg2 = nil
		self:DeleteAction(entry)
		self:SetAction(entry)
    elseif this == CliqueButtonCustom then
        if CliqueCustomFrame:IsVisible() then
            CliqueCustomFrame:Hide()
        else
            CliqueCustomFrame:Show()
		end
	elseif this == CliqueButtonOptions then
		if CliqueTextListFrame:IsVisible() and self.textlist == "FRAMES" then
			CliqueTextListFrame:Hide()
		else
			CliqueTextListFrame:Show()
		end

		self.textlist = "FRAMES"
		CliqueButtonDeleteProfile:Hide()
		CliqueButtonSetProfile:Hide()
		CliqueButtonNewProfile:Hide()

		self:TextListScrollUpdate()
		CliqueTextListFrame.title:SetText("Clique Frame Editor")
		self.textlistSelected = nil
	elseif this == CliqueButtonProfiles then
		if CliqueTextListFrame:IsVisible() and self.textlist == "PROFILES" then
			CliqueTextListFrame:Hide()
		else
			CliqueTextListFrame:Show()
		end
		self.textlist = "PROFILES"
		self:TextListScrollUpdate()
		CliqueButtonDeleteProfile:Show()
		CliqueButtonSetProfile:Show()
		CliqueButtonNewProfile:Show()

		--CliqueTextListFrame.title:SetText("Profile: " .. self.db.char.profileKey)
		self.textlistSelected = nil
	elseif this == CliqueButtonSetProfile then
	    local offset = FauxScrollFrame_GetOffset(CliqueTextListScroll)
		local selected = self.textlistSelected - offset
		local button = getglobal("CliqueTextList"..selected)
		self:SetProfile(button.name:GetText())
	elseif this == CliqueButtonNewProfile then
		StaticPopup_Show("CLIQUE_NEW_PROFILE")
	elseif this == CliqueButtonDeleteProfile then
	    local offset = FauxScrollFrame_GetOffset(CliqueTextListScroll)
		local selected = self.textlistSelected - offset
		local button = getglobal("CliqueTextList"..selected)
		self:DeleteProfile(button.name:GetText())
	elseif this == CliqueButtonEdit then
		-- Make a copy of the entry
		self.customEntry = {}
		for k,v in pairs(entry) do
			self.customEntry[k] = v
		end

		CliqueCustomFrame:Show()

		-- Select the right radio button
		for k,v in pairs(self.radio) do
			if entry.type == k.type then
				self:CustomRadio(k)
				k:SetChecked(true)
			end
		end

		self.customEntry.type = entry.type

		CliqueCustomArg1:SetText(entry.arg1 or "")
		CliqueCustomArg2:SetText(entry.arg2 or "")
		CliqueCustomArg3:SetText(entry.arg3 or "")
		CliqueCustomArg4:SetText(entry.arg4 or "")
		CliqueCustomArg5:SetText(entry.arg5 or "")

		CliqueMultiScrollFrameEditBox:SetText(entry.arg2 or "")
		CliqueCustomButtonIcon.icon:SetTexture(entry.texture or "Interface\\Icons\\INV_Misc_QuestionMark")

		CliqueCustomButtonBinding.modifier = entry.modifier
		CliqueCustomButtonBinding.button = self:GetButtonNumber(entry.button)
		CliqueCustomButtonBinding:SetText(string.format("%s%s", entry.modifier, self:GetButtonText(entry.button)))	

		self.editEntry = entry

    elseif this == CliqueCustomButtonCancel then
		CliqueCustomFrame:Hide()
		CliqueCustomButtonIcon.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		CliqueCustomButtonBinding:SetText("Set Click Binding")
		self.customEntry = {}
		self.editEntry = nil
		self:CustomRadio()

	elseif this == CliqueCustomButtonSave then
		-- Add custom save logic in here
		local entry = self.customEntry

		entry.arg1 = CliqueCustomArg1:GetText()
		entry.arg2 = CliqueCustomArg2:GetText()
		entry.arg3 = CliqueCustomArg3:GetText()
		entry.arg4 = CliqueCustomArg4:GetText()
		entry.arg5 = CliqueCustomArg5:GetText()

		if entry.arg1 == "" then entry.arg1 = nil end
		if entry.arg2 == "" then entry.arg2 = nil end
		if entry.arg3 == "" then entry.arg3 = nil end
		if entry.arg4 == "" then entry.arg4 = nil end
		if entry.arg5 == "" then entry.arg5 = nil end
		
		if tonumber(entry.arg1) then entry.arg1 = tonumber(entry.arg1) end
		if tonumber(entry.arg2) then entry.arg2 = tonumber(entry.arg2) end
		if tonumber(entry.arg3) then entry.arg3 = tonumber(entry.arg3) end
		if tonumber(entry.arg4) then entry.arg4 = tonumber(entry.arg4) end
		if tonumber(entry.arg5) then entry.arg5 = tonumber(entry.arg5) end

		if entry.type == "macro" then
			local text = CliqueMultiScrollFrameEditBox:GetText()
			if text ~= "" then
				entry.arg2 = text
			end
		end

		local pattern = "Hitem.+|h%[(.+)%]|h"
		if entry.arg1 and string.find(entry.arg1, pattern) then
			entry.arg1 = select(3, string.find(entry.arg1, pattern))
		end
		if entry.arg2 and string.find(entry.arg2, pattern) then
			entry.arg2 = select(3, string.find(entry.arg2, pattern))
		end
		if entry.arg3 and string.find(entry.arg3, pattern) then
			entry.arg3 = select(3, string.find(entry.arg3, pattern))
		end
		if entry.arg4 and string.find(entry.arg4, pattern) then
			entry.arg4 = select(3, string.find(entry.arg4, pattern))
		end
		if entry.arg5 and string.find(entry.arg5, pattern) then
			entry.arg5 = select(3, string.find(entry.arg5, pattern))
		end

		local issue
		if not entry.type then
			issue = "You must select an action type."
		elseif not entry.button then
			issue = "You must set a click-binding."
		elseif entry.type == "action" and not entry.arg1 then
			issue = "You must supply an action button number when creating a custom \"action\"."
		elseif entry.type == "pet" and not entry.arg1 then
			issue = "You must supply a pet action button number when creating a custom action \"pet\"."
		elseif entry.type == "spell" and not (entry.arg1 or (entry.arg2 and entry.arg3) or entry.arg4) then
			issue = "You must supply either a spell name and optionally an item slot/bag or name to consume when creating a \"spell\" action."
		elseif entry.type == "item" and not ((entry.arg1 and entry.arg2) or entry.arg3) then
			issue = "You must supply either a bag/slot, or an item name to use."
		elseif entry.type == "menu" and not arg1 then
			issue = "You must supply a menu function for action type \"menu\"."
		end

		if issue then
			StaticPopupDialogs["CLIQUE_CANT_SAVE"].text = issue			
			StaticPopup_Show("CLIQUE_CANT_SAVE")
			return
		end

		-- Delete the one we're editing, if that's the case
		if self.editEntry then
			local key = self.editEntry.modifier..self.editEntry.button
			self.editSet[key] = nil
			self:DeleteAction(self.editEntry)
			self.editEntry = nil
		end

		local key = entry.modifier..entry.button
		self.editSet[key] = entry
		self:SetAction(entry)
		self:ButtonOnClick(CliqueCustomButtonCancel)
	end
    
    Clique:ValidateButtons()
    Clique:ListScrollUpdate()
end

local click_func = function() Clique:DropDown_OnClick() end

function Clique:DropDown_Initialize()
    local info = {}

    for k,v in pairs(work) do
        info = {}
        info.text = v
        info.value = self.clicksets[v]
        info.func = click_func
        UIDropDownMenu_AddButton(info)
	end
end

function Clique:DropDown_OnClick()
	UIDropDownMenu_SetSelectedValue(CliqueDropDown, this.value)
	Clique.editSet = this.value
	self.listSelected = 0
	Clique:ListScrollUpdate()
end

function Clique:DropDown_OnShow()
	work = {}
	for k,v in pairs(self.clicksets) do
		table.insert(work, k)
	end
	table.sort(work)

	UIDropDownMenu_Initialize(this, function() Clique:DropDown_Initialize() end);
	UIDropDownMenu_SetSelectedValue(CliqueDropDown, self.editSet)
	Clique:ListScrollUpdate()
end

function Clique:CustomBinding_OnClick()
	-- This handles the binding click
	local mod = self:GetModifierText()
	local button = arg1

	self.customEntry.modifier = mod
	self.customEntry.button = self:GetButtonNumber(button)
	this:SetText(string.format("%s%s", mod, button))	
end

local buttonSetup = {
	actionbar = {
		help = "Change the actionbar.  'increment' will move it up one page, 'decrement' does the opposite.  If you supply a number, the action bar will be turned to that page.  You can specify 1,3 to toggle between pages 1 and 3",
		arg1 = "Action:",
	},
	action = {
		help = "Simulate a click on an action button.  Specify the number of the action button.",
		arg1 = "Button Number:",
		arg2 = "(Optional) Unit:",
	},
	pet = {
		help = "Simulate a click on an pet's action button.  Specify the number of the button.",
		arg1 = "Pet Button Number:",
		arg2 = "(Optional) Unit:",
	},
	spell = {
		help = "Cast a spell from the spellbook.  Takes a spell name, and optionally a bag and slot, or item name to use as the target of the spell (i.e. Feed Pet)",
		arg1 = "Spell Name:",
		arg2 = "*Rank/Bag Number:",
		arg3 = "*Slot Number:",
		arg4 = "*Item Name:",
		arg5 = "(Optional) Unit:",
	},
	item = {
		help = "Use an item.  Can take either a bag and slot, or an item name.",
		arg1 = "Bag Number:",
		arg2 = "Slot Number:",
		arg3 = "Item Name:",
		arg4 = "(Optional) Unit:",
	},
	macro = {
		help = "Use a custom macro in a given index",
		arg1 = "Macro Index:",
		arg2 = "Macro Text:",
	},
	stop = {
		help = "Stops casting the current spell",
	},
	target = {
		help = "Targets the unit",
		arg1 = "(Optional) Unit:",
	},
	focus = {
		help = "Sets your \"focus\" unit",
		arg1 = "(Optional) Unit:",
	},
	assist = {
		help = "Assists the unit",
		arg1 = "(Optional) Unit:",
	},
	click = {
		help = "Simulate click on a button",
		arg1 = "Button Name:",
	},
	menu = {
		help = "Shows the unit pop up menu",
	},
}

function Clique:CustomRadio(button)
	this = button or this

	local anySelected
	for k,v in pairs(self.radio) do
		if k ~= this then
			k:SetChecked(nil)
		end
	end

	local entry = buttonSetup[this.type]
	self.customEntry.type = this.type

	if this and this.type then
		if not this:GetChecked() then
			self.customEntry.type = nil
		end
	end

	if not entry then
		CliqueCustomHelpText:SetText(L.CUSTOM_HELP)
		CliqueCustomArg1:Hide()
		CliqueCustomArg2:Hide()
		CliqueCustomArg3:Hide()
		CliqueCustomArg4:Hide()
		CliqueCustomArg5:Hide()
		CliqueCustomButtonBinding:SetText("Set Click Binding")
		return
	end
	
	-- Clear any open arguments
	CliqueCustomArg1:SetText("")
	CliqueCustomArg2:SetText("")
	CliqueCustomArg3:SetText("")
	CliqueCustomArg4:SetText("")
	CliqueCustomArg5:SetText("")

	CliqueCustomHelpText:SetText(entry.help)
	CliqueCustomArg1.label:SetText(entry.arg1)
	CliqueCustomArg2.label:SetText(entry.arg2)
	CliqueCustomArg3.label:SetText(entry.arg3)
	CliqueCustomArg4.label:SetText(entry.arg4)
	CliqueCustomArg5.label:SetText(entry.arg5)

	if entry.arg1 then CliqueCustomArg1:Show() else CliqueCustomArg1:Hide() end
	if entry.arg2 then CliqueCustomArg2:Show() else CliqueCustomArg2:Hide() end
	if entry.arg3 then CliqueCustomArg3:Show() else CliqueCustomArg3:Hide() end
	if entry.arg4 then CliqueCustomArg4:Show() else CliqueCustomArg4:Hide() end
	if entry.arg5 then CliqueCustomArg5:Show() else CliqueCustomArg5:Hide() end

	-- Handle MacroText
	if this.type == "macro" then
		CliqueCustomArg2:Hide()
		CliqueMulti:Show()
		CliqueMultiScrollFrameEditBox:SetText("")
	else
		CliqueMulti:Hide()
	end
end

function Clique:UpdateIconFrame()
    local MAX_MACROS = 18;
    local NUM_MACRO_ICONS_SHOWN = 20;
    local NUM_ICONS_PER_ROW = 5;
    local NUM_ICON_ROWS = 4;
    local MACRO_ICON_ROW_HEIGHT = 36;
    local macroPopupOffset = FauxScrollFrame_GetOffset(CliqueIconScrollFrame);
    local numMacroIcons = GetNumMacroIcons();

    -- Icon list
    for i=1, NUM_MACRO_ICONS_SHOWN do
        macroPopupIcon = getglobal("CliqueIcon"..i.."Icon");
        macroPopupButton = getglobal("CliqueIcon"..i);
        
        if not macroPopupButton.icon then
            macroPopupButton.icon = macroPopupIcon
        end
        
        index = (macroPopupOffset * NUM_ICONS_PER_ROW) + i;
        if ( index <= numMacroIcons ) then
            macroPopupIcon:SetTexture(GetMacroIconInfo(index));
            macroPopupButton:Show();
        else
            macroPopupIcon:SetTexture("");
            macroPopupButton:Hide();
        end
        macroPopupButton:SetChecked(nil);
    end
    
    FauxScrollFrame_Update(CliqueIconScrollFrame, ceil(numMacroIcons / NUM_ICONS_PER_ROW) , NUM_ICON_ROWS, MACRO_ICON_ROW_HEIGHT );
end

function Clique:SetSpellIcon()
	local texture = this.icon:GetTexture()
	self.customEntry.texture = texture
	CliqueCustomButtonIcon.icon:SetTexture(texture)
	CliqueIconSelectFrame:Hide()
end

StaticPopupDialogs["CLIQUE_PASSIVE_SKILL"] = {
	text = "You can't bind a passive skill.",
button1 = TEXT(OKAY),
	OnAccept = function()
	end,
	timeout = 0,
	hideOnEscape = 1
}

StaticPopupDialogs["CLIQUE_CANT_SAVE"] = {
	text = "",
	button1 = TEXT(OKAY),
	OnAccept = function()
	end,
	timeout = 0,
	hideOnEscape = 1
}

StaticPopupDialogs["CLIQUE_BINDING_PROBLEM"] = {
	text = "That combination is already bound.  Delete the old one before trying to re-bind.",
	button1 = TEXT(OKAY),
	OnAccept = function()
	end,
	timeout = 0,
	hideOnEscape = 1
}

StaticPopupDialogs["CLIQUE_COMBAT_LOCKDOWN"] = {
	text = "You are currently in combat.  You cannot make changes to your click casting while in combat..",
	button1 = TEXT(OKAY),
	OnAccept = function()
	end,
	timeout = 0,
	hideOnEscape = 1
}

StaticPopupDialogs["CLIQUE_NEW_PROFILE"] = {
	text = TEXT("Enter the name of a new profile you'd like to create"),
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()		
		local name = this:GetParent():GetName().."EditBox"
		local button = getglobal(name)
		local text = button:GetText()
		Clique:SetProfile(text)
	end,
	timeout = 0,
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
	maxLetters = 32,
	OnShow = function()
		getglobal(this:GetName().."Button1"):Disable();
		getglobal(this:GetName().."EditBox"):SetFocus();
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		if ( getglobal(this:GetParent():GetName().."Button1"):IsEnabled() == 1 ) then
			Clique:SetProfile(this:GetText())
			this:GetParent():Hide();
		end
	end,
	EditBoxOnTextChanged = function ()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		local txt = editBox:GetText()
		if #txt > 0 then
			getglobal(this:GetParent():GetName().."Button1"):Enable();
		else
			getglobal(this:GetParent():GetName().."Button1"):Disable();
		end
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
		ClearCursor();
	end
}

StaticPopupDialogs["CLIQUE_DELETE_PROFILE"] = {
	text = TEXT("Enter the name of a profile you'd like to delete"),
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		Clique:DeleteProfile(getglobal(this:GetName().."EditBox"):GetText())
		Clique:DropDownProfile_OnShow()
	end,
	timeout = 0,
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
	maxLetters = 32,
	OnShow = function()
		getglobal(this:GetName().."Button1"):Disable();
		getglobal(this:GetName().."EditBox"):SetFocus();
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		if ( getglobal(this:GetParent():GetName().."Button1"):IsEnabled() == 1 ) then
			Clique:DeleteProfile(this:GetText())
			Clique:DropDownProfile_OnShow()
			this:GetParent():Hide();
		end
	end,
	EditBoxOnTextChanged = function ()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		local txt = editBox:GetText()
		if Clique.db.profiles[txt] then
			getglobal(this:GetParent():GetName().."Button1"):Enable();
		else
			getglobal(this:GetParent():GetName().."Button1"):Disable();
		end
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
		ClearCursor();
	end
}

local work = {}

function Clique:TextListScrollUpdate()
	if not CliqueTextListScroll then return end

    local idx,button
	for k,v in pairs(work) do work[k] = nil end

	if not self.textlist then self.textlist = "FRAMES" end

	if self.textlist == "PROFILES" then
		for k,v in pairs(self.db.profiles) do table.insert(work, k) end
		table.sort(work)
		CliqueTextListFrame.title:SetText("Profile: " .. self.db.char.profileKey)

	elseif self.textlist == "FRAMES" then
		for k,v in pairs(self.ccframes) do 
			local name = k:GetName()
			if name then
				table.insert(work, name)
			end
		end
		table.sort(work)
	end
	
    local offset = FauxScrollFrame_GetOffset(CliqueTextListScroll)
    FauxScrollFrame_Update(CliqueTextListScroll, #work, 12, 22)

    if not CliqueTextListScroll:IsShown() then 
        CliqueTextListFrame:SetWidth(250)
    else
        CliqueTextListFrame:SetWidth(275)
    end
	
    for i=1,12 do
        idx = offset + i
        button = getglobal("CliqueTextList"..i)
        if idx <= #work then
			button.name:SetText(work[idx])
            button:Show()
			-- Change texture
			if self.textlist == "PROFILES" then
				button:SetNormalTexture("Interface\\AddOns\\Clique\\images\\RadioEmpty")
				button:SetCheckedTexture("Interface\\AddOns\\Clique\\images\\RadioChecked")
				button:SetHighlightTexture("Interface\\AddOns\\Clique\\images\\RadioChecked")
			else
				button:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
				button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
				button:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
			end

			if self.textlistSelected == nil and self.textlist == "PROFILES" then
				if work[idx] == self.db.char.profileKey then
					button:SetChecked(true)
					CliqueButtonSetProfile:Disable()
					CliqueButtonDeleteProfile:Disable()
				else
					button:SetChecked(nil)
				end
			elseif idx == self.textlistSelected and self.textlist == "PROFILES" then
				if work[idx] == self.db.char.profileKey then
					CliqueButtonSetProfile:Disable()
					CliqueButtonDeleteProfile:Disable()
				else
					CliqueButtonSetProfile:Enable()
					CliqueButtonDeleteProfile:Enable()
				end
				button:SetChecked(true)
			elseif self.textlist == "FRAMES" then
				local name = work[idx]
				local frame = getglobal(name)

				if not self.profile.blacklist then 
					self.profile.blacklist = {}
				end
				local bl = self.profile.blacklist

				if bl[name] then
					button:SetChecked(nil)
				else
					button:SetChecked(true)
				end
            else
                button:SetBackdropBorderColor(0.3, 0.3, 0.3)
				button:SetChecked(nil)
            end
        else
            button:Hide()
        end
    end
end
