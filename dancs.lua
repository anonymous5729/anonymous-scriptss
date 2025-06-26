pcall(function()
if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").RigType ~= Enum.HumanoidRigType.R15 then 
    game.StarterGui:SetCore("SendNotification", {
        Title = "R6 Detected", 
        Text = "Switch to R15 to use Freeman HUB.", 
        Duration = 10
    })
    return
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Char = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

local function getScaledSize(relativeWidth, relativeHeight)
    local viewportSize = camera.ViewportSize
    return UDim2.new(0, viewportSize.X * relativeWidth, 0, viewportSize.Y * relativeHeight)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreemanHubAnimationsEditor"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:FindFirstChildOfClass("CoreGui") or player:WaitForChild("PlayerGui")

local frame = Instance.new("TextButton")
frame.Name = "MainFrame"
frame.Text = ""
frame.Size = getScaledSize(0.35, 0.5)
frame.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2, 0.5, -frame.Size.Y.Offset / 2)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Text = "🎬 Freeman HUB - Animations Editor"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextScaled = true
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Parent = frame

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.PlaceholderText = "Search animations..."
searchBar.Text = ""
searchBar.Font = Enum.Font.SourceSans
searchBar.TextScaled = true
searchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBar.BorderSizePixel = 0
searchBar.Size = UDim2.new(0.9, 0, 0.08, 0)
searchBar.Position = UDim2.new(0.05, 0, 0.11, 0)
searchBar.ClearTextOnFocus = true
searchBar.Parent = frame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "AnimationsList"
scrollFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.21, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = frame

local reopenButton = Instance.new("TextButton")
reopenButton.Name = "ReopenButton"
reopenButton.Text = "+"
reopenButton.Font = Enum.Font.GothamBold
reopenButton.TextScaled = true
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
reopenButton.BorderSizePixel = 0
reopenButton.Size = UDim2.new(0, 40, 0, 40)
reopenButton.Position = UDim2.new(1, -50, 1, -50)
reopenButton.AnchorPoint = Vector2.new(1, 1)
reopenButton.Visible = false
reopenButton.Parent = screenGui
reopenButton.ZIndex = 10

-- Close Button ("✕")
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "✕"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Size = UDim2.new(0, 35, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.Parent = frame
closeButton.ZIndex = 5
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Minimize Button ("–")
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Text = "–"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextScaled = true
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.Size = UDim2.new(0, 35, 0, 30)
minimizeButton.Position = UDim2.new(1, -80, 0, 5)
minimizeButton.Parent = frame
minimizeButton.ZIndex = 5

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "Title" and not child:FindFirstChild("MinimizeIgnore") then
                child.Visible = true
            end
        end
        frame.Size = getScaledSize(0.35, 0.5)
    else
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "Title" and not child:FindFirstChild("MinimizeIgnore") then
                child.Visible = false
            end
        end
        frame.Size = UDim2.new(0, 250, 0, 60)
    end
    isMinimized = not isMinimized
end)

local buttons = {}

local function createAnimationButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "AnimationButton"
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, #buttons * 45)
    button.BorderSizePixel = 0
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(callback)

    table.insert(buttons, button)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #buttons * 45)
end

searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBar.Text:lower()
    local visibleCount = 0
    for _, button in ipairs(buttons) do
        if searchText == "" or button.Text:lower():find(searchText) then
            button.Visible = true
            button.Position = UDim2.new(0, 0, 0, visibleCount * 45)
            visibleCount += 1
        else
            button.Visible = false
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 45)
end)

local HttpService = game:GetService("HttpService")

local function stopAllAnimations()
    local humanoid = Char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, anim in ipairs(humanoid:GetPlayingAnimationTracks()) do
            anim:Stop()
        end
    end
end

local function playAnimation(animationId)
    local humanoid = Char:WaitForChild("Humanoid")
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    local track = humanoid:LoadAnimation(animation)
    track:Play()
    return track
end

local lastSelected = {
    Idle = nil,
    Walk = nil,
    Run = nil
}

local function applyIdle(id1, id2)
    stopAllAnimations()
    local animate = Char:WaitForChild("Animate")
    animate.idle.Animation1.AnimationId = "rbxassetid://" .. id1
    animate.idle.Animation2.AnimationId = "rbxassetid://" .. id2
    lastSelected.Idle = {id1, id2}
end

local function applyWalk(id)
    stopAllAnimations()
    local animate = Char:WaitForChild("Animate")
    animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. id
    lastSelected.Walk = id
end

