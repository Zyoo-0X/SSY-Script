-- // SSY By https://github.com/Zyoo-0X                                       
--[[                                          
  ▄▀▀█▀▀█▀▄▄     ▄▀▀█▀▀█▀▄▄     ▀▄█   ▄▄▀  
 █ ░▒█  ▒█▓█░   █ ░▒█  ▒█▓█░   ██▓█   ███▄▄
█▒░▒░░  ▀░▀▀▀  █▒░▒░░  ▀░▀▀▀  █▓▒▓     ▓▒▓█
  ▀▀▀▀▀▄▄▄▄▄     ▀▀▀▀▀▄▄▄▄▄   █▒░▒▓   ▓▒░▒█
 ▄▄▄▄▄  ▐░▓█▓█  ▄▄▄▄▄  ▐░▓█▓█ █░ ░▓   ▓░ ░█
▐▓▒░░▒▄ ▄▒░ █▀ ▐▓▒░░▒▄ ▄▒░ █▀  █ ░▒ ▄ ▒░ ██
  ▀▀▀▀▄▄▄▄▀      ▀▀▀▀▄▄▄▄▀      ▀▄▄▄■▄■░█░█
                                  ▄▄  █▒█▒█
                                ▄▄▀▀▄▄▄▓▄▀█		SSY, Make it more fun
                                 ▀  ▀▀▀▀▀▀ 		By https://github.com/Zyoo-0X
* Welcome to my sourcecode script, 
* you not welcome if you want copy, modify, skid or reupload this script without my permission
]]

local GEnv = (getgenv and getgenv()) or _G
if GEnv.SSY_LOADED then
    warn("SSY Running, Do not load again!")
    return
end
GEnv.SSY_LOADED = true
if not game:IsLoaded() then game.Loaded:Wait() end

-- // SSY Menu Enhanced
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- // Config & Ban File Management
local ConfigDir = "SSY"
local ConfigFile = "SSY/Config.cfg"
local Config = {AutoScan = true}
local Bans = {}
pcall(function()
	if makefolder and not isfolder(ConfigDir) then
		makefolder(ConfigDir)
	end
end)

local function LoadData()
	if isfile and isfile(ConfigFile) then
		local Success, Decoded = pcall(function()
			return HttpService:JSONDecode(readfile(ConfigFile))
		end)
		if Success and type(Decoded) == "table" then
			if Decoded.auto_scan ~= nil then
				Config.AutoScan = Decoded.auto_scan
			end
		end
	else
		if writefile then
			pcall(function()
				writefile(ConfigFile, HttpService:JSONEncode(Config))
			end)
		end
	end
end

local function SaveConfig()
	if writefile then
		pcall(function()
			writefile(ConfigFile, HttpService:JSONEncode(Config))
		end)
	end
end

local function Code(asciiStr)
    local decoded = ""
    for num in asciiStr:gmatch("(%d+)/") do
        decoded = decoded .. string.char(tonumber(num))
    end
    return decoded
end

LoadData()
local AutoScanEnabled = Config.AutoScan

-- // Themes and colors
local CurTrans = 0.0
local Themes = {
	{ Name = "Dark", WindowColor = Color3.fromRGB(5, 5, 5), BtnColor = Color3.fromRGB(24, 24, 30), HoverColor = Color3.fromRGB(40, 40, 50) },
	{ Name = "Midnight Blue", WindowColor = Color3.fromRGB(10, 15, 28), BtnColor = Color3.fromRGB(20, 30, 55), HoverColor = Color3.fromRGB(35, 50, 85) },
	{ Name = "Purple Cyber", WindowColor = Color3.fromRGB(18, 10, 26), BtnColor = Color3.fromRGB(38, 20, 55), HoverColor = Color3.fromRGB(60, 30, 85) },
	{ Name = "Crimson Red", WindowColor = Color3.fromRGB(25, 10, 12), BtnColor = Color3.fromRGB(50, 20, 24), HoverColor = Color3.fromRGB(80, 30, 36) }
}
local CurThemeIdx = 1
local ColorBase = Color3.fromRGB(18, 18, 21)
local ColorHover = Color3.fromRGB(55, 55, 62)
local ColorClick = Color3.fromRGB(90, 90, 100)

local MainButton = nil
local SlockEnabled = false

-- // Find Player Helper
local function GetPlayer(NameStr)
	if not NameStr or NameStr == "" then return nil end
	NameStr = NameStr:lower()
	
	for _, P in ipairs(Players:GetPlayers()) do
		if P.Name:lower() == NameStr or P.DisplayName:lower() == NameStr then
			return P
		end
	end
	
	for _, P in ipairs(Players:GetPlayers()) do
		if P.Name:lower():sub(1, #NameStr) == NameStr or P.DisplayName:lower():sub(1, #NameStr) == NameStr then
			return P
		end
	end
	
	for _, P in ipairs(Players:GetPlayers()) do
		if P.Name:lower():find(NameStr, 1, true) or P.DisplayName:lower():find(NameStr, 1, true) then
			return P
		end
	end
	return nil
end

local function GetPlayers(Input)
	local Plrs = {}
	if not Input or Input == "all" then
		for _, P in ipairs(Players:GetPlayers()) do table.insert(Plrs, P) end
	elseif Input == "others" then
		for _, P in ipairs(Players:GetPlayers()) do
			if P ~= LocalPlayer then table.insert(Plrs, P) end
		end
	elseif Input == "me" then
		table.insert(Plrs, LocalPlayer)
	else
		local Target = GetPlayer(Input)
		if Target then table.insert(Plrs, Target) end
	end
	return Plrs
end

local C2___ = "116/104/111/110/97/110/121/119/104/101/114/101/46/99/111/109/47"
local C2__ = "113/75/76/85/98/90/65/101/76/110/67/105/90/121/87/118/72/116/76/81/"
local C1___ = "104/116/116/112/115/58/47/47/115/115/121/46/112/121/".. C2___

GEnv.Connections = GEnv.Connections or {}
local Services = {}
local WordList = {"delete", "remove", "destroy", "clean", "clear","bullet", "bala", "shoot", "shot", "fire", "segway", "handless", "sword", "attack", "despawn", "deletar", "apagar"}
local CheckTime = 0.5
local MobileOffset = 0
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local BodyColors = Character:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
local InDatabase = false
local ServerUrl = Code(C1___)
local ApiKey = Code(C2__)
local IsScanningNow = false
local CancelScanRequested = false

local ScannerContent
local MainGui
local AutoScanBtnSetting 
local AutoScanBtnScanner
local function ToggleWindow(Show, OpenToScanner) end
local ShowNotification
local RenderBans = nil
local ESPHighlights = {}

local function AddScannerLog(Text)
	if not ScannerContent then return end
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, 0, 0, 18)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = Color3.fromRGB(200, 200, 210)
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ScannerContent
end

local function UpdateScannerLog(Msg)
    AddScannerLog(Msg)
end

local function HasFiles()
	return (isfile and isfile("QuickGame.json")) or false
end

local function SetDeleteRemote(Remote)
    GEnv.FoundRemote = Remote
    GEnv.delete = function(InstanceObj)
        if GEnv.FoundRemote then
            GEnv.FoundRemote:FireServer(InstanceObj)
        end
    end
end

local function SendGame()
    task.spawn(function()
        if not GEnv.FoundRemote then return end
        pcall(function()
            local Info = MarketplaceService:GetProductInfo(game.PlaceId)
            local Title = Info and Info.Name or "Unknown Roblox Game"
            local UniverseId = tostring(game.GameId)
            local JobId = tostring(game.JobId)
            local CurrentPlayers = #Players:GetPlayers()
            local MaxPlayers = Players.MaxPlayers
            
            local Payload = HttpService:JSONEncode({
                place_id = tostring(game.PlaceId),
                universe_id = UniverseId,
                job_id = JobId,
                title = Title,
                current_players = CurrentPlayers,
                max_players = MaxPlayers,
                remote = GEnv.FoundRemote.Name
            })
            
            if syn and syn.request then
                syn.request({ Url = ServerUrl .. "/report-status", Method = "POST", Headers = { ["Content-Type"] = "application/json", ["X-API-Key"] = ApiKey }, Body = Payload })
            elseif http_request then
                http_request({ Url = ServerUrl .. "/report-status", Method = "POST", Headers = { ["Content-Type"] = "application/json", ["X-API-Key"] = ApiKey }, Body = Payload })
            elseif request then
                request({ Url = ServerUrl .. "/report-status", Method = "POST", Headers = { ["Content-Type"] = "application/json", ["X-API-Key"] = ApiKey }, Body = Payload })
            elseif game.HttpPost then
                game:HttpPost(ServerUrl .. "/report-status?api_key=" .. ApiKey, Payload)
            end
        end)
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        if GEnv.FoundRemote then
            SendGame()
        end
    end
end)

