--// SILLYHUB V3
--// Full Developer / Testing Utility Hub
--// Made by 3fettalI

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--==================================================
-- REMOVE OLD SILLYHUB
--==================================================

for _, name in ipairs({
	"SillyHub",
	"SillyHubV3",
	"SillyHubNotifications",
	"SillyHubCrosshair",
	"SillyHubESP",
	"SillyHubAimCircle",
	}) do
	local old = PlayerGui:FindFirstChild(name)

	if old then
		old:Destroy()
	end
end

--==================================================
-- THEME
--==================================================

local Theme = {
	Background = Color3.fromRGB(17, 17, 21),
	Panel = Color3.fromRGB(23, 23, 29),
	Panel2 = Color3.fromRGB(31, 31, 39),

	Accent = Color3.fromRGB(120, 90, 255),

	Text = Color3.fromRGB(240, 240, 245),
	SubText = Color3.fromRGB(155, 155, 165),

	Success = Color3.fromRGB(80, 220, 120),
	Error = Color3.fromRGB(255, 85, 85),
	Warning = Color3.fromRGB(255, 190, 70),
}

--==================================================
-- STATE
--==================================================

local State = {

	-- PLAYER
	Godmode = false,
	InfiniteJump = false,
	Noclip = false,
	Flight = false,

	FlightSpeed = 100,
	VerticalFlightSpeed = 100,

	WalkSpeed = 16,
	JumpPower = 50,
	Gravity = 196.2,
	HipHeight = 2,

	AutoRotate = true,
	PlatformStand = false,
	Frozen = false,

	-- TELEPORT
	RepeatTeleport = false,
	RandomTeleport = false,
	RandomRadius = 200,
	RandomTeleportInterval = 0.5,
	SavedPosition = nil,

	-- SPIN
	Spin = false,
	SpinSpeed = 5,
	CameraFollowsSpin = false,

	-- ORBIT
	Orbit = false,
	OrbitTarget = "",
	OrbitRadius = 10,
	OrbitSpeed = 2,
	OrbitHeight = 0,
	OrbitAngle = 0,

	-- CAMERA
	FOV = 70,
	CameraDistance = 12,
	CameraSensitivity = 50,
	Freecam = false,
	FreecamSpeed = 50,

	-- COMBAT
	Aimbot = false,
	AimHoldMode = false,
	AimKey = Enum.KeyCode.Q,

	AimFOV = 150,
	AimRange = 1000,
	AimSmoothness = 0.35,
	AimPrediction = 0.08,

	AimTargetPart = "Head",
	AimPriority = "Crosshair",

	AimTeamCheck = true,
	AimWallCheck = true,
	AimSticky = true,
	AimAutoSwitch = true,

	AimFOVCircle = true,
	AimTargetHighlight = true,
	AimTargetIndicator = true,

	AimTarget = nil,

	-- VISUAL
	ESP = false,
	Names = false,
	Distance = false,
	Health = false,
	HealthBars = false,
	Tracers = false,
	HeadDots = false,

	ESPFill = 50,
	ESPOutline = 0,

	ESPColor = Color3.fromRGB(255, 255, 255),

	FakeName = "",

	-- WORLD
	Fullbright = false,
	NoFog = false,

	Brightness = Lighting.Brightness,
	Exposure = Lighting.ExposureCompensation,
	ClockTime = Lighting.ClockTime,
	GlobalShadows = Lighting.GlobalShadows,

	-- PERFORMANCE
	FPSCounter = false,
	PingCounter = false,

	-- NOTIFICATIONS
	Notifications = true,

	NotifyPlayerJoin = true,
	NotifyPlayerLeave = true,
	NotifyTeleport = true,
	NotifyMovement = true,
	NotifyVisual = true,
	NotifyUtility = true,
	NotifyAvatar = true,
	NotifySystem = true,
	NotifySettings = true,

	NotificationSound = true,
	NotificationDuration = 3,

	-- UI
	MenuScale = 100,
	MenuTransparency = 0,

	OpenKey = Enum.KeyCode.RightShift,

	-- THEME
	ThemeR = 120,
	ThemeG = 90,
	ThemeB = 255,
}

local SavedColor = nil

--==================================================
-- ORIGINAL LIGHTING
--==================================================

local OriginalLighting = {
	Brightness = Lighting.Brightness,
	Exposure = Lighting.ExposureCompensation,
	ClockTime = Lighting.ClockTime,
	GlobalShadows = Lighting.GlobalShadows,
	FogStart = Lighting.FogStart,
	FogEnd = Lighting.FogEnd,
}

--==================================================
-- CHARACTER HELPERS
--==================================================

local function getCharacter()
	return LP.Character
end

local function getHumanoid()
	local character = getCharacter()

	if character then
		return character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

local function getRoot()
	local character = getCharacter()

	if character then
		return character:FindFirstChild("HumanoidRootPart")
	end

	return nil
end

local function findPlayer(text)
	if not text or text == "" then
		return nil
	end

	text = string.lower(
		string.gsub(text, "^%s*(.-)%s*$", "%1")
	)

	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == text then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.DisplayName) == text then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(
			string.lower(player.Name),
			1,
			#text
			) == text then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(
			string.lower(player.DisplayName),
			1,
			#text
			) == text then
			return player
		end
	end

	return nil
end

--==================================================
-- NOTIFICATIONS
--==================================================

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "SillyHubNotifications"
NotificationGui.ResetOnSpawn = false
NotificationGui.IgnoreGuiInset = true
NotificationGui.DisplayOrder = 1000
NotificationGui.Parent = PlayerGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Size = UDim2.new(0, 350, 1, -30)
NotificationHolder.Position = UDim2.new(1, -365, 0, 15)
NotificationHolder.Parent = NotificationGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Parent = NotificationHolder

local function notificationCategoryAllowed(category)
	if not State.Notifications then
		return false
	end

	if category == "Player" then
		return true
	end

	if category == "Teleport" then
		return State.NotifyTeleport
	end

	if category == "Movement" then
		return State.NotifyMovement
	end

	if category == "Visual" then
		return State.NotifyVisual
	end

	if category == "Utility" then
		return State.NotifyUtility
	end

	if category == "Avatar" then
		return State.NotifyAvatar
	end

	if category == "System" then
		return State.NotifySystem
	end

	if category == "Settings" then
		return State.NotifySettings
	end

	return true
end

local function playNotificationSound()
	if not State.NotificationSound then
		return
	end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://6895079853"
	sound.Volume = 0.25
	sound.Parent = NotificationGui

	pcall(function()
		sound:Play()
	end)

	task.delay(2, function()
		if sound then
			sound:Destroy()
		end
	end)
end

local function Notify(title, message, category)
	if not State.Notifications then
		return
	end

	if category and not notificationCategoryAllowed(category) then
		return
	end

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 72)
	card.BackgroundColor3 = Theme.Panel
	card.BackgroundTransparency = 0.03
	card.BorderSizePixel = 0
	card.Parent = NotificationHolder

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Accent
	stroke.Thickness = 1
	stroke.Transparency = 0.35
	stroke.Parent = card

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 14, 0, 8)
	titleLabel.Size = UDim2.new(1, -25, 0, 22)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = card

	local msgLabel = Instance.new("TextLabel")
	msgLabel.BackgroundTransparency = 1
	msgLabel.Position = UDim2.new(0, 14, 0, 31)
	msgLabel.Size = UDim2.new(1, -25, 0, 32)
	msgLabel.Font = Enum.Font.Gotham
	msgLabel.Text = message
	msgLabel.TextColor3 = Theme.SubText
	msgLabel.TextSize = 12
	msgLabel.TextWrapped = true
	msgLabel.TextXAlignment = Enum.TextXAlignment.Left
	msgLabel.Parent = card

	card.Position = UDim2.new(1, 30, 0, 0)

	TweenService:Create(
		card,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.Out
		),
		{
			Position = UDim2.new(0, 0, 0, 0)
		}
	):Play()

	playNotificationSound()

	task.delay(State.NotificationDuration, function()
		if card and card.Parent then
			local tween = TweenService:Create(
				card,
				TweenInfo.new(0.25),
				{
					Position = UDim2.new(1, 30, 0, 0)
				}
			)

			tween:Play()
			tween.Completed:Wait()

			if card then
				card:Destroy()
			end
		end
	end)
end

--==================================================
-- MAIN GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "SillyHubV3"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999
Gui.Enabled = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 950, 0, 620)
Main.Position = UDim2.new(0.5, -475, 0.5, -310)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Transparency = 0.45
MainStroke.Parent = Main

local Scale = Instance.new("UIScale")
Scale.Scale = State.MenuScale / 100
Scale.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Theme.Panel
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.Position = UDim2.new(0, 0, 1, -14)
HeaderCover.Size = UDim2.new(1, 0, 0, 14)
HeaderCover.BackgroundColor3 = Theme.Panel
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 22, 0, 8)
Title.Size = UDim2.new(0, 350, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "SillyHub V3"
Title.TextColor3 = Theme.Text
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MadeBy = Instance.new("TextLabel")
MadeBy.BackgroundTransparency = 1
MadeBy.Position = UDim2.new(0, 23, 0, 39)
MadeBy.Size = UDim2.new(0, 250, 0, 18)
MadeBy.Font = Enum.Font.Gotham
MadeBy.Text = "Made by 3fettalI"
MadeBy.TextColor3 = Theme.SubText
MadeBy.TextSize = 11
MadeBy.TextXAlignment = Enum.TextXAlignment.Left
MadeBy.Parent = Header

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -55, 0, 18)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Font = Enum.Font.GothamBold
Close.Text = "×"
Close.TextColor3 = Theme.SubText
Close.TextSize = 25
Close.Parent = Header

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.new(0, 0, 0, 70)
Sidebar.Size = UDim2.new(0, 180, 1, -70)
Sidebar.BackgroundColor3 = Theme.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 180, 0, 70)
Content.Size = UDim2.new(1, -180, 1, -70)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- UI HELPERS
--==================================================

local Pages = {}
local TabButtons = {}
local CurrentPage = nil

local function UpdateCanvas(page, layout)
	page.CanvasSize = UDim2.new(
		0,
		0,
		0,
		layout.AbsoluteContentSize.Y + 45
	)
end

