local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- locals --
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
local Towers = workspace:FindFirstChild("Towers")

-- local tables --
local towers = {"Scout", "Sniper", "Soldier", "Paintballer", "Demoman", "Hunter", "Crook Boss", "Medic", "Militant", "Freezer", "Rocketeer", "Shotgunner", "Farm", "Trapper", "Ace Pilot", "Pyromancer", "Military Base", "Mortar", "Turret", "Mercenary Base", "Electroshocker", "Cowboy", "Warden", "Commander", "DJ Booth", "Minigunner", "Ranger", "Pursuit", "Gatling Gun", "Brawler", "Necromancer", "Accelerator", "Engineer"}
local Crossroadstowers = {"Crook Boss", "Trapper"}
local PullutedWasteland2 = {"Brawler", "Trapper"}
local U_Turn = {"Shotgunner"}
local UnknownGargentowers = {}
local FourSeasonstowers = {}
local MedievalTimestowers = {}

local tableAutoSkip = {
    [1] = "Voting",
    [2] = "Skip"
}

-- local functions --
local function UnequipAllTowers()
	for _, towersUnequip in ipairs(towers) do
		local args = {
			[1] = "Inventory",
			[2] = "Unequip",
			[3] = "tower",
			[4] = towersUnequip
		}
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
	end
end

local function EquipAllTowers(TowersForMap)
	for _, towersEquip in ipairs(TowersForMap) do
		local args = {
			[1] = "Inventory",
			[2] = "Equip",
			[3] = "tower",
			[4] = towersEquip
		}
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
	end
end

local function placeTower(towerName, position)
	local towerArgs = {
        [1] = "Troops",
        [2] = "Pl\208\176ce",
        [3] = {
            ["Rotation"] = CFrame.new(0, 0, 0, 1, -0, 0, 0, 1, -0, 0, 0, 1),
            ["Position"] = position
        },
        [4] = towerName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(towerArgs))
end

