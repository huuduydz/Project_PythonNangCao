
if getgenv().DuyHubMsMother_Running then return end
getgenv().DuyHubMsMother_Running = true

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end
task.wait(1) -- Trễ thêm 1 nhịp để các Service của game load hoàn tất

local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait(0.1) end
local lplr = Players.LocalPlayer

-- =========================================================================
-- KHAI BÁO BIẾN
-- =========================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local workspace = game.Workspace

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local getReq = isMobile and ((fluxus and fluxus.request) or (http and http.request) or request or http_request) or ((syn and syn.request) or request or http_request or (http and http.request))
local lplr = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- =========================================================================
-- LOGIC LƯU HOP
-- =========================================================================
local safeName = tostring(lplr.Name)
local HopFileName = "DuyHub_HopArray_" .. safeName .. ".json"
local HopFlagName = "DuyHub_IsHopping_" .. safeName .. ".txt"
local T = {}

local function LoadHop()
    pcall(function()
        if isfile and readfile and isfile(HopFileName) then
            local decoded = HttpService:JSONDecode(readfile(HopFileName))
            if type(decoded) == "table" then
                local temp = {}
                for _, v in pairs(decoded) do table.insert(temp, 1) end
                T = temp
            end
        end
    end)
end

local function SaveHop()
    pcall(function() if writefile then writefile(HopFileName, HttpService:JSONEncode(T)) end end)
end

LoadHop()

pcall(function()
    if isfile and readfile and writefile and isfile(HopFlagName) then
        if readfile(HopFlagName) == "true" then
            table.insert(T, 1)
            SaveHop()
            writefile(HopFlagName, "false") 
        end
    end
end)

local currentHop = #T

local Settings = { AutoMsMother = true, DistanceStud = 9, Buso = true, Ken = true, HopCount = currentHop, WebhookStarted = false, IsFightingBoss = false }
local UserWebhook = "https://discord.com/api/webhooks/1467875798831730913/zsa2TrwzhGh_wvRfZTF_Zhm85kJago6fZU0IEFZNxS2U1pHW203sAHVVFDPcRE_RSHH3"
local ActiveSkills = {"Z", "X", "C", "V"}

pcall(function()
    local globalEnv = type(_G) == "table" and _G or {}
    if globalEnv.auto_ms_mother ~= nil then Settings.AutoMsMother = globalEnv.auto_ms_mother end
    if type(globalEnv.distance_stud) == "number" then Settings.DistanceStud = globalEnv.distance_stud end
    if globalEnv.buso ~= nil then Settings.Buso = globalEnv.buso end
    if globalEnv.ken ~= nil then Settings.Ken = globalEnv.ken end
    if type(globalEnv.webhook_url) == "string" then UserWebhook = globalEnv.webhook_url end
    if type(globalEnv.skill) == "table" then ActiveSkills = globalEnv.skill end
end)

coroutine.wrap(function()
    lplr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)()

if not game:IsLoaded() then game.Loaded:Wait() end

-- =========================================================================
-- GIAO DIỆN GUI
-- =========================================================================
local UIStatusLabel = nil
local UIServerLabel = nil

