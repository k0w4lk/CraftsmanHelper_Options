local realmName = GetRealmName()
local PrceListInitialized = false
local lastReagenIndex = 0

Core = CreateFrame("Frame", "CharacterNotes", UIParent)
Core:SetSize(640, 620)
Core:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
Core.texture = Core:CreateTexture()
Core.texture:SetAllPoints(Core)
Core.texture:SetTexture(0, 0, 0, 0.8)
Core:SetBackdrop(
    {
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    }
)
Core:SetBackdropColor(0, 0, 0, 0)
Core:SetMovable(true)
Core:EnableMouse(true)
Core:RegisterForDrag("LeftButton")
Core:SetScript("OnDragStart", Core.StartMoving)
Core:SetScript("OnDragStop", Core.StopMovingOrSizing)

local OptionsScrollChild = CreateFrame("Frame", "OptionsScrollChild")
OptionsScrollChild:SetWidth(620)
OptionsScrollChild:SetHeight(550)

local Options = CreateFrame("ScrollFrame", "CraftsmanHelper_Options", Core, "UIPanelScrollFrameTemplate")
Options:SetHeight(550)
Options:SetWidth(600)
Options:SetPoint("TOPLEFT", Core, "TOPLEFT", 0, -60)
Options:SetFrameLevel(1)
Options:SetScrollChild(OptionsScrollChild)

Options:RegisterEvent("PLAYER_LOGIN")
Options:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

function Options:PLAYER_LOGIN()
    if ReagentsPrices == nil then
        ReagentsPrices = {
            [realmName] = {}
        }
    end
end

local auctionatorRealmName = realmName .. "_" .. UnitFactionGroup("player")

Options:SetScript(
    "OnEvent",
    function(self, event, ...)
        return self[event](self, ...)
    end
)

Core:Hide()

local CloseSetingsButton = CreateFrame("Button", "CloseSetingsButton", Core, "UIPanelCloseButton")

CloseSetingsButton:SetPoint("TOPRIGHT", Core, "TOPRIGHT", 0, 0)

local ReagentName = CreateFrame("EditBox", "ReagentName", Core, "InputBoxTemplate")
ReagentName:SetHeight(20)
ReagentName:SetAutoFocus(false)

ReagentName:SetWidth(200)
ReagentName:SetPoint("TOPLEFT", Core, "TOPLEFT", 20, -20)

local ReagentPriceGold = CreateFrame("EditBox", "ReagentPriceGold", Core, "InputBoxTemplate")
ReagentPriceGold:SetHeight(20)
ReagentPriceGold:SetWidth(50)
ReagentPriceGold:SetAutoFocus(false)
ReagentPriceGold:SetPoint("TOPLEFT", Core, "TOPLEFT", 240, -20)
ReagentPriceGold.texture = ReagentPriceGold:CreateTexture()
ReagentPriceGold.texture:SetPoint("TOPLEFT", ReagentPriceGold, "TOPRIGHT", 4, -2)
ReagentPriceGold.texture:SetTexture("Interface/Icons/INV_Misc_Coin_01")
ReagentPriceGold.texture:SetSize(16, 16)

local ReagentPriceSilver = CreateFrame("EditBox", "ReagentPriceSilver", Core, "InputBoxTemplate")
ReagentPriceSilver:SetHeight(20)
ReagentPriceSilver:SetWidth(50)
ReagentPriceSilver:SetAutoFocus(false)
ReagentPriceSilver:SetPoint("TOPLEFT", Core, "TOPLEFT", 320, -20)
ReagentPriceSilver.texture = ReagentPriceSilver:CreateTexture()
ReagentPriceSilver.texture:SetPoint("TOPLEFT", ReagentPriceSilver, "TOPRIGHT", 4, -2)
ReagentPriceSilver.texture:SetTexture("Interface/Icons/INV_Misc_Coin_03")
ReagentPriceSilver.texture:SetSize(16, 16)

local ReagentPriceCopper = CreateFrame("EditBox", "ReagentPriceCopper", Core, "InputBoxTemplate")
ReagentPriceCopper:SetHeight(20)
ReagentPriceCopper:SetWidth(50)
ReagentPriceCopper:SetAutoFocus(false)
ReagentPriceCopper:SetPoint("TOPLEFT", Core, "TOPLEFT", 400, -20)
ReagentPriceCopper.texture = ReagentPriceCopper:CreateTexture()
ReagentPriceCopper.texture:SetPoint("TOPLEFT", ReagentPriceCopper, "TOPRIGHT", 4, -2)
ReagentPriceCopper.texture:SetTexture("Interface/Icons/INV_Misc_Coin_05")
ReagentPriceCopper.texture:SetSize(16, 16)

local SaveReagentButton = CreateFrame("Button", "SaveReagentButton", Core, "UIPanelButtonTemplate")
SaveReagentButton:SetSize(100, 20)
SaveReagentButton:SetText("Сохранить")
SaveReagentButton:SetPoint("TOPLEFT", Core, "TOPLEFT", 475, -20)
SaveReagentButton:SetScript(
    "OnClick",
    function(self, button, down)
        SaveReagent()
    end
)

function CreateReagentInput(width, text, left)
    local input = CreateFrame("EditBox", "ReagentInput", OptionsScrollChild)
    input:SetHeight(20)
    input:SetAutoFocus(false)
    input:SetWidth(width)
    input:SetText(text)
    input:SetFont("Fonts\\FRIZQT__.TTF", 11)
    input:SetTextInsets(4, 0, 0, 0)
    input:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", left, (0 - 24 * (lastReagenIndex + 1)))
    input:SetScript(
        "OnEscapePressed",
        function(self)
            self:ClearFocus()
        end
    )

    return input
end

function CreateReagentAuctionatorPrice(width, text, left)
    local auctionatorPrice = OptionsScrollChild:CreateFontString()
    auctionatorPrice:SetHeight(20)
    auctionatorPrice:SetFont("Fonts\\FRIZQT__.TTF", 11)
    auctionatorPrice:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", left, (0 - 24 * (lastReagenIndex + 1)))
    auctionatorPrice:SetText(GetCoinTextureString(text))
end

function SaveReagent()
    local reagent = ReagentName:GetText()

    if reagent ~= "" then
        local price = ReagentPriceGold:GetNumber()
        ReagentsPrices[realmName][reagent] = price

        ReagentName:SetText("")
        ReagentPriceGold:SetNumber("")
        ReagentPriceGold:ClearFocus()
        ReagentPriceGold:ClearFocus()

        local ReagentRowName = CreateReagentInput(200, reagent, 20)
        SetupInputTexture(ReagentRowName)

        local ReagentRowPrice = CreateReagentInput(100, price, 240)
        SetupInputTexture(ReagentRowPrice)

        local auctionatorPrice = AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagent]

        if auctionatorPrice ~= nil then
            CreateReagentAuctionatorPrice(100, auctionatorPrice, 350)
        end

        lastReagenIndex = lastReagenIndex + 1
    end
end

function InitPriceList()
    for name, price in pairs(ReagentsPrices[realmName]) do
        local ReagentRowName = CreateReagentInput(200, name, 20)
        SetupInputTexture(ReagentRowName)

        local ReagentRowPrice = CreateReagentInput(100, price, 240)
        SetupInputTexture(ReagentRowPrice)

        local auctionatorPrice = AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][name]

        if auctionatorPrice ~= nil then
            CreateReagentAuctionatorPrice(100, auctionatorPrice, 350)
        end

        lastReagenIndex = lastReagenIndex + 1
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
        if not PrceListInitialized then
            InitPriceList()
            PrceListInitialized = true
        end
        Core:Show()
    end
end