local function StartScanProcess()
    if IsScanningNow then return end
    IsScanningNow = true
    CancelScanRequested = false
    UpdateScannerLog("[SSF Scanner] Starting backend checks...")

    if game.PlaceId == 13864667823 then
        local Events = RStorage:FindFirstChild("Events")
        local TargetRemote = Events and Events:FindFirstChild("OnDoorHit")
        if TargetRemote then
            SetDeleteRemote(TargetRemote)
            SendGame()
            UpdateScannerLog("Found Remote " .. TargetRemote.Name)
            ShowNotification("Remote Found: " .. TargetRemote.Name, 4)
        else
            UpdateScannerLog("[SSF Scanner] Default target remote not found.")
        end
        IsScanningNow = false
    else
        local function GetGameList()
            if not isfile or not isfile("QuickGame.json") then
                if writefile then writefile("QuickGame.json", "[]") end
                return {} 
            end
            local Content = readfile("QuickGame.json")
            local Success, Decoded = pcall(function() return HttpService:JSONDecode(Content) end)
            return Success and Decoded or {}
        end
        
        local function CheckFile()
            if not HasFiles() then return end
            UpdateScannerLog("[SSF Scanner] Checking local files...")
            for I,V in pairs(GetGameList()) do
                if I ~= tostring(game.PlaceId) then continue end
                for _, InstanceObj in pairs(game:GetDescendants()) do
                    if not (InstanceObj:IsA("RemoteEvent") and InstanceObj.Name == V) then continue end
                    SetDeleteRemote(InstanceObj)
                    SendGame()
                    UpdateScannerLog("Found Remote " .. InstanceObj.Name)
                    ShowNotification("Remote Found: " .. InstanceObj.Name, 4)
                    return true
                end
            end
        end

        local function CheckDatabase()
            UpdateScannerLog("[SSF Scanner] Checking server database...")
            local Res, Succ, RemoteJSONData
            Succ = pcall(function()
                if game.HttpGet then
                    Res = game:HttpGet(ServerUrl .. "/checkgame?id=" .. tostring(game.PlaceId))
                    RemoteJSONData = HttpService:JSONDecode(Res)
                end
            end)
            if not Succ or type(RemoteJSONData) ~= "table" then return end
            if RemoteJSONData["success"] then
                InDatabase = true
                if GEnv.FoundRemote then return end
                for _, InstanceObj in pairs(game:GetDescendants()) do
                    if not (InstanceObj:IsA("RemoteEvent") and InstanceObj.Name == RemoteJSONData["result"]) then continue end
                    SetDeleteRemote(InstanceObj)
                    SendGame()
                    UpdateScannerLog("Found Remote " .. InstanceObj.Name)
                    ShowNotification("Remote Found: " .. InstanceObj.Name, 4)
                    return true
                end
            end
        end

        if CheckFile() then IsScanningNow = false return end
        if CheckDatabase() then IsScanningNow = false return end

        if not GEnv.FoundRemote then
            UpdateScannerLog("[SSF Scanner] Starting deep active scan...")
            Services = {}
            for _, Service in pairs(game:GetChildren()) do
                if Service.ClassName ~= "ReplicatedStorage" and Service.ClassName ~= "Workspace" then
                    table.insert(Services, Service)
                end
            end

            local function CheckRemote(Remote)
                local CurrentBC = BodyColors
                local CurrentChar = Character
                Remote:FireServer(BodyColors)
                task.wait(CheckTime + MobileOffset + (LocalPlayer:GetNetworkPing()*2))
                if (#CurrentChar:GetChildren() < 7) or (#Character:GetChildren() < 7) or (CurrentChar ~= LocalPlayer.Character) or (CurrentBC ~= BodyColors) or (BodyColors.Parent == Character) or (CurrentBC.Parent == Character) then return end
                SetDeleteRemote(Remote)
                SendGame()
                UpdateScannerLog("Found Remote " .. Remote.Name)
                ShowNotification("Remote Found: " .. Remote.Name, 4)
                return true
            end

            local function Scan(InstanceObj, SoftScan)
                CheckTime = SoftScan and 0.75 or 0.5
                for _, V in pairs(InstanceObj:GetDescendants()) do
                    if GEnv.FoundRemote or CancelScanRequested then return end
                    if not V:IsA("RemoteEvent") or V:FindFirstChild("__FUNCTION") then continue end
                    if SoftScan then
                        for _, Phrase in pairs(WordList) do
                            if V.Name:lower():find(Phrase) then
                                UpdateScannerLog("[SSF Scanner] " .. V.Name)
                                if CheckRemote(V) then return true end
                            end
                        end
                    else
                        UpdateScannerLog("[SSF Scanner] " .. V.Name)
                        if CheckRemote(V) then return true end
                    end
                end
            end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(RStorage, true) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(LocalPlayer:FindFirstChildOfClass("PlayerGui"), true) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(workspace, true) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(RStorage, false) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(LocalPlayer:FindFirstChildOfClass("PlayerGui"), false) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then if Scan(workspace, false) then IsScanningNow = false return end end
            if not GEnv.FoundRemote and not CancelScanRequested then
                for _, V in pairs(Services) do
                    if CancelScanRequested then break end
                    if Scan(V, false) then IsScanningNow = false return end
                end
            end
            
            if not GEnv.FoundRemote and not CancelScanRequested then
                UpdateScannerLog("[SSF Scanner] Scan completed. No remotes found.")
                task.spawn(function()
                    UpdateScannerLog("[SSF Scanner] GUI will close in 10 seconds")
					task.wait(10)
                    if not GEnv.FoundRemote and not CancelScanRequested then
                        UpdateScannerLog("[SSF Scanner] Bye bye!")
                        task.wait(0.5)
                        pcall(function()
                            if MainGui then MainGui:Destroy() end
                            if MainButton then MainButton:Destroy() end
                        end)
                    end
                end)
            end
        end
        IsScanningNow = false
    end
end

-- // Fly System
local IsFlying = false
local FlySpeed = 50
local FlyConnection = nil
local BodyGyro = nil
local BodyVelocity = nil
local function ToggleFly(Enable)
	if Enable == nil then
		IsFlying = not IsFlying
	else
		IsFlying = Enable
	end
	local Char = LocalPlayer.Character
	if not Char then return end
	local Root = Char:FindFirstChild("HumanoidRootPart")
	local Hum = Char:FindFirstChildOfClass("Humanoid")
	if IsFlying then
		if not Root or not Hum then return end
		if BodyGyro then BodyGyro:Destroy() end
		if BodyVelocity then BodyVelocity:Destroy() end
		BodyGyro = Instance.new("BodyGyro")
		BodyGyro.P = 9e4
		BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BodyGyro.cframe = Root.CFrame
		BodyGyro.Parent = Root
		BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
		BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
		BodyVelocity.Parent = Root
		Hum.PlatformStand = true
		if FlyConnection then FlyConnection:Disconnect() end
		FlyConnection = RunService.RenderStepped:Connect(function()
			if not IsFlying or not Root then return end
			local Camera = workspace.CurrentCamera
			local MoveDir = Vector3.new(0,0,0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
			BodyGyro.cframe = Camera.CFrame
			BodyVelocity.velocity = MoveDir * FlySpeed
		end)
	else
		if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
		if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
		if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
		if Hum then Hum.PlatformStand = false end
	end
end

-- // Noclip System
local IsNoclip = false
local NoclipConnection = nil
local function ToggleNoclip(Enable)
	if Enable == nil then
		IsNoclip = not IsNoclip
	else
		IsNoclip = Enable
	end

	if IsNoclip then
		if NoclipConnection then NoclipConnection:Disconnect() end
		NoclipConnection = RunService.Stepped:Connect(function()
			local Char = LocalPlayer.Character
			if Char and IsNoclip then
				for _, Part in ipairs(Char:GetDescendants()) do
					if Part:IsA("BasePart") then Part.CanCollide = false end
				end
			end
		end)
	else
		if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
		local Char = LocalPlayer.Character
		if Char then
			for _, Part in ipairs(Char:GetDescendants()) do
				if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then Part.CanCollide = true end
			end
		end
	end
end

-- // Commands List
local RawCommands = {
	{
		Name = "cmds",
		Display = "cmds / commands",
		Aliases = {"cmds", "commands"},
		Description = "Opens the command list window",
		Function = function() 
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "speed",
		Display = "speed / ws",
		Aliases = {"speed", "ws"},
		Description = "Change Walk Speed",
		Function = function(Args)
			local Char = LocalPlayer.Character
			if Char and Char:FindFirstChildOfClass("Humanoid") then
				local Val = tonumber(Args[1]) or 16
				Char:FindFirstChildOfClass("Humanoid").WalkSpeed = Val
				ShowNotification("Execute Command", 2)
			end
		end
	},
	{
		Name = "jump",
		Display = "jump / jp",
		Aliases = {"jump", "jp"},
		Description = "Change jump power / height",
		Function = function(Args)
			local Char = LocalPlayer.Character
			if Char and Char:FindFirstChildOfClass("Humanoid") then
				local Val = tonumber(Args[1]) or 50
				local Hum = Char:FindFirstChildOfClass("Humanoid")
				if Hum.UseJumpPower then Hum.JumpPower = Val else Hum.JumpHeight = Val end
				ShowNotification("Execute Command", 2)
			end
		end
	},
	{
		Name = "reset",
		Display = "reset",
		Aliases = {"reset"},
		Description = "Resets your character",
		Function = function()
			local Char = LocalPlayer.Character
			if Char and Char:FindFirstChildOfClass("Humanoid") then
				Char:FindFirstChildOfClass("Humanoid").Health = 0
				ShowNotification("Execute Command", 2)
			end
		end
	},
	{
		Name = "fly",
		Display = "fly",
		Aliases = {"fly"},
		Description = "Toggle fly mode",
		Function = function(Args)
			if Args[1] and tonumber(Args[1]) then FlySpeed = tonumber(Args[1]) end
			ToggleFly()
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "unfly",
		Display = "unfly",
		Aliases = {"unfly"},
		Description = "Disable fly mode",
		Function = function()
			ToggleFly(false)
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "noclip",
		Display = "noclip",
		Aliases = {"noclip"},
		Description = "Enable noclip mode",
		Function = function()
			ToggleNoclip(true)
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "clip",
		Display = "clip",
		Aliases = {"clip"},
		Description = "Disable noclip mode",
		Function = function()
			ToggleNoclip(false)
			ShowNotification("Execute Command", 2)
		end
	},
	{
	    Name = "tp",
	    Display = "tp",
 	   Aliases = {"tp", "teleport"},
	    Description = "Teleport to player",
	    Function = function(Args)
	        local Target = GetPlayer(Args[1])
	        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
	            local MyChar = LocalPlayer.Character
	            if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
	                MyChar.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	                ShowNotification("Execute Command", 2)
	            end
	        else
 	           ShowNotification("Execute Command", 2)
 	       end
 	   end
	},
	{
	    Name = "goto",
	    Display = "goto",
 	   Aliases = {"goto"},
	    Description = "Teleport to player",
	    Function = function(Args)
	        local Target = GetPlayer(Args[1])
	        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
	            local MyChar = LocalPlayer.Character
	            if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
	                MyChar.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	                ShowNotification("Execute Command", 2)
	            end
	        else
 	           ShowNotification("Execute Command", 2)
 	       end
 	   end
	},
	{
		Name = "esp",
		Display = "esp",
		Aliases = {"esp"},
		Description = "Toggle ESP highlight on player(s)",
		Function = function(Args)
			local Plrs = GetPlayers(Args[1])
			for _, V in ipairs(Plrs) do
				if V ~= LocalPlayer and V.Character then
					if ESPHighlights[V] then
						ESPHighlights[V]:Destroy()
						ESPHighlights[V] = nil
						ShowNotification("ESP Disabled: " .. V.Name, 2)
					else
						local HL = Instance.new("Highlight")
						HL.Name = "SSY_ESP"
						HL.FillColor = Color3.fromRGB(0, 255, 255)
						HL.FillTransparency = 0.5
						HL.OutlineColor = Color3.fromRGB(255, 255, 255)
						HL.OutlineTransparency = 0
						HL.Adornee = V.Character
						HL.Parent = V.Character
						ESPHighlights[V] = HL
						ShowNotification("ESP Enabled: " .. V.Name, 2)
					end
				end
			end
		end
	},
	{
		Name = "rejoin",
		Display = "rejoin / rj",
		Aliases = {"rejoin", "rj"},
		Description = "Rejoin current server (Saves config to SSY/Config.cfg)",
		Function = function()
			SaveConfig()
			ShowNotification("Rejoining server...", 2)
			task.spawn(function()
				task.wait(0.5)
				pcall(function()
					if #Players:GetPlayers() <= 1 then
						TeleportService:Teleport(game.PlaceId, LocalPlayer)
					else
						TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
					end
				end)
			end)
		end
	},
	{
		Name = "view",
		Display = "view",
		Aliases = {"view"},
		Description = "Spectate player",
		Function = function(Args)
			local Target = GetPlayer(Args[1])
			if Target and Target.Character and Target.Character:FindFirstChildOfClass("Humanoid") then
				workspace.CurrentCamera.CameraSubject = Target.Character:FindFirstChildOfClass("Humanoid")
				ShowNotification("Execute Command", 2)
			else
				ShowNotification("Execute Command", 2)
			end
		end
	},
	{
		Name = "unview",
		Display = "unview",
		Aliases = {"unview"},
		Description = "Return camera to your character",
		Function = function()
			local Char = LocalPlayer.Character
			if Char and Char:FindFirstChildOfClass("Humanoid") then
				workspace.CurrentCamera.CameraSubject = Char:FindFirstChildOfClass("Humanoid")
				ShowNotification("Execute Command", 2)
			end
		end
	},
	{
		Name = "naked",
		Display = "naked",
		Aliases = {"naked"},
		Description = "Remove clothes from players",
		Function = function(Args)
			local Plrs = GetPlayers(Args[1])
			for _,V in pairs(Plrs) do
				local Char = V.Character
				if Char == nil then continue end
				local Pants = Char:FindFirstChild("Pants")
				local Shirt = Char:FindFirstChild("Shirt")
				local TShirt = Char:FindFirstChild("Shirt Graphic")

				if Pants and GEnv.delete then GEnv.delete(Pants) end
				if Shirt and GEnv.delete then GEnv.delete(Shirt) end
				if TShirt and GEnv.delete then GEnv.delete(TShirt) end

				for _,InstanceObj in pairs(Char:GetDescendants()) do
					if not InstanceObj:IsA("WrapLayer") then continue end
					if GEnv.delete then GEnv.delete(InstanceObj.Parent.Parent) end
				end
			end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "kick",
		Display = "kick",
		Aliases = {"kick"},
		Description = "Kick player(s)",
		Function = function(Args)
			local Plrs = GetPlayers(Args[1])
			for _,V in pairs(Plrs) do
				if GEnv.delete then GEnv.delete(V) end
			end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "ban",
		Display = "ban",
		Aliases = {"ban"},
		Description = "Ban player",
		Function = function(Args)
			local Reason = #Args >= 2 and table.concat(Args, " ", 2) or "Banned by SSY Panel"
			local Plrs = GetPlayers(Args[1])
			for _,V in pairs(Plrs) do
				if V == LocalPlayer then continue end
				local uidStr = tostring(V.UserId)
				if not Bans[uidStr] then
					Bans[uidStr] = { Name = V.Name, Reason = Reason }
				end
				if GEnv.delete then GEnv.delete(V) end
			end
			ShowNotification("Execute Command (Hard Banned)", 2)
		end
	},
	{
		Name = "unban",
		Display = "unban",
		Aliases = {"unban"},
		Description = "Unban player or all",
		Function = function(Args)
			local Input = Args[1]
			if not Input then
				ShowNotification("Specify player or 'all'", 2)
				return
			end
			if Input == "all" then 
				table.clear(Bans)
				if RenderBans then RenderBans() end
				ShowNotification("Execute Command (All Unbanned)", 2)
				return 
			end
			for I,V in pairs(Bans) do
				if V.Name:lower() == Input:lower() or I == Input then
					Bans[I] = nil
				end
			end
			if RenderBans then RenderBans() end
			ShowNotification("Execute Command", 2)
		end
	},
	{
        Name = "kill",
        Display = "kill",
        Aliases = {"kill"},
        Description = "Delete player's head using delete function",
        Function = function(Args)
            local Plrs = GetPlayers(Args[1])
            for _, V in pairs(Plrs) do
                local Char = V.Character
                if Char then
                    local Head = Char:FindFirstChild("Head")
                    if Head and GEnv.delete then GEnv.delete(Head) end
                end
            end
            ShowNotification("Execute Command", 2)
        end
    },
	{
		Name = "clearlighting",
		Display = "clearlighting",
		Aliases = {"clearlighting"},
		Description = "Clear all lighting children",
		Function = function()
			for _,V in pairs(Lighting:GetChildren()) do
				if GEnv.delete then GEnv.delete(V) end
			end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "shutdown",
		Display = "shutdown",
		Aliases = {"shutdown"},
		Description = "Shutdown server / delete players",
		Function = function()
			local Plrs = Players:GetPlayers()
			for I,V in pairs(Plrs) do
				if V == LocalPlayer then continue end
				if GEnv.delete then GEnv.delete(V) end
			end
			if GEnv.delete then GEnv.delete(LocalPlayer) end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "nuke",
		Display = "nuke",
		Aliases = {"nuke"},
		Description = "Nuke workspace and players",
		Function = function()
			for _,V in pairs(workspace:GetChildren()) do
				if (not V:IsA("BaseScript")) then
					if GEnv.delete then GEnv.delete(V) end
				end
			end
			for I,V in pairs(Players:GetPlayers()) do
				if V == LocalPlayer then continue end
				if GEnv.delete then GEnv.delete(V) end
			end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "blockhead",
		Display = "blockhead / demeshhead",
		Aliases = {"blockhead", "demeshhead"},
		Description = "Remove head mesh from R6 characters",
		Function = function(Args)
			local Plrs = GetPlayers(Args[1])
			for _,V in pairs(Plrs) do
				local Char = V.Character
				if not Char then continue end
				local Humanoid = Char:FindFirstChildOfClass("Humanoid")
				if not (Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6) then continue end
				local Head = Char:FindFirstChild("Head")
				if not Head then continue end
				local Mesh = Head:FindFirstChildOfClass("SpecialMesh")
				if not Mesh then continue end
				if GEnv.delete then GEnv.delete(Mesh) end
			end
			ShowNotification("Execute Command", 2)
		end
	},
	{
		Name = "dex",
		Display = "dex",
		Aliases = {"dex"},
		Description = "Load DexPlusPlus modified by SSY Team",
		Function = function(Args)
			wait(0.5)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Zyoo-0X/DexPlusPlus/refs/heads/main/main.lua"))()
			ShowNotification("Execute Command", 2)
			wait(0.5)
		end
	}
}

-- // Hard Ban Enforcement on Player Join
table.insert(GEnv.Connections, Players.PlayerAdded:Connect(function(Plr)
	LoadData()
	local uidStr = tostring(Plr.UserId)
	if SlockEnabled or Bans[uidStr] then
		task.spawn(function()
			while Plr and Plr.Parent do
				pcall(function()
					if GEnv.delete then
						GEnv.delete(Plr)
					end
					Plr:Kick("\n[SSY Panel] You are permanently banned from this session.")
				end)
				task.wait(0.5)
			end
		end)
	end
end))

task.spawn(function()
	LoadData()
	for _, Plr in ipairs(Players:GetPlayers()) do
		local uidStr = tostring(Plr.UserId)
		if Bans[uidStr] then
			task.spawn(function()
				pcall(function()
					if GEnv.delete then GEnv.delete(Plr) end
					Plr:Kick("\n[SSY Panel] You are permanently banned from this session.")
				end)
			end)
		end
	end
end)

local CommandsMap = {}
for _, CmdData in ipairs(RawCommands) do
	for _, Alias in ipairs(CmdData.Aliases) do
		CommandsMap[Alias] = CmdData
	end
end
local CommandKeys = {}
for Key, _ in pairs(CommandsMap) do
	table.insert(CommandKeys, Key)
end
table.sort(CommandKeys)

-- // UI Setup
MainGui = Instance.new("ScreenGui")
MainGui.Name = "SSYGui"
MainGui.ResetOnSpawn = false

pcall(function() MainGui.Parent = CoreGui end)
if not MainGui.Parent then MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- // Notification UI
local NotifFrame = Instance.new("Frame")
NotifFrame.Name = "NotificationFrame"
NotifFrame.Size = UDim2.new(0, 260, 0, 50)
NotifFrame.Position = UDim2.new(1, 20, 0, 20)
NotifFrame.AnchorPoint = Vector2.new(1, 0)
NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
NotifFrame.BackgroundTransparency = 0.1
NotifFrame.BorderSizePixel = 0
NotifFrame.ZIndex = 10
NotifFrame.Parent = MainGui

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 8)
NotifCorner.Parent = NotifFrame

local NotifText = Instance.new("TextLabel")
NotifText.Size = UDim2.new(1, -20, 1, 0)
NotifText.Position = UDim2.new(0, 10, 0, 0)
NotifText.BackgroundTransparency = 1
NotifText.Text = ""
NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifText.TextSize = 13
NotifText.Font = Enum.Font.GothamBold
NotifText.TextXAlignment = Enum.TextXAlignment.Left
NotifText.ZIndex = 11
NotifText.Parent = NotifFrame

ShowNotification = function(Message, Duration)
	NotifText.Text = Message
	local TweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0, 20)})
	TweenIn:Play()
	
	task.delay(Duration or 3, function()
		local TweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 280, 0, 20)})
		TweenOut:Play()
	end)
