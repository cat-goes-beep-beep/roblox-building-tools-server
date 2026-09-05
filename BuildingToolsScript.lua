-- Roblox Server-Sided Building Tools Script
-- This script gives players building tools when they join or respawn

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tool configuration
local TOOLS = {
	{name = "Part", toolType = "Part"},
	{name = "Wedge", toolType = "Wedge"},
	{name = "Ball", toolType = "Ball"},
	{name = "Cylinder", toolType = "Cylinder"},
	{name = "Delete", toolType = "Delete"},
	{name = "Clone", toolType = "Clone"},
	{name = "Rotate", toolType = "Rotate"},
	{name = "Scale", toolType = "Scale"}
}

-- Function to create a building tool
local function createBuildingTool(toolName, toolType)
	local tool = Instance.new("Tool")
	tool.Name = toolName
	tool.RequiresHandle = false
	
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Shape = Enum.PartType.Ball
	handle.Size = Vector3.new(1, 1, 1)
	handle.CanCollide = false
	handle.Parent = tool
	
	-- Create a local script for tool functionality
	local localScript = Instance.new("LocalScript")
	localScript.Source = [[
local tool = script.Parent
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local selectedPart = nil

tool.Activated:Connect(function()
	if "]] .. toolType .. [[" == "Delete" then
		local target = mouse.Target
		if target and target.Parent:FindFirstChild("Humanoid") == nil then
			target:Destroy()
		end
	elseif "]] .. toolType .. [[" == "Clone" then
		local target = mouse.Target
		if target and target.Parent:FindFirstChild("Humanoid") == nil then
			local clone = target:Clone()
			clone.Parent = target.Parent
			clone.Position = target.Position + Vector3.new(3, 0, 0)
		end
	elseif "]] .. toolType .. [[" == "Part" then
		local newPart = Instance.new("Part")
		newPart.Shape = Enum.PartType.Block
		newPart.Size = Vector3.new(2, 2, 2)
		newPart.BrickColor = BrickColor.new("Bright blue")
		newPart.CanCollide = true
		newPart.Position = mouse.Hit.Position + Vector3.new(0, 3, 0)
		newPart.Parent = workspace
	elseif "]] .. toolType .. [[" == "Wedge" then
		local newPart = Instance.new("Part")
		newPart.Shape = Enum.PartType.Wedge
		newPart.Size = Vector3.new(2, 2, 2)
		newPart.BrickColor = BrickColor.new("Bright green")
		newPart.CanCollide = true
		newPart.Position = mouse.Hit.Position + Vector3.new(0, 3, 0)
		newPart.Parent = workspace
	elseif "]] .. toolType .. [[" == "Ball" then
		local newPart = Instance.new("Part")
		newPart.Shape = Enum.PartType.Ball
		newPart.Size = Vector3.new(2, 2, 2)
		newPart.BrickColor = BrickColor.new("Bright red")
		newPart.CanCollide = true
		newPart.Position = mouse.Hit.Position + Vector3.new(0, 3, 0)
		newPart.Parent = workspace
	elseif "]] .. toolType .. [[" == "Cylinder" then
		local newPart = Instance.new("Part")
		newPart.Shape = Enum.PartType.Cylinder
		newPart.Size = Vector3.new(2, 2, 2)
		newPart.BrickColor = BrickColor.new("Bright yellow")
		newPart.CanCollide = true
		newPart.Position = mouse.Hit.Position + Vector3.new(0, 3, 0)
		newPart.Parent = workspace
	end
end)
	]]
	
	localScript.Parent = tool
	
	return tool
end

-- Function to give tools to a player
local function giveToolsToPlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local backpack = player:WaitForChild("Backpack")
	
	-- Give each tool to the player
	for _, toolConfig in ipairs(TOOLS) do
		local tool = createBuildingTool(toolConfig.name, toolConfig.toolType)
		tool.Parent = backpack
	end
	
	print(player.Name .. " has received building tools!")
end

-- When a player joins, give them building tools
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.5) -- Wait for character to fully load
		giveToolsToPlayer(player)
	end)
	
	-- Give tools on first spawn
	if player.Character then
		task.wait(0.5)
		giveToolsToPlayer(player)
	end
end)

print("Building Tools Server Script Loaded!")
