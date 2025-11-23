-- Brookhaven Command GUI - antilopa.cc
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "AntilopaGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 1, -410)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)

-- Заголовок
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "antilopa.cc"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Поле для ввода команд
local CommandBox = Instance.new("TextBox")
CommandBox.Parent = MainFrame
CommandBox.Size = UDim2.new(0.8, 0, 0, 30)
CommandBox.Position = UDim2.new(0.05, 0, 0, 40)
CommandBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CommandBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBox.PlaceholderText = "Введите команду..."
CommandBox.Text = ""
CommandBox.TextSize = 12
CommandBox.Font = Enum.Font.Gotham
CommandBox.ClearTextOnFocus = false

local CommandCorner = Instance.new("UICorner")
CommandCorner.Parent = CommandBox
CommandCorner.CornerRadius = UDim.new(0, 4)

-- Кнопка EXECUTE справа
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Parent = MainFrame
ExecuteButton.Size = UDim2.new(0.1, 0, 0, 30)
ExecuteButton.Position = UDim2.new(0.87, 0, 0, 40)
ExecuteButton.Text = "?"
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextSize = 14
ExecuteButton.Font = Enum.Font.GothamBold

local ExecuteCorner = Instance.new("UICorner")
ExecuteCorner.Parent = ExecuteButton
ExecuteCorner.CornerRadius = UDim.new(0, 4)

-- Контейнер для списка команд
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, 0, 1, -80)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 75)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Переменные для функций
local flying = false
local flyConnection
local espEnabled = false
local invisible = false

-- Функция для создания текстовых меток
local function createCommandLabel(name)
    local label = Instance.new("TextLabel")
    label.Parent = ScrollingFrame
    label.Size = UDim2.new(0.95, 0, 0, 25)
    label.Position = UDim2.new(0.025, 0, 0, 0)
    label.Text = name
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.BorderSizePixel = 0
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local padding = Instance.new("UIPadding")
    padding.Parent = label
    padding.PaddingLeft = UDim.new(0, 10)
    
    local corner = Instance.new("UICorner")
    corner.Parent = label
    corner.CornerRadius = UDim.new(0, 4)
    
    return label
end

-- Создаем список команд (без "Список команд")
createCommandLabel("fly [1-100] - полет")
createCommandLabel("unfly - выключить полет")
createCommandLabel("speed [1-100] - скорость")
createCommandLabel("jump [1-100] - прыжок")
createCommandLabel("noclip - сквозь стены")
createCommandLabel("clip - выключить ноклип")
createCommandLabel("esp - вх")
createCommandLabel("clearesp - убрать подсветку")
createCommandLabel("reset - переродиться")
createCommandLabel("invisible - невидимость")
createCommandLabel("visible - видимость")
createCommandLabel("black - черное небо")
createCommandLabel("unblack - обычное небо")

-- Обновляем размер контента
task.wait()
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

-- Функция для создания ников над игроками
local function createNicknames(player)
    if not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local oldBillboard = head:FindFirstChild("PlayerNickname")
    if oldBillboard then
        oldBillboard:Destroy()
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerNickname"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

-- Функция для удаления ников
local function clearNicknames()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("PlayerNickname")
                if billboard then
                    billboard:Destroy()
                end
            end
        end
    end
end

-- Функции для невидимости
local function makeInvisible()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        print("Невидимость включена!")
    end
end

local function makeVisible()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
        print("Видимость включена!")
    end
end

-- Функция для выполнения команд
local function executeCommand(fullCommand)
    local args = {}
    for arg in fullCommand:gmatch("%S+") do
        table.insert(args, arg:lower())
    end
    
    if #args == 0 then return end
    
    local cmd = args[1]
    
    if cmd == "fly" then
        local speed = tonumber(args[2]) or 50
        speed = math.clamp(speed, 1, 100) * 3
        
        flying = not flying
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not rootPart or not humanoid then return end
        
        if flying then
            humanoid.PlatformStand = true
            
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Parent = rootPart
            
            if flyConnection then flyConnection:Disconnect() end
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying or not rootPart or not bodyVelocity then
                    return
                end
                
                local newVelocity = Vector3.new()
                local cam = workspace.CurrentCamera
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    newVelocity = newVelocity + (cam.CFrame.LookVector * speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    newVelocity = newVelocity + (cam.CFrame.LookVector * -speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    newVelocity = newVelocity + (cam.CFrame.RightVector * -speed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    newVelocity = newVelocity + (cam.CFrame.RightVector * speed)
                end
                
                bodyVelocity.Velocity = newVelocity
            end)
        else
            flying = false
            if flyConnection then flyConnection:Disconnect() end
            
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if rootPart then
                for _, obj in pairs(rootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") then
                        obj:Destroy()
                    end
                end
            end
        end
        
    elseif cmd == "unfly" then
        flying = false
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in pairs(rootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") then
                        obj:Destroy()
                    end
                end
            end
        end
        if flyConnection then flyConnection:Disconnect() end
        
    elseif cmd == "speed" then
        local speed = tonumber(args[2]) or 16
        speed = math.clamp(speed, 1, 100)
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
        
    elseif cmd == "jump" then
        local power = tonumber(args[2]) or 50
        power = math.clamp(power, 1, 100)
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = power
            end
        end
        
    elseif cmd == "noclip" then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
    elseif cmd == "clip" then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
    elseif cmd == "esp" then
        espEnabled = true
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Name = "IY_ESP"
                    
                    createNicknames(player)
                end
            end
        end
        
    elseif cmd == "clearesp" then
        espEnabled = false
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("IY_ESP")
                if esp then
                    esp:Destroy()
                end
            end
        end
        clearNicknames()
        
    elseif cmd == "reset" then
        local character = LocalPlayer.Character
        if character then
            character:BreakJoints()
        end
        
    elseif cmd == "invisible" then
        invisible = not invisible
        if invisible then
            makeInvisible()
        else
            makeVisible()
        end
        
    elseif cmd == "visible" then
        invisible = false
        makeVisible()
        
    elseif cmd == "black" then
        Lighting.TimeOfDay = "24:00:00"
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.FogColor = Color3.new(0, 0, 0)
        Lighting.FogEnd = 1000
        
    elseif cmd == "unblack" then
        Lighting.TimeOfDay = "14:00:00"
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
    end
    
    CommandBox.Text = ""
end

-- Автоматически создаем ники для новых игроков при ESP
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function()
            if espEnabled then
                wait(1)
                createNicknames(player)
                
                local character = player.Character
                if character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Name = "IY_ESP"
                end
            end
        end)
    end
end)

-- Автоматически применяем невидимость при появлении нового персонажа
LocalPlayer.CharacterAdded:Connect(function(character)
    if invisible then
        wait(1)
        makeInvisible()
    end
end)

-- Выполнение команды по кнопке EXECUTE
ExecuteButton.MouseButton1Click:Connect(function()
    local command = CommandBox.Text
    if command and command ~= "" then
        executeCommand(command)
    end
end)

-- Выполнение команды по Enter
CommandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local command = CommandBox.Text
        if command and command ~= "" then
            executeCommand(command)
        end
    end
end)

-- Кнопка сворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 120, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 1, -45)
ToggleButton.Text = "antilopa.cc"
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ZIndex = 10

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Parent = ToggleButton
ToggleCorner.CornerRadius = UDim.new(0, 8)

-- Сворачивание/разворачивание
local isMinimized = false
ToggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Visible = false
        ToggleButton.Text = "antilopa.cc"
    else
        MainFrame.Visible = true
        ToggleButton.Text = "antilopa.cc"
    end
end)

print("Antilopa.cc GUI загружен!")