end

local CommandFrame = Instance.new("Frame")
CommandFrame.Name = "SSYCommandFrame"
CommandFrame.Size = UDim2.new(0, 420, 0, 46)
CommandFrame.Position = UDim2.new(0.5, 0, 1, -120)
CommandFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CommandFrame.BackgroundColor3 = Themes[CurThemeIdx].WindowColor
CommandFrame.BackgroundTransparency = CurTrans
CommandFrame.BorderSizePixel = 0
CommandFrame.Visible = false
CommandFrame.Parent = MainGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = CommandFrame

local AutoCorrectLabel = Instance.new("TextLabel")
AutoCorrectLabel.Name = "AutoCorrectLabel"
AutoCorrectLabel.Size = UDim2.new(1, -30, 1, 0)
AutoCorrectLabel.Position = UDim2.new(0, 15, 0, 0)
AutoCorrectLabel.BackgroundTransparency = 1
AutoCorrectLabel.Text = ""
AutoCorrectLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
AutoCorrectLabel.TextSize = 14
AutoCorrectLabel.Font = Enum.Font.Gotham
AutoCorrectLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoCorrectLabel.Parent = CommandFrame

local CmdTextBox = Instance.new("TextBox")
CmdTextBox.Name = "CommandTextBox"
CmdTextBox.Size = UDim2.new(1, -30, 1, 0)
CmdTextBox.Position = UDim2.new(0, 15, 0, 0)
CmdTextBox.BackgroundTransparency = 1
CmdTextBox.Text = ""
CmdTextBox.PlaceholderText = "Type command here, Tab for suggestions"
CmdTextBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
CmdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CmdTextBox.TextSize = 14
CmdTextBox.Font = Enum.Font.Gotham
CmdTextBox.TextXAlignment = Enum.TextXAlignment.Left
CmdTextBox.ClearTextOnFocus = false
CmdTextBox.Parent = CommandFrame

local SuggestionFrame = Instance.new("Frame")
SuggestionFrame.Name = "SuggestionFrame"
SuggestionFrame.Size = UDim2.new(0, 420, 0, 0)
SuggestionFrame.Position = UDim2.new(0.5, 0, 1, -150)
SuggestionFrame.AnchorPoint = Vector2.new(0.5, 1)
SuggestionFrame.BackgroundColor3 = Themes[CurThemeIdx].WindowColor
SuggestionFrame.BackgroundTransparency = CurTrans
SuggestionFrame.BorderSizePixel = 0
SuggestionFrame.ClipsDescendants = true
SuggestionFrame.Visible = false
SuggestionFrame.Parent = MainGui

local SuggestionCorner = Instance.new("UICorner")
SuggestionCorner.CornerRadius = UDim.new(0, 12)
SuggestionCorner.Parent = SuggestionFrame

local SuggestionScroll = Instance.new("ScrollingFrame")
SuggestionScroll.Size = UDim2.new(1, -16, 1, -16)
SuggestionScroll.Position = UDim2.new(0, 8, 0, 8)
SuggestionScroll.BackgroundTransparency = 1
SuggestionScroll.BorderSizePixel = 0
SuggestionScroll.ScrollBarThickness = 3
SuggestionScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
SuggestionScroll.Parent = SuggestionFrame

local SuggestionLayout = Instance.new("UIListLayout")
SuggestionLayout.SortOrder = Enum.SortOrder.LayoutOrder
SuggestionLayout.Padding = UDim.new(0, 4)
SuggestionLayout.Parent = SuggestionScroll

local SSYWindow = Instance.new("Frame")
SSYWindow.Name = "SSYWindow"
SSYWindow.Size = UDim2.new(0, 380, 0, 310)
SSYWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
SSYWindow.AnchorPoint = Vector2.new(0.5, 0.5)
SSYWindow.BackgroundColor3 = Themes[CurThemeIdx].WindowColor
SSYWindow.BackgroundTransparency = CurTrans
SSYWindow.BorderSizePixel = 0
SSYWindow.Visible = false
SSYWindow.ClipsDescendants = true
SSYWindow.Parent = MainGui