local function CreateTab(name, order)
	local button = Instance.new("TextButton")
	button.Name = name .. "Tab"
	button.Size = UDim2.new(1, 0, 0, 38)
	button.BackgroundColor3 = Theme.Panel
	button.BackgroundTransparency = 1
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamMedium
	button.Text = name
	button.TextColor3 = Theme.SubText
	button.TextSize = 12
	button.LayoutOrder = order
	button.Parent = Sidebar

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 7)
	buttonCorner.Parent = button

	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 5
	page.ScrollBarImageColor3 = Theme.Accent
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.Parent = Content

	local layout = Instance.new("UIListLayout")
	layout.Name = "ContentLayout"
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 18)
	padding.PaddingLeft = UDim.new(0, 20)
	padding.PaddingRight = UDim.new(0, 20)
	padding.PaddingBottom = UDim.new(0, 20)
	padding.Parent = page

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		UpdateCanvas(page, layout)
	end)

	Pages[name] = page
	TabButtons[name] = button

	button.MouseButton1Click:Connect(function()
		CurrentPage = name

		for n, p in pairs(Pages) do
			p.Visible = n == name
		end

		for n, b in pairs(TabButtons) do
			if n == name then
				b.BackgroundTransparency = 0
				b.BackgroundColor3 = Theme.Accent
				b.TextColor3 = Color3.new(1, 1, 1)
			else
				b.BackgroundTransparency = 1
				b.TextColor3 = Theme.SubText
			end
		end
	end)

	return page
end

local function Section(parent, text)
	local frame = Instance.new("Frame")
	frame.Name = "Section_" .. text
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.BackgroundTransparency = 1
	frame.LayoutOrder = #parent:GetChildren() + 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = Theme.Accent
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	return frame
end

local function Button(parent, text, callback)
	local b = Instance.new("TextButton")
	b.Name = "Button_" .. text
	b.Size = UDim2.new(1, 0, 0, 38)
	b.BackgroundColor3 = Theme.Panel2
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamMedium
	b.Text = text
	b.TextColor3 = Theme.Text
	b.TextSize = 12
	b.AutoButtonColor = true
	b.LayoutOrder = #parent:GetChildren() + 1
	b.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = b

	b.MouseButton1Click:Connect(function()
		if callback then
			local success, err = pcall(callback)

			if not success then
				warn("[SillyHub V3] Button error:", err)

				Notify(
					"Button Error",
					"An error occurred. Check Output.",
					"System"
				)
			end
		end
	end)

	return b
end

local function Toggle(parent, text, key, callback)
	local b

	local function refresh()
		if not b then
			return
		end

		b.Text = text .. ": " ..
			(State[key] and "ON" or "OFF")

		if State[key] then
			b.BackgroundColor3 = Theme.Accent
		else
			b.BackgroundColor3 = Theme.Panel2
		end
	end

	b = Button(parent, text, function()
		State[key] = not State[key]

		refresh()

		if callback then
			local success, err = pcall(
				callback,
				State[key]
			)

			if not success then
				warn("[SillyHub V3] Toggle error:", err)
			end
		end

		refresh()
	end)

	refresh()

	return b
end

local function Input(parent, placeholder, default, callback)
	local box = Instance.new("TextBox")
	box.Name = "Input_" .. placeholder
	box.Size = UDim2.new(1, 0, 0, 38)
	box.BackgroundColor3 = Theme.Panel2
	box.BorderSizePixel = 0
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = placeholder
	box.Text = default or ""
	box.TextColor3 = Theme.Text
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.LayoutOrder = #parent:GetChildren() + 1
	box.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = box

	box.FocusLost:Connect(function()
		if callback then
			local success, err = pcall(
				callback,
				box.Text
			)

			if not success then
				warn("[SillyHub V3] Input error:", err)
			end
		end
	end)

	return box
end

local function Slider(parent, text, key, min, max, callback)
	local holder = Instance.new("Frame")
	holder.Name = "Slider_" .. text
	holder.Size = UDim2.new(1, 0, 0, 65)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = #parent:GetChildren() + 1
	holder.Parent = parent

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -100, 0, 22)
	label.Font = Enum.Font.GothamMedium
	label.Text = text
	label.TextColor3 = Theme.Text
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local value = Instance.new("TextBox")
	value.Position = UDim2.new(1, -90, 0, 0)
	value.Size = UDim2.new(0, 90, 0, 24)
	value.BackgroundColor3 = Theme.Panel2
	value.BorderSizePixel = 0
	value.Font = Enum.Font.Gotham
	value.Text = tostring(State[key] or min)
	value.TextColor3 = Theme.Text
	value.TextSize = 11
	value.ClearTextOnFocus = false
	value.Parent = holder

	local valueCorner = Instance.new("UICorner")
	valueCorner.CornerRadius = UDim.new(0, 6)
	valueCorner.Parent = value

	local bar = Instance.new("Frame")
	bar.Position = UDim2.new(0, 0, 0, 34)
	bar.Size = UDim2.new(1, 0, 0, 8)
	bar.BackgroundColor3 = Theme.Panel2
	bar.BorderSizePixel = 0
	bar.Parent = holder

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = bar

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local draggingSlider = false

	local function setValue(v, runCallback)
		v = math.clamp(
			tonumber(v) or min,
			min,
			max
		)

		State[key] = v

		value.Text = tostring(
			math.floor(v * 100) / 100
		)

		local percentage

		if max == min then
			percentage = 0
		else
			percentage =
				(v - min) /
				(max - min)
		end

		fill.Size = UDim2.new(
			percentage,
			0,
			1,
			0
		)

		if callback and runCallback ~= false then
			local success, err = pcall(
				callback,
				v
			)

			if not success then
				warn(
					"[SillyHub V3] Slider error:",
					err
				)
			end
		end
	end

	setValue(State[key] or min, false)

	bar.InputBegan:Connect(function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			draggingSlider = true

			local percentage =
				math.clamp(
					(
						input.Position.X -
						bar.AbsolutePosition.X
					) / bar.AbsoluteSize.X,
					0,
					1
				)

			setValue(
				min +
					percentage *
					(max - min)
			)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingSlider
			and input.UserInputType ==
			Enum.UserInputType.MouseMovement then

			local percentage =
				math.clamp(
					(
						input.Position.X -
						bar.AbsolutePosition.X
					) / bar.AbsoluteSize.X,
					0,
					1
				)

			setValue(
				min +
					percentage *
					(max - min)
			)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			draggingSlider = false
		end
	end)

	value.FocusLost:Connect(function()
		local number = tonumber(value.Text)

		if number then
			setValue(number)
		else
			value.Text = tostring(State[key])
		end
	end)

	return holder
end

--==================================================
-- TABS
--==================================================

local PlayerPage = CreateTab("Player", 1)
local CombatPage = CreateTab("Combat", 2)
local MovementPage = CreateTab("Movement", 3)
local CameraPage = CreateTab("Camera", 4)
local VisualPage = CreateTab("Visual", 5)
local WorldPage = CreateTab("World", 6)
local UtilityPage = CreateTab("Utility", 7)
local ServerPage = CreateTab("Server", 8)
local PerformancePage = CreateTab("Performance", 9)
local NotificationsPage = CreateTab("Notifications", 10)
local ThemePage = CreateTab("Theme", 11)
local SettingsPage = CreateTab("Settings", 12)

--==================================================
-- PLAYER TAB
--==================================================

Section(PlayerPage, "CHARACTER")

Toggle(
	PlayerPage,
	"Godmode",
	"Godmode",
	function(on)
		Notify(
			"Godmode",
			on and
				"Godmode enabled."
				or
				"Godmode disabled.",
			"Movement"
		)

		if on then
			local humanoid = getHumanoid()

			if humanoid then
				humanoid.Health =
					humanoid.MaxHealth
			end
		end
	end
)

Button(
	PlayerPage,
	"Respawn Character",
	function()
		pcall(function()
			LP:LoadCharacter()
		end)

		Notify(
			"Respawn",
			"Character respawn requested.",
			"Utility"
		)
	end
)

Toggle(
	PlayerPage,
	"Freeze Character",
	"Frozen",
	function(on)
		local humanoid = getHumanoid()
		local root = getRoot()

		if humanoid then
			if on then
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0

				if root then
					root.AssemblyLinearVelocity =
						Vector3.zero
				end
			else
				humanoid.WalkSpeed =
					State.WalkSpeed

				humanoid.JumpPower =
					State.JumpPower
			end
		end

		Notify(
			"Freeze",
			on and
				"Character frozen."
				or
				"Character unfrozen.",
			"Movement"
		)
	end
)

Toggle(
	PlayerPage,
	"Platform Stand",
	"PlatformStand",
	function(on)
		local humanoid = getHumanoid()

		if humanoid then
			humanoid.PlatformStand = on
		end
	end
)

Toggle(
	PlayerPage,
	"Auto Rotate",
	"AutoRotate",
	function(on)
		local humanoid = getHumanoid()

		if humanoid then
			humanoid.AutoRotate = on
		end
	end
)

--==================================================
-- TELEPORT
--==================================================

Section(PlayerPage, "TELEPORT")

Slider(
	PlayerPage,
	"Random Radius",
	"RandomRadius",
	1,
	10000
)

Button(
	PlayerPage,
	"Save Current Position",
	function()
		local root = getRoot()

		if root then
			State.SavedPosition =
				root.CFrame

			Notify(
				"Position Saved",
				"Current position saved.",
				"Utility"
			)
		end
	end
)

Button(
	PlayerPage,
	"Teleport To Saved Position",
	function()
		local root = getRoot()

		if State.SavedPosition and root then
			root.CFrame =
				State.SavedPosition

			Notify(
				"Teleport",
				"Teleported to saved position.",
				"Teleport"
			)
		end
	end
)

Button(
	PlayerPage,
	"Random Teleport",
	function()
		local root = getRoot()

		if root then
			local radius =
				math.floor(State.RandomRadius)

			root.CFrame =
				root.CFrame +
				Vector3.new(
					math.random(
						-radius,
						radius
					),
					math.random(
						0,
						radius
					),
					math.random(
						-radius,
						radius
					)
				)

			Notify(
				"Random Teleport",
				"Teleported randomly.",
				"Teleport"
			)
		end
	end
)

