frame = CreateFrame('Frame');
windowMerchantOpened = false;

local function RegisterEvents(self, ...)
    for i=1,select('#', ...) do
        self:RegisterEvent(select(i, ...))
    end
end

local function eventHandler(self, event, ...)
    if (event == 'MERCHANT_SHOW') then
        windowMerchantOpened = true;
    end
    if (event == 'MERCHANT_CLOSED') then
        windowMerchantOpened = false;
    end
end
frame:SetScript("OnEvent", eventHandler);

RegisterEvents(frame, 'MERCHANT_SHOW', 'MERCHANT_CLOSED');