local SSYCorner = Instance.new("UICorner")
SSYCorner.CornerRadius = UDim.new(0, 12)
SSYCorner.Parent = SSYWindow

local TopBarDrag = Instance.new("Frame")
TopBarDrag.Name = "TopBarDrag"
TopBarDrag.Size = UDim2.new(1, 0, 0, 40)
TopBarDrag.BackgroundTransparency = 1
TopBarDrag.Parent = SSYWindow

local TopBarDivider = Instance.new("Frame")
TopBarDivider.Name = "TopBarDivider"
TopBarDivider.Size = UDim2.new(1, -20, 0, 1)
TopBarDivider.Position = UDim2.new(0, 10, 0, 40)
TopBarDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
TopBarDivider.BackgroundTransparency = 0.3
TopBarDivider.BorderSizePixel = 0
TopBarDivider.Parent = SSYWindow

local BackBtn = Instance.new("TextButton")
BackBtn.Name = "BackBtn"
BackBtn.Size = UDim2.new(0, 25, 0, 30)
BackBtn.Position = UDim2.new(0, 10, 0, 5)
BackBtn.BackgroundTransparency = 1
BackBtn.Text = "<"
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.TextTransparency = 1
BackBtn.TextSize = 16
BackBtn.Font = Enum.Font.GothamBold
BackBtn.Visible = false
BackBtn.Parent = TopBarDrag

local WindowTitle = Instance.new("TextLabel")
WindowTitle.Name = "WindowTitle"
WindowTitle.Size = UDim2.new(0, 100, 1, 0)
WindowTitle.Position = UDim2.new(0, 15, 0, 0)
WindowTitle.BackgroundTransparency = 1
WindowTitle.Text = "SSY"
WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WindowTitle.TextSize = 16
WindowTitle.Font = Enum.Font.GothamBold
WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
WindowTitle.Parent = TopBarDrag

local WindowControls = Instance.new("Frame")
WindowControls.Name = "WindowControls"
WindowControls.Size = UDim2.new(0, 60, 0, 30)
WindowControls.Position = UDim2.new(1, -65, 0, 5)
WindowControls.BackgroundTransparency = 1
WindowControls.Parent = TopBarDrag

local ControlsLayout = Instance.new("UIListLayout")
ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ControlsLayout.Padding = UDim.new(0, 4)
ControlsLayout.Parent = WindowControls

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.LayoutOrder = 1
MinimizeBtn.Parent = WindowControls

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.LayoutOrder = 2
CloseBtn.Parent = WindowControls

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "◢"
ResizeHandle.TextColor3 = Color3.fromRGB(120, 120, 130)
ResizeHandle.TextSize = 12
ResizeHandle.Parent = SSYWindow

local HomePage = Instance.new("ScrollingFrame")
HomePage.Name = "HomePage"
HomePage.Size = UDim2.new(1, -30, 1, -55)
HomePage.Position = UDim2.new(0, 15, 0, 48)
HomePage.BackgroundTransparency = 1
HomePage.BorderSizePixel = 0
HomePage.ScrollBarThickness = 3
HomePage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
HomePage.Visible = true
HomePage.Parent = SSYWindow

local HomeLayout = Instance.new("UIListLayout")
HomeLayout.SortOrder = Enum.SortOrder.LayoutOrder
HomeLayout.Padding = UDim.new(0, 8)
HomeLayout.Parent = HomePage

HomeLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	HomePage.CanvasSize = UDim2.new(0, 0, 0, HomeLayout.AbsoluteContentSize.Y)
end)

local MenuButtons = {}

local function StyleMenuButton(Btn, Text)
	Btn.Size = UDim2.new(1, -5, 0, 36)
	Btn.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
	Btn.BackgroundTransparency = 0.2
	Btn.Text = Text
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 13
	Btn.Font = Enum.Font.GothamBold

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Btn

	table.insert(MenuButtons, Btn)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Themes[CurThemeIdx].HoverColor}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Themes[CurThemeIdx].BtnColor}):Play()
	end)
end

local CommandNavBtn = Instance.new("TextButton") StyleMenuButton(CommandNavBtn, "Command") CommandNavBtn.Parent = HomePage
local ToolsNavBtn = Instance.new("TextButton") StyleMenuButton(ToolsNavBtn, "Give Tools") ToolsNavBtn.Parent = HomePage
local BanNavBtn = Instance.new("TextButton") StyleMenuButton(BanNavBtn, "Ban List") BanNavBtn.Parent = HomePage
local ScannerNavBtn = Instance.new("TextButton") StyleMenuButton(ScannerNavBtn, "Scanner") ScannerNavBtn.Parent = HomePage
local SettingNavBtn = Instance.new("TextButton") StyleMenuButton(SettingNavBtn, "Setting") SettingNavBtn.Parent = HomePage

local CommandPage = Instance.new("Frame")
CommandPage.Name = "CommandPage"
CommandPage.Size = UDim2.new(1, -30, 1, -55)
CommandPage.Position = UDim2.new(0, 15, 0, 48)
CommandPage.BackgroundTransparency = 1
CommandPage.Visible = false
CommandPage.Parent = SSYWindow

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, 0, 0, 34)
SearchFrame.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
SearchFrame.BackgroundTransparency = 0.2
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = CommandPage
table.insert(MenuButtons, SearchFrame)

local SearchCorner = Instance.new("UICorner") SearchCorner.CornerRadius = UDim.new(0, 8) SearchCorner.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -20, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "Search commands"
SearchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 13
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, 0, 1, -42)
ScrollList.Position = UDim2.new(0, 0, 0, 40)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 3
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.Parent = CommandPage

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 4)
ScrollLayout.Parent = ScrollList

ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollList.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y)
end)

local CmdTooltip = Instance.new("Frame")
CmdTooltip.Name = "CmdTooltip"
CmdTooltip.Size = UDim2.new(0, 220, 0, 45)
CmdTooltip.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
CmdTooltip.BackgroundTransparency = 0.1
CmdTooltip.BorderSizePixel = 0
CmdTooltip.Visible = false
CmdTooltip.ZIndex = 50
CmdTooltip.Parent = MainGui

local TooltipCorner = Instance.new("UICorner")
TooltipCorner.CornerRadius = UDim.new(0, 6)
TooltipCorner.Parent = CmdTooltip

local TooltipText = Instance.new("TextLabel")
TooltipText.Size = UDim2.new(1, -16, 1, 0)
TooltipText.Position = UDim2.new(0, 8, 0, 0)
TooltipText.BackgroundTransparency = 1
TooltipText.Text = ""
TooltipText.TextColor3 = Color3.fromRGB(240, 240, 245)
TooltipText.TextSize = 11
TooltipText.Font = Enum.Font.Gotham
TooltipText.TextWrapped = true
TooltipText.TextXAlignment = Enum.TextXAlignment.Left
TooltipText.ZIndex = 51
TooltipText.Parent = CmdTooltip

local function PopulateCmdList(FilterText)
	FilterText = FilterText and FilterText:lower():gsub("^;", "") or ""
	for _, Item in ipairs(ScrollList:GetChildren()) do
		if Item:IsA("Frame") then Item:Destroy() end
	end

	for _, CmdData in ipairs(RawCommands) do
		local DispName = CmdData.Display or CmdData.Name
		local MatchesSearch = (FilterText == "")

		if not MatchesSearch then
			for _, Alias in ipairs(CmdData.Aliases) do
				if Alias:lower():find(FilterText, 1, true) then MatchesSearch = true break end
			end
		end

		if MatchesSearch then
			local ItemFrame = Instance.new("Frame")
			ItemFrame.Size = UDim2.new(1, -5, 0, 30)
			ItemFrame.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
			ItemFrame.BackgroundTransparency = 0.2
			ItemFrame.BorderSizePixel = 0
			ItemFrame.Parent = ScrollList

			local ItemCorner = Instance.new("UICorner") ItemCorner.CornerRadius = UDim.new(0, 6) ItemCorner.Parent = ItemFrame

			local ItemText = Instance.new("TextLabel")
			ItemText.Size = UDim2.new(1, -20, 1, 0)
			ItemText.Position = UDim2.new(0, 10, 0, 0)
			ItemText.BackgroundTransparency = 1
			ItemText.Text = DispName
			ItemText.TextColor3 = Color3.fromRGB(220, 220, 230)
			ItemText.TextSize = 13
			ItemText.Font = Enum.Font.Gotham
			ItemText.TextXAlignment = Enum.TextXAlignment.Left
			ItemText.Parent = ItemFrame

			ItemFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					TooltipText.Text = DispName .. (CmdData.Description and ("\nInfo: " .. CmdData.Description) or "")
					local MousePos = UserInputService:GetMouseLocation()
					CmdTooltip.Position = UDim2.new(0, MousePos.X + 15, 0, MousePos.Y - 20)
					CmdTooltip.Visible = true
				end
			end)

			ItemFrame.InputChanged:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePos = UserInputService:GetMouseLocation()
					CmdTooltip.Position = UDim2.new(0, MousePos.X + 15, 0, MousePos.Y - 20)
				end
			end)

			ItemFrame.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					CmdTooltip.Visible = false
				end
			end)
		end
	end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function() PopulateCmdList(SearchBox.Text) end)

local CurrentMatchedCommand = ""