Toggle(
	PlayerPage,
	"Repeat Teleport",
	"RepeatTeleport",
	function(on)
		Notify(
			"Repeat Teleport",
			on and
				"Repeat teleport enabled."
				or
				"Repeat teleport disabled.",
			"Teleport"
		)

		if on and not State.SavedPosition then
			local root = getRoot()

			if root then
				State.SavedPosition =
					root.CFrame
			end
		end
	end
)

Toggle(
	PlayerPage,
	"Random Teleport Loop",
	"RandomTeleport",
	function(on)
		Notify(
			"Random Teleport Loop",
			on and
				"Random teleport loop enabled."
				or
				"Random teleport loop disabled.",
			"Teleport"
		)
	end
)

Slider(
	PlayerPage,
	"Random Teleport Interval",
	"RandomTeleportInterval",
	0.05,
	10
)

--==================================================
-- AVATAR SPOOFER
--==================================================

Section(
	PlayerPage,
	"AVATAR SPOOFER"
)

local AvatarBox = Input(
	PlayerPage,
	"Enter Roblox User ID",
	"",
	function()
	end
)

Button(
	PlayerPage,
	"Load Avatar From User ID",
	function()
		local userId =
			tonumber(AvatarBox.Text)

		if not userId then
			Notify(
				"Avatar Error",
				"Enter a numeric User ID.",
				"Avatar"
			)

			return
		end

		local humanoid =
			getHumanoid()

		if not humanoid then
			Notify(
				"Avatar Error",
				"Humanoid unavailable.",
				"Avatar"
			)

			return
		end

		Notify(
			"Avatar",
			"Loading avatar...",
			"Avatar"
		)

		task.spawn(function()
			local success, description =
				pcall(function()
					return Players:
					GetHumanoidDescriptionFromUserIdAsync(
						userId
					)
				end)

			if not success or not description then
				Notify(
					"Avatar Error",
					"Could not retrieve that avatar.",
					"Avatar"
				)

				return
			end

			local applied, err =
				pcall(function()
					humanoid:
					ApplyDescriptionResetAsync(
						description
					)
				end)

			if applied then
				Notify(
					"Avatar Changed",
					"Avatar successfully applied.",
					"Avatar"
				)
			else
				Notify(
					"Avatar Error",
					tostring(err),
					"Avatar"
				)
			end
		end)
	end
)

--==================================================
-- ORBIT
--==================================================

Section(
	PlayerPage,
	"ORBIT PLAYER"
)

local OrbitTargetBox = Input(
	PlayerPage,
	"Player username or display name",
	"",
	function(text)
		State.OrbitTarget = text
	end
)

Slider(
	PlayerPage,
	"Orbit Radius",
	"OrbitRadius",
	1,
	500
)

Slider(
	PlayerPage,
	"Orbit Speed",
	"OrbitSpeed",
	0.1,
	20
)

Slider(
	PlayerPage,
	"Orbit Height",
	"OrbitHeight",
	-100,
	100
)

Button(
	PlayerPage,
	"Find Target Player",
	function()
		local target =
			findPlayer(
				OrbitTargetBox.Text
			)

		if target then
			State.OrbitTarget =
				target.Name

			OrbitTargetBox.Text =
				target.Name

			Notify(
				"Orbit Target",
				"Target set to " ..
					target.DisplayName .. ".",
				"Movement"
			)
		else
			Notify(
				"Orbit Error",
				"Player not found.",
				"Movement"
			)
		end
	end
)

Toggle(
	PlayerPage,
	"Orbit Player",
	"Orbit",
	function(on)
		if not on then
			Notify(
				"Orbit",
				"Orbit disabled.",
				"Movement"
			)

			return
		end

		local target =
			findPlayer(
				State.OrbitTarget
			)

		if not target or target == LP then
			State.Orbit = false

			Notify(
				"Orbit Error",
				"Enter a valid player first.",
				"Movement"
			)

			return
		end

		State.OrbitTarget =
			target.Name

		State.OrbitAngle = 0

		Notify(
			"Orbit",
			"Orbiting " ..
				target.DisplayName .. ".",
			"Movement"
		)
	end
)

Button(
	PlayerPage,
	"Orbit Nearest Player",
	function()
		local myRoot =
			getRoot()

		if not myRoot then
			return
		end

		local closest
		local closestDistance =
			math.huge

		for _, player in ipairs(
			Players:GetPlayers()
			) do
			if player ~= LP then
				local character =
					player.Character

				local root =
					character and
					character:FindFirstChild(
						"HumanoidRootPart"
					)

				if root then
					local distance =
						(
							root.Position -
							myRoot.Position
						).Magnitude

					if distance <
						closestDistance then

						closestDistance =
							distance

						closest =
							player
					end
				end
			end
		end

		if closest then
			State.OrbitTarget =
				closest.Name

			OrbitTargetBox.Text =
				closest.Name

			State.Orbit = true
			State.OrbitAngle = 0

			Notify(
				"Orbit",
				"Orbiting nearest player: " ..
					closest.DisplayName,
				"Movement"
			)
		end
	end
)

--==================================================
-- COMBAT
--==================================================

Section(
	CombatPage,
	"AIM ASSIST"
)

local AimHolding = false

local AimCircleGui = Instance.new("ScreenGui")
AimCircleGui.Name = "SillyHubAimCircle"
AimCircleGui.ResetOnSpawn = false
AimCircleGui.IgnoreGuiInset = true
AimCircleGui.DisplayOrder = 998
AimCircleGui.Parent = PlayerGui

local AimCircle = Instance.new("Frame")
AimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
AimCircle.Position = UDim2.fromScale(0.5, 0.5)
AimCircle.Size =
	UDim2.fromOffset(
		State.AimFOV * 2,
		State.AimFOV * 2
	)
AimCircle.BackgroundTransparency = 1
AimCircle.Visible = false
AimCircle.Parent = AimCircleGui

local AimCircleCorner = Instance.new("UICorner")
AimCircleCorner.CornerRadius = UDim.new(1, 0)
AimCircleCorner.Parent = AimCircle

local AimCircleStroke = Instance.new("UIStroke")
AimCircleStroke.Color = Theme.Accent
AimCircleStroke.Thickness = 1
AimCircleStroke.Transparency = 0.25
AimCircleStroke.Parent = AimCircle

local AimIndicator = Instance.new("TextLabel")
AimIndicator.AnchorPoint = Vector2.new(0.5, 0)
AimIndicator.Position =
	UDim2.new(0.5, 0, 0.5, 20)
AimIndicator.Size =
	UDim2.fromOffset(400, 25)
AimIndicator.BackgroundTransparency = 1
AimIndicator.Font = Enum.Font.GothamBold
AimIndicator.TextColor3 = Theme.Accent
AimIndicator.TextSize = 13
AimIndicator.Text = ""
AimIndicator.Visible = false
AimIndicator.Parent = AimCircleGui

local AimHighlight = Instance.new("Highlight")
AimHighlight.Name = "SillyHubAimTarget"
AimHighlight.FillColor = Theme.Accent
AimHighlight.OutlineColor = Theme.Accent
AimHighlight.FillTransparency = 0.8
AimHighlight.OutlineTransparency = 0.1
AimHighlight.DepthMode =
	Enum.HighlightDepthMode.AlwaysOnTop
AimHighlight.Enabled = false
AimHighlight.Parent = workspace

local function GetAimPart(character)
	if not character then
		return nil
	end

	local names = {
		Head = {
			"Head",
			"HumanoidRootPart",
			"UpperTorso",
		},

		HumanoidRootPart = {
			"HumanoidRootPart",
			"UpperTorso",
			"Head",
		},

		UpperTorso = {
			"UpperTorso",
			"HumanoidRootPart",
			"Head",
		},
	}

	for _, name in ipairs(
		names[State.AimTargetPart] or names.Head
		) do
		local part =
			character:FindFirstChild(name)

		if part and part:IsA("BasePart") then
			return part
		end
	end

	return nil
end

local function IsAimTargetValid(player)
	if not player or player == LP then
		return false
	end

	if State.AimTeamCheck then
		if LP.Team ~= nil
			and player.Team == LP.Team then

			return false
		end
	end

	local character =
		player.Character

	if not character then
		return false
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	if not humanoid or humanoid.Health <= 0 then
		return false
	end

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	local camera =
		workspace.CurrentCamera

	if not root or not camera then
		return false
	end

	local distance =
		(
			root.Position -
			camera.CFrame.Position
		).Magnitude

	if distance > State.AimRange then
		return false
	end

	return GetAimPart(character) ~= nil
end

local function AimHasLineOfSight(part)
	if not State.AimWallCheck then
		return true
	end

	local camera =
		workspace.CurrentCamera

	if not camera or not part then
		return false
	end

	local params =
		RaycastParams.new()

	params.FilterType =
		Enum.RaycastFilterType.Exclude

	params.FilterDescendantsInstances = {
		LP.Character,
	}

	params.IgnoreWater = true

	local direction =
		part.Position -
		camera.CFrame.Position

	local result =
		workspace:Raycast(
			camera.CFrame.Position,
			direction,
			params
		)

	if not result then
		return true
	end

	return result.Instance:IsDescendantOf(
		part.Parent
	)
end

local function GetAimTarget()
	local camera =
		workspace.CurrentCamera

	if not camera then
		return nil
	end

	local center =
		camera.ViewportSize / 2

	local bestPlayer = nil
	local bestScore = math.huge

	for _, player in ipairs(
		Players:GetPlayers()
		) do
		if IsAimTargetValid(player) then
			local character =
				player.Character

			local part =
				GetAimPart(character)

			if part and AimHasLineOfSight(part) then
				local screenPosition, onScreen =
					camera:WorldToViewportPoint(
						part.Position
					)

				if onScreen
					and screenPosition.Z > 0 then

					local screenDistance =
						(
							Vector2.new(
								screenPosition.X,
								screenPosition.Y
							) - center
						).Magnitude

					if screenDistance <=
						State.AimFOV then

						local score

						if State.AimPriority ==
							"Distance" then

							local root =
								character:FindFirstChild(
									"HumanoidRootPart"
								)

							score =
								root
								and (
									root.Position -
									camera.CFrame.Position
								).Magnitude
								or math.huge

						elseif State.AimPriority ==
							"Health" then

							local humanoid =
								character:FindFirstChildOfClass(
									"Humanoid"
								)

							score =
								humanoid
								and humanoid.Health
								or math.huge
						else
							score =
								screenDistance
						end

						if score < bestScore then
							bestScore = score
							bestPlayer = player
						end
					end
				end
			end
		end
	end

	return bestPlayer