local function BuildGUI()
    local guiName = "HuDy Hub"
    local parentGui = (gethui and gethui()) or CoreGui or lplr:WaitForChild("PlayerGui")
    if parentGui:FindFirstChild(guiName) then
        parentGui[guiName]:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = guiName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parentGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 190, 0, 0) 
    MainFrame.AutomaticSize = Enum.AutomaticSize.Y 
    MainFrame.Position = UDim2.new(0, 10, 0, 50) 
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    MainFrame.BackgroundTransparency = 0.25
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(167, 139, 250)
    UIStroke.Thickness = 1.2
    UIStroke.Transparency = 0.2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = MainFrame

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10) 
    UIPadding.PaddingLeft = UDim.new(0, 12)
    UIPadding.PaddingRight = UDim.new(0, 12)
    UIPadding.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8) 
    UIListLayout.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 16) 
    Title.BackgroundTransparency = 1
    Title.Text = "HuDy Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14 
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.LayoutOrder = 1
    Title.Parent = MainFrame

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(221, 214, 254)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 139, 250))
    }
    TitleGradient.Parent = Title

    local LineContainer = Instance.new("Frame")
    LineContainer.Size = UDim2.new(1, 0, 0, 4)
    LineContainer.BackgroundTransparency = 1
    LineContainer.LayoutOrder = 2
    LineContainer.Parent = MainFrame

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BorderSizePixel = 0
    Line.Parent = LineContainer

    local LineGradient = Instance.new("UIGradient")
    LineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 189, 248))
    }
    LineGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    LineGradient.Parent = Line

    local function CreateLabel(order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14) 
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.GothamBold 
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255) 
        lbl.RichText = true
        lbl.LayoutOrder = order
        lbl.Parent = MainFrame
        return lbl
    end

    UIServerLabel = CreateLabel(3)
    UIServerLabel.Text = "<font color='#d8b4fe'></font> <font color='#ffffff'>Loading...</font>"

    local HopLabel = CreateLabel(4)
    HopLabel.Text = "<font color='#d8b4fe'> Lan Hop:</font> <font color='#ffffff'>" .. tostring(Settings.HopCount) .. "</font>"
    
    UIStatusLabel = CreateLabel(5)
    UIStatusLabel.Text = "<font color='#4ade80'> Khoi dong...</font>"

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 24) 
    ToggleBtn.BackgroundTransparency = 0.85
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(74, 222, 128) 
    ToggleBtn.Text = "ON"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 11
    ToggleBtn.LayoutOrder = 6 
    ToggleBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = ToggleBtn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(74, 222, 128)
    BtnStroke.Thickness = 1.2
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnStroke.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        Settings.AutoMsMother = not Settings.AutoMsMother
        if Settings.AutoMsMother then
            ToggleBtn.Text = "ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
            BtnStroke.Color = Color3.fromRGB(74, 222, 128)
            if UIStatusLabel then UIStatusLabel.Text = "<font color='#4ade80'> Tiep tuc...</font>" end
        else
            ToggleBtn.Text = "OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(248, 113, 113) 
            BtnStroke.Color = Color3.fromRGB(248, 113, 113)
            if UIStatusLabel then UIStatusLabel.Text = "<font color='#f87171'> Tam dung</font>" end
            
            pcall(function()
                local char = lplr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if char.HumanoidRootPart:FindFirstChild("FreezePos") then char.HumanoidRootPart.FreezePos:Destroy() end
                    if char.HumanoidRootPart:FindFirstChild("FreezeRot") then char.HumanoidRootPart.FreezeRot:Destroy() end
                    if char:FindFirstChild("Humanoid") then char.Humanoid.AutoRotate = true end
                end
            end)
        end
    end)
end

pcall(function() BuildGUI() end)

local function UpdateStatusUI(msg, customServerName)
    pcall(function()
        if UIStatusLabel then
            if Settings.AutoMsMother then
                UIStatusLabel.Text = "<font color='#4ade80'> " .. msg .. "</font>"
            else
                UIStatusLabel.Text = "<font color='#f87171'> " .. msg .. "</font>"
            end
        end
        if UIServerLabel and customServerName then
            UIServerLabel.Text = "<font color='#d8b4fe'></font> <font color='#ffffff'>" .. customServerName .. "</font>"
        end
    end)
end

-- =========================================================================
-- WEBHOOK
-- =========================================================================
function _G.webhook2(webhook, embedData)
    local MY_API = "https://duyhub-api.tanthuy068.workers.dev" 
    local req = getReq
    if req then
        pcall(function()
            req({
                Url = MY_API,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({ webhook = webhook, embed = embedData })
            })
        end)
    else
        local safeData = HttpService:UrlEncode(HttpService:JSONEncode(embedData))
        pcall(function()
            local result = game:HttpGet(MY_API .. "/api/?type=2&webhook="..webhook.."&embed="..safeData)
            if result and result ~= "" then loadstring(result)() end
        end)
    end
end

local function sendWebhook(statusMsg)
    coroutine.wrap(function()
        local tearCount = 0
        pcall(function()
            if lplr:FindFirstChild("PlayerStats") and lplr.PlayerStats:FindFirstChild("Material") then
                local val = lplr.PlayerStats.Material.Value
                local data = {}
                if type(val) == "string" and val ~= "" then
                    pcall(function() data = HttpService:JSONDecode(val) end)
                end
                tearCount = data["Phoenix's Tear"] or data["Phoenix Tear"] or 0
            end
        end)

        local cb = string.rep(string.char(96), 3) 
        
        local myEmbed = {
            ["title"] = "Thong bao",
            ["color"] = 0xFFC0CB,
            ["fields"] = {
                { ["name"] = "Player", ["value"] = cb .. lplr.Name .. cb, ["inline"] = false },
                { ["name"] = "Drops", ["value"] = cb .. "Phoenix's Tear : " .. tearCount .. cb, ["inline"] = true },
                { ["name"] = "Trang Thai", ["value"] = cb .. statusMsg .. cb, ["inline"] = true },
                { ["name"] = "So lan Hop", ["value"] = cb .. Settings.HopCount .. cb, ["inline"] = true }
            },
            ["footer"] = { ["text"] = "HuDy Hub • " .. os.date("%H:%M:%S") }
        }
        _G.webhook2("game", myEmbed)

        if UserWebhook and UserWebhook ~= "" then
            local req = getReq
            if req then
                pcall(function()
                    req({
                        Url = UserWebhook,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = HttpService:JSONEncode({["embeds"] = {myEmbed}})
                    })
                end)
            end
        end
    end)()