local function applyRun(id)
    stopAllAnimations()
    local animate = Char:WaitForChild("Animate")
    animate.run.RunAnim.AnimationId = "rbxassetid://" .. id
    lastSelected.Run = id
end

local animations = {
    Idle = {
        ["Classic Idle"] = {"507766388", "507766666"},
        ["Hero Idle"] = {"616006778", "616008087"},
        ["Ninja Idle"] = {"656117400", "656118341"}
    },
    Walk = {
        ["Classic Walk"] = "507777826",
        ["Goofy Walk"] = "742640026",
        ["Stylish Walk"] = "616146177"
    },
    Run = {
        ["Classic Run"] = "507767714",
        ["Bubbly Run"] = "10921057244",
        ["Cartoony Run"] = "10921076136"
    }
}

local function previewAnimation(animationId)
    stopAllAnimations()
    playAnimation(animationId)
end

local function createPreviewButton(label, animId)
    createAnimationButton(label .. " - Preview", function()
        previewAnimation(animId)
    end)
end

createPreviewButton("Wave", "128777973")
createPreviewButton("Point", "128853357")
createPreviewButton("Laugh", "129423131")
createPreviewButton("Dance", "182435998")

local footer = Instance.new("TextLabel")
footer.Name = "CreditLabel"
footer.Text = "Made by Freeman4i37"
footer.Font = Enum.Font.Code
footer.TextScaled = true
footer.TextColor3 = Color3.fromRGB(200, 200, 200)
footer.BackgroundTransparency = 1
footer.Size = UDim2.new(1, 0, 0.06, 0)
footer.Position = UDim2.new(0, 0, 0.94, 0)
footer.Parent = frame

