--Initializes the tables needed for the code to run
-- maybe https://devforum.roblox.com/t/bettertables-adding-on-to-lua-table-functionality/1583176
if not BzRecipeTweaker then
    BzRecipeTweaker = {}
end

if not TweakOneRecipeData then
    TweakOneRecipeData = {}
end
if not TweakSameNameRecipeData then
    TweakSameNameRecipeData = {}
end
if not TweakAllRecipeData then
    TweakAllRecipeData = {}
end

function BzRecipeTweaker.TweakOneRecipe()
    local recipe;
    for recipeName, recipeChanges in pairs(TweakOneRecipeData) do
        recipe = getScriptManager():getRecipe(recipeName);
        if recipe then
            for _, recipeChange in pairs(recipeChanges) do
                if not BzRecipeTweaker.checkRecipeFilterApply(recipeChange["filter"], recipe) then
                    if recipeChange["resultChanges"] ~= nil then
                        if recipeChange["resultChanges"]["resultCount"] ~= nil then
                            recipe:getResult():setCount(tonumber(recipeChange["resultChanges"]["resultCount"]))
                        end
                        if recipeChange["resultChanges"]["resultDrainableCount"] ~= nil then
                            recipe:getResult():setDrainableCount(tonumber(recipeChange["resultChanges"]["resultDrainableCount"]))
                        end
                    end
                    BzRecipeTweaker.addItemToRecipeSource2(recipe, recipeChange["sourceItem"], recipeChange["newSourceList"], recipeChange["sourceCountChanges"])
                end
            end
        end
    end
end

function TweakOneRecipe(recipeName, sourceItem, sourcesNewItemsList, filter, sourceCountChanges, resultChanges)
    if not TweakOneRecipeData[recipeName] then
        TweakOneRecipeData[recipeName] = {};
    end
    table.insert(TweakOneRecipeData[recipeName], {})
    local lastSourceItemPos = #TweakOneRecipeData[recipeName]
    TweakOneRecipeData[recipeName][lastSourceItemPos]["sourceItem"] = sourceItem
    TweakOneRecipeData[recipeName][lastSourceItemPos]["newSourceList"] = sourcesNewItemsList
    if filter ~= nil and type(filter) == 'table' then
        --if filter["name"] ~= nil then
        TweakOneRecipeData[recipeName][lastSourceItemPos]["filter"] = filter
        --end
    end

    if sourceCountChanges ~= nil and type(sourceCountChanges) == 'table' then
        TweakOneRecipeData[recipeName][lastSourceItemPos]["sourceCountChanges"] = sourceCountChanges
    end

    if resultChanges ~= nil and type(resultChanges) == 'table' then
        TweakOneRecipeData[recipeName][lastSourceItemPos]["resultChanges"] = resultChanges
    end

end

--TweakOneRecipeByType("DLTS.LTS Cut Bits of Mushroom","Base.MushroomGeneric1", "SharpKnife")
function TweakOneRecipeByType(recipeName, sourceItem, type, filter, sourceCountChanges, resultChanges)
    local itemsFromType = getScriptManager():getItemsTag(type)
    if itemsFromType:size() == 0 then
        return
    end
    local listOfItems = {}
    for i = 0, itemsFromType:size() - 1 do
        table.insert(listOfItems, itemsFromType:get(i):getFullName())
    end
    TweakOneRecipe(recipeName, sourceItem, listOfItems, filter, sourceCountChanges, resultChanges)
end