end

-- =========================================================================
-- TÌM SERVER SIÊU TỐC
-- =========================================================================
local visitedServers = {} 
local CYCLE_TIME = 7200 
local currentServerOsTime = nil

local function getValidServersList()
    local ok, srvs = pcall(function() return ReplicatedStorage.Chest.Remotes.Functions.GetServers:InvokeServer() end)
    if not ok or type(srvs) ~= "table" then return {} end

    local potentialServers = {}
    for _, srv in pairs(srvs) do
        if type(srv)=="table" and srv.ServerOsTime and srv.JobId and srv.GetPlayers and srv.PlaceId == game.PlaceId and srv.JobId ~= game.JobId and not visitedServers[srv.JobId] and srv.GetPlayers > 0 and srv.GetPlayers < 13 then
            local uptime = os.time() - srv.ServerOsTime
            local currentCycle = uptime % CYCLE_TIME
            
            if uptime > 600 then
                local priority = nil
                if currentCycle >= 7190 or currentCycle <= 30 then
                    priority = 1
                elseif currentCycle >= 7170 and currentCycle < 7190 then
                    priority = 2
		elseif currentCycle >= 7140 and currentCycle < 7160 then
                    priority = 3
                elseif currentCycle >= 7080 or currentCycle <= 90 then
                    priority = 4
                end
                
                if priority then
                    srv.Priority = priority
                    srv.Score = srv.GetPlayers
                    table.insert(potentialServers, srv)
                end
            end
        end
    end
    
    table.sort(potentialServers, function(a, b) 
        if a.Priority == b.Priority then return a.Score < b.Score 
        else return a.Priority < b.Priority end
    end)
    return potentialServers
end

local isHoppingFinal = false
local function FinalHop()
    if isHoppingFinal then return end
    isHoppingFinal = true
    
    coroutine.wrap(function()
        local scanStartTime = os.clock() 
        
        -- Chốt lưu cờ Hop 1 lần duy nhất trên cùng
        pcall(function() writefile(HopFlagName, "true") end)
        
        while task.wait() do 
            -- [[ BỘ CHỐT CHẶN (KILL SWITCH) ]]
            -- Nếu Main Loop đã phát hiện Boss và tắt cờ, Lập tức phá vỡ vòng lặp Spam Teleport
            if not isHoppingFinal then 
                pcall(function() writefile(HopFlagName, "false") end)
                break 
            end

            -- ĐƯA BỘ ĐẾM THỜI GIAN LÊN ƯU TIÊN KIỂM TRA ĐẦU TIÊN
            local elapsed = os.clock() - scanStartTime
            
            if elapsed >= 60 then
                -- ==============================================
                -- QUÁ 60 GIÂY KHÔNG VÀO ĐƯỢC -> ÉP BUỘC HOP ĐẠI
                -- ==============================================
                UpdateStatusUI("Qua 1p khong vao duoc, Hop Dai...")
                
                local ok, allSrvs = pcall(function() return ReplicatedStorage.Chest.Remotes.Functions.GetServers:InvokeServer() end)
                
                if ok and type(allSrvs) == "table" then
                    local randomServers = {}
                    
                    for _, srv in pairs(allSrvs) do
                        if type(srv) == "table" and srv.JobId and srv.JobId ~= game.JobId and srv.GetPlayers and srv.GetPlayers < 13 then
                            table.insert(randomServers, srv)
                        end
                    end
                    
                    if #randomServers > 0 then
                        local fallbackSrv = randomServers[math.random(1, #randomServers)]
                        local fallbackName = fallbackSrv.Name or ("#" .. string.sub(fallbackSrv.JobId, 1, 5))
                        
                        UpdateStatusUI("Hop Dai toi: " .. fallbackName)
                        
                        -- Chỉ bay nếu cờ Hop vẫn còn bật
                        if isHoppingFinal then
                            pcall(function() 
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, fallbackSrv.JobId, lplr) 
                            end)
                        end
                        
                        task.wait(0.05) -- Đợi game dịch chuyển tránh kẹt
                    else
                        -- Đen đủi nhất: All server full -> Reset đồng hồ và làm lại
                        scanStartTime = os.clock() 
                    end
                end
                
            else
                -- ==============================================
                -- VẪN TRONG 60 GIÂY -> CÀN QUÉT MAX TỐC ĐỘ 
                -- ==============================================
                local srvList = getValidServersList()
                
                if #srvList > 0 then
                    -- XẢ ĐẠN VÀO TẤT CẢ SERVER NGON TÌM THẤY (Không sổ đen)
                    for i = 1, #srvList do
                        if not isHoppingFinal then break end -- Kích hoạt chốt chặn ở bên trong vòng lặp nhả đạn
                        
                        local srv = srvList[i]
                        local nextSrvName = srv.Name or ("#" .. string.sub(srv.JobId, 1, 3))
                        UpdateStatusUI("Spam Max Speed: " .. nextSrvName)
                        
                        -- Buff lệnh/frame cho 1 server
                        for _ = 1, 5 do
                            task.spawn(function()
                                pcall(function() 
                                    if isHoppingFinal then -- Kiểm tra lần cuối trước khi bấm nút Teleport
                                        TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.JobId, lplr) 
                                    end
                                end)
                            end)
                        end
                    end
                else
                    -- Không có server ngon -> UI đếm ngược
                    local timeLeft = math.floor(60 - elapsed)
                    UpdateStatusUI("Tim Server (" .. timeLeft .. "s)...")
                    task.wait(0.05) 
                end
            end
        end
    end)()