end

local function ClearAimTarget()
	State.AimTarget = nil

	AimHighlight.Adornee = nil
	AimHighlight.Enabled = false

	AimIndicator.Text = ""
	AimIndicator.Visible = false
end

local function UpdateAimTarget()
	if not State.Aimbot then
		ClearAimTarget()
		return
	end

	if State.AimHoldMode
		and not AimHolding then

		ClearAimTarget()
		return
	end

	if State.AimSticky
		and State.AimTarget
		and IsAimTargetValid(
			State.AimTarget
		) then

		local part =
			GetAimPart(
				State.AimTarget.Character
			)

		if part
			and AimHasLineOfSight(part) then

			return
		end
	end

	if State.AimAutoSwitch
		or not State.AimTarget then

		State.AimTarget =
			GetAimTarget()
	end
end

local function UpdateAimVisuals()
	AimCircle.Visible =
		State.Aimbot
		and State.AimFOVCircle

	AimCircle.Size =
		UDim2.fromOffset(
			State.AimFOV * 2,
			State.AimFOV * 2
		)

	AimCircleStroke.Color =
		Theme.Accent

	AimIndicator.TextColor3 =
		Theme.Accent

	if State.AimTarget
		and IsAimTargetValid(
			State.AimTarget
		) then

		local target =
			State.AimTarget

		AimIndicator.Text =
			"TARGET: " ..
			target.DisplayName

		AimIndicator.Visible =
			State.AimTargetIndicator

		if State.AimTargetHighlight then
			AimHighlight.Adornee =
				target.Character

			AimHighlight.FillColor =
				Theme.Accent

			AimHighlight.OutlineColor =
				Theme.Accent

			AimHighlight.Enabled = true
		else
			AimHighlight.Enabled = false
		end
	else
		AimHighlight.Enabled = false
		AimIndicator.Visible = false
	end
end

local function PerformAim()
	if not State.Aimbot then
		return
	end

	if State.AimHoldMode
		and not AimHolding then

		return
	end

	local target =
		State.AimTarget

	if not target
		or not IsAimTargetValid(target) then

		return
	end

	local camera =
		workspace.CurrentCamera

	local character =
		target.Character

	local part =
		GetAimPart(character)

	if not camera or not part then
		return
	end

	if not AimHasLineOfSight(part) then
		return
	end

	local predictedPosition =
		part.Position +
		part.AssemblyLinearVelocity *
		State.AimPrediction

	local desired =
		CFrame.lookAt(
			camera.CFrame.Position,
			predictedPosition
		)

	local smooth =
		math.clamp(
			State.AimSmoothness,
			0.01,
			1
		)

	camera.CFrame =
		camera.CFrame:Lerp(
			desired,
			smooth
		)
end

local AimKeyButton

AimKeyButton = Button(
	CombatPage,
	"Aim Key: Q",
	function()
		if State.AimKey == Enum.KeyCode.Q then
			State.AimKey = Enum.KeyCode.E
		elseif State.AimKey == Enum.KeyCode.E then
			State.AimKey = Enum.KeyCode.Q
		else
			State.AimKey = Enum.KeyCode.Q
		end

		AimKeyButton.Text =
			"Aim Key: " ..
			State.AimKey.Name
	end
)

Toggle(
	CombatPage,
	"Aimbot",
	"Aimbot",
	function(on)
		if not on then
			ClearAimTarget()
		end

		Notify(
			"Aimbot",
			on and
				"Aim assist enabled."
				or
				"Aim assist disabled.",
			"System"
		)
	end
)

Toggle(
	CombatPage,
	"Hold Aim Key",
	"AimHoldMode"
)

Slider(
	CombatPage,
	"FOV Radius",
	"AimFOV",
	25,
	600
)

Slider(
	CombatPage,
	"Maximum Range",
	"AimRange",
	25,
	5000
)

Slider(
	CombatPage,
	"Aim Smoothness",
	"AimSmoothness",
	0.01,
	1
)

Slider(
	CombatPage,
	"Prediction",
	"AimPrediction",
	0,
	1
)

local TargetPartButton

TargetPartButton = Button(
	CombatPage,
	"Target Part: Head",
	function()
		if State.AimTargetPart == "Head" then
			State.AimTargetPart =
				"HumanoidRootPart"
		elseif State.AimTargetPart ==
			"HumanoidRootPart" then

			State.AimTargetPart =
				"UpperTorso"
		else
			State.AimTargetPart =
				"Head"
		end

		TargetPartButton.Text =
			"Target Part: " ..
			State.AimTargetPart
	end
)

local PriorityButton

PriorityButton = Button(
	CombatPage,
	"Priority: Crosshair",
	function()
		if State.AimPriority ==
			"Crosshair" then

			State.AimPriority =
				"Distance"

		elseif State.AimPriority ==
			"Distance" then

			State.AimPriority =
				"Health"

		else
			State.AimPriority =
				"Crosshair"
		end

		PriorityButton.Text =
			"Priority: " ..
			State.AimPriority
	end
)

Toggle(
	CombatPage,
	"Team Check",
	"AimTeamCheck"
)

Toggle(
	CombatPage,
	"Wall Check",
	"AimWallCheck"
)

Toggle(
	CombatPage,
	"Sticky Target",
	"AimSticky"
)

Toggle(
	CombatPage,
	"Auto Switch",
	"AimAutoSwitch"
)

Toggle(
	CombatPage,
	"FOV Circle",
	"AimFOVCircle"
)

Toggle(
	CombatPage,
	"Target Highlight",
	"AimTargetHighlight"
)

Toggle(
	CombatPage,
	"Target Indicator",
	"AimTargetIndicator"
)

Button(
	CombatPage,
	"Lock Nearest Target",
	function()
		local target =
			GetAimTarget()

		if target then
			State.AimTarget =
				target

			Notify(
				"Aim Target",
				"Locked onto " ..
					target.DisplayName .. ".",
				"System"
			)
		else
			Notify(
				"Aim Target",
				"No valid target found.",
				"System"
			)
		end
	end
)

Button(
	CombatPage,
	"Clear Target",
	function()
		ClearAimTarget()

		Notify(
			"Aim Target",
			"Target cleared.",
			"System"
		)
	end
)

--==================================================
-- MOVEMENT
--==================================================

Section(
	MovementPage,
	"MOVEMENT"
)

Slider(
	MovementPage,
	"Walk Speed",
	"WalkSpeed",
	0,
	10000,
	function(value)
		local humanoid =
			getHumanoid()

		if humanoid and not State.Frozen then
			humanoid.WalkSpeed =
				value
		end
	end
)

Slider(
	MovementPage,
	"Jump Power",
	"JumpPower",
	0,
	10000,
	function(value)
		local humanoid =
			getHumanoid()

		if humanoid and not State.Frozen then
			humanoid.JumpPower =
				value
		end
	end
)

Slider(
	MovementPage,
	"Gravity",
	"Gravity",
	0,
	10000,
	function(value)
		workspace.Gravity = value
	end
)

Slider(
	MovementPage,
	"Hip Height",
	"HipHeight",
	0,
	1000,
	function(value)
		local humanoid =
			getHumanoid()

		if humanoid then
			humanoid.HipHeight =
				value
		end
	end
)

Toggle(
	MovementPage,
	"Noclip",
	"Noclip",
	function(on)
		Notify(
			"Noclip",
			on and
				"Noclip enabled."
				or
				"Noclip disabled.",
			"Movement"
		)
	end
)

Toggle(
	MovementPage,
	"Infinite Jump",
	"InfiniteJump",
	function(on)
		Notify(
			"Infinite Jump",
			on and
				"Infinite jump enabled."
				or
				"Infinite jump disabled.",
			"Movement"
		)
	end
)

--==================================================
-- FLIGHT
--==================================================

Section(
	MovementPage,
	"FLIGHT"
)

Slider(
	MovementPage,
	"Flight Speed",
	"FlightSpeed",
	1,
	10000
)

Slider(
	MovementPage,
	"Vertical Flight Speed",
	"VerticalFlightSpeed",
	1,
	10000
)

Toggle(
	MovementPage,
	"Flight",
	"Flight",
	function(on)
		local humanoid =
			getHumanoid()

		if humanoid then
			if on then
				humanoid.PlatformStand =
					true
			else
				humanoid.PlatformStand =
					State.PlatformStand
			end
		end

		Notify(
			"Flight",
			on and
				"Flight enabled. WASD + Space/Ctrl."
				or
				"Flight disabled.",
			"Movement"
		)
	end
)

--==================================================
-- SPIN
--==================================================

Section(
	MovementPage,
	"SPIN"
)

Slider(
	MovementPage,
	"Spin Speed",
	"SpinSpeed",
	0,
	10000
)

Toggle(
	MovementPage,
	"Spin",
	"Spin",
	function(on)
		Notify(
			"Spin",
			on and
				"Spin enabled."
				or
				"Spin disabled.",
			"Movement"
		)
	end
)

Toggle(
	MovementPage,
	"Camera Follows Spin",
	"CameraFollowsSpin"
)

--==================================================
-- CAMERA
--==================================================

Section(
	CameraPage,
	"CAMERA"
)

Slider(
	CameraPage,
	"Field Of View",
	"FOV",
	1,
	180,
	function(value)
		local camera =
			workspace.CurrentCamera

		if camera then
			camera.FieldOfView =
				value
		end
	end
)

Slider(
	CameraPage,
	"Camera Distance",
	"CameraDistance",
	1,
	10000
)

Slider(
	CameraPage,
	"Camera Sensitivity",
	"CameraSensitivity",
	0,
	100
)

Section(
	CameraPage,
	"FREECAM"
)

Slider(
	CameraPage,
	"Freecam Speed",
	"FreecamSpeed",
	1,
	5000
)

Toggle(
	CameraPage,
	"Freecam",
	"Freecam",
	function(on)
		local camera =
			workspace.CurrentCamera

		if not camera then
			return
		end

		if on then
			camera.CameraType =
				Enum.CameraType.Scriptable

			Notify(
				"Freecam",
				"Freecam enabled. WASD + Space/Ctrl + mouse.",
				"Utility"
			)
		else
			camera.CameraType =
				Enum.CameraType.Custom

			local humanoid =
				getHumanoid()

			if humanoid then
				camera.CameraSubject =
					humanoid
			end

			Notify(
				"Freecam",
				"Freecam disabled.",
				"Utility"
			)
		end
	end
)