--[[
{ ["Hydrocraft.Make Tailor's Workbench"] = { [1] = { ["newSourceList"] = { [1] = Base.Needle,} ,["filter"] = { ["name"] = jmeno modu filtr,} ,["sourceItem"] = Hydrocraft.HCBoneneedle,} ,} ,}
TweakOneRecipe("Hydrocraft.Make Tailor's Workbench","Hydrocraft.HCBoneneedle", { "Base.Needle" }, {name="jmeno modu filtr"})
]]
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
function BzRecipeTweaker.TweakSameNameRecipe()
    local recipes = getScriptManager():getAllRecipes()
    for recipeName, recipeChanges in pairs(TweakSameNameRecipeData) do
        for i = 0, recipes:size() - 1 do
            local recipe = recipes:get(i)
            if recipe:getModule():getName() .. "." .. recipe:getOriginalname() == recipeName then
                for _, recipeChange in pairs(recipeChanges) do
                    if not BzRecipeTweaker.checkRecipeFilterApply(recipeChange["filter"], recipe) then
                        if recipeChange["resultChanges"] ~= nil then
                            if recipeChange["resultChanges"]["resultCount"] ~= nil then
                                recipe:getResult():setCount(tonumber(recipeChange["resultChanges"]["resultCount"]))
                            end
                            if recipeChange["resultChanges"]["resultDrainableCount"] ~= nil then
                                recipe:getResult():setDrainableCount(tonumber(recipeChange["resultChanges"]["resultDrainableCount"]))
                            end
                        end
                        BzRecipeTweaker.addItemToRecipeSource2(recipe, recipeChange["sourceItem"], recipeChange["newSourceList"], recipeChange["sourceCountChanges"])
                    end
                end
            end
        end
    end
end

--TweakSameNameRecipe("Hydrocraft.Make Compost","Hydrocraft.HCMandrake", { "Base.Needle" })
function TweakSameNameRecipe(recipeName, sourceItem, sourcesNewItemsList, filter, sourceCountChanges, resultChanges)
    if not TweakSameNameRecipeData[recipeName] then
        TweakSameNameRecipeData[recipeName] = {};
    end
    table.insert(TweakSameNameRecipeData[recipeName], {})
    local lastSourceItemPos = #TweakSameNameRecipeData[recipeName]
    TweakSameNameRecipeData[recipeName][lastSourceItemPos]["sourceItem"] = sourceItem
    TweakSameNameRecipeData[recipeName][lastSourceItemPos]["newSourceList"] = sourcesNewItemsList

    if filter ~= nil and type(filter) == 'table' then
        TweakSameNameRecipeData[recipeName][lastSourceItemPos]["filter"] = filter
    end

    if sourceCountChanges ~= nil and type(sourceCountChanges) == 'table' then
        TweakSameNameRecipeData[recipeName][lastSourceItemPos]["sourceCountChanges"] = sourceCountChanges
    end

    if resultChanges ~= nil and type(resultChanges) == 'table' then
        TweakSameNameRecipeData[recipeName][lastSourceItemPos]["resultChanges"] = resultChanges
    end
end

--TweakOneRecipeByType("DLTS.LTS Cut Bits of Mushroom","Base.MushroomGeneric1", "SharpKnife")
function TweakSameNameRecipeByType(recipeName, sourceItem, type, filter, sourceCountChanges, resultChanges)
    local itemsFromType = getScriptManager():getItemsTag(type)
    if itemsFromType:size() == 0 then
        return
    end
    local listOfItems = {}
    for i = 0, itemsFromType:size() - 1 do
        table.insert(listOfItems, itemsFromType:get(i):getFullName())
    end
    TweakSameNameRecipeData(recipeName, sourceItem, listOfItems, filter, sourceCountChanges, resultChanges)
end
-- ====================================================================================================================
function BzRecipeTweaker.TweakAllRecipe()
    local recipes = getScriptManager():getAllRecipes()
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        for _, recipeChange in pairs(TweakAllRecipeData) do
            if not BzRecipeTweaker.checkRecipeFilterApply(recipeChange["filter"], recipe) then
                if recipeChange["resultChanges"] ~= nil then
                    if recipeChange["resultChanges"]["resultCount"] ~= nil then
                        recipe:getResult():setCount(tonumber(recipeChange["resultChanges"]["resultCount"]))
                    end
                    if recipeChange["resultChanges"]["resultDrainableCount"] ~= nil then
                        recipe:getResult():setDrainableCount(tonumber(recipeChange["resultChanges"]["resultDrainableCount"]))
                    end
                end
                BzRecipeTweaker.addItemToRecipeSource2(recipe, recipeChange["sourceItem"], recipeChange["newSourceList"], recipeChange["sourceCountChanges"])
            end
        end
    end
