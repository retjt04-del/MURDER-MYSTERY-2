local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local noclipActive = false
local noclipConnection = nil
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()
local Window = Library.CreateLib("MURDER MYSTERY 2 by qjy_26", "RJTheme1")
local Tab = Window:NewTab("Fun")
local Section = Tab:NewSection("Fun")
Section:NewButton("remove the anchor", "ButtonInfo", function()
    for _, object in ipairs(workspace:GetDescendants()) do
    if object:IsA("BasePart") and object.Anchored then
        pcall(function()
            object.Anchored = false
        end)
    end
end
print("Анкор успешно снят со всех объектов карты!")

end)
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("PLAYER")
Section:NewButton("Anti-AFK", "ButtonInfo", function()
    local virtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, 0, 0)
    wait(1)
    virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
print("Анти-АФК успешно запущен в фоновом режиме!")

end)
Section:NewToggle("Infinite Jump", "Прыгайте в воздухе сколько угодно", function(state)
    -- Прячем переменную в глобальную область видимости, чтобы иметь к ней доступ при выключении
    _G.infJumpConnect = _G.infJumpConnect or nil

    if state then
        -- На всякий случай отключаем старое соединение перед запуском нового
        if _G.infJumpConnect then _G.infJumpConnect:Disconnect() end
        
        -- Включаем бесконечный прыжок
        _G.infJumpConnect = game:GetService("UserInputService").JumpRequest:Connect(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        -- Полностью выключаем прыжок при деактивации тоггла
        if _G.infJumpConnect then
            _G.infJumpConnect:Disconnect()
            _G.infJumpConnect = nil
        end
    end
end)
Section:NewSlider("Speed", "SliderInfo", 50, 0, function(s) -- 500 (Макс. значение) | 0 (Мин. значение)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local noclipActive = false
local noclipConnection = nil

-- Функция для принудительного включения коллизии (когда выключаем ноуклип)
local function resetCollision()
    local character = player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Возвращаем стандартную коллизию для ног, торса и головы
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false -- Этот парт ВСЕГДА должен быть false в Roblox
                else
                    part.CanCollide = true
                end
            end
        end
    end
end
Section:NewButton("Noclip", "Включить / Выключить ноуклип", function()
    noclipActive = not noclipActive
    
    if noclipActive then
        -- Включаем ноуклип
        noclipConnection = runService.Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Выключаем ноуклип
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- Принудительно включаем физику стен обратно
        resetCollision()
    end
end)
local Section = Tab:NewSection("ESP")
Section:NewButton("ESP Dead Players", "ButtonInfo", function()
    -- УНИВЕРСАЛЬНЫЙ ESP НА ЦЕЛЬ ДЛЯ ВСЕХ КАРТ
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Безопасная папка для хранения подсветки (защита от античита)
local safeParent = localPlayer:WaitForChild("PlayerGui")

-- Имя объекта, который мы ищем
local TARGET_NAME = "Raggy"

-- Функция создания подсветки (BoxHandleAdornment)
local function createESP(part)
    local espName = "TargetESP_" .. part:GetDebugId()
    if safeParent:FindFirstChild(espName) then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = espName
    box.Size = Vector3.new(4, 6, 4) -- Размер коробки вокруг персонажа
    box.Color3 = Color3.fromRGB(255, 0, 0) -- Ярко-красный цвет (можно изменить)
    box.AlwaysOnTop = true -- Видно сквозь любые стены
    box.ZIndex = 10
    box.Transparency = 0.4
    box.Adornee = part
    box.Parent = safeParent

    -- Удаляем подсветку, если цель исчезла с карты или раунд закончился
    part.AncestryChanged:Connect(function()
        if not part:IsDescendantOf(workspace) then
            box:Destroy()
        end
    end)
end

-- Функция сканирования объекта на наличие нужной цели
local function checkTarget(object)
    if object.Name == TARGET_NAME then
        -- Ждем появления HumanoidRootPart внутри цели
        local hrp = object:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            createESP(hrp)
        end
    end
end

-- 1. Проверяем, если цель УЖЕ есть на карте в момент запуска скрипта
for _, descendant in ipairs(workspace:GetDescendants()) do
    checkTarget(descendant)
end

-- 2. Отслеживаем появление цели на ЛЮБОЙ новой карте (работает на всех картах)
workspace.DescendantAdded:Connect(function(descendant)
    checkTarget(descendant)
end)

end)
Section:NewButton("ESP Gun", "ButtonInfo", function()
    local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local safeParent = localPlayer:WaitForChild("PlayerGui")

local function highlightGun(gunPart)
    local espName = "GunDropESP_" .. gunPart:GetDebugId()
    if safeParent:FindFirstChild(espName) then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = espName
    box.Size = Vector3.new(3, 2, 3) -- Небольшой размер под пистолет
    box.Color3 = Color3.fromRGB(0, 255, 0) -- Ярко-зеленый цвет для пистолета
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.3
    box.Adornee = gunPart
    box.Parent = safeParent

    gunPart.AncestryChanged:Connect(function()
        if not gunPart:IsDescendantOf(workspace) then
            box:Destroy()
        end
    end)
end

-- Проверка объекта (ищет именно пистолет MM2)
local function checkObject(object)
    -- Проверяем стандартные названия выпавшего пистолета в MM2
    if object.Name == "GunDrop" or object.Name == "Gun" then
        if object:IsA("BasePart") then
            highlightGun(object)
        elseif object:IsA("Model") or object:IsA("Tool") then
            -- Если это модель, подсвечиваем её центральную часть
            local handle = object:FindFirstChild("Handle") or object:FindFirstChildWhichIsA("BasePart")
            if handle then highlightGun(handle) end
        end
    end
end

-- Автоматический поиск на всех картах в реальном времени
for _, descendant in ipairs(workspace:GetDescendants()) do checkObject(descendant) end
workspace.DescendantAdded:Connect(checkObject)

end)
Section:NewButton("ESP Roles", "ButtonInfo", function()
    local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для поиска роли игрока через систему MM2
local function getMM2Role(player)
    -- Пытаемся найтиPlayerData в ReplicatedStorage (так MM2 хранит роли)
    local playerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if playerData and playerData:IsA("RemoteFunction") then
        local success, data = pcall(function() return playerData:InvokeServer() end)
        if success and data and data[player.Name] then
            local role = data[player.Name].Role
            if role == "Murderer" then return "Murderer" end
            if role == "Sheriff" or role == "Hero" then return "Sheriff" end
        end
    end

    -- Запасной проверенный способ: проверка инструментов (скинов)
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    local function checkTools(folder)
        if not folder then return nil end
        for _, tool in ipairs(folder:GetChildren()) do
            if tool:IsA("Tool") then
                if tool:FindFirstChild("KnifeScript") or string.find(string.lower(tool.Name), "knife") then return "Murderer" end
                if tool:FindFirstChild("GunScript") or string.find(string.lower(tool.Name), "gun") then return "Sheriff" end
            end
        end
    end

    return checkTools(char) or checkTools(backpack) or "Innocent"
end

-- Функция создания неоновой подсветки (Chams) сквозь стены
local function applyChams(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:IsDescendantOf(workspace) then return end

    -- Окрашиваем каждую часть тела в нужный цвет
    local role = getMM2Role(player)
    local color = Color3.fromRGB(0, 255, 0) -- Зеленый по дефолту

    if role == "Murderer" then
        color = Color3.fromRGB(255, 0, 0) -- Красный
    elseif role == "Sheriff" then
        color = Color3.fromRGB(0, 0, 255) -- Синий
    end

    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Проверяем, есть ли уже подсветка на этой части тела
            local box = part:FindFirstChild("ChamsBox")
            if not box then
                box = Instance.new("BoxHandleAdornment")
                box.Name = "ChamsBox"
                box.AlwaysOnTop = true -- Видно сквозь стены!
                box.ZIndex = 10
                box.Adornee = part
                box.Parent = part
            end
            box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
            box.Color3 = color
            box.Transparency = 0.4 -- Прозрачность силуэта
        end
    end
end

-- Цикл сканирования ВСЕХ игроков без лагов
task.spawn(function()
    while task.wait(0.5) do
        for _, player in ipairs(Players:GetPlayers()) do
            pcall(applyChams, player)
        end
    end
end)

end)
Section:NewButton("ESP coins", "ButtonInfo", function()
    local Workspace = game:GetService("Workspace")

-- Функция создания подсветки на монете
local function highlightCoin(coin)
    -- Проверяем, что это деталь и на ней еще нет нашей подсветки
    if (coin:IsA("BasePart") or coin:IsA("MeshPart")) and not coin:FindFirstChild("UniversalCoinESP") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "UniversalCoinESP"
        box.AlwaysOnTop = true -- Видно сквозь стены
        box.ZIndex = 8
        box.Adornee = coin
        box.Size = coin.Size + Vector3.new(0.3, 0.3, 0.3) -- Задаем размер рамки
        box.Color3 = Color3.fromRGB(255, 215, 0) -- Золотой цвет
        box.Transparency = 0.4 -- Полупрозрачность
        box.Parent = coin
    end
end

-- Функция универсального поиска папки с монетами
local function scanAllMapsForCoins()
    -- GetDescendants проверяет вообще ВСЕ объекты в игре, на любую глубину
    for _, v in ipairs(Workspace:GetDescendants()) do
        -- Если находим Coin_Server (не важно, в Отеле он, в Офисе или где-то еще)
        if v.Name == "Coin_Server" or v.Name == "CoinContainer" then
            -- Перебираем всё, что лежит внутри этой папки
            for _, coin in ipairs(v:GetChildren()) do
                -- Если это монета (или её часть), накладываем ESP
                if coin:IsA("BasePart") or coin:IsA("MeshPart") or coin.Name == "Coin" then
                    highlightCoin(coin)
                end
            end
        end
    end
end

-- Безопасный цикл (обновление каждые 0.7 секунд, чтобы не лагало)
task.spawn(function()
    while task.wait(0.7) do
        pcall(scanAllMapsForCoins)
    end
end)
end)