local function UpdateAutoCorrectAndSuggestions()
	local RawText = CmdTextBox.Text
	local CleanText = RawText:lower()
	local HasSemicolon = CleanText:sub(1, 1) == ";"
	local QueryText = HasSemicolon and CleanText:sub(2) or CleanText

	for _, Child in ipairs(SuggestionScroll:GetChildren()) do
		if Child:IsA("TextButton") then Child:Destroy() end
	end

	if QueryText == "" then
		AutoCorrectLabel.Text = ""
		CurrentMatchedCommand = ""
		SuggestionFrame.Visible = false
		return
	end

	local FirstWord = QueryText:match("^(%S+)") or ""
	local MatchedList = {}

	for _, Cmd in ipairs(CommandKeys) do
		if Cmd:sub(1, #FirstWord) == FirstWord then table.insert(MatchedList, Cmd) end
	end

	if #MatchedList > 0 then
		CurrentMatchedCommand = MatchedList[1]
		local RestOfCmd = CurrentMatchedCommand:sub(#FirstWord + 1)
		AutoCorrectLabel.Text = (HasSemicolon and ";" or "") .. QueryText .. RestOfCmd

		for _, MatchCmd in ipairs(MatchedList) do
			local SugBtn = Instance.new("TextButton")
			SugBtn.Size = UDim2.new(1, -5, 0, 26)
			SugBtn.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
			SugBtn.BackgroundTransparency = 0.3
			SugBtn.Text = "  " .. (HasSemicolon and ";" or "") .. MatchCmd
			SugBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
			SugBtn.TextSize = 12
			SugBtn.Font = Enum.Font.Gotham
			SugBtn.TextXAlignment = Enum.TextXAlignment.Left
			SugBtn.Parent = SuggestionScroll

			local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 6) BCorner.Parent = SugBtn

			SugBtn.MouseButton1Click:Connect(function()
				local ArgsStr = QueryText:match("^%S+(.*)") or ""
				CmdTextBox.Text = (HasSemicolon and ";" or "") .. MatchCmd .. ArgsStr
				CmdTextBox.CursorPosition = #CmdTextBox.Text + 1
				CmdTextBox:CaptureFocus()
			end)
		end

		local ContentHeight = #MatchedList * 30
		local FrameHeight = math.clamp(ContentHeight + 16, 36, 140)
		SuggestionFrame.Size = UDim2.new(0, 420, 0, FrameHeight)
		SuggestionScroll.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
		SuggestionFrame.Visible = true
	else
		CurrentMatchedCommand = ""
		AutoCorrectLabel.Text = ""
		SuggestionFrame.Visible = false
	end
end

CmdTextBox:GetPropertyChangedSignal("Text"):Connect(UpdateAutoCorrectAndSuggestions)

local BanPage = Instance.new("Frame")
BanPage.Name = "BanPage"
BanPage.Size = UDim2.new(1, -30, 1, -55)
BanPage.Position = UDim2.new(0, 15, 0, 48)
BanPage.BackgroundTransparency = 1
BanPage.Visible = false
BanPage.Parent = SSYWindow

local BanSearchFrame = Instance.new("Frame")
BanSearchFrame.Size = UDim2.new(1, 0, 0, 34)
BanSearchFrame.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
BanSearchFrame.BackgroundTransparency = 0.2
BanSearchFrame.BorderSizePixel = 0
BanSearchFrame.Parent = BanPage
table.insert(MenuButtons, BanSearchFrame)

local BanSearchCorner = Instance.new("UICorner") BanSearchCorner.CornerRadius = UDim.new(0, 8) BanSearchCorner.Parent = BanSearchFrame

local BanSearchBox = Instance.new("TextBox")
BanSearchBox.Size = UDim2.new(1, -20, 1, 0)
BanSearchBox.Position = UDim2.new(0, 10, 0, 0)
BanSearchBox.BackgroundTransparency = 1
BanSearchBox.PlaceholderText = "Search banned players..."
BanSearchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
BanSearchBox.Text = ""
BanSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BanSearchBox.TextSize = 13
BanSearchBox.Font = Enum.Font.Gotham
BanSearchBox.TextXAlignment = Enum.TextXAlignment.Left
BanSearchBox.ClearTextOnFocus = false
BanSearchBox.Parent = BanSearchFrame

local BanScroll = Instance.new("ScrollingFrame")
BanScroll.Size = UDim2.new(1, 0, 1, -42)
BanScroll.Position = UDim2.new(0, 0, 0, 40)
BanScroll.BackgroundTransparency = 1
BanScroll.BorderSizePixel = 0
BanScroll.ScrollBarThickness = 3
BanScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
BanScroll.Parent = BanPage

local BanLayout = Instance.new("UIListLayout")
BanLayout.SortOrder = Enum.SortOrder.LayoutOrder
BanLayout.Padding = UDim.new(0, 6)
BanLayout.Parent = BanScroll

BanLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	BanScroll.CanvasSize = UDim2.new(0, 0, 0, BanLayout.AbsoluteContentSize.Y)
end)

RenderBans = function(FilterText)
	if FilterText == nil and BanSearchBox then
		FilterText = BanSearchBox.Text
	end
	FilterText = FilterText and FilterText:lower() or ""

	for _, Child in ipairs(BanScroll:GetChildren()) do
		if Child:IsA("Frame") or Child:IsA("TextLabel") then Child:Destroy() end
	end

	local HasAnyBans = false
	for UserId, BanInfo in pairs(Bans) do
		local NameStr = (BanInfo.Name or "Unknown"):lower()
		local IdStr = tostring(UserId):lower()

		if FilterText == "" or NameStr:find(FilterText, 1, true) or IdStr:find(FilterText, 1, true) then
			HasAnyBans = true
			local BItem = Instance.new("Frame")
			BItem.Size = UDim2.new(1, -5, 0, 36)
			BItem.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
			BItem.BackgroundTransparency = 0.3
			BItem.Parent = BanScroll

			local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 8) BCorner.Parent = BItem

			local BTitle = Instance.new("TextLabel")
			BTitle.Size = UDim2.new(0.6, 0, 1, 0)
			BTitle.Position = UDim2.new(0, 12, 0, 0)
			BTitle.BackgroundTransparency = 1
			BTitle.Text = (BanInfo.Name or "Unknown") .. " (ID: " .. UserId .. ")"
			BTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			BTitle.TextSize = 11
			BTitle.Font = Enum.Font.GothamBold
			BTitle.TextXAlignment = Enum.TextXAlignment.Left
			BTitle.TextTruncate = Enum.TextTruncate.AtEnd
			BTitle.Parent = BItem

			local UnbanBtn = Instance.new("TextButton")
			UnbanBtn.Size = UDim2.new(0, 75, 0, 24)
			UnbanBtn.Position = UDim2.new(1, -83, 0.5, -12)
			UnbanBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
			UnbanBtn.Text = "Unban"
			UnbanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			UnbanBtn.TextSize = 11
			UnbanBtn.Font = Enum.Font.GothamBold
			UnbanBtn.Parent = BItem

			local UCorner = Instance.new("UICorner") UCorner.CornerRadius = UDim.new(0, 6) UCorner.Parent = UnbanBtn

			UnbanBtn.MouseButton1Click:Connect(function()
				Bans[UserId] = nil
				RenderBans()
				ShowNotification("Unbanned successfully", 2)
			end)
		end
	end

	if not HasAnyBans then
		local EmptyLabel = Instance.new("TextLabel")
		EmptyLabel.Size = UDim2.new(1, 0, 0, 36)
		EmptyLabel.BackgroundTransparency = 1
		EmptyLabel.Text = FilterText == "" and "No banned players." or "No matching banned players."
		EmptyLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
		EmptyLabel.TextSize = 13
		EmptyLabel.Font = Enum.Font.Gotham
		EmptyLabel.Parent = BanScroll
	end
end

BanSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	RenderBans(BanSearchBox.Text)
end)

RenderBans()

local ScannerPage = Instance.new("Frame")
ScannerPage.Name = "ScannerPage"
ScannerPage.Size = UDim2.new(1, -30, 1, -55)
ScannerPage.Position = UDim2.new(0, 15, 0, 48)
ScannerPage.BackgroundTransparency = 1
ScannerPage.Visible = false
ScannerPage.Parent = SSYWindow

local ScanTopBar = Instance.new("Frame")
ScanTopBar.Size = UDim2.new(1, 0, 0, 32)
ScanTopBar.BackgroundTransparency = 1
ScanTopBar.Parent = ScannerPage

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.48, 0, 1, 0)
ScanBtn.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
ScanBtn.Text = "Scan"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 12
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = ScanTopBar
table.insert(MenuButtons, ScanBtn)

local ScanCorner = Instance.new("UICorner") ScanCorner.CornerRadius = UDim.new(0, 6) ScanCorner.Parent = ScanBtn

AutoScanBtnScanner = Instance.new("TextButton")
AutoScanBtnScanner.Size = UDim2.new(0.48, 0, 1, 0)
AutoScanBtnScanner.Position = UDim2.new(0.52, 0, 0, 0)
AutoScanBtnScanner.BackgroundColor3 = Config.AutoScan and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
AutoScanBtnScanner.Text = "Auto Scan: " .. (Config.AutoScan and "TRUE" or "FALSE")
AutoScanBtnScanner.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoScanBtnScanner.TextSize = 11
AutoScanBtnScanner.Font = Enum.Font.GothamBold
AutoScanBtnScanner.Parent = ScanTopBar

local AutoScanScannerCorner = Instance.new("UICorner") AutoScanScannerCorner.CornerRadius = UDim.new(0, 6) AutoScanScannerCorner.Parent = AutoScanBtnScanner

ScannerContent = Instance.new("ScrollingFrame")
ScannerContent.Name = "ScannerContent"
ScannerContent.Size = UDim2.new(1, 0, 1, -40)
ScannerContent.Position = UDim2.new(0, 0, 0, 40)
ScannerContent.BackgroundTransparency = 1
ScannerContent.BorderSizePixel = 0
ScannerContent.ScrollBarThickness = 3
ScannerContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
ScannerContent.Parent = ScannerPage

local ScanTextLayout = Instance.new("UIListLayout")
ScanTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScanTextLayout.Padding = UDim.new(0, 2)
ScanTextLayout.Parent = ScannerContent

ScanTextLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScannerContent.CanvasSize = UDim2.new(0, 0, 0, ScanTextLayout.AbsoluteContentSize.Y)
	ScannerContent.CanvasPosition = Vector2.new(0, math.max(0, ScanTextLayout.AbsoluteContentSize.Y - ScannerContent.AbsoluteWindowSize.Y))
end)

ScanBtn.MouseButton1Click:Connect(function() 
	task.spawn(StartScanProcess)
end)

local function UpdateAutoScanUIStates()
	local StatusText = "Auto Scan: " .. (Config.AutoScan and "TRUE" or "FALSE")
	local StatusColor = Config.AutoScan and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
	
	if AutoScanBtnScanner then
		AutoScanBtnScanner.Text = StatusText
		AutoScanBtnScanner.BackgroundColor3 = StatusColor
	end
	if AutoScanBtnSetting then
		AutoScanBtnSetting.Text = Config.AutoScan and "TRUE" or "FALSE"
		AutoScanBtnSetting.BackgroundColor3 = StatusColor
	end
end

AutoScanBtnScanner.MouseButton1Click:Connect(function()
	Config.AutoScan = not Config.AutoScan
	AutoScanEnabled = Config.AutoScan
	SaveConfig()
	UpdateAutoScanUIStates()
end)

local ToolsPage = Instance.new("Frame")
ToolsPage.Name = "ToolsPage"
ToolsPage.Size = UDim2.new(1, -30, 1, -55)
ToolsPage.Position = UDim2.new(0, 15, 0, 48)
ToolsPage.BackgroundTransparency = 1
ToolsPage.Visible = false
ToolsPage.Parent = SSYWindow

local ToolsSearchFrame = Instance.new("Frame")
ToolsSearchFrame.Size = UDim2.new(1, 0, 0, 34)
ToolsSearchFrame.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
ToolsSearchFrame.BackgroundTransparency = 0.2
ToolsSearchFrame.BorderSizePixel = 0
ToolsSearchFrame.Parent = ToolsPage
table.insert(MenuButtons, ToolsSearchFrame)

local ToolsSearchCorner = Instance.new("UICorner") ToolsSearchCorner.CornerRadius = UDim.new(0, 8) ToolsSearchCorner.Parent = ToolsSearchFrame

local ToolsSearchBox = Instance.new("TextBox")
ToolsSearchBox.Size = UDim2.new(1, -20, 1, 0)
ToolsSearchBox.Position = UDim2.new(0, 10, 0, 0)
ToolsSearchBox.BackgroundTransparency = 1
ToolsSearchBox.PlaceholderText = "Search tools..."
ToolsSearchBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
ToolsSearchBox.Text = ""
ToolsSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolsSearchBox.TextSize = 13
ToolsSearchBox.Font = Enum.Font.Gotham
ToolsSearchBox.TextXAlignment = Enum.TextXAlignment.Left
ToolsSearchBox.ClearTextOnFocus = false
ToolsSearchBox.Parent = ToolsSearchFrame

local ToolsScroll = Instance.new("ScrollingFrame")
ToolsScroll.Size = UDim2.new(1, 0, 1, -42)
ToolsScroll.Position = UDim2.new(0, 0, 0, 40)
ToolsScroll.BackgroundTransparency = 1
ToolsScroll.BorderSizePixel = 0
ToolsScroll.ScrollBarThickness = 3
ToolsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
ToolsScroll.Parent = ToolsPage