end
--TweakAllRecipe("Hydrocraft.HCBoneneedle", { "Base.Needle" })
--TweakAllRecipe("Base.Needle", { "Hydrocraft.HCBoneneedle" })
function TweakAllRecipe(sourceItem, sourcesNewItemsList, filter, sourceCountChanges, resultChanges)
    local data = {}
    data["sourceItem"] = sourceItem
    data["newSourceList"] = sourcesNewItemsList
    if filter ~= nil and type(filter) == 'table' then
        data["filter"] = filter
    end
    if sourceCountChanges ~= nil and type(sourceCountChanges) == 'table' then
        data["sourceCountChanges"] = sourceCountChanges
    end
    if resultChanges ~= nil and type(resultChanges) == 'table' then
        data["resultChanges"] = resultChanges
    end
    table.insert(TweakAllRecipeData, data)
end

function TweakAllRecipeByType(sourceItem, type, filter, sourceCountChanges, resultChanges)
    local itemsFromType = getScriptManager():getItemsTag(type)
    if itemsFromType:size() == 0 then
        return
    end
    local listOfItems = {}
    for i = 0, itemsFromType:size() - 1 do
        table.insert(listOfItems, itemsFromType:get(i):getFullName())
    end
    TweakAllRecipe(sourceItem, listOfItems, filter, sourceCountChanges, resultChanges)
end

-- ====================================================================================================================
-- ====================================================================================================================
function BzRecipeTweaker.addItemToRecipeSource(recipe, alt_target, alt, filter, sourceChange)
    if filter ~= nil then
        local result = recipe:getResult() -- still java object
        if filter["resultName"] ~= nil and filter["resultName"] ~= "" then
            -- if result is nil and we have filter for name return
            if result == nil then
                return
            elseif result:getFullType() ~= filter["resultName"] then
                return
            end
        end
        if filter["resultCount"] ~= nil and filter["resultCount"] ~= "" then
            -- if result is nil and we have filter for name return
            local resultCountNum = tonumber(filter["resultCount"])
            if resultCountNum ~= nil then
                if result == nil then
                    return
                elseif result:getCount() ~= filter["resultCount"] then
                    return
                end
            end
        end
    end

    for i = 0, recipe:getSource():size() - 1 do
        local source = recipe:getSource():get(i)
        local isSourceMatch = false
        local isAlreadyInSource = false
        local sourceItems = source:getItems()
        for j = 0, sourceItems:size() - 1 do
            local sourceItem = sourceItems:get(j)
            if sourceItem == alt_target then
                isSourceMatch = true
            end
            if sourceItem == alt then
                isAlreadyInSource = true
            end
        end
        if sourceChange ~= nil and isSourceMatch then
            if sourceChange["sourceCount"] ~= nil then
                recipe:getSource():setCount(tonumber(sourceChange["sourceCount"]))
                print(recipe:getOriginalname() .. ": changing Count: ", sourceChange["sourceCount"]);
            end
            if sourceChange["sourceDrainableCount"] ~= nil then
                recipe:getSource():setDrainableCount(tonumber(sourceChange["sourceDrainableCount"]))
                print(recipe:getOriginalname() .. ": changing DrainableCount: ", sourceChange["sourceDrainableCount"]);
            end
        end

        if isSourceMatch and not isAlreadyInSource and alt ~= nil then
            sourceItems:add(alt)
            print(recipe:getOriginalname() .. ": add into " .. alt_target .. ", other item: " .. alt);
            break
        end
    end
