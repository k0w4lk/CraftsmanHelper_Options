local MMB = CreateFrame("Button", "CMH_MinimapButton", Minimap)

MMB:SetSize(32, 32)

MMB.icon = MMB:CreateTexture("", "BACKGROUND")
MMB.icon:SetTexture("Interface\\AddOns\\CraftsmanHelper_Options\\mmb-icon")
MMB.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
MMB.icon:SetWidth(17)
MMB.icon:SetHeight(17)
MMB.icon:SetPoint("CENTER", MMB, "CENTER", 0,0)

MMB.mask = MMB:CreateTexture("", "OVERLAY")
MMB.mask:SetTexCoord(0.0, 0.6, 0.0, 0.6)
MMB.mask:SetTexture("Interface\\Minimap\\Minimap-TrackingBorder")
MMB.mask:SetAllPoints(true)

MMB:SetMovable(true)
MMB:SetFrameStrata("MEDIUM")

local function mouseDown()
	MMB.icon:SetTexCoord(0, 1, 0, 1)
end

local function mouseUp()
	MMB.icon:SetTexCoord(0.075, 0.925, 0.075, 0.925)
end

MMB:SetScript("OnMouseDown", mouseDown)
MMB:SetScript("OnMouseUp", mouseUp)

local myIconPos = 0

local function UpdateMapBtn()
    local Xpoa, Ypoa = GetCursorPosition()
    local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
    Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
    Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
    myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
    MMB:ClearAllPoints()
    MMB:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)
end

MMB:RegisterForDrag("LeftButton")

MMB:SetScript(
    "OnDragStart",
    function()
        MMB:StartMoving()
        MMB:SetScript("OnUpdate", UpdateMapBtn)
    end
)

MMB:SetScript(
    "OnDragStop",
    function()
        MMB:StopMovingOrSizing()
        MMB:SetScript("OnUpdate", nil)
        UpdateMapBtn()
    end
)
MMB:ClearAllPoints()

MMB:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)

MMB:SetScript(
    "OnClick",
    function()
        SlashCmdList["CMH"]('options')
    end
)

MMB:SetScript(
    "OnEnter", 
    function(self, motion)
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	    GameTooltip:SetText("CMH Options")
    end
)
MMB:SetScript(
    "OnLeave", 
    function(self, motion)
        GameTooltip:Hide()
    end
)