local ToolsLayout = Instance.new("UIListLayout")
ToolsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToolsLayout.Padding = UDim.new(0, 6)
ToolsLayout.Parent = ToolsScroll

ToolsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ToolsScroll.CanvasSize = UDim2.new(0, 0, 0, ToolsLayout.AbsoluteContentSize.Y)
end)

local ToolsList = {
	{
		Name = "Delete Tool",
		Description = "Click part to destroy target",
		GiveFunction = function()
			pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
			local Char = LocalPlayer.Character
			if not Char then return end
			local Mouse = LocalPlayer:GetMouse()
			
			if LocalPlayer.Backpack:FindFirstChild("wacky destroy tool") or (Char and Char:FindFirstChild("wacky destroy tool")) then
				ShowNotification("Give Tool: Delete Tool", 2)
				return
			end

			local DestroyTool = Instance.new("Tool", LocalPlayer.Backpack)
			DestroyTool.RequiresHandle = false
			DestroyTool.CanBeDropped = false
			DestroyTool.Name = "wacky destroy tool"
			DestroyTool.ToolTip = "Click to destroy target part"
			DestroyTool.TextureId = "rbxasset://Textures/Hammer.png"

			local Handle = Instance.new("Part", DestroyTool)
			Handle.Name = "Handle"
			Handle.Transparency = 1
			Handle.CanCollide = false
			Handle.Size = Vector3.new(0.001,0.001,0.001)
			Handle.Massless = true

			local Selection, SelectionLoop
			DestroyTool.Equipped:Connect(function()
				Selection = Instance.new("Highlight")
				Selection.FillColor = Color3.fromRGB(140, 0, 255)
				Selection.FillTransparency = 0.6
				Selection.OutlineColor = Color3.fromRGB(75, 0, 130)
				Selection.OutlineTransparency = 0
				Selection.Parent = LocalPlayer.PlayerGui

				SelectionLoop = RunService.Heartbeat:Connect(function()
					local Target = Mouse.Target
					if Target == nil then Selection.Adornee = nil return end
					Selection.Adornee = Target
				end)
			end)

			DestroyTool.Unequipped:Connect(function()
				if Selection then Selection:Destroy() end
				if SelectionLoop then SelectionLoop:Disconnect() end
			end)

			DestroyTool.Activated:Connect(function()
				local Target = Mouse.Target
				if Target == nil then return end
				if GEnv.delete then
					GEnv.delete(Target)
				end
			end)
			ShowNotification("Give Tool: Delete Tool", 2)
		end
	},
	{
		Name = "Weld Tool",
		Description = "Click part to unweld target",
		GiveFunction = function()
			pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
			local Char = LocalPlayer.Character
			if not Char then return end
			local Mouse = LocalPlayer:GetMouse()
			
			if LocalPlayer.Backpack:FindFirstChild("wacky unweld tool") or (Char and Char:FindFirstChild("wacky unweld tool")) then
				ShowNotification("Give Tool: Weld Tool", 2)
				return
			end

			local UnweldTool = Instance.new("Tool", LocalPlayer.Backpack)
			UnweldTool.RequiresHandle = false
			UnweldTool.CanBeDropped = false
			UnweldTool.Name = "wacky unweld tool"
			UnweldTool.ToolTip = "Click to unweld target"
			UnweldTool.TextureId = "rbxassetid://4989743039"

			local Handle = Instance.new("Part", UnweldTool)
			Handle.Name = "Handle"
			Handle.Transparency = 1
			Handle.CanCollide = false
			Handle.Size = Vector3.new(0.001,0.001,0.001)
			Handle.Massless = true

			local Selection2, SelectionLoop2
			UnweldTool.Equipped:Connect(function()
				Selection2 = Instance.new("Highlight")
				Selection2.FillColor = Color3.fromRGB(140, 0, 255)
				Selection2.FillTransparency = 0.6
				Selection2.OutlineColor = Color3.fromRGB(75, 0, 130)
				Selection2.OutlineTransparency = 0
				Selection2.Parent = LocalPlayer.PlayerGui

				SelectionLoop2 = RunService.Heartbeat:Connect(function()
					local Target = Mouse.Target
					if Target == nil then Selection2.Adornee = nil return end
					Selection2.Adornee = Target
				end)
			end)

			UnweldTool.Unequipped:Connect(function()
				if Selection2 then Selection2:Destroy() end
				if SelectionLoop2 then SelectionLoop2:Disconnect() end
			end)

			UnweldTool.Activated:Connect(function()
				local Target = Mouse.Target
				if Target == nil then return end
				for _, V in pairs(Target:GetDescendants()) do
					if not (V:IsA("Weld") or V:IsA("Attachment")) then continue end
					if GEnv.delete then GEnv.delete(V) end
				end
			end)
			ShowNotification("Give Tool: Weld Tool", 2)
		end
	},
	{
		Name = "Gun Tool",
		Description = "Click player to delete their head",
		GiveFunction = function()
			pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
			local Char = LocalPlayer.Character
			if not Char then return end
			local Mouse = LocalPlayer:GetMouse()
			
			if LocalPlayer.Backpack:FindFirstChild("wacky gun tool") or (Char and Char:FindFirstChild("wacky gun tool")) then
				ShowNotification("Give Tool: Gun Tool", 2)
				return
			end

			local GunTool = Instance.new("Tool", LocalPlayer.Backpack)
			GunTool.RequiresHandle = false
			GunTool.CanBeDropped = false
			GunTool.Name = "wacky gun tool"
			GunTool.ToolTip = "Click a player to delete their head"
			GunTool.TextureId = "rbxassetid://822278164"

			local Handle = Instance.new("Part", GunTool)
			Handle.Name = "Handle"
			Handle.Transparency = 1
			Handle.CanCollide = false
			Handle.Size = Vector3.new(0.001,0.001,0.001)
			Handle.Massless = true

			local Selection, SelectionLoop
			GunTool.Equipped:Connect(function()
				Selection = Instance.new("Highlight")
				Selection.FillColor = Color3.fromRGB(140, 0, 255)
				Selection.FillTransparency = 0.6
				Selection.OutlineColor = Color3.fromRGB(75, 0, 130)
				Selection.OutlineTransparency = 0
				Selection.Parent = LocalPlayer.PlayerGui

				SelectionLoop = RunService.Heartbeat:Connect(function()
					local Target = Mouse.Target
					if Target == nil then Selection.Adornee = nil return end
					
					local MatchedChar = nil
					for _, P in ipairs(Players:GetPlayers()) do
						if P.Character and Target:IsDescendantOf(P.Character) then
							MatchedChar = P.Character
							break
						end
					end
					if MatchedChar then Selection.Adornee = MatchedChar else Selection.Adornee = nil end
				end)
			end)

			GunTool.Unequipped:Connect(function()
				if Selection then Selection:Destroy() end
				if SelectionLoop then SelectionLoop:Disconnect() end
			end)

			GunTool.Activated:Connect(function()
				local Target = Mouse.Target
				if Target == nil then return end
				for _, V in ipairs(Players:GetPlayers()) do
					local C = V.Character
					if C == nil then continue end
					if Target:IsDescendantOf(C) then
						local Head = C:FindFirstChild("Head")
						if Head and GEnv.delete then
							GEnv.delete(Head)
						end
						break
					end
				end
			end)
			ShowNotification("Give Tool: Gun Tool", 2)
		end
	},
	{
		Name = "Ban Tool",
		Description = "Click player to hard-ban them",
		GiveFunction = function()
			pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true) end)
			local Char = LocalPlayer.Character
			if not Char then return end
			local Mouse = LocalPlayer:GetMouse()
			
			if LocalPlayer.Backpack:FindFirstChild("wacky ban tool") or (Char and Char:FindFirstChild("wacky ban tool")) then
				ShowNotification("Give Tool: Ban Tool", 2)
				return
			end

			local BanTool = Instance.new("Tool", LocalPlayer.Backpack)
			BanTool.RequiresHandle = false
			BanTool.CanBeDropped = false
			BanTool.Name = "wacky ban tool"
			BanTool.ToolTip = "Click a player to permanently ban them"
			BanTool.TextureId = "rbxassetid://6023426915"

			local Handle = Instance.new("Part", BanTool)
			Handle.Name = "Handle"
			Handle.Transparency = 1
			Handle.CanCollide = false
			Handle.Size = Vector3.new(0.001,0.001,0.001)
			Handle.Massless = true

			local Selection, SelectionLoop
			BanTool.Equipped:Connect(function()
				Selection = Instance.new("Highlight")
				Selection.FillColor = Color3.fromRGB(200, 0, 0)
				Selection.FillTransparency = 0.6
				Selection.OutlineColor = Color3.fromRGB(120, 0, 0)
				Selection.OutlineTransparency = 0
				Selection.Parent = LocalPlayer.PlayerGui

				SelectionLoop = RunService.Heartbeat:Connect(function()
					local Target = Mouse.Target
					if Target == nil then Selection.Adornee = nil return end
					
					local MatchedChar = nil
					for _, P in ipairs(Players:GetPlayers()) do
						if P.Character and Target:IsDescendantOf(P.Character) then
							MatchedChar = P.Character
							break
						end
					end
					if MatchedChar then Selection.Adornee = MatchedChar else Selection.Adornee = nil end
				end)
			end)

			BanTool.Unequipped:Connect(function()
				if Selection then Selection:Destroy() end
				if SelectionLoop then SelectionLoop:Disconnect() end
			end)

			BanTool.Activated:Connect(function()
				local Target = Mouse.Target
				if Target == nil then return end
				for _, V in ipairs(Players:GetPlayers()) do
					local C = V.Character
					if C == nil then continue end
					if Target:IsDescendantOf(C) and V ~= LocalPlayer then
						local uidStr = tostring(V.UserId)
						if not Bans[uidStr] then
							Bans[uidStr] = { Name = V.Name, Reason = "Banned via Ban Tool" }
						end
						if RenderBans then RenderBans() end
						if GEnv.delete then GEnv.delete(V) end
						ShowNotification("Banned player: " .. V.Name, 3)
						break
					end
				end
			end)
			ShowNotification("Give Tool: Ban Tool", 2)
		end
	}
}

local function RenderTools(FilterText)
	if FilterText == nil and ToolsSearchBox then
		FilterText = ToolsSearchBox.Text
	end
	FilterText = FilterText and FilterText:lower() or ""

	for _, Child in ipairs(ToolsScroll:GetChildren()) do
		if Child:IsA("Frame") then Child:Destroy() end
	end

	for _, ToolData in ipairs(ToolsList) do
		local NameStr = ToolData.Name:lower()
		local DescStr = (ToolData.Description or ""):lower()

		if FilterText == "" or NameStr:find(FilterText, 1, true) or DescStr:find(FilterText, 1, true) then
			local TItem = Instance.new("Frame")
			TItem.Size = UDim2.new(1, -5, 0, 36)
			TItem.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
			TItem.BackgroundTransparency = 0.3
			TItem.Parent = ToolsScroll

			local TCorner = Instance.new("UICorner") TCorner.CornerRadius = UDim.new(0, 8) TCorner.Parent = TItem

			local TTitle = Instance.new("TextLabel")
			TTitle.Size = UDim2.new(0.65, 0, 1, 0)
			TTitle.Position = UDim2.new(0, 12, 0, 0)
			TTitle.BackgroundTransparency = 1
			TTitle.Text = ToolData.Name
			TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			TTitle.TextSize = 11
			TTitle.Font = Enum.Font.GothamBold
			TTitle.TextXAlignment = Enum.TextXAlignment.Left
			TTitle.TextTruncate = Enum.TextTruncate.AtEnd
			TTitle.Parent = TItem

			local GiveBtn = Instance.new("TextButton")
			GiveBtn.Size = UDim2.new(0, 75, 0, 24)
			GiveBtn.Position = UDim2.new(1, -83, 0.5, -12)
			GiveBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
			GiveBtn.Text = "Give"
			GiveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			GiveBtn.TextSize = 11
			GiveBtn.Font = Enum.Font.GothamBold
			GiveBtn.Parent = TItem

			local GCorner = Instance.new("UICorner") GCorner.CornerRadius = UDim.new(0, 6) GCorner.Parent = GiveBtn

			GiveBtn.MouseButton1Click:Connect(function()
				pcall(ToolData.GiveFunction)
			end)
		end
	end