game.StarterGui:SetCore("SendNotification", {
    Title = "Freeman HUB",
    Text = "Animations Editor is ready to use.",
    Duration = 6
end

local extraAnimations = {
    Idle = {
        ["Adidas Community"] = {"122257458498464", "102357151005774"},
        ["Wicked (Popular)"] = {"118832222982049", "76049494037641"},
        ["Stylized Female"] = {"4708191566", "4708192150"},
        ["Bubbly"] = {"910004836", "910009958"},
        ["Cartoony"] = {"742637544", "742638445"},
        ["Bold"] = {"16738333868", "16738334710"},
        ["Stylish"] = {"616136790", "616138447"}
    },
    Walk = {
        ["Adidas Community"] = "122150855457006",
        ["Wicked (Popular)"] = "92072849924640",
        ["Stylized Female"] = "4708193840",
        ["Bubbly"] = "910034870",
        ["Cartoony"] = "742640026",
        ["Bold"] = "16738340646",
        ["Stylish"] = "616146177"
    },
    Run = {
        ["Adidas Community"] = "82598234841035",
        ["Wicked (Popular)"] = "72301599441680",
        ["Stylized Female"] = "4708192705",
        ["Bubbly"] = "10921057244",
        ["Cartoony"] = "10921076136",
        ["Bold"] = "16738337225",
        ["Stylish"] = "10921276116"
    }
}

for name, ids in pairs(extraAnimations.Idle) do
    createAnimationButton(name .. " - Idle", function()
        applyIdle(ids[1], ids[2])
    end)
end

for name, id in pairs(extraAnimations.Walk) do
    createAnimationButton(name .. " - Walk", function()
        applyWalk(id)
    end)
end

for name, id in pairs(extraAnimations.Run) do
    createAnimationButton(name .. " - Run", function()
        applyRun(id)
    end)
end

local animationTypes = {
    Idle = applyIdle,
    Walk = applyWalk,
    Run = applyRun,
    Jump = function(id) 
        stopAllAnimations()
        Char.Animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. id 
    end,
    Fall = function(id) 
        stopAllAnimations()
        Char.Animate.fall.FallAnim.AnimationId = "rbxassetid://" .. id 
    end,
    Swim = function(id) 
        stopAllAnimations()
        if Char.Animate:FindFirstChild("swim") then
            Char.Animate.swim.Swim.AnimationId = "rbxassetid://" .. id
        end
    end,
    SwimIdle = function(id) 
        stopAllAnimations()
        if Char.Animate:FindFirstChild("swimidle") then
            Char.Animate.swimidle.SwimIdle.AnimationId = "rbxassetid://" .. id
        end
    end,
    Climb = function(id) 
        stopAllAnimations()
        Char.Animate.climb.ClimbAnim.AnimationId = "rbxassetid://" .. id 
    end
}

local function createTypedButton(name, type, ids)
    if type == "Idle" and typeof(ids) == "table" then
        createAnimationButton(name .. " - Idle", function()
            animationTypes.Idle(ids[1], ids[2])
        end)
    elseif animationTypes[type] then
        createAnimationButton(name .. " - " .. type, function()
            animationTypes[type](ids)
        end)
    end
end

createTypedButton("Adidas Community", "Idle", {"122257458498464", "102357151005774"})
createTypedButton("Adidas Community", "Walk", "122150855457006")
createTypedButton("Adidas Community", "Run", "82598234841035")
createTypedButton("Adidas Community", "Jump", "656117878")
createTypedButton("Adidas Community", "Fall", "98600215928904")
createTypedButton("Adidas Community", "Climb", "88763136693023")
createTypedButton("Adidas Community", "Swim", "133308483266208")
createTypedButton("Adidas Community", "SwimIdle", "109346520324160")

-- Bubbly
createTypedButton("Bubbly", "Idle", {"910004836", "910009958"})
createTypedButton("Bubbly", "Walk", "910034870")
createTypedButton("Bubbly", "Run", "10921057244")
createTypedButton("Bubbly", "Jump", "910016857")
createTypedButton("Bubbly", "Fall", "910001910")
createTypedButton("Bubbly", "Swim", "910028158")
createTypedButton("Bubbly", "SwimIdle", "910030921")

-- Cartoony
createTypedButton("Cartoony", "Idle", {"742637544", "742638445"})
createTypedButton("Cartoony", "Walk", "742640026")
createTypedButton("Cartoony", "Run", "10921076136")
createTypedButton("Cartoony", "Jump", "742637942")
createTypedButton("Cartoony", "Fall", "742637151")
createTypedButton("Cartoony", "Climb", "742636889")
createTypedButton("Cartoony", "Swim", "10921079380")
createTypedButton("Cartoony", "SwimIdle", "10921079380")

-- Stylish
createTypedButton("Stylish", "Idle", {"616136790", "616138447"})
createTypedButton("Stylish", "Walk", "616146177")
createTypedButton("Stylish", "Run", "10921276116")
createTypedButton("Stylish", "Jump", "616139451")
createTypedButton("Stylish", "Fall", "616134815")
createTypedButton("Stylish", "Swim", "10921281000")
createTypedButton("Stylish", "SwimIdle", "10921281964")
createTypedButton("Stylish", "Climb", "10921271391")

-- Wicked (Popular)
createTypedButton("Wicked", "Idle", {"118832222982049", "76049494037641"})
createTypedButton("Wicked", "Walk", "92072849924640")
createTypedButton("Wicked", "Run", "72301599441680")
createTypedButton("Wicked", "Jump", "104325245285198")
createTypedButton("Wicked", "Fall", "121152442762481")
createTypedButton("Wicked", "Climb", "131326830509784")
createTypedButton("Wicked", "Swim", "99384245425157")
createTypedButton("Wicked", "SwimIdle", "113199415118199")

-- Bold
createTypedButton("Bold", "Idle", {"16738333868", "16738334710"})
createTypedButton("Bold", "Walk", "16738340646")
createTypedButton("Bold", "Run", "16738337225")
createTypedButton("Bold", "Jump", "16738336650")
createTypedButton("Bold", "Fall", "16738333171")
createTypedButton("Bold", "Climb", "16738332169")
createTypedButton("Bold", "Swim", "16738339158")
createTypedButton("Bold", "SwimIdle", "16738339817")

local tabTypes = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
local currentTab = "Idle"
local tabButtons = {}
local spacing = 0.01
local tabHeight = 0.06

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, tabHeight, 0)
tabBar.Position = UDim2.new(0, 0, 0.1, 0)
tabBar.BackgroundTransparency = 1
tabBar.Parent = frame

local function showTab(tabName)
    currentTab = tabName
    local visibleCount = 0
    for _, btn in pairs(buttons) do
        local isMatch = btn.Name:lower():find(tabName:lower())
        btn.Visible = isMatch ~= nil
        if btn.Visible then
            btn.Position = UDim2.new(0, 0, 0, visibleCount * 45)
            visibleCount += 1
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 45)
end

for i, tabName in ipairs(tabTypes) do
    local button = Instance.new("TextButton")
    button.Text = tabName
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.Size = UDim2.new(1 / #tabTypes - spacing, 0, 1, 0)
    button.Position = UDim2.new((i - 1) / #tabTypes, (i - 1) * spacing * frame.AbsoluteSize.X, 0, 0)
    button.BorderSizePixel = 0
    button.Parent = tabBar

    button.MouseButton1Click:Connect(function()
        showTab(tabName)
    end)

    tabButtons[tabName] = button
end

showTab(currentTab)

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    reopenButton.Visible = true
end)


