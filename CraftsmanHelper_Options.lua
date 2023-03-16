local realmName = GetRealmName()

if ReagentPrices == nil then
    ReagentsPrices = {
        [realmName] = {}
    }
end

local Options = CreateFrame("ScrollFrame", "CraftsmanHelper_Options", UIParent, "UIPanelScrollFrameTemplate")
Options:SetPoint("TOPLEFT", 3, -4)
Options:SetPoint("BOTTOMRIGHT", -27, 4)
Options:SetHeight(600)
Options:SetWidth(600)
Options:SetFrameLevel(1)

local OptionsScrollChild = CreateFrame("Frame")
Options:SetScrollChild(OptionsScrollChild)
OptionsScrollChild:SetWidth(582)
OptionsScrollChild:SetHeight(600)


local auctionatorRealmName = realmName .. "_" .. UnitFactionGroup("player")

Options:SetMovable(true)
Options:EnableMouse(true)
Options:RegisterForDrag("LeftButton")
Options:SetScript("OnDragStart", Options.StartMoving)
Options:SetScript("OnDragStop", Options.StopMovingOrSizing)

Options:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

Options.texture = Options:CreateTexture()
Options.texture:SetAllPoints(Options)
Options.texture:SetTexture(0, 0, 0, 0.5)
Options:SetBackdrop(
    {
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 3,
            right = 3,
            top = 5,
            bottom = 3
        }
    }
)
Options:SetBackdropColor(0, 0, 0, 1)

Options:Hide()

local CloseSetingsButton = CreateFrame("Button", "CloseSetingsButton", OptionsScrollChild, "UIPanelCloseButton")

CloseSetingsButton:SetPoint("TOPRIGHT", OptionsScrollChild, "TOPRIGHT", 0, 0)

local ReagentName = CreateFrame("EditBox", "ReagentName", OptionsScrollChild, "InputBoxTemplate")
ReagentName:SetHeight(20)
ReagentName:SetAutoFocus(false)

ReagentName:SetWidth(200)
ReagentName:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", 20, -20)

local ReagentPrice = CreateFrame("EditBox", "ReagentPrice", OptionsScrollChild, "InputBoxTemplate")
ReagentPrice:SetHeight(20)
ReagentPrice:SetWidth(100)
ReagentPrice:SetAutoFocus(false)

ReagentPrice:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", 240, -20)

local SaveReagentButton = CreateFrame("Button", "SaveReagentButton", OptionsScrollChild, "UIPanelButtonTemplate")
SaveReagentButton:SetSize(100, 20)
SaveReagentButton:SetText("Сохранить")
SaveReagentButton:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", 360, -20)
SaveReagentButton:SetScript(
    "OnClick",
    function(self, button, down)
        SaveReagent()
    end
)

function SaveReagent()
    local reagent = ReagentName:GetText()

    if reagent ~= "" then
        local price = ReagentPrice:GetNumber()
        ReagentsPrices[realmName][reagent] = price
    end
end

SLASH_CMH1 = "/cmh"
SlashCmdList["CMH"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if (cmd == "options") then
        Options:Show()
        local idx = 1
        for name, price in pairs(ReagentsPrices[realmName]) do
            local ReagentRowName = CreateFrame("EditBox", "ReagentRowName", OptionsScrollChild, "InputBoxTemplate")
            ReagentRowName:SetHeight(20)
            ReagentRowName:SetAutoFocus(false)
            ReagentRowName:SetWidth(200)
            ReagentRowName:SetText(name)
            ReagentRowName:SetFont("Fonts\\FRIZQT__.TTF", 11)
            ReagentRowName:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", 20, (-60 * (idx * 2)))
            ReagentRowName:SetScript(
                "OnEscapePressed",
                function(self)
                    self:ClearFocus()
                end
            )

            local ReagentRowPrice = CreateFrame("EditBox", "ReagentRowPrice", OptionsScrollChild, "InputBoxTemplate")
            ReagentRowPrice:SetHeight(20)
            ReagentRowPrice:SetAutoFocus(false)

            ReagentRowPrice:SetWidth(100)
            ReagentRowPrice:SetNumber(price)
            ReagentRowPrice:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", 240, (-60 * (idx * 4)))
            idx = idx + 1
        end
    end
end