end
function BzRecipeTweaker.checkRecipeFilterApply(filter, recipe)
    if filter ~= nil then
        local result = recipe:getResult() -- still java object
        if filter["resultName"] ~= nil and filter["resultName"] ~= "" then
            -- if result is nil and we have filter for name return
            if result == nil then
                return true
            elseif result:getFullType() ~= filter["resultName"] then
                return true
            end
        end
        if filter["resultCount"] ~= nil and filter["resultCount"] ~= "" then
            -- if result is nil and we have filter for name return
            local resultCountNum = tonumber(filter["resultCount"])
            if resultCountNum ~= nil then
                if result == nil then
                    return true
                elseif result:getCount() ~= filter["resultCount"] then
                    return true
                end
            end
        end
        if filter["modName"] ~= nil and filter["modName"] ~= "" then
            if recipe:getModule():getName() ~= filter["modName"] then
                return true
            end
        end
        return false
    end
end

function BzRecipeTweaker.addItemToRecipeSource2(recipe, alt_target, alternatives, sourceChange)
    for i = 0, recipe:getSource():size() - 1 do
        local source = recipe:getSource():get(i)
        local isSourceMatch = false
        local sourceItems = source:getItems()
        for j = 0, sourceItems:size() - 1 do
            local sourceItem = sourceItems:get(j)
            if sourceItem == alt_target then
                isSourceMatch = true
            end
            break
        end

        if sourceChange ~= nil and isSourceMatch then
            if sourceChange["sourceCount"] ~= nil then
                source:setCount(tonumber(sourceChange["sourceCount"]))
                print(recipe:getOriginalname() .. ": changing Count: ", sourceChange["sourceCount"]);
            end
            if sourceChange["sourceDrainableCount"] ~= nil then
                source:setUse(tonumber(sourceChange["sourceDrainableCount"]))
                print(recipe:getOriginalname() .. ": changing DrainableCount: ", sourceChange["sourceDrainableCount"]);
            end
        end

        if isSourceMatch and alternatives ~= nil then
            for _, newSourcesItem in pairs(alternatives) do
                if not sourceItems:contains(newSourcesItem) then
                    sourceItems:add(newSourcesItem)
                    print(recipe:getOriginalname() .. ": add into " .. alt_target .. ", other item: " .. newSourcesItem);
                end
            end
            break
        end
    end
end

function BzRecipeTweaker.CreateFilter(resultName, resultCount, modName)
    -- string,int
    local filter = { resultName = resultName, resultCount = resultCount, modName = modName }
    return filter
end

function BzRecipeTweaker.CreateResultChanges(resultCount, resultDrainableCount)
    -- string,int
    local resultChanges = { resultCount = resultCount, resultDrainableCount = resultDrainableCount }
    return resultChanges
end

function BzRecipeTweaker.CreateSourceCountChanges(sourceCount, sourceDrainableCount)
    -- string,int
    local resultChanges = { sourceCount = sourceCount, sourceDrainableCount = sourceDrainableCount }
    return resultChanges
end
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================

-- https://theindiestone.com/forums/index.php?/topic/22762-how-to-change-tweak-existing-recipes/
--
--Prep code to make the changes to all item in the TweakRecipeItemsAlternativeData table.
function BzRecipeTweaker.tweakItems()
    BzRecipeTweaker.TweakOneRecipe()
    BzRecipeTweaker.TweakSameNameRecipe()
    BzRecipeTweaker.TweakAllRecipe()
end

Events.OnGameBoot.Add(BzRecipeTweaker.tweakItems)

--TweakRecipeItemsAlternativeData["Hydrocraft.Make Tailor's Workbench"] = { ["Hydrocraft.HCBoneneedle"] = "Base.Needle" };
--TweakOneRecipeSourceAlternative("Hydrocraft.Make Tailor's Workbench","Hydrocraft.HCBoneneedle","Base.Needle")
--TweakRecipeAlternativeDeep("Hydrocraft.Make Compost","Hydrocraft.HCMandrake", "Base.Needle");
--TweakRecipeAlternative("Hydrocraft.Make Tailor's Workbench","Hydrocraft.HCBoneneedle", "Base.Needle");
--TweakRecipeAlternativeDeep("Hydrocraft.Make Compost","Hydrocraft.HCMandrake", "Base.Needle");
--TweakRecipeAlternative("Hydrocraft.Make Tailor's Workbench","Hydrocraft.HCBoneneedle", "[Recipe.GetItemTypes.SharpKnife]");
--TweakRecipeAlternativeByType("Hydrocraft.Cut Cheese Wheel","Base.MeatCleaver", "SharpKnife");
--TweakRecipeAlternativeByType("Hydrocraft.Make Tailor's Workbench","Hydrocraft.HCBoneneedle", "SharpKnife");
--TweakAllRecipeAlternative("Hydrocraft.HCBoneneedle","Base.Needle")
--TweakAllRecipeAlternative("Base.Needle","Hydrocraft.HCBoneneedle")