local function upgradeTower(troopName)
    local upgradeArgs = {
        "Troops",
        "Upgrade",
        "Set",
        {
            Troop = troopName,
            Path = 1
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(upgradeArgs))
end

local function Landmine(number)
    local args = {
        "Troops",
        "Option",
        "Set",
        {
            Troop = Towers:GetChildren()[number],
            Name = "Trap",
            Value = "Landmine"
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
end

function WalkSpeed()
	while game:GetService("RunService").RenderStepped:wait() do
    	Humanoid.WalkSpeed = _G.WalkSpeed
    end
end

local function whilePlaceTower(towerName, position, count)
    while #Towers:GetChildren() ~= count and #Towers:GetChildren() ~= 0 and  _G.AutoFarm do wait(0.5)
        placeTower(towerName, position)
	end
end

local function whileUpgradeTower(troopName, numberUpgrades, folder)
    while troopName.Upgrades[numberUpgrades]:WaitForChild(folder).Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
		upgradeTower(troopName)
	end
end

-- Anti_AFK --
repeat wait() until game:IsLoaded()
    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Window = Fluent:CreateWindow({
    Title = "Tower Defense Simulator " .. Fluent.Version,
    SubTitle = "| by Swordik",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "rbxassetid://4370345144" }),
	Farming = Window:AddTab({ Title = "Farming", Icon = "rbxassetid://4483364237" }),
	AutoQuest = Window:AddTab({ Title = "Auto Quest", Icon = "rbxassetid://4335484884" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://4483362748" }),
	Themes = Window:AddTab({ Title = "Themes", Icon = "rbxassetid://4335483762" }),
	Visuals = Window:AddTab({ Title = "Visuals", Icon = "rbxassetid://3610254229" }),
	Configs = Window:AddTab({ Title = "Configs", Icon = "rbxassetid://3610247188" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://4483345737" })
}

local Options = Fluent.Options

--Tab Notification--
Fluent:Notify({
    Title = "Notification",
    Content = "Script loaded",
    SubContent = "<3",
    Duration = 2
})

--Tabs Home--
Tabs.Home:AddParagraph({
    Title = "Thanks you for using my script!",
    Content = "Version 1.1.0\nMy Discord: swordik_"
})

--Tabs Farming--
local Dropdown = Tabs.Farming:AddDropdown("Dropdown", {
    Title = "Choose The Map",
    Values = {"Crossroads(Crook Boss, Trapper)", "Pulluted Wasteland 2(Brawler, Trapper)", "U_Turn(Shotgunner)"},
    Multi = false,
    Default = "...",
})

Dropdown:OnChanged(function(Value)
    if Value == "Crossroads(Crook Boss, Trapper)" then
		UnequipAllTowers()
		EquipAllTowers(Crossroadstowers)
	elseif Value == "Pulluted Wasteland 2(Brawler, Trapper)" then
		UnequipAllTowers()
		EquipAllTowers(PullutedWasteland2)
	elseif Value == "U_Turn(Shotgunner)" then
		UnequipAllTowers()
		EquipAllTowers(U_Turn)
	end 
end)

local Toggle = Tabs.Farming:AddToggle("MyToggle", {Title = "AutoFarm", Default = false})
Toggle:OnChanged(function(Value)
	_G.AutoFarm = Value
    while _G.AutoFarm do wait(0.5)
		Dropdown:OnChanged(function(Value)
			if Value == "Crossroads(Crook Boss, Trapper)" then
				while #Towers:GetChildren() ~= 1 and _G.AutoFarm do wait(0.5)
					placeTower("Crook Boss", Vector3.new(11.4159966, 2.34999824, 10.5649462, 0, 0, 0, 0, 1, 0, 0, 0, 0))
				end
				while Towers:GetChildren()[1].Upgrades["2"].EarPiece.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[1])
				end
				while Towers:FindFirstChild("Default") == nil and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(2.63791084, 2.3500061, -37.7612457, -1, 0, 0, 0, 1, 0, 0, 0, -1))
				end
				while Towers:GetChildren()[2].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[2])
				end
				while #Towers:GetChildren() ~= 3 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(2.63707829, 2.35000563, -34.6940994, -0.961341619, 0, 0.275358737, 0, 1.00000012, -0, -0.275358737, 0, -0.961341619))
				end
				while Towers:GetChildren()[3].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[3])
				end
				while #Towers:GetChildren() ~= 4 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-2.55636215, 2.35000801, -32.3431625, 0.0338419713, 0, -0.999427199, -0, 1, -0, 0.999427199, 0, 0.0338419713))
				end
				while Towers:GetChildren()[4].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[4])
				end
				while #Towers:GetChildren() ~= 5 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Crook Boss", Vector3.new(9.16937828, 2.349998, 12.585495, -0.109067462, 0, -0.99403441, 0, 1.00000012, -0, 0.99403441, -0, -0.109067462))
				end
				while Towers:GetChildren()[5].Upgrades["2"].EarPiece.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[5])
				end
				while #Towers:GetChildren() ~= 6 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Crook Boss", Vector3.new(8.55912399, 2.34999847, 9.5717392, 0.99990809, 0, 0.0135630034, 0, 1, -0, -0.0135630053, 0, 0.99990797))
				end
				while Towers:GetChildren()[6].Upgrades["2"].EarPiece.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[6])
				end
				while #Towers:GetChildren() ~= 7 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Crook Boss", Vector3.new(10.7829161, 2.34999871, 7.54335117, 0.759056091, 0, 0.651025295, 0, 1, -0, -0.651025355, 0, 0.759055972))
				end
				while Towers:GetChildren()[7].Upgrades["2"].EarPiece.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[7])
				end
				while #Towers:GetChildren() ~= 8 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Crook Boss", Vector3.new(5.63760138, 2.34999847, 8.8894434, 0.610479712, 0, 0.792031944, 0, 1.00000012, -0, -0.792031944, 0, 0.610479712))
				end
				while Towers:GetChildren()[8].Upgrades["2"].EarPiece.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[8])
				end
				while Towers:GetChildren()[1].Upgrades["3"].MoneyCase.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[1])
				end
				while #Towers:GetChildren() ~= 0 and _G.AutoFarm do
					wait(1)
				end
				wait(5)
			elseif Value == "Pulluted Wasteland 2(Brawler, Trapper)" then
				while #Towers:GetChildren() ~= 1 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(1.12966609, 2.35000801, -7.74175596, 0.331033051, 0, 0.943619132, 0, 1, 0, -0.943619251, 0, 0.331033021))
				end
				while #Towers:GetChildren() ~= 2 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(-1.06129456, 2.35000801, -7.76885509, -0.237911835, 0, 0.971286774, 0, 1, 0, -0.971286774, 0, -0.237911835))
				end
				while #Towers:GetChildren() ~= 3 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(-0.81419903, 2.35000801, -9.76670456, -0.453678876, 0, 0.891165197, 0, 1, 0, -0.891165316, 0, -0.453678817))
				end
				while #Towers:GetChildren() ~= 4 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(1.23481107, 2.35000801, -9.78998184, -0.148538768, 0, 0.988906622, 0, 1.00000012, 0, -0.988906622, 0, -0.148538768))
				end
				while #Towers:GetChildren() ~= 5 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(3.26371861, 2.35000801, -7.73256111, -0.654829919, 0, 0.755776286, 0, 1, 0, -0.755776405, 0, -0.65482986))
				end
				while #Towers:GetChildren() ~= 6 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Brawler", Vector3.new(3.27758455, 2.35000801, -9.73951721, -0.890398204, 0, 0.455182493, 0, 1, 0, -0.455182493, 0, -0.890398204))
				end
				while #Towers:GetChildren() ~= 7 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-15.3021049, 2.35000801, -2.64966488, 0.769444406, 0, -0.638713777, -0, 1, -0, 0.638713777, 0, 0.769444406))
				end
				while #Towers:GetChildren() ~= 8 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-18.3173981, 2.35000801, -2.58554173, 0.388187438, 0, 0.921580434, -0, 1, -0, -0.921580434, 0, 0.388187438))
				end
				while #Towers:GetChildren() ~= 9 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-16.7420273, 2.4000001, -0.00460910797, 0.805656791, 0, 0.59238261, -0, 1, -0, -0.59238261, 0, 0.805656791))
				end
				while #Towers:GetChildren() ~= 10 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-21.3622169, 2.35000801, -2.67031097, -0.861847937, 0, 0.507166803, 0, 1, -0, -0.507166803, 0, -0.861847937))
				end
				while #Towers:GetChildren() ~= 11 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-19.9067879, 2.4000001, -0.0217428207, -0.426200151, 0, 0.904628873, 0, 1.00000012, -0, -0.904628992, 0, -0.426200092))
				end
				while #Towers:GetChildren() ~= 12 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					placeTower("Trapper", Vector3.new(-22.3155594, 2.35000801, -7.70352173, 1, 0, 0, 0, 1, 0, 0, 0, 1))
				end
				while Towers:GetChildren()[7].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[7])
				end
				while Towers:GetChildren()[8].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[8])
				end
				while Towers:GetChildren()[9].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[9])
				end
				while Towers:GetChildren()[10].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[10])
				end
				while Towers:GetChildren()[11].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[11])
				end
				while Towers:GetChildren()[12].Upgrades["1"].goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[12])
				end
				while Towers:GetChildren()[7].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[7])
				end
				Landmine(7)
				while Towers:GetChildren()[8].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[8])
				end
				Landmine(8)
				while Towers:GetChildren()[9].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[9])
				end
				Landmine(9)
				while Towers:GetChildren()[10].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[10])
				end
				Landmine(10)
				while Towers:GetChildren()[11].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[11])
				end
				Landmine(11)
				while Towers:GetChildren()[12].Upgrades["2"].Torso1.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[12])
				end
				Landmine(12)
				while Towers:GetChildren()[1].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[1])
				end
				while Towers:GetChildren()[2].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[2])
				end
				while Towers:GetChildren()[3].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[3])
				end
				while Towers:GetChildren()[4].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[4])
				end
				while Towers:GetChildren()[5].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[5])
				end
				while Towers:GetChildren()[6].Upgrades["1"].Goggles.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[6])
				end
				while Towers:GetChildren()[1].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[1])
				end
				while Towers:GetChildren()[2].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[2])
				end
				while Towers:GetChildren()[3].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[3])
				end
				while Towers:GetChildren()[4].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[4])
				end
				while Towers:GetChildren()[5].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[5])
				end
				while Towers:GetChildren()[6].Upgrades["2"].R6_Torso.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[6])
				end
				while Towers:GetChildren()[1].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[1])
				end
				while Towers:GetChildren()[2].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[2])
				end
				while Towers:GetChildren()[3].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[3])
				end
				while Towers:GetChildren()[4].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[4])
				end
				while Towers:GetChildren()[5].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[5])
				end
				while Towers:GetChildren()[6].Upgrades["3"].Plane.Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
					upgradeTower(Towers:GetChildren()[6])
				end
				while #Towers:GetChildren() ~= 0 and _G.AutoFarm do
					wait(1)
				end
				wait(5)
			elseif Value == "U_Turn(Shotgunner)" then
				while #Towers:GetChildren() == 0 and _G.AutoFarm do wait(0.5)
					placeTower("Shotgunner", Vector3.new(15.6670189, 2.35, 14.7578468, 0.42744875, 0, -0.904039621, -0, 1, -0, 0.904039621, 0, 0.42744875))
				end
				whileUpgradeTower(Towers:GetChildren()[1], "1", "Glove")
				whilePlaceTower("Shotgunner", Vector3.new(20.8013554, 2.35, 14.6790104, 0.764372051, 0, 0.64477545, 0, 1, -0, -0.64477545, 0, 0.764372051), 2)
				whileUpgradeTower(Towers:GetChildren()[2], "1", "Glove")
				whilePlaceTower("Shotgunner", Vector3.new(15.7033548, 2.35, 17.7909336, 0.670523286, 0, -0.741888523, -0, 1, -0, 0.741888523, 0, 0.670523286), 3)
				whileUpgradeTower(Towers:GetChildren()[3], "1", "Glove")
				whilePlaceTower("Shotgunner", Vector3.new(20.8352203, 2.35, 17.7401562, 0.846146464, 0, 0.532950521, 0, 1, -0, -0.53295058, 0, 0.846146345), 4)
				whileUpgradeTower(Towers:GetChildren()[4], "1", "Glove")
				whilePlaceTower("Shotgunner", Vector3.new(15.731719, 2.35, 21.7069454, 0.864093363, 0, -0.503331602, -0, 1, -0, 0.503331602, 0, 0.864093363), 5)
				whilePlaceTower("Shotgunner", Vector3.new(20.8301544, 2.35, 21.634037, 0.924385786, 0, 0.381459057, 0, 1.00000012, -0, -0.381459057, 0, 0.924385786), 6)
				whilePlaceTower("Shotgunner", Vector3.new(15.7139311, 2.35, 11.73526, -0.114642918, 0, -0.993406773, 0, 1, -0, 0.993406773, -0, -0.114642918), 7)
				whilePlaceTower("Shotgunner", Vector3.new(20.8603363, 2.35, 11.6562672, 0.692461252, 0, 0.721455038, 0, 1, -0, -0.721455038, 0, 0.692461252), 8)
				whilePlaceTower("Shotgunner", Vector3.new(15.699173, 2.35, 8.70601654, -0.559147835, 0, -0.829068065, 0, 1.00000012, -0, 0.829068065, -0, -0.559147835), 9)
				whilePlaceTower("Shotgunner", Vector3.new(20.8081551, 2.35, 8.60277367, 0.940048873, 0, 0.341039836, 0, 1.00000012, -0, -0.341039836, 0, 0.940048873), 10)
				whilePlaceTower("Shotgunner", Vector3.new(15.672473, 2.35, 5.63084412, 0.907738805, 0, -0.419535786, -0, 1, -0, 0.419535786, 0, 0.907738805), 11)
				whilePlaceTower("Shotgunner", Vector3.new(20.8850956, 2.35, 5.58672523, 0.904096842, 0, 0.427327633, 0, 0.999999881, -0, -0.427327693, 0, 0.904096723), 12)
				whilePlaceTower("Shotgunner", Vector3.new(15.6290121, 2.35, 2.54067612, 0.855340481, 0, -0.518066287, -0, 1, -0, 0.518066287, 0, 0.855340481), 13, 0.5)
				whilePlaceTower("Shotgunner", Vector3.new(20.8285179, 2.35, 2.56128597, -0.898659468, 0, 0.438647032, 0, 1, -0, -0.438647032, 0, -0.898659468), 14)
				whileUpgradeTower(Towers:GetChildren()[5], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[6], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[7], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[8], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[9], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[10], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[11], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[12], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[13], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[14], "1", "Glove")
				whileUpgradeTower(Towers:GetChildren()[6], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[7], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[8], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[9], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[10], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[11], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[12], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[13], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[14], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[5], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[4], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[3], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[2], "2", "Headset")
				whileUpgradeTower(Towers:GetChildren()[1], "2", "Headset")
				while Towers:GetChildren()[5].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[5])
				end
				while Towers:GetChildren()[6].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[6])
				end
				while Towers:GetChildren()[7].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[7])
				end
				while Towers:GetChildren()[8].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[8])
				end
				while Towers:GetChildren()[9].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[9])
				end
				while Towers:GetChildren()[10].Upgrades["3"].Vest:GetChildren()[1].Transparency == 1 and #Towers:GetChildren() ~= 0 and _G.AutoFarm do wait(0.5)
				    upgradeTower(Towers:GetChildren()[10])
				end
			end
		end)
	end
end)
Options.MyToggle:SetValue(false)

--Tabs AutoQuest--
--Tabs Misc--
local Toggle = Tabs.Misc:AddToggle("MyToggle", {Title = "AutoSkip", Default = false})
Toggle:OnChanged(function(Value)
	_G.AutoSkip = Value
    while _G.AutoSkip == true do wait(1)
		game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction"):InvokeServer(unpack(tableAutoSkip))
	end
end)
Options.MyToggle:SetValue(false)

local Input = Tabs.Misc:AddInput("Input", {
	Title = "WalkSpeed",
	Default = "",
	Placeholder = "input",
	Numeric = false, -- Only allows numbers
	Finished = false, -- Only calls callback when you press enter
	Callback = function(Value)
		_G.WalkSpeed = Value
		WalkSpeed()
	end
})
--Tabs Themes--
--Tabs Themes--
--Tabs Visuals--
--Tabs Configs--
--Tabs Settings--
