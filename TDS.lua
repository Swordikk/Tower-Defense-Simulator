local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Script by Swordik | ⚡Tower Defense Simulator", HidePremium = false, IntroText = "Script by Swordik for TDS", IntroIcon = "rbxassetid://4335482575", SaveConfig = true, IntroEnabled = true, ConfigFolder = "Scripts"})

-- Anti_AFK --
while not game:IsLoaded() do wait() end
repeat wait() until game.Players.LocalPlayer.Character
Players = game:GetService("Players")
local GC = getconnections or get_signal_cons
if GC then
	for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
		if v["Disable"] then v["Disable"](v)
		elseif v["Disconnect"] then v["Disconnect"](v)
		end
	end
else
Players.LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
  	end)
end

-- Tab Main --
local Tab = Window:MakeTab({
	Name = "Home",
	Icon = "rbxassetid://4370345144", 
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "     MAIN                                                              			CREDITS"
})

local Section = Tab:AddSection({
	Name = "     Thanks you for using my script!                       My Discord: swordik_"
})

local Section = Tab:AddSection({
	Name = "     Version: v1.0.0"
})

local Tab = Window:MakeTab({
	Name = "Farming",
	Icon = "rbxassetid://4483364237",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "",
	Icon = "rbxassetid://4370186570",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "Auto Quest",
	Icon = "rbxassetid://4335484884",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "",
	Icon = "rbxassetid://4335480353",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483362748",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "Themes",
	Icon = "rbxassetid://4335483762", 
	PremiumOnly = false
})

-- Tab Visuals --
local Tab = Window:MakeTab({
	Name = "Visuals",
	Icon = "rbxassetid://3610254229",
	PremiumOnly = false
})

-- Tab Configs --
local Tab = Window:MakeTab({
	Name = "Configs",
	Icon = "rbxassetid://3610247188",
	PremiumOnly = false
})

-- Tab Setthings --
local Tab = Window:MakeTab({
	Name = "Setthings",
	Icon = "rbxassetid://4483345737",
	PremiumOnly = false
})