Button(
	CameraPage,
	"Reset Camera",
	function()
		State.FOV = 70
		State.Freecam = false

		local camera =
			workspace.CurrentCamera

		if camera then
			camera.CameraType =
				Enum.CameraType.Custom

			camera.FieldOfView =
				70

			local humanoid =
				getHumanoid()

			if humanoid then
				camera.CameraSubject =
					humanoid
			end
		end

		Notify(
			"Camera",
			"Camera reset.",
			"Utility"
		)
	end
)

--==================================================
-- VISUAL
--==================================================

Section(
	VisualPage,
	"PLAYER ESP"
)

Toggle(
	VisualPage,
	"ESP",
	"ESP"
)

Toggle(
	VisualPage,
	"Names",
	"Names"
)

Toggle(
	VisualPage,
	"Distance",
	"Distance"
)

Toggle(
	VisualPage,
	"Health",
	"Health"
)

Toggle(
	VisualPage,
	"Health Bars",
	"HealthBars"
)

Toggle(
	VisualPage,
	"Tracers",
	"Tracers"
)

Toggle(
	VisualPage,
	"Head Dots",
	"HeadDots"
)

Slider(
	VisualPage,
	"ESP Fill Transparency",
	"ESPFill",
	0,
	100
)

Slider(
	VisualPage,
	"ESP Outline Transparency",
	"ESPOutline",
	0,
	100
)

--==================================================
-- NAME SPOOFER
--==================================================

Section(
	VisualPage,
	"NAME SPOOFER"
)

local FakeNameBox = Input(
	VisualPage,
	"Fake display name",
	"",
	function(text)
		State.FakeName = text
	end
)

Button(
	VisualPage,
	"Apply Fake Name",
	function()
		if State.FakeName == "" then
			Notify(
				"Name Spoofer",
				"Enter a name first.",
				"Visual"
			)

			return
		end

		Notify(
			"Name Spoofer",
			"Local fake name set to " ..
				State.FakeName,
			"Visual"
		)
	end
)

Button(
	VisualPage,
	"Clear Fake Name",
	function()
		State.FakeName = ""
		FakeNameBox.Text = ""

		Notify(
			"Name Spoofer",
			"Fake name cleared.",
			"Visual"
		)
	end
)

--==================================================
-- SCREEN OVERLAY
--==================================================

Section(
	VisualPage,
	"SCREEN OVERLAY"
)

Button(
	VisualPage,
	"Create Crosshair",
	function()
		local existing =
			PlayerGui:FindFirstChild(
				"SillyHubCrosshair"
			)

		if existing then
			existing:Destroy()

			Notify(
				"Crosshair",
				"Crosshair removed.",
				"Visual"
			)

			return
		end

		local screenGui =
			Instance.new("ScreenGui")

		screenGui.Name =
			"SillyHubCrosshair"

		screenGui.ResetOnSpawn =
			false

		screenGui.IgnoreGuiInset =
			true

		screenGui.DisplayOrder =
			900

		screenGui.Parent =
			PlayerGui

		local horizontal =
			Instance.new("Frame")

		horizontal.AnchorPoint =
			Vector2.new(0.5, 0.5)

		horizontal.Position =
			UDim2.fromScale(0.5, 0.5)

		horizontal.Size =
			UDim2.new(0, 20, 0, 2)

		horizontal.BackgroundColor3 =
			Theme.Accent

		horizontal.BorderSizePixel =
			0

		horizontal.Parent =
			screenGui

		local vertical =
			Instance.new("Frame")

		vertical.AnchorPoint =
			Vector2.new(0.5, 0.5)

		vertical.Position =
			UDim2.fromScale(0.5, 0.5)

		vertical.Size =
			UDim2.new(0, 2, 0, 20)

		vertical.BackgroundColor3 =
			Theme.Accent

		vertical.BorderSizePixel =
			0

		vertical.Parent =
			screenGui

		Notify(
			"Crosshair",
			"Crosshair created.",
			"Visual"
		)
	end
)

--==================================================
-- WORLD
--==================================================

Section(
	WorldPage,
	"LIGHTING"
)

Toggle(
	WorldPage,
	"Fullbright",
	"Fullbright",
	function(on)
		if on then
			Lighting.Brightness = 10
			Lighting.ClockTime = 14
			Lighting.GlobalShadows = false
		else
			Lighting.Brightness =
				State.Brightness

			Lighting.ClockTime =
				State.ClockTime

			Lighting.GlobalShadows =
				State.GlobalShadows
		end
	end
)

Toggle(
	WorldPage,
	"No Fog",
	"NoFog",
	function(on)
		if not on then
			Lighting.FogStart =
				OriginalLighting.FogStart

			Lighting.FogEnd =
				OriginalLighting.FogEnd
		end
	end
)

Slider(
	WorldPage,
	"Brightness",
	"Brightness",
	0,
	10000,
	function(value)
		Lighting.Brightness =
			value
	end
)

Slider(
	WorldPage,
	"Exposure",
	"Exposure",
	-10000,
	10000,
	function(value)
		Lighting.ExposureCompensation =
			value
	end
)

Slider(
	WorldPage,
	"Clock Time",
	"ClockTime",
	0,
	24,
	function(value)
		Lighting.ClockTime =
			value
	end
)

Toggle(
	WorldPage,
	"Global Shadows",
	"GlobalShadows",
	function(on)
		Lighting.GlobalShadows =
			on
	end
)

--==================================================
-- UTILITY
--==================================================

Section(
	UtilityPage,
	"CHARACTER"
)

Button(
	UtilityPage,
	"Sit",
	function()
		local humanoid =
			getHumanoid()

		if humanoid then
			humanoid.Sit = true
		end
	end
)

Button(
	UtilityPage,
	"Reset Character",
	function()
		pcall(function()
			LP:LoadCharacter()
		end)

		Notify(
			"Reset",
			"Character reset requested.",
			"Utility"
		)
	end
)

Button(
	UtilityPage,
	"Copy Coordinates",
	function()
		local root =
			getRoot()

		if not root then
			return
		end

		local position =
			root.Position

		local text =
			string.format(
				"%.3f, %.3f, %.3f",
				position.X,
				position.Y,
				position.Z
			)

		if setclipboard then
			pcall(function()
				setclipboard(text)
			end)

			Notify(
				"Coordinates",
				"Coordinates copied.",
				"Utility"
			)
		else
			print(text)
		end
	end
)

Section(
	UtilityPage,
	"POSITION"
)

Button(
	UtilityPage,
	"Save Position",
	function()
		local root =
			getRoot()

		if root then
			State.SavedPosition =
				root.CFrame

			Notify(
				"Position Saved",
				"Position saved.",
				"Utility"
			)
		end
	end
)

Button(
	UtilityPage,
	"Teleport To Saved",
	function()
		local root =
			getRoot()

		if root and State.SavedPosition then
			root.CFrame =
				State.SavedPosition

			Notify(
				"Teleport",
				"Teleported to saved position.",
				"Teleport"
			)
		end
	end
)

Section(
	UtilityPage,
	"MISC"
)

Button(
	UtilityPage,
	"Rejoin Server",
	function()
		Notify(
			"Rejoin",
			"Rejoining server...",
			"Utility"
		)

		task.wait(0.2)

		pcall(function()
			TeleportService:
				TeleportToPlaceInstance(
					game.PlaceId,
					game.JobId,
					LP
				)
		end)
	end
)

Button(
	UtilityPage,
	"Print Character Info",
	function()
		local humanoid =
			getHumanoid()

		local root =
			getRoot()

		if humanoid and root then
			print(
				"===== SillyHub V3 Character Info ====="
			)

			print(
				"Position:",
				root.Position
			)

			print(
				"Velocity:",
				root.AssemblyLinearVelocity
			)

			print(
				"WalkSpeed:",
				humanoid.WalkSpeed
			)

			print(
				"JumpPower:",
				humanoid.JumpPower
			)

			print(
				"Health:",
				humanoid.Health
			)

			print(
				"MaxHealth:",
				humanoid.MaxHealth
			)
		end

		Notify(
			"Character Info",
			"Information printed to Output.",
			"Utility"
		)
	end
)

--==================================================
-- SERVER
--==================================================

Section(
	ServerPage,
	"SERVER INFORMATION"
)

local ServerInfo =
	Instance.new("TextLabel")

ServerInfo.Size =
	UDim2.new(1, 0, 0, 120)

ServerInfo.BackgroundColor3 =
	Theme.Panel2

ServerInfo.BorderSizePixel =
	0

ServerInfo.Font =
	Enum.Font.Code

ServerInfo.TextColor3 =
	Theme.Text

ServerInfo.TextSize =
	12

ServerInfo.TextWrapped =
	true

ServerInfo.TextXAlignment =
	Enum.TextXAlignment.Left

ServerInfo.TextYAlignment =
	Enum.TextYAlignment.Top

ServerInfo.Parent =
	ServerPage

local ServerInfoCorner =
	Instance.new("UICorner")

ServerInfoCorner.CornerRadius =
	UDim.new(0, 8)

ServerInfoCorner.Parent =
	ServerInfo

local function UpdateServerInfo()
	ServerInfo.Text =
		"Players: " ..
		#Players:GetPlayers() ..

		"\nPlace ID: " ..
		game.PlaceId ..

		"\nJob ID: " ..
		game.JobId ..

		"\nLocal User ID: " ..
		LP.UserId
end

UpdateServerInfo()

Button(
	ServerPage,
	"Refresh Server Info",
	function()
		UpdateServerInfo()

		Notify(
			"Server",
			"Server information refreshed.",
			"System"
		)
	end
)

Button(
	ServerPage,
	"Rejoin Server",
	function()
		pcall(function()
			TeleportService:
				Teleport(
					game.PlaceId,
					LP
				)
		end)
	end
)

--==================================================
-- PERFORMANCE
--==================================================

Section(
	PerformancePage,
	"MONITORS"
)

local PerfLabel =
	Instance.new("TextLabel")

PerfLabel.Size =
	UDim2.new(1, 0, 0, 80)

PerfLabel.BackgroundColor3 =
	Theme.Panel2

PerfLabel.BorderSizePixel =
	0

PerfLabel.Font =
	Enum.Font.Code