if getActivatedMods():contains("Hydrocraft") then
    TweakOneRecipe("Hydrocraft.Make Tailor's Workbench", "Hydrocraft.HCBoneneedle", { "Base.Needle" }, BzRecipeTweaker.CreateFilter("Hydrocraft.HCTailoringbench"))
    TweakSameNameRecipe("Hydrocraft.Fill Trough with Vegetable Oil", "Hydrocraft.HCWoodenbucketvegoil", nil, nil, BzRecipeTweaker.CreateSourceCountChanges(0, 10))
    TweakAllRecipe("Base.Needle", { "Hydrocraft.HCBoneneedle" })

    TweakAllRecipe("Hydrocraft.HCWoodenbucketconcrete", { "Base.BucketConcreteFull" },BzRecipeTweaker.CreateFilter(nil,nil, "Hydrocraft"))
    -- Hammer
    TweakAllRecipeByType("Base.Hammer", "Hammer", BzRecipeTweaker.CreateFilter(nil,nil, "Hydrocraft"), nil, nil)
end

if getActivatedMods():contains("Hydrocraft") and getActivatedMods():contains("DLTS") then
    TweakOneRecipe("DLTS.LTS Cut Bits of Mushroom", "Base.MushroomGeneric1",
            {
                "Hydrocraft.HCPortobello",
                "Hydrocraft.HCShiitake",
                "Hydrocraft.HCBlewitshroom",
                "Hydrocraft.HCBlewitshroom",
                "Hydrocraft.HCLobstershroom",
                "Hydrocraft.HCWitchshatshroom",
                "Hydrocraft.HCYellowmorelshroom",
                "Hydrocraft.HCChantrelle",
            })
end
--[[

KeyForTest = {};
KeyForTest.onKeyPressed = function(key)
    if key == Keyboard.KEY_A and getPlayer() and getGameSpeed() > 0 then
        BzRecipeTweaker.tweakItems()
    end
end

Events.OnKeyPressed.Add(KeyForTest.onKeyPressed);
]]