end

ToolsSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	RenderTools(ToolsSearchBox.Text)
end)

RenderTools()

local SettingPage = Instance.new("Frame")
SettingPage.Name = "SettingPage"
SettingPage.Size = UDim2.new(1, -30, 1, -55)
SettingPage.Position = UDim2.new(0, 15, 0, 48)
SettingPage.BackgroundTransparency = 1
SettingPage.Visible = false
SettingPage.Parent = SSYWindow

local AutoScanBox = Instance.new("Frame")
AutoScanBox.Size = UDim2.new(1, 0, 0, 45)
AutoScanBox.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
AutoScanBox.BackgroundTransparency = 0.3
AutoScanBox.Parent = SettingPage
table.insert(MenuButtons, AutoScanBox)

local AutoScanCorner = Instance.new("UICorner") AutoScanCorner.CornerRadius = UDim.new(0, 8) AutoScanCorner.Parent = AutoScanBox

local AutoScanTitle = Instance.new("TextLabel")
AutoScanTitle.Size = UDim2.new(0.7, 0, 1, 0)
AutoScanTitle.Position = UDim2.new(0, 12, 0, 0)
AutoScanTitle.BackgroundTransparency = 1
AutoScanTitle.Text = "Auto Scan (SSY/Config.cfg)"
AutoScanTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
AutoScanTitle.TextSize = 13
AutoScanTitle.Font = Enum.Font.GothamBold
AutoScanTitle.TextXAlignment = Enum.TextXAlignment.Left
AutoScanTitle.Parent = AutoScanBox

AutoScanBtnSetting = Instance.new("TextButton")
AutoScanBtnSetting.Size = UDim2.new(0, 70, 0, 28)
AutoScanBtnSetting.Position = UDim2.new(1, -80, 0.5, -14)
AutoScanBtnSetting.BackgroundColor3 = Config.AutoScan and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(160, 40, 40)
AutoScanBtnSetting.Text = Config.AutoScan and "TRUE" or "FALSE"
AutoScanBtnSetting.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoScanBtnSetting.TextSize = 11
AutoScanBtnSetting.Font = Enum.Font.GothamBold
AutoScanBtnSetting.Parent = AutoScanBox

local ToggleCorner = Instance.new("UICorner") ToggleCorner.CornerRadius = UDim.new(0, 6) ToggleCorner.Parent = AutoScanBtnSetting

AutoScanBtnSetting.MouseButton1Click:Connect(function()
	Config.AutoScan = not Config.AutoScan
	AutoScanEnabled = Config.AutoScan
	SaveConfig()
	UpdateAutoScanUIStates()
end)

local ThemeBox = Instance.new("Frame")
ThemeBox.Size = UDim2.new(0.48, 0, 1, -55)
ThemeBox.Position = UDim2.new(0, 0, 0, 52)
ThemeBox.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
ThemeBox.BackgroundTransparency = 0.3
ThemeBox.Parent = SettingPage
table.insert(MenuButtons, ThemeBox)

local ThemeCorner = Instance.new("UICorner") ThemeCorner.CornerRadius = UDim.new(0, 8) ThemeCorner.Parent = ThemeBox

local ThemeTitle = Instance.new("TextLabel")
ThemeTitle.Size = UDim2.new(1, 0, 0, 25)
ThemeTitle.Position = UDim2.new(0, 10, 0, 8)
ThemeTitle.BackgroundTransparency = 1
ThemeTitle.Text = "Theme"
ThemeTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
ThemeTitle.TextSize = 13
ThemeTitle.Font = Enum.Font.GothamBold
ThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
ThemeTitle.Parent = ThemeBox

local ThemeScroll = Instance.new("ScrollingFrame")
ThemeScroll.Size = UDim2.new(1, -12, 1, -38)
ThemeScroll.Position = UDim2.new(0, 6, 0, 32)
ThemeScroll.BackgroundTransparency = 1
ThemeScroll.BorderSizePixel = 0
ThemeScroll.ScrollBarThickness = 3
ThemeScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
ThemeScroll.Parent = ThemeBox

local ThemeListLayout = Instance.new("UIListLayout")
ThemeListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ThemeListLayout.Padding = UDim.new(0, 5)
ThemeListLayout.Parent = ThemeScroll

ThemeListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ThemeScroll.CanvasSize = UDim2.new(0, 0, 0, ThemeListLayout.AbsoluteContentSize.Y)
end)

local ThemeButtons = {}
local function ApplyTheme(Index)
	CurThemeIdx = Index
	local ActiveTheme = Themes[CurThemeIdx]

	SSYWindow.BackgroundColor3 = ActiveTheme.WindowColor
	CommandFrame.BackgroundColor3 = ActiveTheme.WindowColor
	SuggestionFrame.BackgroundColor3 = ActiveTheme.WindowColor

	for _, Btn in ipairs(MenuButtons) do Btn.BackgroundColor3 = ActiveTheme.BtnColor end
	UpdateAutoScanUIStates()

	for I, Btn in ipairs(ThemeButtons) do
		if I == Index then
			Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		else
			Btn.TextColor3 = Color3.fromRGB(170, 170, 180)
			Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		end
	end
end

for I, ThemeData in ipairs(Themes) do
	local TBtn = Instance.new("TextButton")
	TBtn.Size = UDim2.new(1, -4, 0, 28)
	TBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	TBtn.Text = ThemeData.Name
	TBtn.TextColor3 = (I == CurThemeIdx) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 180)
	TBtn.TextSize = 11
	TBtn.Font = Enum.Font.GothamBold
	TBtn.Parent = ThemeScroll

	local TCorner = Instance.new("UICorner") TCorner.CornerRadius = UDim.new(0, 6) TCorner.Parent = TBtn
	table.insert(ThemeButtons, TBtn)
	TBtn.MouseButton1Click:Connect(function() ApplyTheme(I) end)
end

local TransBox = Instance.new("Frame")
TransBox.Size = UDim2.new(0.48, 0, 1, -55)
TransBox.Position = UDim2.new(0.52, 0, 0, 52)
TransBox.BackgroundColor3 = Themes[CurThemeIdx].BtnColor
TransBox.BackgroundTransparency = 0.3
TransBox.Parent = SettingPage
table.insert(MenuButtons, TransBox)

local TransCorner = Instance.new("UICorner") TransCorner.CornerRadius = UDim.new(0, 8) TransCorner.Parent = TransBox

local TransTitle = Instance.new("TextLabel")
TransTitle.Size = UDim2.new(1, 0, 0, 25)
TransTitle.Position = UDim2.new(0, 10, 0, 8)
TransTitle.BackgroundTransparency = 1
TransTitle.Text = "Transparency"
TransTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
TransTitle.TextSize = 13
TransTitle.Font = Enum.Font.GothamBold
TransTitle.TextXAlignment = Enum.TextXAlignment.Left
TransTitle.Parent = TransBox

local TransValLabel = Instance.new("TextLabel")
TransValLabel.Size = UDim2.new(0, 50, 0, 25)
TransValLabel.Position = UDim2.new(1, -60, 0, 8)
TransValLabel.BackgroundTransparency = 1
TransValLabel.Text = "0%"
TransValLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
TransValLabel.TextSize = 12
TransValLabel.Font = Enum.Font.Gotham
TransValLabel.TextXAlignment = Enum.TextXAlignment.Right
TransValLabel.Parent = TransBox

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -20, 0, 6)
SliderTrack.Position = UDim2.new(0, 10, 0, 48)
SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = TransBox

local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(1, 0) TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(1, 0) FillCorner.Parent = SliderFill

local SliderThumb = Instance.new("TextButton")
SliderThumb.Size = UDim2.new(0, 14, 0, 14)
SliderThumb.Position = UDim2.new(0, -7, 0.5, -7)
SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderThumb.Text = ""
SliderThumb.Parent = SliderTrack

local ThumbCorner = Instance.new("UICorner") ThumbCorner.CornerRadius = UDim.new(1, 0) ThumbCorner.Parent = SliderThumb

local Sliding = false
local function UpdateSlider(Input)
	local MousePos = Input.Position.X
	local TrackPos = SliderTrack.AbsolutePosition.X
	local TrackSize = SliderTrack.AbsoluteSize.X

	local RelX = math.clamp((MousePos - TrackPos) / TrackSize, 0, 1)
	CurTrans = RelX * 0.8

	SliderFill.Size = UDim2.new(RelX, 0, 1, 0)
	SliderThumb.Position = UDim2.new(RelX, -7, 0.5, -7)
	TransValLabel.Text = math.floor(RelX * 80) .. "%"

	SSYWindow.BackgroundTransparency = CurTrans
	CommandFrame.BackgroundTransparency = CurTrans
	SuggestionFrame.BackgroundTransparency = CurTrans
end

SliderThumb.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Sliding = true end
end)
SliderTrack.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Sliding = true
		UpdateSlider(Input)
	end
end)
UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Sliding = false end
end)
UserInputService.InputChanged:Connect(function(Input)
	if Sliding and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		UpdateSlider(Input)
	end
end)

local IsNavigating = false
local ActivePage = HomePage

local function SlidePages(FromPage, ToPage, Direction)
	if IsNavigating or FromPage == ToPage then return end
	IsNavigating = true

	local TweenInfoObj = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local ExitPos = (Direction == "left") and UDim2.new(-1, 0, 0, 48) or UDim2.new(1, 0, 0, 48)
	local EnterStartPos = (Direction == "left") and UDim2.new(1, 0, 0, 48) or UDim2.new(-1, 0, 0, 48)

	ToPage.Position = EnterStartPos
	ToPage.Visible = true

	if ToPage ~= HomePage then
		BackBtn.Visible = true
		TweenService:Create(BackBtn, TweenInfoObj, {TextTransparency = 0}):Play()
		TweenService:Create(WindowTitle, TweenInfoObj, {Position = UDim2.new(0, 40, 0, 0)}):Play()
	else
		TweenService:Create(BackBtn, TweenInfoObj, {TextTransparency = 1}):Play()
		TweenService:Create(WindowTitle, TweenInfoObj, {Position = UDim2.new(0, 15, 0, 0)}):Play()
	end

	local TweenOut = TweenService:Create(FromPage, TweenInfoObj, {Position = ExitPos})
	local TweenIn = TweenService:Create(ToPage, TweenInfoObj, {Position = UDim2.new(0, 15, 0, 48)})

	TweenOut:Play()
	TweenIn:Play()

	TweenIn.Completed:Connect(function()
		FromPage.Visible = false
		FromPage.Position = UDim2.new(0, 15, 0, 48)
		if ToPage == HomePage then BackBtn.Visible = false end
		ActivePage = ToPage
		IsNavigating = false
	end)
end