PerfLabel.TextColor3 =
	Theme.Text

PerfLabel.TextSize =
	13

PerfLabel.Text =
	"FPS: --\nPing: --"

PerfLabel.TextXAlignment =
	Enum.TextXAlignment.Left

PerfLabel.Parent =
	PerformancePage

local PerfCorner =
	Instance.new("UICorner")

PerfCorner.CornerRadius =
	UDim.new(0, 8)

PerfCorner.Parent =
	PerfLabel

Toggle(
	PerformancePage,
	"FPS Counter",
	"FPSCounter"
)

Toggle(
	PerformancePage,
	"Ping Counter",
	"PingCounter"
)

--==================================================
-- NOTIFICATIONS TAB
--==================================================

Section(
	NotificationsPage,
	"NOTIFICATION SYSTEM"
)

Toggle(
	NotificationsPage,
	"Notifications",
	"Notifications"
)

Toggle(
	NotificationsPage,
	"Player Joined",
	"NotifyPlayerJoin"
)

Toggle(
	NotificationsPage,
	"Player Left",
	"NotifyPlayerLeave"
)

Toggle(
	NotificationsPage,
	"Teleport Notifications",
	"NotifyTeleport"
)

Toggle(
	NotificationsPage,
	"Movement Notifications",
	"NotifyMovement"
)

Toggle(
	NotificationsPage,
	"Visual Notifications",
	"NotifyVisual"
)

Toggle(
	NotificationsPage,
	"Utility Notifications",
	"NotifyUtility"
)

Toggle(
	NotificationsPage,
	"Avatar Notifications",
	"NotifyAvatar"
)

Toggle(
	NotificationsPage,
	"System Notifications",
	"NotifySystem"
)

Toggle(
	NotificationsPage,
	"Settings Notifications",
	"NotifySettings"
)

Toggle(
	NotificationsPage,
	"Notification Sound",
	"NotificationSound"
)

Section(
	NotificationsPage,
	"NOTIFICATION OPTIONS"
)

Slider(
	NotificationsPage,
	"Notification Duration",
	"NotificationDuration",
	1,
	30
)

Button(
	NotificationsPage,
	"Test Notification",
	function()
		Notify(
			"SillyHub Test",
			"This is a test notification.",
			"System"
		)
	end
)

Button(
	NotificationsPage,
	"Test Player Joined",
	function()
		Notify(
			"Player Joined",
			"ExamplePlayer joined the server.",
			"Player"
		)
	end
)

Button(
	NotificationsPage,
	"Test Player Left",
	function()
		Notify(
			"Player Left",
			"ExamplePlayer left the server.",
			"Player"
		)
	end
)

Section(
	NotificationsPage,
	"CUSTOM NOTIFICATION"
)

local CustomTitle =
	Input(
		NotificationsPage,
		"Notification title",
		"",
		function()
		end
	)

local CustomMessage =
	Input(
		NotificationsPage,
		"Notification message",
		"",
		function()
		end
	)

Button(
	NotificationsPage,
	"Send Custom Notification",
	function()
		local title =
			CustomTitle.Text ~= ""
			and CustomTitle.Text
			or "SillyHub"

		local message =
			CustomMessage.Text ~= ""
			and CustomMessage.Text
			or "Custom notification."

		Notify(
			title,
			message,
			"System"
		)
	end
)

--==================================================
-- THEME
--==================================================

Section(
	ThemePage,
	"RGB ACCENT"
)

local function ApplyThemeColor()
	Theme.Accent =
		Color3.fromRGB(
			State.ThemeR,
			State.ThemeG,
			State.ThemeB
		)

	MainStroke.Color =
		Theme.Accent

	AimCircleStroke.Color =
		Theme.Accent

	for _, button in pairs(
		TabButtons
		) do
		if button == TabButtons[CurrentPage] then
			button.BackgroundColor3 =
				Theme.Accent
		end
	end
end

Slider(
	ThemePage,
	"Red",
	"ThemeR",
	0,
	255,
	function()
		ApplyThemeColor()
	end
)

Slider(
	ThemePage,
	"Green",
	"ThemeG",
	0,
	255,
	function()
		ApplyThemeColor()
	end
)

Slider(
	ThemePage,
	"Blue",
	"ThemeB",
	0,
	255,
	function()
		ApplyThemeColor()
	end
)

Button(
	ThemePage,
	"Save Color",
	function()
		SavedColor =
			Theme.Accent

		Notify(
			"Theme",
			"Accent color saved.",
			"Settings"
		)
	end
)

Button(
	ThemePage,
	"Load Color",
	function()
		if not SavedColor then
			Notify(
				"Theme",
				"No saved color.",
				"Settings"
			)

			return
		end

		Theme.Accent =
			SavedColor

		local r, g, b =
			SavedColor:ToRGB()

		State.ThemeR = r
		State.ThemeG = g
		State.ThemeB = b

		ApplyThemeColor()

		Notify(
			"Theme",
			"Saved accent color loaded.",
			"Settings"
		)
	end
)

Button(
	ThemePage,
	"Purple Preset",
	function()
		State.ThemeR = 120
		State.ThemeG = 90
		State.ThemeB = 255

		ApplyThemeColor()
	end
)

Button(
	ThemePage,
	"Blue Preset",
	function()
		State.ThemeR = 70
		State.ThemeG = 140
		State.ThemeB = 255

		ApplyThemeColor()
	end
)

Button(
	ThemePage,
	"Green Preset",
	function()
		State.ThemeR = 80
		State.ThemeG = 220
		State.ThemeB = 120

		ApplyThemeColor()
	end
)

Button(
	ThemePage,
	"Red Preset",
	function()
		State.ThemeR = 255
		State.ThemeG = 80
		State.ThemeB = 80

		ApplyThemeColor()
	end
)

--==================================================
-- SETTINGS
--==================================================

Section(
	SettingsPage,
	"MENU"
)

local KeybindButton
local waitingForKey = false

KeybindButton =
	Button(
		SettingsPage,
		"Open/Close Key: RightShift",
		function()
			if waitingForKey then
				return
			end

			waitingForKey = true

			KeybindButton.Text =
			"Press a key..."

			Notify(
				"Keybind",
				"Press the key you want to use.",
				"Settings"
			)
		end
	)

Slider(
	SettingsPage,
	"Menu Scale",
	"MenuScale",
	50,
	200,
	function(value)
		Scale.Scale =
			value / 100
	end
)

Slider(
	SettingsPage,
	"Menu Transparency",
	"MenuTransparency",
	0,
	100,
	function(value)
		Main.BackgroundTransparency =
			value / 100
	end
)

Section(
	SettingsPage,
	"RESET"
)

Button(
	SettingsPage,
	"Reset Movement",
	function()
		State.WalkSpeed = 16
		State.JumpPower = 50
		State.Gravity = 196.2
		State.HipHeight = 2

		workspace.Gravity =
			196.2

		local humanoid =
			getHumanoid()

		if humanoid then
			humanoid.WalkSpeed =
				16

			humanoid.JumpPower =
				50

			humanoid.HipHeight =
				2
		end

		Notify(
			"Reset",
			"Movement settings reset.",
			"Settings"
		)
	end
)

Button(
	SettingsPage,
	"Reset Camera",
	function()
		State.FOV = 70
		State.Freecam = false

		local camera =
			workspace.CurrentCamera

		if camera then
			camera.CameraType =
				Enum.CameraType.Custom

			camera.FieldOfView =
				70

			local humanoid =
				getHumanoid()

			if humanoid then
				camera.CameraSubject =
					humanoid
			end
		end

		Notify(
			"Reset",
			"Camera settings reset.",
			"Settings"
		)
	end
)

Button(
	SettingsPage,
	"Reset Lighting",
	function()
		Lighting.Brightness =
			OriginalLighting.Brightness

		Lighting.ExposureCompensation =
			OriginalLighting.Exposure

		Lighting.ClockTime =
			OriginalLighting.ClockTime

		Lighting.GlobalShadows =
			OriginalLighting.GlobalShadows

		Lighting.FogStart =
			OriginalLighting.FogStart

		Lighting.FogEnd =
			OriginalLighting.FogEnd

		Notify(
			"Reset",
			"Lighting reset.",
			"Settings"
		)
	end
)

Button(
	SettingsPage,
	"Reset Everything",
	function()
		State.Godmode = false
		State.Noclip = false
		State.Flight = false
		State.Spin = false
		State.InfiniteJump = false
		State.Frozen = false
		State.Orbit = false
		State.Freecam = false
		State.RepeatTeleport = false
		State.RandomTeleport = false

		State.Aimbot = false
		State.AimTarget = nil

		workspace.Gravity =
			196.2

		local humanoid =
			getHumanoid()

		if humanoid then
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			humanoid.HipHeight = 2
			humanoid.AutoRotate = true
			humanoid.PlatformStand = false
		end

		local camera =
			workspace.CurrentCamera

		if camera then
			camera.CameraType =
				Enum.CameraType.Custom

			camera.FieldOfView =
				70
		end

		Lighting.Brightness =
			OriginalLighting.Brightness

		Lighting.ExposureCompensation =
			OriginalLighting.Exposure

		Lighting.ClockTime =
			OriginalLighting.ClockTime

		Lighting.GlobalShadows =
			OriginalLighting.GlobalShadows

		Lighting.FogStart =
			OriginalLighting.FogStart

		Lighting.FogEnd =
			OriginalLighting.FogEnd

		ClearAimTarget()

		Notify(
			"Reset",
			"Everything reset.",
			"Settings"
		)
	end
)

--==================================================
-- ESP SYSTEM
--==================================================

local ESPObjects = {}

local function removeESP(player)
	local data =
		ESPObjects[player]

	if not data then
		return
	end

	for _, object in ipairs(
		data.Objects or {}
		) do
		if object and object.Parent then
			object:Destroy()
		end
	end

	for _, connection in ipairs(
		data.Connections or {}
		) do
		if connection then
			connection:Disconnect()
		end
	end

	ESPObjects[player] = nil
end

