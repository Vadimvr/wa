local slackList = {}

local report_options = {'self', 'raid', 'raid_warning', 'guild', 'party'}
local report_to = report_options[aura_env.config["report_to"]]
local test_mode = aura_env.config["test"]

aura_env.send_msg = function(namePlayer)
    
    local found  = true;
    local className = nil
    local classFilename = nil
    local color = "|cFFFFFFFF"
    -- get a class if the player is in the raid 
    if(UnitInRaid ("player"))then
        className, classFilename = UnitClass(namePlayer) 
    end
    -- color
    if (classFilename =="DEATHKNIGHT")then
        color = "|cFFFF0000"; 
    elseif (classFilename =="WARLOCK")then
        color = "|cFFCC00FF";
    elseif (classFilename =="DRUID")then
        color = "|cFFFF9900";
    elseif (classFilename =="MAGE")then
        color = "|cFF00B4FF";
    elseif (classFilename =="HUNTER")then
        color = "|cFF66FF00";
    elseif (classFilename =="PALADIN")then
        color = "|cFFff0092";
    elseif (classFilename =="WARRIOR")then
        color = "|cFF66281e";
    elseif (classFilename =="ROGUE")then
        color = "|cFFFFF00";
    elseif (classFilename =="SHAMAN")then
        color = "|cF0918e3";
    else
        color = "|cFFb3afaf"
    end
    
    local msg = color..namePlayer .. "|r".. " exploded spirit"
    print(msg)
    -- add a player to the table 
    for k,v in ipairs(slackList) do 
        msg = v.count.." - "..v.name
        if v.name == namePlayer then
            v.count = v.count +1;
            found = false;
        end
    end 
    if(found) then
        table.insert(slackList,{name = namePlayer, count = 1, colorText = color, endColor = "|r"})
    end
end
-- function for getting a list of slackers 
aura_env.updateSlackers = function()
    local res = ""
    for k,v in ipairs(slackList) do
        res = res..v.count.." - ".. v.colorText..v.name .. v.endColor.."\n"
    end 
    return res;
end

aura_env.printSlakersInRaid = function() --print chat messages
    local msg = ""
    local msgFirst = "Did not run away from the spirits:"
    if report_to == "self" then
        print(msgFirst)
    else
        SendChatMessage(msgFirst, report_to)
    end
    
    for k,v in ipairs(slackList) do 
        if report_to == "self" then
            print(v.count.." - ".. v.colorText..v.name .. v.endColor)
        else
            msg = v.count.." - "..v.name
            SendChatMessage(msg, report_to)
        end
    end 
end
-- Creating buttons
aura_env.clearSlackers = function()
    print("clearSlackers");
    slackList = {}
end

local frameNamePrint = aura_env.id.."print"
local frameNameClear = aura_env.id.."clear"

local existingFramePrint  = _G[frameNamePrint]
local existingFrameClear  = _G[frameNameClear]

local buttonPrint = existingFramePrint
local buttonClear = existingFrameClear

if buttonPrint == nil then
    buttonPrint=CreateFrame("Button", frameNamePrint, aura_env.region, "UIPanelButtonTemplate")
end
if buttonClear == nil then
    buttonClear=CreateFrame("Button", frameNameClear, aura_env.region, "UIPanelButtonTemplate")
end

buttonPrint:SetAllPoints()
buttonPrint:SetText("Print")
buttonPrint:SetSize(60, 24)
buttonPrint:ClearAllPoints()
buttonPrint:SetPoint("TOPLEFT",0,0)
buttonPrint:SetScript("OnClick",aura_env.printSlakersInRaid)


buttonClear:SetAllPoints()
buttonClear:SetText("Clear")
buttonClear:SetSize(60, 24)
buttonClear:ClearAllPoints()
buttonClear:SetPoint("TOPLEFT",70,0)
buttonClear:SetScript("OnClick",aura_env.clearSlackers)



-- Test
local frameNameTest = aura_env.id.."test"
local existingFrameTest  = _G[frameNameTest]
local buttonTest = existingFrameTest

aura_env.testSlackers = function()
    slackList = {
            {name = "DEATHKNIGHT",     count = 1, colorText = "|cFFFF0000", endColor = "|r"},
            {name = "WARLOCK",    count = 1, colorText = "|cFFCC00FF", endColor = "|r"},
            {name = "DRUID",  count = 1, colorText = "|cffFF9900", endColor = "|r"},
            {name = "MAGE",   count = 1, colorText = "|cFF00B4FF", endColor = "|r"},
            {name = "HUNTER", count = 1, colorText = "|cFF66FF00", endColor = "|r"},
            {name = "PALADIN",    count = 1, colorText = "|cFFff0092", endColor = "|r"},
            {name = "WARRIOR",    count = 1, colorText = "|cFF66281e", endColor = "|r"},
            {name = "ROGUE",    count = 1, colorText = "|cFFFFFF00", endColor = "|r"},
            {name = "PRIEST",  count = 1, colorText = "|cFFFFFFFF", endColor = "|r"}, 
            {name = "SHAMAN",  count = 1, colorText = "|cFF0918e3", endColor = "|r"},
        }
        
        local msg = ""        
end
    
if buttonTest == nil then
    buttonTest=CreateFrame("Button", frameNameTest, aura_env.region, "UIPanelButtonTemplate")
end

buttonTest:SetAllPoints()
buttonTest:SetText("Test")
buttonTest:SetSize(60, 24)
buttonTest:ClearAllPoints()
buttonTest:SetPoint("TOPLEFT",140,0)
buttonTest:SetScript("OnClick",aura_env.testSlackers)
buttonTest:Hide();

local frameNameTest_target = aura_env.id.."_target"
local existingFrameTest_target  = _G[frameNameTest_target]
local buttonTest_target = existingFrameTest_target

if buttonTest_target == nil then
    buttonTest_target=CreateFrame("Button", frameNameTest_target, aura_env.region, "UIPanelButtonTemplate")
end

aura_env._target  = function()
    local unitName, realm = UnitName("target")
    print (tostring(unitName))
    if(unitName ~=nil)then
        aura_env.send_msg(unitName);
    end
end

buttonTest_target:SetAllPoints()
buttonTest_target:SetText("target")
buttonTest_target:SetSize(60, 24)
buttonTest_target:ClearAllPoints()
buttonTest_target:SetPoint("TOPLEFT",210,0)
buttonTest_target:SetScript("OnClick",aura_env._target)
buttonTest_target:Hide();
    
if(test_mode)then
    buttonTest:Show();
    buttonTest_target:Show();
else
    buttonTest:Hide();
    buttonTest_target:Hide();
end