end

-- =========================================================================
-- CƠ CHẾ CLICK NHẸ NHÀNG (DÀNH RIÊNG CHO NÚT PLAY ĐỂ KHÔNG MẤT LOGO)
-- =========================================================================
local function GentleUIPlayClick(btn)
    if not btn or typeof(btn) ~= "Instance" or not btn:IsA("GuiObject") then return end
    pcall(function()
        btn.Selectable = true
        if btn:IsDescendantOf(game) and btn.Visible then
            -- Chỉ dùng điều hướng UI thuần túy, KHÔNG bắn signal để tránh lỗi animation
            GuiService.SelectedObject = btn
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.5)
            GuiService.SelectedObject = nil
        end
    end)
end
-- =========================================================================
-- CHỜ VÀ BẤM NÚT PLAY TỰ ĐỘNG THEO CHUẨN (KHÔNG BYPASS LOADING)
-- =========================================================================
local function isFullyLoaded()
    local stats = lplr:FindFirstChild("PlayerStats")
    return stats and stats:FindFirstChild("beli") and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
end

if not isFullyLoaded() then
    local timeoutLoad = 0
    while not isFullyLoaded() and timeoutLoad < 60 do
        timeoutLoad = timeoutLoad + 1
        UpdateStatusUI("Cho vao game ("..timeoutLoad.."/60)")
        
        pcall(function()
            local pgui = lplr:FindFirstChild("PlayerGui")
            if pgui and pgui:FindFirstChild("LoadingGUI") then
                local playBtn = pgui.LoadingGUI:FindFirstChild("Play")
                -- Chỉ tiếp tục khi Nút Play đã hiện rõ ràng trên màn hình
                if playBtn and playBtn:IsA("GuiObject") and playBtn.Visible and playBtn.AbsolutePosition.Y > 0 then
                    
                    -- Đợi thêm 3 giây để Logo Animation và dữ liệu Server Load xong hoàn toàn
                    if not playBtn:GetAttribute("SafeToClick") then
                        local waitTick = playBtn:GetAttribute("WaitTick") or 0
                        waitTick = waitTick + 1
                        playBtn:SetAttribute("WaitTick", waitTick)
                        
                        UpdateStatusUI("Cho Animation Logo ("..waitTick.."/3s)...")
                        
                        if waitTick >= 3 then
                            playBtn:SetAttribute("SafeToClick", true)
                        end
                    else
                        UpdateStatusUI("Auto Click Play...")
                        -- Dùng hàm Click mềm để nút Play hoạt động trơn tru
                        GentleUIPlayClick(playBtn)
                    end
                end
            end
        end)
        
        task.wait(1)
    end
    if timeoutLoad >= 60 and not isFullyLoaded() then FinalHop(); return end
end
UpdateStatusUI("San sang!")
if not Settings.WebhookStarted then Settings.WebhookStarted = true; sendWebhook("🟢 Script bat dau hoat dong!") end