local function createESP(player)
	if player == LP then
		return
	end

	removeESP(player)

	local character =
		player.Character

	if not character then
		return
	end

	local objects = {}
	local connections = {}

	ESPObjects[player] = {
		Objects = objects,
		Connections = connections,
	}

	-- HIGHLIGHT

	if State.ESP then
		local highlight =
			Instance.new("Highlight")

		highlight.Name =
			"SillyHubESP"

		highlight.Adornee =
			character

		highlight.FillColor =
			State.ESPColor

		highlight.FillTransparency =
			State.ESPFill / 100

		highlight.OutlineColor =
			State.ESPColor

		highlight.OutlineTransparency =
			State.ESPOutline / 100

		highlight.DepthMode =
			Enum.HighlightDepthMode.AlwaysOnTop

		highlight.Parent =
			character

		table.insert(
			objects,
			highlight
		)
	end

	local head =
		character:FindFirstChild("Head")

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	local adornee =
		head or root

	if adornee then
		local billboard =
			Instance.new("BillboardGui")

		billboard.Name =
			"SillyHubInfo"

		billboard.Adornee =
			adornee

		billboard.Size =
			UDim2.new(
				0,
				250,
				0,
				90
			)

		billboard.StudsOffset =
			Vector3.new(0, 3, 0)

		billboard.AlwaysOnTop =
			true

		billboard.Parent =
			adornee

		local text =
			Instance.new("TextLabel")

		text.BackgroundTransparency =
			1

		text.Size =
			UDim2.fromScale(1, 1)

		text.Font =
			Enum.Font.GothamBold

		text.TextColor3 =
			Color3.new(1, 1, 1)

		text.TextStrokeTransparency =
			0.35

		text.TextSize =
			12

		text.TextWrapped =
			true

		text.Parent =
			billboard

		table.insert(
			objects,
			billboard
		)

		local healthBackground =
			Instance.new("Frame")

		healthBackground.Size =
			UDim2.new(
				0,
				120,
				0,
				7
			)

		healthBackground.AnchorPoint =
			Vector2.new(0.5, 0)

		healthBackground.Position =
			UDim2.new(
				0.5,
				0,
				1,
				-10
			)

		healthBackground.BackgroundColor3 =
			Color3.fromRGB(
				30,
				30,
				30
			)

		healthBackground.BorderSizePixel =
			0

		healthBackground.Visible =
			State.HealthBars

		healthBackground.Parent =
			billboard

		local healthBackgroundCorner =
			Instance.new("UICorner")

		healthBackgroundCorner.CornerRadius =
			UDim.new(1, 0)

		healthBackgroundCorner.Parent =
			healthBackground

		local healthFill =
			Instance.new("Frame")

		healthFill.Size =
			UDim2.fromScale(1, 1)

		healthFill.BackgroundColor3 =
			Color3.fromRGB(
				80,
				220,
				120
			)

		healthFill.BorderSizePixel =
			0

		healthFill.Parent =
			healthBackground

		local healthFillCorner =
			Instance.new("UICorner")

		healthFillCorner.CornerRadius =
			UDim.new(1, 0)

		healthFillCorner.Parent =
			healthFill

		table.insert(
			objects,
			healthBackground
		)

		if State.HeadDots and head then
			local dot =
				Instance.new("BillboardGui")

			dot.Name =
				"SillyHubHeadDot"

			dot.Adornee =
				head

			dot.Size =
				UDim2.new(
					0,
					14,
					0,
					14
				)

			dot.AlwaysOnTop =
				true

			dot.Parent =
				head

			local dotFrame =
				Instance.new("Frame")

			dotFrame.Size =
				UDim2.fromScale(1, 1)

			dotFrame.BackgroundColor3 =
				Theme.Accent

			dotFrame.BorderSizePixel =
				0

			dotFrame.Parent =
				dot

			local dotCorner =
				Instance.new("UICorner")

			dotCorner.CornerRadius =
				UDim.new(1, 0)

			dotCorner.Parent =
				dotFrame

			table.insert(
				objects,
				dot
			)
		end

		local connection =
			RunService.RenderStepped:Connect(
				function()
					if not billboard.Parent then
						return
					end

					local parts = {}

					if State.Names then
						local display =
						State.FakeName ~= ""
						and State.FakeName
						or player.DisplayName

						table.insert(
							parts,
							display
						)
					end

					if State.Distance then
						local myRoot =
						getRoot()

						if myRoot and root then
							local distance =
							(
								myRoot.Position -
								root.Position
							).Magnitude

							table.insert(
								parts,
								string.format(
									"%.0f studs",
									distance
								)
							)
						end
					end

					local humanoid =
					character:
					FindFirstChildOfClass(
						"Humanoid"
					)

					if State.Health
						and humanoid then

						table.insert(
							parts,
							string.format(
								"HP: %.0f/%.0f",
								humanoid.Health,
								humanoid.MaxHealth
							)
						)
					end

					text.Text =
					table.concat(
						parts,
						" • "
					)

					text.Visible =
					#parts > 0

					healthBackground.Visible =
					State.HealthBars

					if humanoid then
						local ratio =
						math.clamp(
							humanoid.Health /
							math.max(
								humanoid.MaxHealth,
								1
							),
							0,
							1
						)

						healthFill.Size =
						UDim2.new(
							ratio,
							0,
							1,
							0
						)
					end

					local headDot =
					billboard.Parent:
					FindFirstChild(
						"SillyHubHeadDot"
					)

					if headDot then
						headDot.Enabled =
						State.HeadDots
					end
				end
			)

		table.insert(
			connections,
			connection
		)
	end

	if State.Tracers and root then
		local attachment0 =
			Instance.new("Attachment")

		attachment0.Name =
			"SillyHubTracerStart"

		attachment0.Parent =
			root

		table.insert(
			objects,
			attachment0
		)

		local localRoot =
			getRoot()

		if localRoot then
			local attachment1 =
				Instance.new("Attachment")

			attachment1.Name =
				"SillyHubTracerEnd"

			attachment1.Parent =
				localRoot

			table.insert(
				objects,
				attachment1
			)

			local beam =
				Instance.new("Beam")

			beam.Name =
				"SillyHubTracer"

			beam.Attachment0 =
				attachment0

			beam.Attachment1 =
				attachment1

			beam.Color =
				ColorSequence.new(
					Theme.Accent
				)

			beam.Width0 =
				0.08

			beam.Width1 =
				0.08

			beam.FaceCamera =
				true

			beam.Parent =
				root

			table.insert(
				objects,
				beam
			)
		end
	end
end

local function updateESP()
	for _, player in ipairs(
		Players:GetPlayers()
		) do
		if player ~= LP then
			if
				State.ESP
				or State.Names
				or State.Distance
				or State.Health
				or State.HealthBars
				or State.Tracers
				or State.HeadDots
			then
				createESP(player)
			else
				removeESP(player)
			end
		end
	end
end

--==================================================
-- INPUT STATE
--==================================================

local keys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false,
	LeftControl = false,
}

local freecamYaw = 0
local freecamPitch = 0

--==================================================
-- GLOBAL INPUT
--==================================================

UIS.InputBegan:Connect(
	function(input, gameProcessed)

		-- KEYBIND CAPTURE
		if waitingForKey then
			if input.UserInputType ==
				Enum.UserInputType.Keyboard then

				local key =
					input.KeyCode

				if key ~= Enum.KeyCode.Unknown then
					State.OpenKey =
						key

					waitingForKey =
						false

					KeybindButton.Text =
						"Open/Close Key: " ..
						key.Name

					Notify(
						"Keybind",
						"Menu key changed to " ..
							key.Name .. ".",
						"Settings"
					)
				end
			end

			return
		end

		-- MENU KEY
		if
			input.UserInputType ==
			Enum.UserInputType.Keyboard
			and
			input.KeyCode ==
			State.OpenKey
			and
			not gameProcessed
		then
			Gui.Enabled =
				not Gui.Enabled

			return
		end

		-- AIM KEY
		if
			input.UserInputType ==
			Enum.UserInputType.Keyboard
			and
			input.KeyCode ==
			State.AimKey
		then
			AimHolding = true
		end

		-- MOVEMENT KEYS

		if input.KeyCode ==
			Enum.KeyCode.W then
			keys.W = true
		end

		if input.KeyCode ==
			Enum.KeyCode.A then
			keys.A = true
		end

		if input.KeyCode ==
			Enum.KeyCode.S then
			keys.S = true
		end

		if input.KeyCode ==
			Enum.KeyCode.D then
			keys.D = true
		end

		if input.KeyCode ==
			Enum.KeyCode.Space then
			keys.Space = true
		end

		if input.KeyCode ==
			Enum.KeyCode.LeftControl then
			keys.LeftControl = true
		end
	end
)

UIS.InputEnded:Connect(
	function(input)

		-- AIM KEY RELEASE

		if
			input.UserInputType ==
			Enum.UserInputType.Keyboard
			and
			input.KeyCode ==
			State.AimKey
		then
			AimHolding = false
		end

		if input.KeyCode ==
			Enum.KeyCode.W then
			keys.W = false
		end

		if input.KeyCode ==
			Enum.KeyCode.A then
			keys.A = false
		end

		if input.KeyCode ==
			Enum.KeyCode.S then
			keys.S = false
		end

		if input.KeyCode ==
			Enum.KeyCode.D then
			keys.D = false
		end

		if input.KeyCode ==
			Enum.KeyCode.Space then
			keys.Space = false
		end

		if input.KeyCode ==
			Enum.KeyCode.LeftControl then
			keys.LeftControl = false
		end
	end
)

--==================================================
-- INFINITE JUMP
--==================================================

UIS.JumpRequest:Connect(
	function()
		if not State.InfiniteJump then
			return
		end

		local humanoid =
			getHumanoid()

		if humanoid then
			humanoid:
				ChangeState(
					Enum.HumanoidStateType.Jumping
				)
		end
	end
)

--==================================================
-- FREECAM MOUSE
--==================================================

UIS.InputChanged:Connect(
	function(input)
		if
			State.Freecam
			and
			input.UserInputType ==
			Enum.UserInputType.MouseMovement
		then
			if Gui.Enabled then
				return
			end

			local sensitivity =
				State.CameraSensitivity /
				1000

			freecamYaw -=
				input.Delta.X *
				sensitivity

			freecamPitch -=
				input.Delta.Y *
				sensitivity

			freecamPitch =
				math.clamp(
					freecamPitch,
					-math.rad(89),
					math.rad(89)
				)
		end
	end
)

--==================================================
-- RENDER LOOP
--==================================================

local lastFPSUpdate = tick()
local frames = 0
local fps = 0
local randomTeleportTimer = 0

