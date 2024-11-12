local realmName = GetRealmName()
local PrceListInitialized = false
local lastReagenIndex = 0
local FrameHidden = true

local renderedItems = {}

function cmh_ChatEdit_InsertLink(text)
	if (CMH_Core:IsShown() and IsShiftKeyDown()) then	
		local item;
		
        if (strfind(text, "item:", 1, true)) then
			item = GetItemInfo(text);
		end

		if (item) then
			ReagentName:SetText(item);
			return true;
		end
	end

	return cmh_orig_ChatEdit_InsertLink(text);

end 

local cmh_orig_ChatEdit_InsertLink = ChatEdit_InsertLink;
ChatEdit_InsertLink = cmh_ChatEdit_InsertLink;


local priceInputWidth = {
    gold = 80,
    silver = 30,
    copper = 30
}

CMH_Core = CreateFrame("Frame", "CMH", UIParent)
CMH_Core:SetSize(640, 620)
CMH_Core:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
CMH_Core.texture = CMH_Core:CreateTexture()
CMH_Core.texture:SetAllPoints(CMH_Core)
CMH_Core.texture:SetTexture(0, 0, 0, 0.8)
CMH_Core:SetBackdrop(
    {
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    }
)
CMH_Core:SetBackdropColor(0, 0, 0, 0)
CMH_Core:SetMovable(true)
CMH_Core:EnableMouse(true)
CMH_Core:RegisterForDrag("LeftButton")
CMH_Core:SetScript("OnDragStart", CMH_Core.StartMoving)
CMH_Core:SetScript("OnDragStop", CMH_Core.StopMovingOrSizing)

local OptionsScrollChild = CreateFrame("Frame", "OptionsScrollChild")
OptionsScrollChild:SetWidth(620)
OptionsScrollChild:SetHeight(550)

local autionPriceTextLabel = CMH_Core:CreateFontString(nil, "OVERLAY", "GameFontNormal")
autionPriceTextLabel:SetPoint("TOP", -36, -68);
autionPriceTextLabel:SetText("Цена аукциона");

local userPriceTextLabel = CMH_Core:CreateFontString(nil, "OVERLAY", "GameFontNormal")
userPriceTextLabel:SetPoint("TOP", 90, -68);
userPriceTextLabel:SetText("Твоя цена");

local Options = CreateFrame("ScrollFrame", "CraftsmanHelper_Options", CMH_Core, "UIPanelScrollFrameTemplate")
Options:SetHeight(550)
Options:SetWidth(600)
Options:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 0, -60)
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

CMH_Core:Hide()

local CloseSetingsButton = CreateFrame("Button", "CloseSetingsButton", CMH_Core, "UIPanelCloseButton")

CloseSetingsButton:SetPoint("TOPRIGHT", CMH_Core, "TOPRIGHT", 0, 0)
CMH_Core:SetScript(
    "OnHide",
    function()
        FrameHidden = true
    end
)

local ReagentName = CreateFrame("EditBox", "ReagentName", CMH_Core, "InputBoxTemplate")
ReagentName:SetHeight(20)
ReagentName:SetAutoFocus(false)

ReagentName:SetWidth(200)
ReagentName:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 20, -20)

local ReagentPriceGold = CreateFrame("EditBox", "ReagentPriceGold", CMH_Core, "InputBoxTemplate")
ReagentPriceGold:SetHeight(20)
ReagentPriceGold:SetWidth(50)
ReagentPriceGold:SetAutoFocus(false)
ReagentPriceGold:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 240, -20)
ReagentPriceGold.texture = ReagentPriceGold:CreateTexture()
ReagentPriceGold.texture:SetPoint("TOPLEFT", ReagentPriceGold, "TOPRIGHT", 4, -2)
ReagentPriceGold.texture:SetTexture("Interface/Icons/INV_Misc_Coin_01")
ReagentPriceGold.texture:SetSize(16, 16)

local ReagentPriceSilver = CreateFrame("EditBox", "ReagentPriceSilver", CMH_Core, "InputBoxTemplate")
ReagentPriceSilver:SetHeight(20)
ReagentPriceSilver:SetWidth(50)
ReagentPriceSilver:SetAutoFocus(false)
ReagentPriceSilver:SetMaxLetters(2)
ReagentPriceSilver:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 320, -20)
ReagentPriceSilver.texture = ReagentPriceSilver:CreateTexture()
ReagentPriceSilver.texture:SetPoint("TOPLEFT", ReagentPriceSilver, "TOPRIGHT", 4, -2)
ReagentPriceSilver.texture:SetTexture("Interface/Icons/INV_Misc_Coin_03")
ReagentPriceSilver.texture:SetSize(16, 16)

