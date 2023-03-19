local realmName = GetRealmName()

if ReagentPrices == nil then
    ReagentsPrices = {
        [realmName] = {}
    }
end

local Options = CreateFrame("ScrollFrame", "CraftsmanHelper_Options", UIParent, "UIPanelScrollFrameTemplate")
Options:SetHeight(600)
Options:SetWidth(600)
Options:SetPoint("CENTER", 0, 0)
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

function CreateReagentInput(width, text, left)
    input = CreateFrame("EditBox", nil, OptionsScrollChild)
    input:SetHeight(20)
    input:SetAutoFocus(false)
    input:SetWidth(width)
    input:SetText(text)
    input:SetFont("Fonts\\FRIZQT__.TTF", 11)
    input:SetTextInsets(4, 0, 0, 0)
    input:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", left, (-40 - 24 * (idx + 1)))
    input:SetScript(
        "OnEscapePressed",
        function(self)
            self:ClearFocus()
        end
    )

    return input
end

function InitPriceList()
    local idx = 1
    for name, price in pairs(ReagentsPrices[realmName]) do
        local ReagentRowName = CreateReagentInput(200, name, 20)

        SetupInputTexture(ReagentRowName)

        local ReagentRowPrice = CreateReagentInput(100, price, 240)

        SetupInputTexture(ReagentRowPrice)

        idx = idx + 1
    end
end

function SetupInputTexture(frame)
    frame.texture = frame:CreateTexture()
    frame.texture:SetAllPoints(frame)
    frame.texture:SetTexture(0, 0, 0, 0.5)
    frame:SetBackdrop(
        {
            bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            tile = true,
            tileSize = 16,
            edgeSize = 4,
            insets = {
                left = 3,
                right = 3,
                top = 5,
                bottom = 3
            }
        }
    )
    frame:SetBackdropColor(0, 0, 0, 1)
end

SLASH_CMH1 = "/cmh"
SlashCmdList["CMH"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if (cmd == "options") then
        InitPriceList()
        Options:Show()
    end
end
