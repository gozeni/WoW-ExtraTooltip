local function GameTooltip_OnTooltipSetItem(tooltip, data)
    assert(tooltip, "Tooltip window not loading properly");

    local _, link = tooltip:GetItem();
    if not link or windowMerchantOpened then return; end

    local focus = GetMouseFocus();
    local bagId, slotId, frameName = focus:GetParent():GetID(), focus:GetID(), focus:GetParent():GetName();

    local itemStackCount = select(8, GetItemInfo(link));
    local itemPrice = select(11, GetItemInfo(link));
    local currentStackCount = (bagId ~= nil and slotId ~= nil) and C_Container.GetContainerItemInfo(bagId, slotId).stackCount or 1;
    if currentStackCount < 2 then return; end

    local itemPriceGold = floor(itemPrice / 10000);
    local itemPriceSilver = floor((itemPrice - itemPriceGold * 10000) / 100);
    local itemPriceCopper = itemPrice - itemPriceGold * 10000 - itemPriceSilver * 100;
    local itemPriceText = itemPriceGold > 0 and (itemPriceGold .. ' |TInterface/MoneyFrame/UI-GoldIcon:0|t ') or '';
    itemPriceText = itemPriceText .. (itemPriceSilver > 0 and (itemPriceSilver .. ' |TInterface/MoneyFrame/UI-SilverIcon:0|t ') or '');
    itemPriceText = itemPriceText .. (itemPriceCopper > 0 and (itemPriceCopper .. ' |TInterface/MoneyFrame/UI-CopperIcon:0|t') or '');

    local itemString = string.match(link, "item[%-?%d:]+");
    local _, itemId = strsplit(":", itemString);

    if itemPrice > 0 and currentStackCount > 1 and itemStackCount > 1 and frameName ~= 'QuestInfoRewardsFrame' then
        tooltip:AddDoubleLine('Sell One: ' .. itemPriceText, 'Stack: ' .. itemStackCount, 1, 1, 1, 1, 1, 1);
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, GameTooltip_OnTooltipSetItem);