--[[
Steal a Brainrot UI Lib
V4.0.0
by @iksuwu ( discord )
]]
return (function()

	local Sab = {}

	local TweenService = game:GetService("TweenService")
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer

	local NOTIFY_ANIM_TIME = 0.3
	local NOTIFY_SPACING = 10
	local NOTIFY_WIDTH = 250
	local NOTIFY_HEIGHT = 65
	local LAYOUT_TWEEN_INFO = TweenInfo.new(NOTIFY_ANIM_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local activeNotifications = {}
	local notificationLayoutOrder = 0

	local ScreenGuiHost = gethui()
	local existingGui = ScreenGuiHost:FindFirstChild("SabGUIS")
	if existingGui then
		existingGui:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui", ScreenGuiHost)
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = "SabGUIS"


	local function AddCorner(parent, radius)
		local c = Instance.new("UICorner", parent)
		c.CornerRadius = UDim.new(0, radius)
		return c
	end

	local function round(n)
		return math.floor(n + 0.5)
	end



	local blur = Instance.new("Frame", ScreenGui)
	blur.Size = UDim2.new(0, 520, 0, 330)
	blur.Position = UDim2.new(0.5, -260, 0.5, -165)
	blur.BackgroundColor3 = Color3.fromRGB(25,25,30)
	blur.BackgroundTransparency = 0.32
	blur.BorderSizePixel = 0
	AddCorner(blur, 16)


	local TitleBar = Instance.new("Frame", ScreenGui)
	TitleBar.Size = UDim2.new(0, 520, 0, 45)
	TitleBar.Position = UDim2.new(0.5, -260, 0.5, -220)
	TitleBar.BackgroundColor3 = Color3.fromRGB(30,30,40)
	TitleBar.BackgroundTransparency = 0.15
	TitleBar.ZIndex = 10
	TitleBar.BorderSizePixel = 0
	AddCorner(TitleBar, 14)

	local TitleText = Instance.new("TextLabel", TitleBar)
	TitleText.Size = UDim2.new(1,0,1,0)
	TitleText.BackgroundTransparency = 1
	TitleText.Text = "Steal a Brainrot Lib"
	TitleText.TextColor3 = Color3.fromRGB(166, 166, 166)
	TitleText.Font = Enum.Font.GothamBold
	TitleText.TextSize = 18
	TitleBar.ZIndex = 15


	function Sab:SetTitle(title)
		TitleText.Text = title
	end


	local dragging = false
	local dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		blur.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TitleBar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 55)
	end

	local function dragBegin(input)
		dragging = true
		dragStart = input.Position
		startPos = blur.Position
	end
	local function dragEnd()
		dragging = false
	end

	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
			input.UserInputType == Enum.UserInputType.Touch then
			dragBegin(input)
		end
	end)
	TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
			input.UserInputType == Enum.UserInputType.Touch then
			dragEnd()
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)


	local ToggleUI = Instance.new("TextButton", ScreenGui)
	ToggleUI.Size = UDim2.new(0, 50, 0, 50)
	ToggleUI.Position = UDim2.new(1, -70, 0, 20)
	ToggleUI.Text = "◎"
	ToggleUI.Font = Enum.Font.GothamBold
	ToggleUI.TextSize = 22
	ToggleUI.TextColor3 = Color3.fromRGB(255,255,255)
	ToggleUI.BackgroundColor3 = Color3.fromRGB(40,40,55)
	ToggleUI.BorderSizePixel = 0
	AddCorner(ToggleUI, 25)

	local minimized = false

	ToggleUI.MouseButton1Click:Connect(function()
		minimized = not minimized
		blur.Visible = not minimized
		TitleBar.Visible = not minimized
	end)

	Sab.ToggleUI = ToggleUI


	local Main = Instance.new("Frame", blur)
	Main.Size = UDim2.new(1, -10, 1, -10)
	Main.Position = UDim2.new(0,5,0,5)
	Main.BackgroundColor3 = Color3.fromRGB(30,30,38)
	Main.BackgroundTransparency = 0.15
	Main.BorderSizePixel = 0
	AddCorner(Main, 14)


	local TabBar = Instance.new("ScrollingFrame", Main)
	TabBar.Size = UDim2.new(1,0,0,40)
	TabBar.BackgroundColor3 = Color3.fromRGB(35,35,50)
	TabBar.BorderSizePixel = 0
	TabBar.CanvasSize = UDim2.new(0,0,0,0)
	TabBar.ScrollBarThickness = 0
	TabBar.ScrollBarImageTransparency = 1
	TabBar.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	TabBar.ScrollingDirection = Enum.ScrollingDirection.X
	AddCorner(TabBar, 12)

	local tabLayout = Instance.new("UIListLayout", TabBar)
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + tabLayout.Padding.Offset, 0, 0)
	end)


	local Content = Instance.new("Frame", Main)
	Content.Size = UDim2.new(1,0,1,-40)
	Content.Position = UDim2.new(0,0,0,40)
	Content.BackgroundTransparency = 1
	Content.ClipsDescendants = true


	function Sab:cTab(name)
		local tab = {}

		local TabBtn = Instance.new("TextButton", TabBar)
		TabBtn.Size = UDim2.new(0,140,1,0)
		TabBtn.Text = name
		TabBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
		TabBtn.TextColor3 = Color3.fromRGB(255,255,255)
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.BorderSizePixel = 0
		TabBtn.LayoutOrder = 1
		AddCorner(TabBtn, 10)

		local Frame = Instance.new("ScrollingFrame", Content)
		Frame.Size = UDim2.new(1,-20,1,-20)
		Frame.Position = UDim2.new(0,10,0,10)
		Frame.BackgroundTransparency = 1
		Frame.CanvasSize = UDim2.new(0,0,0,0)
		Frame.ScrollBarThickness = 4
		Frame.Visible = false

		Frame.ScrollingDirection = Enum.ScrollingDirection.Y
		Frame.ScrollBarImageTransparency = 0.8

		local Layout = Instance.new("UIListLayout", Frame)
		Layout.Padding = UDim.new(0,10)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Frame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _,v in ipairs(Content:GetChildren()) do
				if v ~= Frame then v.Visible = false end
			end
			Frame.Visible = true
		end)


		function tab:Button(text, callback)
			local Btn = Instance.new("TextButton", Frame)
			Btn.Size = UDim2.new(1,0,0,40)
			Btn.Text = text
			Btn.BackgroundColor3 = Color3.fromRGB(45,45,60)
			Btn.TextColor3 = Color3.fromRGB(255,255,255)
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.BorderSizePixel = 0
			AddCorner(Btn, 12)

			local element = {
				Frame = Btn,
				SetVisible = function(self, state)
					self.Frame.Visible = state
				end
			}

			Btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)

			return element
		end


		function tab:Toggle(text, callback)
			local Toggle = Instance.new("Frame", Frame)
			Toggle.Size = UDim2.new(1,0,0,40)
			Toggle.BackgroundColor3 = Color3.fromRGB(45,45,60)
			Toggle.BorderSizePixel = 0
			AddCorner(Toggle, 12)

			local Label = Instance.new("TextLabel", Toggle)
			Label.Size = UDim2.new(1,-60,1,0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(255,255,255)
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14

			local Switch = Instance.new("Frame", Toggle)
			Switch.Size = UDim2.new(0,38,0,20)
			Switch.Position = UDim2.new(1,-50,0.5,-10)
			Switch.BackgroundColor3 = Color3.fromRGB(100,100,120)
			Switch.BorderSizePixel = 0
			AddCorner(Switch, 10)

			local Dot = Instance.new("Frame", Switch)
			Dot.Size = UDim2.new(0,16,0,16)
			Dot.Position = UDim2.new(0,2,0,2)
			Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Dot.BorderSizePixel = 0
			AddCorner(Dot, 8)

			local Hitbox = Instance.new("TextButton", Toggle)
			Hitbox.BackgroundTransparency = 1
			Hitbox.Size = UDim2.new(1,0,1,0)
			Hitbox.Text = ""

			local state = false

			local element = {
				Frame = Toggle,
				SetVisible = function(self, state)
					self.Frame.Visible = state
				end
			}

			local function apply()
				if state then
					TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1,-18,0,2)}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0,150,255)}):Play()
				else
					TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0,2,0,2)}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(100,100,120)}):Play()
				end
				if callback then callback(state) end
			end

			Hitbox.MouseButton1Click:Connect(function()
				state = not state
				apply()
			end)

			return element
		end

		function tab:Slider(text, min, max, initial, callback)
			local SliderFrame = Instance.new("Frame", Frame)
			SliderFrame.Size = UDim2.new(1,0,0,60)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,60)
			SliderFrame.BorderSizePixel = 0
			AddCorner(SliderFrame, 12)

			local Label = Instance.new("TextLabel", SliderFrame)
			Label.Size = UDim2.new(1,-10,0,20)
			Label.Position = UDim2.new(0,5,0,5)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.fromRGB(255,255,255)
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14

			local Track = Instance.new("Frame", SliderFrame)
			Track.Size = UDim2.new(1,-20,0,6)
			Track.Position = UDim2.new(0,10,0,35)
			Track.BackgroundColor3 = Color3.fromRGB(50,50,70)
			Track.BorderSizePixel = 0
			AddCorner(Track, 3)

			local Fill = Instance.new("Frame", Track)
			Fill.Size = UDim2.new(0, 0, 1, 0) 
			Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			Fill.BorderSizePixel = 0

			local Handle = Instance.new("Frame", Track)
			Handle.Size = UDim2.new(0,12,0,12)
			Handle.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Handle.BorderSizePixel = 0
			AddCorner(Handle, 6)

			local Hitbox = Instance.new("TextButton", Track)
			Hitbox.Size = UDim2.new(1, 0, 1, 0)
			Hitbox.BackgroundTransparency = 1
			Hitbox.Text = ""

			local currentValue = math.clamp(initial, min, max)
			local dragging = false

			local element = {
				Frame = SliderFrame,
				SetVisible = function(self, state)
					self.Frame.Visible = state
				end
			}

			local function updateValue(input)
				local pos = input.Position
				local x = math.min(math.max(pos.X - Track.AbsolutePosition.X, 0), Track.AbsoluteSize.X)
				local percentage = x / Track.AbsoluteSize.X
				local newValue = min + (max - min) * percentage

				currentValue = round(newValue)

				local fillScale = (currentValue - min) / (max - min)
				Fill.Size = UDim2.new(fillScale, 0, 1, 0)
				Handle.Position = UDim2.new(fillScale, -Handle.Size.X.Offset / 2, 0.5, -Handle.Size.Y.Offset / 2)
				Label.Text = text .. " [" .. tostring(currentValue) .. "]"

				if callback and dragging then
					callback(currentValue)
				end
			end

			do
				local fillScale = (currentValue - min) / (max - min)
				Fill.Size = UDim2.new(fillScale, 0, 1, 0)
				Handle.Position = UDim2.new(fillScale, -Handle.Size.X.Offset / 2, 0.5, -Handle.Size.Y.Offset / 2)
				Label.Text = text .. " [" .. tostring(currentValue) .. "]"
			end

			Hitbox.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateValue(input)
				end
			end)

			Hitbox.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			UIS.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateValue(input)
				end
			end)

			return element
		end

		return tab
	end


	function Sab:cMenu(title, properties)
		properties = properties or {}
		local menuType = properties.Type or "Button"
		local callback = properties.Callback
		local initialPosition = properties.Position or UDim2.new(0.02973, 0, 0.5, 0)


		local MainFrame = Instance.new("Frame", ScreenGui)
		MainFrame.BorderSizePixel = 0
		MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
		MainFrame.BackgroundTransparency = 0.15
		MainFrame.Size = UDim2.new(0, 270, 0, 42)
		MainFrame.Position = initialPosition
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.Name = "Instance_" .. title:gsub("%s", "_")
		MainFrame.Active = true
		MainFrame.Draggable = true

		local MainFrameCorner = Instance.new("UICorner", MainFrame)
		MainFrameCorner.CornerRadius = UDim.new(0.3, 0)


		local TitleLabel = Instance.new("TextLabel", MainFrame)
		TitleLabel.BorderSizePixel = 0
		TitleLabel.TextSize = 20
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TitleLabel.FontFace = Font.new("rbxasset://fonts/families/Gotham.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Size = UDim2.new(0, 187, 0, 36)
		TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TitleLabel.Text = title
		TitleLabel.Name = "Desync_Title"
		TitleLabel.Position = UDim2.new(0.02757, 0, 0.07143, 0)

		local buttonElement = nil

		if menuType == "Button" then

			local UseButton = Instance.new("TextButton", MainFrame)
			UseButton.TextWrapped = true
			UseButton.BorderSizePixel = 0
			UseButton.TextSize = 18
			UseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			UseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			UseButton.FontFace = Font.new("rbxasset://fonts/families/Gotham.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			UseButton.Size = UDim2.new(0, 67, 0, 29)
			UseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			UseButton.Text = "USE"
			UseButton.Name = "Action_Button"
			UseButton.Position = UDim2.new(0.71852, 0, 0.14286, 0)

			local UseButtonCorner = Instance.new("UICorner", UseButton)
			UseButtonCorner.CornerRadius = UDim.new(0.5, 0)

			UseButton.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)

		elseif menuType == "Toggle" then

			local ToggleContainer = Instance.new("Frame", MainFrame)
			ToggleContainer.Size = UDim2.new(0, 67, 0, 29)
			ToggleContainer.Position = UDim2.new(0.71852, 0, 0.14286, 0)
			ToggleContainer.BackgroundTransparency = 1

			local Switch = Instance.new("Frame", ToggleContainer)
			Switch.Size = UDim2.new(0, 45, 0, 22)
			Switch.Position = UDim2.new(0.5, -22.5, 0.5, -11)
			Switch.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
			Switch.BorderSizePixel = 0
			AddCorner(Switch, 11)

			local Dot = Instance.new("Frame", Switch)
			Dot.Size = UDim2.new(0, 18, 0, 18)
			Dot.Position = UDim2.new(0, 2, 0, 2)
			Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Dot.BorderSizePixel = 0
			AddCorner(Dot, 9)

			local Hitbox = Instance.new("TextButton", ToggleContainer)
			Hitbox.BackgroundTransparency = 1
			Hitbox.Size = UDim2.new(1, 0, 1, 0)
			Hitbox.Text = ""

			local state = false

			local function apply()
				if state then
					TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1, -20, 0, 2)}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
				else
					TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0, 2)}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(100, 100, 120)}):Play()
				end
				if callback then callback(state) end
			end

			Hitbox.MouseButton1Click:Connect(function()
				state = not state
				apply()
			end)
		end


		buttonElement = {
			Frame = MainFrame,
			SetVisible = function(self, state)
				self.Frame.Visible = state
			end
		}

		return buttonElement
	end


	local NotifyContainer = ScreenGui:FindFirstChild("NotifyContainer")
	if not NotifyContainer then
		NotifyContainer = Instance.new("Frame", ScreenGui)
		NotifyContainer.Name = "NotifyContainer"


		NotifyContainer.AnchorPoint = Vector2.new(1, 0)
		NotifyContainer.Size = UDim2.new(0, NOTIFY_WIDTH, 1, 0)
		NotifyContainer.Position = UDim2.new(1, -NOTIFY_SPACING, 0, NOTIFY_SPACING)

		NotifyContainer.BackgroundTransparency = 1
		NotifyContainer.ClipsDescendants = true

		local NotifyLayout = Instance.new("UIListLayout", NotifyContainer)
		NotifyLayout.Name = "UIListLayout"
		NotifyLayout.FillDirection = Enum.FillDirection.Vertical
		NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		NotifyLayout.Padding = UDim.new(0, NOTIFY_SPACING)

	end

	function Sab:MakeNotify(settings)
		local Title = settings.Title or "Notification"
		local SubTitle = settings.SubTitle or ""
		local Duration = settings.Duration or 5

		local NotifyFrame = Instance.new("Frame")
		NotifyFrame.Size = UDim2.new(0, NOTIFY_WIDTH, 0, NOTIFY_HEIGHT)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
		NotifyFrame.BackgroundTransparency = 0.05
		NotifyFrame.BorderSizePixel = 0
		AddCorner(NotifyFrame, 10)


		NotifyFrame.LayoutOrder = notificationLayoutOrder
		notificationLayoutOrder = notificationLayoutOrder - 1


		local TitleLabel = Instance.new("TextLabel", NotifyFrame)
		TitleLabel.Text = Title
		TitleLabel.FontFace = Font.new("rbxasset://fonts/families/Gotham.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		TitleLabel.TextSize = 16
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.Position = UDim2.new(0, 10, 0, 5)
		TitleLabel.Size = UDim2.new(1, -20, 0, 20)
		TitleLabel.BackgroundTransparency = 1

		local SubLabel = Instance.new("TextLabel", NotifyFrame)
		SubLabel.Text = SubTitle
		SubLabel.FontFace = Font.new("rbxasset://fonts/families/Gotham.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		SubLabel.TextSize = 13
		SubLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubLabel.Position = UDim2.new(0, 10, 0, 25)
		SubLabel.Size = UDim2.new(1, -20, 0, 20)
		SubLabel.BackgroundTransparency = 1

		local BarBG = Instance.new("Frame", NotifyFrame)
		BarBG.Size = UDim2.new(1, 0, 0, 5)
		BarBG.Position = UDim2.new(0, 0, 1, -5)
		BarBG.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
		BarBG.BorderSizePixel = 0

		local BarFill = Instance.new("Frame", BarBG)
		BarFill.Size = UDim2.new(1, 0, 1, 0)
		BarFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		BarFill.BorderSizePixel = 0

		table.insert(activeNotifications, 1, {Frame = NotifyFrame, Duration = Duration})


		NotifyFrame.Parent = NotifyContainer
		NotifyFrame.Visible = false
		NotifyFrame.Position = UDim2.new(1, 0, 0, 0)


		local entryTween = TweenService:Create(NotifyFrame, LAYOUT_TWEEN_INFO, {Position = UDim2.new(0, 0, 0, 0)})

		entryTween:Play()
		NotifyFrame.Visible = true


		TweenService:Create(BarFill, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 1, 0)}):Play()


		delay(Duration, function()


			local exitTween = TweenService:Create(NotifyFrame, LAYOUT_TWEEN_INFO, {Position = UDim2.new(1, 0, 0, 0)})
			exitTween:Play()

			local index = nil
			for i, notify in ipairs(activeNotifications) do
				if notify.Frame == NotifyFrame then
					index = i
					break
				end
			end
			if index then
				table.remove(activeNotifications, index)
			end

			exitTween.Completed:Wait()


			NotifyFrame:Destroy()
		end)

		return NotifyFrame
	end

	return Sab
end)()