local ReagentPriceCopper = CreateFrame("EditBox", "ReagentPriceCopper", CMH_Core, "InputBoxTemplate")
ReagentPriceCopper:SetHeight(20)
ReagentPriceCopper:SetWidth(50)
ReagentPriceCopper:SetAutoFocus(false)
ReagentPriceCopper:SetMaxLetters(2)
ReagentPriceCopper:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 400, -20)
ReagentPriceCopper.texture = ReagentPriceCopper:CreateTexture()
ReagentPriceCopper.texture:SetPoint("TOPLEFT", ReagentPriceCopper, "TOPRIGHT", 4, -2)
ReagentPriceCopper.texture:SetTexture("Interface/Icons/INV_Misc_Coin_05")
ReagentPriceCopper.texture:SetSize(16, 16)

local SaveReagentButton = CreateFrame("Button", "SaveReagentButton", CMH_Core, "UIPanelButtonTemplate")
SaveReagentButton:SetSize(100, 20)
SaveReagentButton:SetText("Сохранить")
SaveReagentButton:SetPoint("TOPLEFT", CMH_Core, "TOPLEFT", 475, -20)
SaveReagentButton:SetScript(
    "OnClick",
    function(self, button, down)
        SaveReagent()
    end
)

function CreateReagentInput(width, text, left)
    if (not renderedItems[text]) then
        local input = OptionsScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        local index = lastReagenIndex + 1
        input:SetHeight(20)
        input:SetWidth(width)
        input:SetText(text)
        input:SetJustifyH("LEFT")
        input:SetTextColor(255, 255, 255)
        input:SetFont("Fonts\\FRIZQT__.TTF", 11)
        input:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", left, (0 - 24 * index))
    end    
end

function CreateReagentAuctionatorPrice(width, price, left, text)
    if (renderedItems[text]) then
        renderedItems[text]:SetText(GetCoinTextureString(price))
        return nil
    else
        local auctionatorPrice = OptionsScrollChild:CreateFontString()
        local index = lastReagenIndex + 1
        auctionatorPrice:SetHeight(20)
        auctionatorPrice:SetFont("Fonts\\FRIZQT__.TTF", 11)
        auctionatorPrice:SetPoint("TOPLEFT", OptionsScrollChild, "TOPLEFT", left, (0 - 24 * index))
        auctionatorPrice:SetText(GetCoinTextureString(price))
        return auctionatorPrice;
    end
end

function SaveReagent()
    local reagent = ReagentName:GetText()

    if reagent ~= "" then
        local priceGold = ReagentPriceGold:GetNumber()
        local priceSilver = ReagentPriceSilver:GetNumber()
        local priceCopper = ReagentPriceCopper:GetNumber()

        local price = priceGold * 10000 + priceSilver * 100 + priceCopper

        ReagentsPrices[realmName][reagent] = price

        ReagentName:SetText("")
        ReagentPriceGold:SetNumber("")
        ReagentPriceGold:ClearFocus()
        ReagentPriceSilver:SetNumber("")
        ReagentPriceSilver:ClearFocus()
        ReagentPriceCopper:SetNumber("")
        ReagentPriceCopper:ClearFocus()

        CreateReagentInput(200, reagent, 20)

        local priceText = CreateReagentAuctionatorPrice(100, price, 380, reagent)

        if (priceText) then
            renderedItems[reagent] = priceText
            lastReagenIndex = lastReagenIndex + 1
       
            if auctionatorPrice ~= nil then
                CreateReagentAuctionatorPrice(100, auctionatorPrice, 380, nil)
            end
        end

        local auctionatorPrice = AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][reagent]

    end
end

function InitPriceList()
    for name, price in pairs(ReagentsPrices[realmName]) do
        CreateReagentInput(200, name, 20)

        local priceText = CreateReagentAuctionatorPrice(100, price, 380, nil)

        if (priceText) then
            renderedItems[name] = priceText
        end

        local auctionatorPrice = AUCTIONATOR_PRICE_DATABASE[auctionatorRealmName][name]

        if auctionatorPrice ~= nil then
            CreateReagentAuctionatorPrice(100, auctionatorPrice, 240, nil)
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

        if FrameHidden then
            CMH_Core:Show()
            FrameHidden = false
        else
            CMH_Core:Hide()
            FrameHidden = true
        end
    end
end