RunService.RenderStepped:Connect(
	function(dt)

		-- FPS

		frames += 1

		if tick() -
			lastFPSUpdate >= 1 then

			fps = frames
			frames = 0
			lastFPSUpdate =
				tick()
		end

		-- PING

		local ping = 0

		pcall(
			function()
				local item =
					Stats.Network.ServerStatsItem[
				"Data Ping"
				]

				if item then
					ping =
						math.floor(
							item:GetValue()
						)
				end
			end
		)

		PerfLabel.Text =
			"FPS: " ..
			(
				State.FPSCounter
				and fps
				or "--"
			) ..

			"\nPing: " ..

			(
				State.PingCounter
				and
				(
					tostring(ping) ..
					" ms"
				)
				or "--"
			)

		--==================================================
		-- GODMODE
		--==================================================

		if State.Godmode then
			local humanoid =
				getHumanoid()

			if humanoid then
				if humanoid.Health <
					humanoid.MaxHealth then

					humanoid.Health =
						humanoid.MaxHealth
				end
			end
		end

		--==================================================
		-- NOCLIP
		--==================================================

		if State.Noclip then
			local character =
				getCharacter()

			if character then
				for _, part in ipairs(
					character:GetDescendants()
					) do
					if part:IsA(
						"BasePart"
						) then

						part.CanCollide =
							false
					end
				end
			end
		end

		--==================================================
		-- FREECAM
		--==================================================

		if State.Freecam then
			local camera =
				workspace.CurrentCamera

			if camera then
				local move =
					Vector3.zero

				if keys.W then
					move +=
						Vector3.new(
							0,
							0,
							-1
						)
				end

				if keys.S then
					move +=
						Vector3.new(
							0,
							0,
							1
						)
				end

				if keys.A then
					move +=
						Vector3.new(
							-1,
							0,
							0
						)
				end

				if keys.D then
					move +=
						Vector3.new(
							1,
							0,
							0
						)
				end

				if keys.Space then
					move +=
						Vector3.new(
							0,
							1,
							0
						)
				end

				if keys.LeftControl then
					move +=
						Vector3.new(
							0,
							-1,
							0
						)
				end

				local rotation =
					CFrame.Angles(
						freecamPitch,
						freecamYaw,
						0
					)

				if move.Magnitude > 0 then
					local direction =
						rotation:
						VectorToWorldSpace(
							move.Unit
						)

					camera.CFrame =
						camera.CFrame +
						direction *
						State.FreecamSpeed *
						dt
				end

				local position =
					camera.CFrame.Position

				camera.CFrame =
					CFrame.new(
						position
					) *
					rotation
			end
		end

		--==================================================
		-- FLIGHT
		--==================================================

		if State.Flight then
			local root =
				getRoot()

			if root then
				local camera =
					workspace.CurrentCamera

				if camera then
					local direction =
						Vector3.zero

					if keys.W then
						direction +=
							camera.CFrame.LookVector
					end

					if keys.S then
						direction -=
							camera.CFrame.LookVector
					end

					if keys.A then
						direction -=
							camera.CFrame.RightVector
					end

					if keys.D then
						direction +=
							camera.CFrame.RightVector
					end

					if direction.Magnitude > 0 then
						direction =
							direction.Unit *
							State.FlightSpeed
					end

					local vertical = 0

					if keys.Space then
						vertical +=
							State.VerticalFlightSpeed
					end

					if keys.LeftControl then
						vertical -=
							State.VerticalFlightSpeed
					end

					root.AssemblyLinearVelocity =
						Vector3.new(
							direction.X,
							vertical,
							direction.Z
						)
				end
			end
		end

		--==================================================
		-- SPIN
		--==================================================

		if State.Spin then
			local root =
				getRoot()

			if root then
				root.CFrame =
					root.CFrame *
					CFrame.Angles(
						0,
						math.rad(
							State.SpinSpeed
						) * dt,
						0
					)
			end
		end

		--==================================================
		-- ORBIT
		--==================================================

		if State.Orbit then
			local target =
				findPlayer(
					State.OrbitTarget
				)

			local myRoot =
				getRoot()

			if not target
				or target == LP then

				State.Orbit = false
			else
				local character =
					target.Character

				local targetRoot =
					character and
					character:FindFirstChild(
						"HumanoidRootPart"
					)

				if targetRoot and myRoot then
					State.OrbitAngle +=
						State.OrbitSpeed *
						dt

					local x =
						math.cos(
							State.OrbitAngle
						) *
						State.OrbitRadius

					local z =
						math.sin(
							State.OrbitAngle
						) *
						State.OrbitRadius

					local position =
						targetRoot.Position +
						Vector3.new(
							x,
							State.OrbitHeight,
							z
						)

					myRoot.CFrame =
						CFrame.lookAt(
							position,
							targetRoot.Position
						)
				end
			end
		end

		--==================================================
		-- REPEAT TELEPORT
		--==================================================

		if
			State.RepeatTeleport
			and
			State.SavedPosition
		then
			local root =
				getRoot()

			if root then
				root.CFrame =
					State.SavedPosition
			end
		end

		--==================================================
		-- RANDOM TELEPORT LOOP
		--==================================================

		if State.RandomTeleport then
			randomTeleportTimer +=
				dt

			if randomTeleportTimer >=
				State.RandomTeleportInterval then

				randomTeleportTimer = 0

				local root =
					getRoot()

				if root then
					local radius =
						math.floor(
							State.RandomRadius
						)

					root.CFrame =
						root.CFrame +
						Vector3.new(
							math.random(
								-radius,
								radius
							),
							math.random(
								-radius,
								radius
							),
							math.random(
								-radius,
								radius
							)
						)
				end
			end
		else
			randomTeleportTimer = 0
		end

		--==================================================
		-- NO FOG
		--==================================================

		if State.NoFog then
			Lighting.FogStart = 0
			Lighting.FogEnd = 100000
		end

		--==================================================
		-- FROZEN
		--==================================================

		if State.Frozen then
			local root =
				getRoot()

			local humanoid =
				getHumanoid()

			if root then
				root.AssemblyLinearVelocity =
					Vector3.zero

				root.AssemblyAngularVelocity =
					Vector3.zero
			end

			if humanoid then
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			end
		end

		--==================================================
		-- COMBAT AIM
		--==================================================

		UpdateAimTarget()
		PerformAim()
		UpdateAimVisuals()

		--==================================================
		-- ESP LIVE UPDATE
		--==================================================

		if
			State.ESP
			or State.Names
			or State.Distance
			or State.Health
			or State.HealthBars
			or State.Tracers
			or State.HeadDots
		then
			for _, player in ipairs(
				Players:GetPlayers()
				) do
				if player ~= LP
					and not ESPObjects[player]
				then
					createESP(player)
				end
			end
		else
			for player in pairs(
				ESPObjects
				) do
				removeESP(player)
			end
		end
	end
)

--==================================================
-- CHARACTER RESPAWN
--==================================================

LP.CharacterAdded:Connect(
	function(character)
		task.wait(0.5)

		local humanoid =
			character:WaitForChild(
				"Humanoid"
			)

		humanoid.WalkSpeed =
			State.WalkSpeed

		humanoid.JumpPower =
			State.JumpPower

		humanoid.HipHeight =
			State.HipHeight

		humanoid.AutoRotate =
			State.AutoRotate

		humanoid.PlatformStand =
			State.PlatformStand

		if State.Godmode then
			humanoid.Health =
				humanoid.MaxHealth
		end

		task.wait(0.25)

		updateESP()

		ClearAimTarget()

		Notify(
			"Character",
			"Your character respawned.",
			"System"
		)
	end
)

--==================================================
-- PLAYER JOIN / LEAVE
--==================================================

Players.PlayerAdded:Connect(
	function(player)
		if State.NotifyPlayerJoin then
			Notify(
				"Player Joined",
				player.DisplayName ..
					" joined the server.",
				"Player"
			)
		end

		player.CharacterAdded:Connect(
			function()
				task.wait(1)

				updateESP()
			end
		)

		UpdateServerInfo()
	end
)

Players.PlayerRemoving:Connect(
	function(player)
		if State.NotifyPlayerLeave then
			Notify(
				"Player Left",
				player.DisplayName ..
					" left the server.",
				"Player"
			)
		end

		removeESP(player)

		if State.AimTarget == player then
			ClearAimTarget()
		end

		if State.OrbitTarget ==
			player.Name then

			State.Orbit = false
			State.OrbitTarget = ""

			Notify(
				"Orbit",
				"Orbit stopped because the target left.",
				"Movement"
			)
		end

		UpdateServerInfo()
	end
)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(
	function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			dragging = true

			dragStart =
				input.Position

			startPosition =
				Main.Position
		end
	end
)

UIS.InputChanged:Connect(
	function(input)
		if dragging
			and
			input.UserInputType ==
			Enum.UserInputType.MouseMovement
		then

			local delta =
				input.Position -
				dragStart

			Main.Position =
				UDim2.new(
					startPosition.X.Scale,
					startPosition.X.Offset +
					delta.X,

					startPosition.Y.Scale,
					startPosition.Y.Offset +
					delta.Y
				)
		end
	end
)

UIS.InputEnded:Connect(
	function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			dragging = false
		end
	end
)

--==================================================
-- CLOSE BUTTON
--==================================================

Close.MouseButton1Click:Connect(
	function()
		Gui.Enabled = false
	end
)

--==================================================
-- INITIAL TAB
--==================================================

CurrentPage = "Player"

Pages.Player.Visible = true

for name, page in pairs(Pages) do
	if name ~= "Player" then
		page.Visible = false
	end
end

for name, button in pairs(TabButtons) do
	if name == "Player" then
		button.BackgroundTransparency = 0
		button.BackgroundColor3 =
			Theme.Accent
		button.TextColor3 =
			Color3.new(1, 1, 1)
	else
		button.BackgroundTransparency = 1
		button.TextColor3 =
			Theme.SubText
	end
end

--==================================================
-- INITIAL ESP
--==================================================

updateESP()

--==================================================
-- INITIAL THEME
--==================================================

ApplyThemeColor()

--==================================================
-- LOADED
--==================================================

task.delay(
	1,
	function()
		Notify(
			"SillyHub V3",
			"SillyHub V3 loaded successfully. Right Shift opens/closes the menu.",
			"System"
		)
	end
)