--[[
-------------------------------------------------
--------------------IMPORTANT--------------------
-------------------------------------------------
You should be able to modify any aspect of an item such as: DisplayName, DisplayCategory, Weight, Icon, StressReduction, HungerChange
		HOWEVER
DO NOT MODIFY AN ITEM'S TYPE UNLESS YOU WANT PLAYERS TO START A NEW WORLD. ITEMS WITH THEIR TYPES CHANGED ARE DELETED.
If you have a workaround for this in place however, then it should be okay.

You can make compatibility patches, allowing tweaks to only be applied under the proper circumstances.
Examples:


		TweakItemData["MyMod.MyItem"] = { ["DisplayCategory"] = "Weapon" };
		
		if getActivatedMods():contains("CustomCategories") then 
			TweakItemData["MyMod.MyItem"] = { ["DisplayCategory"] = "BluntWeapon" };
		end
		
and
		
		TweakItemData["MyMod.Book"] = { ["Weight"] = "0.8" };
		
		if getActivatedMods():contains("WeightlessBooks") then 
			TweakItemData["MyMod.Book"] = { ["Weight"] = "0" };
		end



-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================
-- ====================================================================================================================

--if not TweakSourceDataOneRecipe then  TweakSourceDataOneRecipe = {} end
--if not TweakSourceDataSameNameRecipe then  TweakSourceDataSameNameRecipe = {} end
--if not TweakSourceDataOneRecipeByType then  TweakSourceDataOneRecipeByType = {} end
--if not TweakAllRecipeSourceItems then  TweakAllRecipeSourceItems = {} end

function BzRecipeTweaker.TweakOneRecipeSourceAlternative()
	local recipe;
	for k,v in pairs(TweakSourceDataOneRecipe) do
		recipe = getScriptManager():getRecipe(k);
		if recipe then
			for t,y in pairs(v) do
				for _,itemName in pairs(y) do
					BzRecipeTweaker.addItemToRecipeSource(recipe,t,itemName)
				end
			end
		end
	end
end
-- recipe fulname name (Mod.recipe_name), what in recipe, added alternative
function TweakOneRecipeSourceAlternative(itemName, itemProperty, propertyValue)
	if not TweakSourceDataOneRecipe[itemName] then
		TweakSourceDataOneRecipe[itemName] = {};
	end
	if not TweakSourceDataOneRecipe[itemName][itemProperty] then
		TweakSourceDataOneRecipe[itemName][itemProperty] = {};
	end
	table.insert(TweakSourceDataOneRecipe[itemName][itemProperty], propertyValue)
	--TweakSourceDataOneRecipe[itemName][itemProperty] = propertyValue;
end
-- ====================================================================================================================
function BzRecipeTweaker.TweakSourceSameNameRecipe()
	local recipes = getScriptManager():getAllRecipes()
	for k,v in pairs(TweakSourceDataSameNameRecipe) do
		for i = 0, recipes:size()-1 do
			local recipe2 = recipes:get(i)
			if recipe2:getModule():getName().."."..recipe2:getOriginalname() == k then
				for t,y in pairs(v) do
					BzRecipeTweaker.addItemToRecipeSource(recipe2,t,y)
				end
			end
		end
	end
end
-- recipe fulname name (Mod.recipe_name), what in recipe, added alternative - for multiple recipes with same name
function TweakSourceSameNameRecipe(itemName, itemProperty, propertyValue)
	if not TweakSourceDataSameNameRecipe[itemName] then
		TweakSourceDataSameNameRecipe[itemName] = {};
	end
	if not TweakSourceDataSameNameRecipe[itemName][itemProperty] then
		TweakSourceDataSameNameRecipe[itemName][itemProperty] = {};
	end


	TweakSourceDataSameNameRecipe[itemName][itemProperty] = propertyValue;
end

function BzRecipeTweaker.TweakSourceDataOneRecipeByType()
	local recipe;
	for k,v in pairs(TweakSourceDataOneRecipeByType) do
		for t,y in pairs(v) do
			recipe = getScriptManager():getRecipe(k);
			if recipe then
				local itemsFromType = getScriptManager():getItemsTag(y)
				for i=0,itemsFromType:size()-1 do
					BzRecipeTweaker.addItemToRecipeSource(recipe,t,itemsFromType:get(i):getFullName())
				end
			end
		end
	end
end
-- recipe fulname name (Mod.recipe_name), what in recipe, added alternative - for multiple recipes with same name
function TweakSourceOneRecipeByType(itemName, itemProperty, propertyValue)
	if not TweakSourceDataOneRecipeByType[itemName] then
		TweakSourceDataOneRecipeByType[itemName] = {};
	end
	TweakSourceDataOneRecipeByType[itemName][itemProperty] = propertyValue;
end

function BzRecipeTweaker.TweakAllRecipeItemsAlternative()
	local recipes = getScriptManager():getAllRecipes()
	for i = 0, recipes:size()-1 do
		local recipe = recipes:get(i)
		for k,v in pairs(TweakAllRecipeSourceItems) do
			BzRecipeTweaker.addItemToRecipeSource(recipe,k,v)
		end
	end
end
-- recipe fulname name (Mod.recipe_name), what in recipe, added alternative - for multiple recipes with same name
function TweakAllRecipeAlternative(itemProperty, propertyValue)
	TweakAllRecipeSourceItems[itemProperty] = propertyValue;
end
]]