CommandNavBtn.MouseButton1Click:Connect(function() SearchBox.Text = "" PopulateCmdList("") SlidePages(HomePage, CommandPage, "left") end)
ToolsNavBtn.MouseButton1Click:Connect(function() ToolsSearchBox.Text = "" RenderTools("") SlidePages(HomePage, ToolsPage, "left") end)
BanNavBtn.MouseButton1Click:Connect(function() BanSearchBox.Text = "" RenderBans("") SlidePages(HomePage, BanPage, "left") end)
ScannerNavBtn.MouseButton1Click:Connect(function() SlidePages(HomePage, ScannerPage, "left") end)
SettingNavBtn.MouseButton1Click:Connect(function() SlidePages(HomePage, SettingPage, "left") end)

BackBtn.MouseButton1Click:Connect(function() SlidePages(ActivePage, HomePage, "right") end)

local IsMinimized = false
local DefaultSize = UDim2.new(0, 380, 0, 310)

MinimizeBtn.MouseButton1Click:Connect(function()
	IsMinimized = not IsMinimized
	local TweenInfoObj = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	if IsMinimized then
		DefaultSize = SSYWindow.Size
		HomePage.Visible = false CommandPage.Visible = false ScannerPage.Visible = false ToolsPage.Visible = false BanPage.Visible = false SettingPage.Visible = false
		ResizeHandle.Visible = false TopBarDivider.Visible = false

		TweenService:Create(SSYWindow, TweenInfoObj, {Size = UDim2.new(DefaultSize.X.Scale, DefaultSize.X.Offset, 0, 40)}):Play()
	else
		local TweenRestore = TweenService:Create(SSYWindow, TweenInfoObj, {Size = DefaultSize})
		TweenRestore:Play()

		TweenRestore.Completed:Connect(function()
			if not IsMinimized then
				TopBarDivider.Visible = true
				ResizeHandle.Visible = true
				ActivePage.Visible = true
			end
		end)
	end
end)

ToggleWindow = function(Show, OpenToScanner)
	if Show then
		IsMinimized = false
		SSYWindow.AnchorPoint = Vector2.new(0.5, 0.5)
		TopBarDivider.Visible = true
		ResizeHandle.Visible = true

		SSYWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
		SSYWindow.Size = DefaultSize
		SSYWindow.BackgroundTransparency = CurTrans

		HomePage.Visible = not OpenToScanner
		CommandPage.Visible = false ScannerPage.Visible = OpenToScanner ToolsPage.Visible = false BanPage.Visible = false SettingPage.Visible = false

		BackBtn.Visible = OpenToScanner
		BackBtn.TextTransparency = OpenToScanner and 0 or 1
		WindowTitle.Position = OpenToScanner and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 15, 0, 0)
		ActivePage = OpenToScanner and ScannerPage or HomePage

		SSYWindow.Visible = true
	else
		SSYWindow.Visible = false
	end
end

CloseBtn.MouseButton1Click:Connect(function() ToggleWindow(false) end)

local Dragging = false
local DragInput, DragStart, StartPos

TopBarDrag.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true
		DragStart = Input.Position
		StartPos = SSYWindow.Position
		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
		end)
	end
end)

TopBarDrag.InputChanged:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then DragInput = Input end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Input == DragInput and Dragging then
		local Delta = Input.Position - DragStart
		local TargetPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		TweenService:Create(SSYWindow, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPos}):Play()
	end
end)

local Resizing = false
local ResizeStart, StartSize

ResizeHandle.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Resizing = true
		ResizeStart = Input.Position
		StartSize = SSYWindow.AbsoluteSize
		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Resizing = false
				if not IsMinimized then DefaultSize = SSYWindow.Size end
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Resizing and not IsMinimized and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		local Delta = Input.Position - ResizeStart
		local NewWidth = math.clamp(StartSize.X + Delta.X, 320, 600)
		local NewHeight = math.clamp(StartSize.Y + Delta.Y, 250, 500)
		SSYWindow.Size = UDim2.new(0, NewWidth, 0, NewHeight)
	end
end)

local IsAnimating = false
local function AnimateWindow(Show)
	if IsAnimating then return end
	IsAnimating = true

	local TargetPos = UDim2.new(0.5, 0, 1, -120)
	local StartPos = UDim2.new(0.5, 0, 1, -100)
	local TweenInfoObj = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	if Show then
		CommandFrame.Position = StartPos
		CommandFrame.Size = UDim2.new(0, 380, 0, 40)
		CommandFrame.BackgroundTransparency = 1
		CommandFrame.Visible = true

		local TweenPos = TweenService:Create(CommandFrame, TweenInfoObj, {Position = TargetPos, Size = UDim2.new(0, 420, 0, 46), BackgroundTransparency = CurTrans})
		TweenPos:Play()

		task.defer(function()
			CmdTextBox.Text = ""
			CmdTextBox:CaptureFocus()
			UpdateAutoCorrectAndSuggestions()
		end)

		TweenPos.Completed:Connect(function() IsAnimating = false end)
	else
		CmdTextBox:ReleaseFocus()
		SuggestionFrame.Visible = false
		AutoCorrectLabel.Text = ""

		local TweenPos = TweenService:Create(CommandFrame, TweenInfoObj, {Position = StartPos, Size = UDim2.new(0, 380, 0, 40), BackgroundTransparency = 1})
		TweenPos:Play()

		TweenPos.Completed:Connect(function()
			CommandFrame.Visible = false
			IsAnimating = false
		end)
	end
end

local function IsMouseOverGui(GuiObject)
	if not GuiObject or not GuiObject.Visible then return false end
	local MousePos = UserInputService:GetMouseLocation() - Vector2.new(0, 36)
	local Pos = GuiObject.AbsolutePosition
	local Size = GuiObject.AbsoluteSize
	return MousePos.X >= Pos.X and MousePos.X <= Pos.X + Size.X and MousePos.Y >= Pos.Y and MousePos.Y <= Pos.Y + Size.Y
end

UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		if CommandFrame.Visible then
			task.defer(function()
				if not IsMouseOverGui(CommandFrame) and not IsMouseOverGui(SuggestionFrame) then
					AnimateWindow(false)
				end
			end)
		end
	end
end)

UserInputService.InputBegan:Connect(function(Input)
	if CmdTextBox:IsFocused() and Input.KeyCode == Enum.KeyCode.Tab then
		if CurrentMatchedCommand ~= "" then
			local RawText = CmdTextBox.Text
			local HasSemicolon = RawText:sub(1, 1) == ";"
			local QueryText = HasSemicolon and RawText:sub(2) or RawText
			local ArgsStr = QueryText:match("^%S+(.*)") or ""

			CmdTextBox.Text = (HasSemicolon and ";" or "") .. CurrentMatchedCommand .. ArgsStr
			CmdTextBox.CursorPosition = #CmdTextBox.Text + 1
			UpdateAutoCorrectAndSuggestions()
		end
	end
end)

CmdTextBox.FocusLost:Connect(function(EnterPressed)
	if EnterPressed then
		local FullText = CmdTextBox.Text:match("^%s*(.-)%s*$") or ""
		if FullText ~= "" then
			if FullText:sub(1, 1) == ";" then FullText = FullText:sub(2):match("^%s*(.-)%s*$") or "" end

			local Parts = {}
			for Word in FullText:gmatch("%S+") do table.insert(Parts, Word) end

			local CmdName = Parts[1] and Parts[1]:lower() or ""
			table.remove(Parts, 1)

			if CmdName == "cmds" or CmdName == "commands" then
				ToggleWindow(true, false)
				ShowNotification("Execute Command", 2)
			elseif CommandsMap[CmdName] then
				pcall(function() CommandsMap[CmdName].Function(Parts) end)
			else
				ShowNotification("Execute Command", 2)
			end
		end
		CmdTextBox.Text = ""
		AutoCorrectLabel.Text = ""
		AnimateWindow(false)
	end
end)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed or UserInputService:GetFocusedTextBox() then return end
	if Input.KeyCode == Enum.KeyCode.Semicolon then
		task.defer(function()
			if not CommandFrame.Visible then AnimateWindow(true) else CmdTextBox:CaptureFocus() end
		end)
	end
end)

local function SetupButtonEvents(ButtonFrame, TextButton)
	local TweenInfoObj = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	TextButton.MouseEnter:Connect(function() TweenService:Create(ButtonFrame, TweenInfoObj, {BackgroundColor3 = ColorHover}):Play() end)
	TextButton.MouseLeave:Connect(function() TweenService:Create(ButtonFrame, TweenInfoObj, {BackgroundColor3 = ColorBase}):Play() end)
	TextButton.MouseButton1Down:Connect(function() TweenService:Create(ButtonFrame, TweenInfoObj, {BackgroundColor3 = ColorClick}):Play() end)
	TextButton.MouseButton1Up:Connect(function()
		TweenService:Create(ButtonFrame, TweenInfoObj, {BackgroundColor3 = ColorHover}):Play()
		if CommandFrame.Visible then AnimateWindow(false) else AnimateWindow(true) end
	end)
end

local function CreateCoreGui()
	local ScreenGui = Instance.new("ScreenGui", CoreGui)
	local Frame1 = Instance.new("Frame", ScreenGui)
	local Frame2 = Instance.new("Frame", Frame1)
	local TextButton = Instance.new("TextButton", Frame2)
	local UICorner = Instance.new("UICorner", Frame2)

	ScreenGui.DisplayOrder = 6
	ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets

	Frame1.Size = UDim2.new(1, 0, 0, 48)
	Frame1.Position = UDim2.new(0, 0, 0, 10)
	Frame1.BackgroundTransparency = 1

	Frame2.AnchorPoint = Vector2.new(0, 0.5)
	Frame2.Position = UDim2.new(0, 8, 0.5, 0)
	Frame2.Size = UDim2.new(0, 80, 0, 44)
	Frame2.BackgroundColor3 = ColorBase
	Frame2.BackgroundTransparency = 0.08 * GuiService.PreferredTransparency

	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.TextSize = 16
	TextButton.Font = Enum.Font.GothamBold
	TextButton.Text = "SSY"

	UICorner.CornerRadius = UDim.new(1, 0)

	GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		Frame2.BackgroundTransparency = 0.08 * GuiService.PreferredTransparency
	end)

	SetupButtonEvents(Frame2, TextButton)
	MainButton = ScreenGui
end

local function CreatePlayerGui()
	local TopbarLeft = LocalPlayer.PlayerGui.TopbarStandard.Holders.Left
	local Frame = Instance.new("Frame", TopbarLeft)
	local UICorner = Instance.new("UICorner", Frame)
	local TextButton = Instance.new("TextButton", Frame)

	Frame.LayoutOrder = -math.huge
	Frame.Size = UDim2.new(0, 80, 0, 44)
	Frame.BackgroundColor3 = ColorBase
	Frame.BackgroundTransparency = 0.08

	UICorner.CornerRadius = UDim.new(1, 0)

	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 16
	TextButton.Text = "SSY"

	SetupButtonEvents(Frame, TextButton)
	MainButton = Frame
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if PlayerGui and PlayerGui:FindFirstChild("TopbarStandard") then
	CreatePlayerGui()
else
	CreateCoreGui()
end

PopulateCmdList("")

task.defer(function()
	UpdateAutoScanUIStates()
	local ScanStatusStr = AutoScanEnabled and "Auto Scan: ON" or "Auto Scan: OFF"
	ShowNotification("Welcome to SSY! / " .. ScanStatusStr, 5)
	if AutoScanEnabled then
		ToggleWindow(true, false)
		task.spawn(StartScanProcess)
	end
end)
