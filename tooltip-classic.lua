local function GameTooltip_OnTooltipSetItem(tooltip)
    assert(tooltip, "Tooltip window not loading properly");

    local _, link = tooltip:GetItem();
    if tooltipModified[tooltip:GetName()] then return; end
    tooltipModified[tooltip:GetName()] = true;
    if not link or windowMerchantOpened then return; end

    local focus = GetMouseFocus();
    local bagId, slotId, frameName = focus:GetParent():GetID(), focus:GetID(), focus:GetParent():GetName();

    local itemStackCount = select(8, GetItemInfo(link));
    local itemPrice = select(11, GetItemInfo(link));
    if not itemPrice or itemPrice == 0 then return; end

    local currentStackCount = focus.count ~= nil and focus.count or 1;
    if bagId ~= nil and slotId ~= nil and string.find(frameName, 'ContainerFrame[%d]+') ~= nil then
        local containerItemInfo = C_Container.GetContainerItemInfo(bagId, slotId);
        if containerItemInfo.hasNoValue == true then return; end
    end

    if slotId ~= nil and focus.count == nil and frameName == 'LootFrame' then
        currentStackCount = select(3, GetLootSlotInfo(slotId));
    end

    if not itemPrice or itemPrice == 0 then return; end
    local stackPrice = itemPrice * currentStackCount;

    local itemPriceGold = floor(itemPrice / 10000);
    local itemPriceSilver = floor((itemPrice - itemPriceGold * 10000) / 100);
    local itemPriceCopper = itemPrice - itemPriceGold * 10000 - itemPriceSilver * 100;
    local itemPriceText = itemPriceGold > 0 and (itemPriceGold .. ' |TInterface/MoneyFrame/UI-GoldIcon:0|t ') or '';
    itemPriceText = itemPriceText .. (itemPriceSilver > 0 and (itemPriceSilver .. ' |TInterface/MoneyFrame/UI-SilverIcon:0|t ') or '');
    itemPriceText = itemPriceText .. (itemPriceCopper > 0 and (itemPriceCopper .. ' |TInterface/MoneyFrame/UI-CopperIcon:0|t') or '');

    local stackPriceGold = floor(stackPrice / 10000);
    local stackPriceSilver = floor((stackPrice - stackPriceGold * 10000) / 100);
    local stackPriceCopper = stackPrice - stackPriceGold * 10000 - stackPriceSilver * 100;
    local stackPriceText = stackPriceGold > 0 and (stackPriceGold .. ' |TInterface/MoneyFrame/UI-GoldIcon:0|t ') or '';
    stackPriceText = stackPriceText .. (stackPriceSilver > 0 and (stackPriceSilver .. ' |TInterface/MoneyFrame/UI-SilverIcon:0|t ') or '');
    stackPriceText = stackPriceText .. (stackPriceCopper > 0 and (stackPriceCopper .. ' |TInterface/MoneyFrame/UI-CopperIcon:0|t') or '');

    local itemString = string.match(link, "item[%-?%d:]+");
    local _, itemId = strsplit(":", itemString);
    local shouldUpdate = false;
    local displayStack = itemPrice > 0 and currentStackCount > 1 and itemStackCount > 1;

    if itemPrice > 0 then
        tooltip:AddDoubleLine(displayStack and ('Sell One: ' .. itemPriceText) or ('Sell Price: ' .. itemPriceText), '', 1, 1, 1, 1, 1, 1);
        shouldUpdate = true;
    end
    if displayStack then
        tooltip:AddDoubleLine('Sell Price: ' .. stackPriceText, 'Stack: ' .. itemStackCount, 1, 1, 1, 1, 1, 1);
        shouldUpdate = true;
    end

    if shouldUpdate == true then
        tooltip:Show();
    end
end

GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem);
GameTooltip:HookScript("OnTooltipCleared", GameTooltip_OnTooltipCleared);