-- =========================================================================
-- BỌC THÉP: XỬ LÝ BẢNG LỖI, LƯU VẾT & AUTO RECONNECT CHỐNG KẸT
-- =========================================================================
local isRejoining = false
local function ForceRejoinGame()
    if isRejoining then return end
    isRejoining = true
    
    pcall(function() GuiService:ClearError() end)
    UpdateStatusUI("Mat ket noi! Tu dong Reconnect...")
    
    task.spawn(function()
        -- ƯU TIÊN 1: QUAY VỀ SERVER TRƯỚC ĐÓ (DÙNG FILE LƯU VẾT)
        local prevJobId = nil
        pcall(function()
            if isfile and readfile and isfile(PrevServerFileName) then
                prevJobId = readfile(PrevServerFileName)
            end
        end)
        
        if prevJobId and prevJobId ~= "" and prevJobId ~= game.JobId then
            UpdateStatusUI("Quay ve server cu truoc do...")
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, prevJobId, Players.LocalPlayer) end)
            task.wait(4)
        end

        -- ƯU TIÊN 2: CÀO API CỦA ROBLOX ĐỂ TÌM SERVER KHÁC (NẾU SERVER CŨ CŨNG SẬP NỐT)
        local req = getReq
        if req then
            pcall(function()
                local response = req({
                    Url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100",
                    Method = "GET"
                })
                if response and response.Body then
                    local data = HttpService:JSONDecode(response.Body)
                    if data and data.data then
                        local srvs = {}
                        for _, s in pairs(data.data) do
                            if type(s) == "table" and s.id and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 and s.id ~= game.JobId and s.id ~= prevJobId then
                                table.insert(srvs, s.id)
                            end
                        end
                        if #srvs > 0 then
                            local rId = srvs[math.random(1, #srvs)]
                            UpdateStatusUI("Reconnect vao Server ngau nhien...")
                            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, rId, Players.LocalPlayer) end)
                        end
                    end
                end
            end)
        end
    end)
    
    -- DỰ PHÒNG: Nháy lệnh Teleport thường liên tục mỗi 3s để ép vọt qua màn hình
    coroutine.wrap(function()
        task.wait(5)
        while task.wait(3) do
            pcall(function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
        end
    end)()
end

GuiService.ErrorMessageChanged:Connect(function(errMsg)
    if not errMsg or errMsg == "" then return end
    local errorString = string.lower(errMsg)
    
    -- Xử lý lỗi 771, 773 (Lỗi Teleport do server mục tiêu sập/đầy)
    if string.find(errorString, "771") or string.find(errorString, "773") or string.find(errorString, "no longer available") or string.find(errorString, "teleport") then
        UpdateStatusUI("Loi Teleport (771)! Bo qua va tim sv khac...")
        task.wait(1)
        pcall(function() GuiService:ClearError() end)
        if CurrentTargetJobId then 
            sessionIgnoredServers[CurrentTargetJobId] = true 
            CurrentTargetJobId = nil 
        end
        return
    end
    
    -- Xử lý lỗi 288, 277, 268 (Văng game hoàn toàn / Server hiện tại sập)
    if string.find(errorString, "disconnect") or string.find(errorString, "277") or string.find(errorString, "268") or string.find(errorString, "288") or string.find(errorString, "kick") or string.find(errorString, "unexpected") or string.find(errorString, "shut down") then
        ForceRejoinGame()
    end
end)

-- Vòng lặp quét thẳng vào giao diện báo lỗi của Roblox (Bọc thép vòng 2)
coroutine.wrap(function()
    while task.wait(2) do
        pcall(function()
            local prompt = CoreGui:FindFirstChild("RobloxPromptGui") and CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
            if prompt and prompt:FindFirstChild("ErrorPrompt") and prompt.ErrorPrompt.Visible then
                local errText = ""
                pcall(function() errText = string.lower(prompt.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text) end)
                
                -- NẾU LÀ LỖI TELEPORT THÌ XÓA BẢNG VÀ TÌM TIẾP
                if string.find(errText, "771") or string.find(errText, "teleport") or string.find(errText, "773") or string.find(errText, "no longer available") then
                    pcall(function() GuiService:ClearError() end)
                    if CurrentTargetJobId then 
                        sessionIgnoredServers[CurrentTargetJobId] = true 
                        CurrentTargetJobId = nil 
                    end
                
                -- NẾU LÀ LỖI DISCONNECT THÌ ÉP REJOIN
                elseif string.find(errText, "288") or string.find(errText, "shut down") or string.find(errText, "277") or string.find(errText, "268") or string.find(errText, "kick") or string.find(errText, "disconnect") then
                    ForceRejoinGame()
                end
            end
        end)
    end
end)()
-- =========================================================================
-- ĐỒNG BỘ THỜI GIAN SERVER CHUẨN XÁC
-- =========================================================================
coroutine.wrap(function()
    pcall(function()
        local ok, srvs = pcall(function() return ReplicatedStorage.Chest.Remotes.Functions.GetServers:InvokeServer() end)
        if ok and type(srvs) == "table" then
            for _, srv in pairs(srvs) do
                if srv.JobId == game.JobId then
                    currentServerOsTime = srv.ServerOsTime
                    break
                end
            end
        end
    end)
end)()

coroutine.wrap(function()
    local chest = ReplicatedStorage:WaitForChild("Chest", 10)
    while task.wait(2) do 
        pcall(function()
            local playerScripts = lplr:FindFirstChild("PlayerScripts")
            if playerScripts and playerScripts:FindFirstChild("Services") then
                local effectClient = playerScripts.Services:FindFirstChild("EffectClient")
                if effectClient then
                    for _, obj in ipairs(effectClient:GetDescendants()) do
                        if obj:IsA("LocalScript") then obj.Disabled = true end
                    end
                end
            end
        end)
        if Settings.AutoMsMother and chest then
            pcall(function()
                if chest:FindFirstChild("FruitEffect") then chest.FruitEffect:ClearAllChildren() end
                if chest:FindFirstChild("SwordEffect") then chest.SwordEffect:ClearAllChildren() end
                if chest:FindFirstChild("DamageIndicator") then chest.DamageIndicator:ClearAllChildren() end
                if chest:FindFirstChild("MonsterEffect") then chest.MonsterEffect:ClearAllChildren() end
            end)
        end
    end
end)()



-- TÌM VÀ ĐÁNH BOSS
local function getMsMotherRoot()
    local msMother = workspace:FindFirstChild("Monster") and workspace:FindFirstChild("Monster"):FindFirstChild("Boss") and workspace.Monster.Boss:FindFirstChild("Ms. Mother [Lv. 7500]")
    if msMother and msMother:FindFirstChild("Humanoid") and msMother.Humanoid.Health > 0 and msMother:FindFirstChild("HumanoidRootPart") then return msMother.HumanoidRootPart end
    return nil
end

local function getAllValidWeapons()
    local validTools = {}
    local char = lplr.Character
    if char then
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped and not equipped.Name:match("Compass") and not equipped.Name:match("Map") then table.insert(validTools, equipped) end
    end
    for _, t in pairs(lplr.Backpack:GetChildren()) do
        if t:IsA("Tool") and not t.Name:match("Compass") and not t.Name:match("Map") then table.insert(validTools, t) end
    end
    return validTools
end

coroutine.wrap(function()
    while task.wait(1) do
        if Settings.AutoMsMother then
            pcall(function()
                local bossRoot = getMsMotherRoot()
                if bossRoot and bossRoot.Size.X < 15 then
                    bossRoot.Size = Vector3.new(15, 15, 15)
                    bossRoot.Transparency = 0.7 
                    bossRoot.CanCollide = false 
                end
            end)
        end
    end
end)()

local skillAction = ReplicatedStorage:WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction")

-- =========================================================================
-- [[ FIX 9: GIẢ LẬP MÁY TÍNH SPAM PHÍM CHUẨN XÁC ]]
-- =========================================================================
coroutine.wrap(function()
    while true do
        task.wait(0.05) -- Tốc độ vòng lặp siêu tốc
        if Settings.AutoMsMother and Settings.IsFightingBoss then
            pcall(function()
                local target = getMsMotherRoot()
                if target then
                    local allWeapons = getAllValidWeapons()
                    for _, weapon in ipairs(allWeapons) do
                        if not Settings.IsFightingBoss or not getMsMotherRoot() then break end
                        
                        local char = lplr.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid:EquipTool(weapon)
                            task.wait(0.05) 
                        end
                        
                        local aimCFrame = target.CFrame
                        
                        -- SPAM M1 (Kéo lùi thời gian đè chuột để giống PC)
                        coroutine.wrap(function()
                            if skillAction:IsA("RemoteFunction") then
                                pcall(function() skillAction:InvokeServer("SW_" .. weapon.Name .. "_M1", {["MouseHit"] = aimCFrame, ["Type"] = "Click"}) end)
                                pcall(function() skillAction:InvokeServer("DF_" .. weapon.Name .. "_M1", {["MouseHit"] = aimCFrame, ["Type"] = "Click"}) end)
                            end
                            VirtualInputManager:SendMouseButtonEvent(150, 150, 0, true, game, 1)
                            task.wait(0.02)
                            VirtualInputManager:SendMouseButtonEvent(150, 150, 0, false, game, 1)
                        end)()
                        
                        -- SPAM SKILL KIỂU CUỘN PHÍM PIANO (PC SIMULATOR)
                        for _, keyString in ipairs(ActiveSkills) do
                            coroutine.wrap(function()
                                local argsSW = {"SW_" .. weapon.Name .. "_" .. keyString, {["MouseHit"] = aimCFrame, ["Type"] = "Down"}}
                                local argsDF = {"DF_" .. weapon.Name .. "_" .. keyString, {["MouseHit"] = aimCFrame, ["Type"] = "Down"}}
                                
                                -- Gửi lệnh Server
                                pcall(function() skillAction:InvokeServer(unpack(argsSW)) end)
                                pcall(function() skillAction:InvokeServer(unpack(argsDF)) end)
                                
                                -- Bấm phím vật lý giả lập
                                local keyCode = Enum.KeyCode[keyString]
                                if keyCode then
                                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                                    task.wait(math.random(1, 3) / 100) -- Trễ tí xíu như ngón tay đè phím cơ
                                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                                end
                                
                                task.wait(math.random(2, 5) / 100)
                                
                                -- Nhả lệnh Server
                                argsSW[2].Type = "Up"
                                argsDF[2].Type = "Up"
                                pcall(function() skillAction:InvokeServer(unpack(argsSW)) end)
                                pcall(function() skillAction:InvokeServer(unpack(argsDF)) end)
                            end)()
                            task.wait(math.random(2, 5) / 100) -- Cuộn phím liên tục
                        end
                    end
                end
            end)
        end
    end
end)()

coroutine.wrap(function()
    while task.wait(1) do
        if Settings.AutoMsMother then
            if Settings.Buso then
                pcall(function()
                    local cw = game.Workspace:FindFirstChild("CharacterWorkshop")
                    if cw and not cw:FindFirstChild(lplr.Name.."ArmamentGroup") then 
                        game:GetService("ReplicatedStorage").Chest.Remotes.Events.Armament:FireServer()
                    end
                end)
            end
            if Settings.Ken then
                pcall(function()
                    local pcChars = game.Workspace:FindFirstChild("PlayerCharacters")
                    if pcChars and pcChars:FindFirstChild(lplr.Name) then
                        local services = pcChars[lplr.Name]:FindFirstChild("Services")
                        if services and services:FindFirstChild("KenOpen") and services.KenOpen.Value == false then
                            game:GetService("ReplicatedStorage").Chest.Remotes.Functions.KenEvent:InvokeServer()
                        end
                    end
                end)
            end
        end
    end
end)()

local lastBossCFrame = nil
local checkBossTimer = 0
local mapLoadTimer = 0
local lootedChests = {}
local flyAngle = 0 

coroutine.wrap(function()
    while task.wait(0.1) do
        if Settings.AutoMsMother then
            
            -- LIÊN KẾT LUỒNG CHÍNH VỚI LUỒNG HOP: NẾU THẤY BOSS -> TẮT CỜ HOP!
            if isHoppingFinal and getMsMotherRoot() then
                isHoppingFinal = false
                pcall(function() writefile(HopFlagName, "false") end)
            end
            
            if not isHoppingFinal then
                pcall(function()
                    local char = lplr.Character
                    local isAlive = char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart")
                    if not isAlive then
                        if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("FreezePos") then char.HumanoidRootPart.FreezePos:Destroy() end
                        return 
                    end
                    local root = char.HumanoidRootPart
                    local wIsland = workspace:FindFirstChild("Island")
                    local targetChestCFrame = nil
                    local chestId = nil

                    for id, timeLooted in pairs(lootedChests) do
                        if os.clock() - timeLooted > 10 then lootedChests[id] = nil end
                    end

                    if wIsland then
                        for _, n in ipairs({"Sea King Thunder", "Sea King Water", "Sea King Lava"}) do
                            local isl = wIsland:FindFirstChild(n)
                            if isl and isl:FindFirstChild("HydraStand") then
                                for _, obj in ipairs(isl:GetChildren()) do
                                    if obj:IsA("Model") and obj.Name:match("Chest$") then
                                        local id = "Hydra_" .. n
                                        if not lootedChests[id] then
                                            targetChestCFrame = isl.HydraStand.CFrame
                                            chestId = id; break
                                        end
                                    end
                                end
                            end
                            if targetChestCFrame then break end
                        end

                        if not targetChestCFrame then
                            for _, n in ipairs({"Legacy Island1", "Legacy Island2", "Legacy Island3", "Legacy Island4"}) do
                                local isl = wIsland:FindFirstChild(n)
                                if isl and isl:FindFirstChild("ChestSpawner") then
                                    for _, obj in ipairs(isl.ChestSpawner:GetChildren()) do
                                        if obj:IsA("Model") and obj.Name:match("Chest$") then
                                            local id = "SK_" .. n
                                            if not lootedChests[id] then
                                                targetChestCFrame = isl.ChestSpawner.CFrame
                                                chestId = id; break
                                            end
                                        end
                                    end
                                end
                                if targetChestCFrame then break end
                            end
                        end
                    end

                    if not targetChestCFrame then
                        for i = 1, 5 do
                            local chest = workspace:FindFirstChild("Chest"..i)
                            if chest and chest:FindFirstChild("Top") then
                                local id = "GS_" .. i
                                if not lootedChests[id] then
                                    targetChestCFrame = chest.Top.CFrame
                                    chestId = id; break
                                end
                            end
                        end
                    end

                    if targetChestCFrame and chestId then
                        UpdateStatusUI("check " .. chestId)
                        root.CFrame = targetChestCFrame
                        lootedChests[chestId] = os.clock() 
                        task.wait(0.2) 
                        return 
                    end

                    local uptime = currentServerOsTime and (os.time() - currentServerOsTime) or workspace.DistributedGameTime
                    local cycle = uptime % 7200
                    local isUnderTwoHours = (cycle >= 7080 and cycle < 7200)
                    local isOverTwoHours = (cycle >= 0 and cycle <= 90) 
                    local bossRoot = getMsMotherRoot()
                    
                    if bossRoot then
                        UpdateStatusUI("Dang Danh Boss")
                        if not Settings.IsFightingBoss then
                            Settings.IsFightingBoss = true
                            sendWebhook("⚔️ Co BOSS! Dang danh boss...")
                        end
                        checkBossTimer = 0 
                        mapLoadTimer = 0
                        lastBossCFrame = bossRoot.CFrame 
                        char.Humanoid.AutoRotate = false

                        if not root:FindFirstChild("FreezePos") then
                            local bv = Instance.new("BodyVelocity")
                            bv.Name = "FreezePos"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = Vector3.new(0, 0, 0)
                            bv.Parent = root
                        end
                        if not root:FindFirstChild("FreezeRot") then
                            local bg = Instance.new("BodyGyro")
                            bg.Name = "FreezeRot"
                            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bg.P = 500000 
                            bg.Parent = root
                        end
                    else
                        char.Humanoid.AutoRotate = true
                        if root:FindFirstChild("FreezePos") then root.FreezePos:Destroy() end
                        if root:FindFirstChild("FreezeRot") then root.FreezeRot:Destroy() end
                        if Settings.IsFightingBoss then Settings.IsFightingBoss = false end

                        if lastBossCFrame then
                            UpdateStatusUI("Check Boss...")
                            root.CFrame = lastBossCFrame 
                            checkBossTimer = checkBossTimer + 0.1
                            if checkBossTimer < 2 then 
                                return
                            else
                                sendWebhook("☠️ BOSS Dead! Check Drop...")
                                lastBossCFrame = nil 
                                UpdateStatusUI("Len Dao An Toan...")
                                if wIsland then
                                    for _, v in pairs(wIsland:GetChildren()) do
                                        if v.Name:match("Loaf") then
                                            local part = v:FindFirstChildWhichIsA("BasePart", true)
                                            if part then
                                                root.CFrame = part.CFrame * CFrame.new(0, 200, 0)
                                                task.wait(0.2) 
                                            end
                                            break
                                        end
                                    end
                                end
                                FinalHop()
                                return
                            end
                        end

                        if isUnderTwoHours or isOverTwoHours then
                            if wIsland then
                                for _, v in pairs(wIsland:GetChildren()) do
                                    if v.Name:match("Loaf") then
                                        local part = v:FindFirstChildWhichIsA("BasePart", true)
                                        if part then
                                            if (root.Position - part.Position).Magnitude > 300 then
                                                UpdateStatusUI("Bay Den Bai...")
                                                root.CFrame = part.CFrame * CFrame.new(0, 200, 0)
                                                task.wait(1) 
                                                return
                                            end
                                            
                                            if isUnderTwoHours then
                                                UpdateStatusUI("Cho Boss Ra (" .. math.floor(7200 - cycle) .. "s)...")
                                            end
                                            return 
                                        end
                                        break
                                    end
                                end
                            end
                            
                            -- ĐOẠN NÀY LÀ BỘ ĐẾM KHI LỖI MAP (KHÔNG CÓ ĐẢO LOAF)
                            if isUnderTwoHours then mapLoadTimer = 0
                            elseif isOverTwoHours then
                                UpdateStatusUI("Loi Map, Dang Hop...")
                                mapLoadTimer = mapLoadTimer + 0.1
                                if mapLoadTimer >= 5 then FinalHop() end
                            end
                        else
                            FinalHop()
                        end
                    end
                end)
            end
        end
    end
end)()

-- DI CHUYỂN & CAMERA (HẠ TỌA ĐỘ XUỐNG ĐỂ TRÚNG M1)
RunService.RenderStepped:Connect(function(deltaTime)
    if Settings.AutoMsMother and Settings.IsFightingBoss then
        pcall(function()
            local char = lplr.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local bossRoot = getMsMotherRoot()
            
            if root and bossRoot then
                local radius = Settings.DistanceStud 
                if radius > 10 then radius = 10 end 
                local speed = 2 
                
                flyAngle = flyAngle + (speed * deltaTime)
                
                local offsetX = math.cos(flyAngle) * radius
                local offsetZ = math.sin(flyAngle) * radius
                
                -- Khóa Y ở mức Ngực/Đỉnh đầu để M1 trúng 100% (Y+7)
                local safeY = bossRoot.Position.Y + 7
                
                local myNewPos = Vector3.new(bossRoot.Position.X + offsetX, safeY, bossRoot.Position.Z + offsetZ)
                local targetPos = bossRoot.Position 
                
                local lockCFrame = CFrame.lookAt(myNewPos, targetPos)

                root.CFrame = lockCFrame
                if root:FindFirstChild("FreezeRot") then 
                    root.FreezeRot.CFrame = lockCFrame 
                end
                
                workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, targetPos)
            end
        end)
    end
end)
