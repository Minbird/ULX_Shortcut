
ulxSTC.HKEditor = {}

function ulxSTC.HKEditor:Open( hk, num, shareMode )
	
	ulxSTC.HKEditor.DFrame = vgui.Create( "DFrame" )
	ulxSTC.HKEditor.DFrame:SetSize( 500, 500 )
	ulxSTC.HKEditor.DFrame:Center()
	ulxSTC.HKEditor.DFrame:SetTitle( ulxSTC:Str( "Select_The_Command_To_Creat_Shortcut" ) )
	ulxSTC.HKEditor.DFrame:MakePopup() 	
	ulxSTC.HKEditor.DFrame:SetBackgroundBlur( true )
	ulxSTC.HKEditor.DFrame:SetIcon("icon16/lightning_add.png")
	
	ulxSTC.HKEditor.DPanel = vgui.Create( "DPanel", ulxSTC.HKEditor.DFrame )
	ulxSTC.HKEditor.DPanel:Dock( FILL )
	ulxSTC.HKEditor.DPanel.Paint = function() end
	
	local marginLeft = vgui.Create( "Panel", ulxSTC.HKEditor.DFrame )
	marginLeft:Dock( LEFT )
	marginLeft:SetWide(25)
	marginLeft.Paint = function() end
	
	local marginRight = vgui.Create( "Panel", ulxSTC.HKEditor.DFrame )
	marginRight:Dock( RIGHT )
	marginRight:SetWide(25)
	marginRight.Paint = function() end
	
	local DermaImageButton = vgui.Create( "DImageButton", marginLeft )
	DermaImageButton:SetPos( 2, 5 )
	DermaImageButton:SetImage( "icon16/information.png" )
	DermaImageButton:SizeToContents()
	DermaImageButton:SetTooltip( ulxSTC:Str( "Command_List_Ex" ) )
	
	if shareMode then
		ulxSTC.HKEditor:ShareMode( true )
		return
	end
	
	if not hk then
		ulxSTC.HKEditor:CreatModuleList( "PlayerArg" ) -- alse with PlayersArg
	else
		ulxSTC.HKEditor:EditMode(hk, num)
	end
	
end

function ulxSTC.HKEditor:ShareMode( direct )
	
	local PanelTall = 32 + 50 + 30
	
	self.DPanel:Clear()
	self.DPanel:Dock( FILL )
	
	ulxSTC.HKEditor.DFrame:SetTitle( ulxSTC:Str( "SetListTo" ) )
	
	local arg = {}
	arg.hint = ulxSTC:Str( "SetListToEx" )
	local data = ulxSTC.HKEditor:StringArg( arg )
	
	local bottomButton = vgui.Create( "DPanel", ulxSTC.HKEditor.DPanel )
	bottomButton:Dock( BOTTOM )
	bottomButton:SetWidth( 50 )
	bottomButton.Paint = function(self, w, h) draw.RoundedBox( 0, 0, 0, w, h, Color( 108, 111, 114, 255 ) ) end
	
	local Cancel = vgui.Create( "DButton", bottomButton )
	Cancel:SetText( ulxSTC:Str( "Cancel" ) )
	Cancel.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
	end
	Cancel:Dock( RIGHT )
	
	local Apply = vgui.Create( "DButton", bottomButton )
	Apply:SetText( ulxSTC:Str( "Apply" ) )
	Apply.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
		ulxSTC:SetHKListFromJSON( data:GetValue() )
		hook.Run("ULXSHORTCUT_COMMANDHK_ONCHANGE")
	end
	Apply:Dock( RIGHT )
	
	if not direct then
		local Back = vgui.Create( "DButton", bottomButton )
		Back:SetText( ulxSTC:Str( "Back" ) )
		Back.DoClick = function()
			ulxSTC.HKEditor:CreatModuleList( "PlayerArg" )
		end
		Back:Dock( LEFT )
	end

	self.DFrame:SizeTo( 500, PanelTall, 0.3, 0 )
	self.DFrame:MoveTo( ScrW()/2 - 500/2, ScrH()/2 - PanelTall/2, 0.3, 0 )
	
end

function ulxSTC.HKEditor:EditMode(hk, num)
	ulxSTC.HKEditor:CreatArgsList( ulxSTC:GetModule( hk.cmd ), true, num )
end

function ulxSTC.HKEditor:CreatModuleList( type )
	
	ulxSTC.HKEditor.DFrame:SetTitle( ulxSTC:Str( "Select_The_Command_To_Creat_Shortcut" ) )
	ulxSTC.HKEditor.DFrame:SizeTo( 500, 500, 0.3, 0 )
	ulxSTC.HKEditor.DFrame:MoveTo( ScrW()/2 - 500/2, ScrH()/2 - 500/2, 0.3, 0 )
	--ulxSTC.HKEditor.DFrame:Center()
	ulxSTC.HKEditor.DPanel:Clear()
	ulxSTC.HKEditor.DPanel:Dock( FILL )
	
	local Categorys = vgui.Create( "DCategoryList", ulxSTC.HKEditor.DPanel )
	Categorys:Dock( FILL )
	
	for k, v in pairs(ulxSTC:GetUlxCategory()) do
		local Modules = ulxSTC:FilterModulesWithType( ulx.cmdsByCategory[v], type )
		if #Modules == 0 then continue end
		local Category = Categorys:Add( v )
		for ind, mo in pairs(Modules) do
			local button = Category:Add(mo.cmd)
			button:SetTooltip( mo.helpStr or mo.cmd )
			button.DoClick = function()
				ulxSTC.HKEditor:CreatArgsList( mo )
			end
		end
	end
	
	local bottomButton = vgui.Create( "DPanel", ulxSTC.HKEditor.DPanel )
	bottomButton:Dock( BOTTOM )
	bottomButton:SetWidth( 50 )
	bottomButton.Paint = function(self, w, h) draw.RoundedBox( 0, 0, 0, w, h, Color( 108, 111, 114, 255 ) ) end
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Cancel" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
	end
	Button:Dock( RIGHT )
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "SetListTo" ) )
	Button:SetWide(200)
	Button.DoClick = function()
		ulxSTC.HKEditor:ShareMode()
	end
	Button:Dock( LEFT )
	
end

function ulxSTC.HKEditor:CreatArgsList( mo, isEdit, hkNum ) -- String, Number, Bool... Not for player(target)s.
	
	self.HKColorData = nil
	self.HKIconData = nil
	
	ulxSTC.HKEditor.DFrame:SetTitle( ulxSTC:Str( "Command_Shortcut_Setting", mo.cmd ) )
	local PanelTall = 60
	
	--self.DFrame:Center()
	self.DPanel:Clear()
	self.DPanel:Dock( FILL )
	
	local helpString = vgui.Create( "DTextEntry", self.DPanel ) -- create the form as a child of frame
	helpString:SetTall(64)
	helpString:SetVerticalScrollbarEnabled( false )
	helpString:InsertColorChange(0, 0, 0, 255)
	helpString:Dock( TOP )
	helpString:SetMultiline( true )
	helpString:SetText( mo.helpStr or ulxSTC:Str( "No_Ex_For_This_Command" ) )
	helpString:SetText( helpString:GetText() .. "\n" )
	helpString:SetEditable( false )
	
	PanelTall = PanelTall + 64
	
	self.HKName = vgui.Create( "DTextEntry", self.DPanel )
	self.HKName:Dock( TOP )
	self.HKName:SetTall(32)
	self.HKName:DockMargin( 0, 20, 0, 0 )
	self.HKName:SetPlaceholderText( ulxSTC:Str( "Shortcut_Name_Setting" ) )
	self.HKName.OnEnter = function( self )
		--chat.AddText( self:GetValue() )
	end
	
	PanelTall = PanelTall + 42
	

	local Customs = vgui.Create( "DPanel", self.DPanel )
	Customs:SetTall(100)
	Customs:DockMargin( 0, 5, 0, 25 )
	Customs:Dock( TOP )
	Customs.Paint = function() end

	self.HKIcon = vgui.Create( "DIconBrowser", Customs )
	self.HKIcon:SetPos(0,0)
	self.HKIcon:SetSize(220,100)
	self.HKIcon.OnChange = function(s)
		self.HKIconData = s:GetSelectedIcon()
	end
	
	local ColorPanel = vgui.Create( "DPanel", Customs )
	ColorPanel:SetPos(230,0)
	ColorPanel:SetSize(220,100)
	ColorPanel:DockMargin( 0, 5, 0, 5 )
	ColorPanel:Dock( RIGHT )
	ColorPanel.Paint = function() end
		
		-- Color label
	local color_label = Label("Color( 255, 255, 255 )", ColorPanel)
	color_label:SetPos(40, 75)
	color_label:SetSize(150, 20)
	color_label:SetHighlight(true)
	color_label:SetColor(Color(0, 0, 0))
		
	self.color_picker = vgui.Create("DRGBPicker", ColorPanel)
	self.color_picker:SetPos(5, 0)
	self.color_picker:SetSize(30, 90)

	-- Color cube
	self.color_cube = vgui.Create("DColorCube", ColorPanel)
	self.color_cube:SetPos(40, 0)
	self.color_cube:SetSize(155, 75)

	-- When the picked color is changed...
	function self.color_picker.OnChange( s, col )
		
		-- Get the hue of the RGB picker and the saturation and vibrance of the color cube
		local h = ColorToHSV(col)
		local _, s, v = ColorToHSV(self.color_cube:GetRGB())
		
		-- Mix them together and update the color cube
		col = HSVToColor(h, s, v)
		self.color_cube:SetColor(col)
		
		-- Lastly, update the background color and label
		self.color_cube:UpdateColors(col)
			
	end

	function self.color_cube:OnUserChanged(col)
		-- Update background color and label
		self:UpdateColors(col)
	end

	-- Updates display colors, label, and clipboard text
	function self.color_cube.UpdateColors(s,col)
		color_label:SetText("Color( "..col.r..", "..col.g..", "..col.b.." )")
		color_label:SetColor(s:GetRGB())
		--SetClipboardText(color_label:GetText())
			
		self.HKColorData = s:GetRGB()
	end
	
	PanelTall = PanelTall + 130
	
	local list = ulxSTC:GetArgsType( mo )
	local asdf = false
	
	self.argPanels = {}

	for k, v in pairs(list) do
	
		local panel = nil
		
		if v == "StringArg" then
			panel = ulxSTC.HKEditor:StringArg( mo.args[k] )
			PanelTall = PanelTall + 32 + 10
		end
		
		if v == "NumArg" then
			panel = ulxSTC.HKEditor:NumArg( mo.args[k] )
			PanelTall = PanelTall + 32 + 10
		end
		
		if v == "BoolArg" then
			panel = ulxSTC.HKEditor:BoolArg( mo.args[k] )
			PanelTall = PanelTall + 32 + 10 + 18
		end
		
		if panel == nil then continue end
		
		if not asdf and not noSave then
			helpString:SetText( helpString:GetText() .. ulxSTC:Str( "Shortcut_Default_Args_Ex" ) )
			asdf = true
		end
		
		table.insert(self.argPanels, panel)
		
	end
	
	if isEdit then
		ulxSTC.HKEditor:CreatEditHKButton( hkNum )
	else
		ulxSTC.HKEditor:CreatNewHKButton( mo )
	end
	
	PanelTall = PanelTall + 50
	
	function helpString:PerformLayout()
		self:SetFontInternal( "Trebuchet18" )
		self:SetBGColor( Color( 255, 255, 255 ) )
		self:SizeToContents()
	end
	
	self.DFrame:SizeTo( 500, PanelTall, 0.3, 0 )
	self.DFrame:MoveTo( ScrW()/2 - 500/2, ScrH()/2 - PanelTall/2, 0.3, 0 )
	
end

function ulxSTC.HKEditor:CreatEditHKButton( hkNum )

	if ulxSTC.HKEditor.DPanel == nil or not ulxSTC.HKEditor.DPanel:IsValid() then return end
	
	local hk = ulxSTC:GetAllCommandHK()[hkNum]

	self.HKName:SetText(hk.name or "") -- fill default settings
	self.color_picker:SetRGB( hk.color or Color(255,255,255) )
	self.color_cube:SetColor( hk.color or Color(255,255,255) )
	self.HKIcon:SelectIcon( hk.icon )
	self.HKIconData = hk.icon
	for k, v in pairs(self.argPanels) do
		v:SetValue(hk.args[k])
	end

	local bottomButton = vgui.Create( "DPanel", ulxSTC.HKEditor.DPanel )
	bottomButton:Dock( BOTTOM )
	bottomButton:SetWidth( 50 )
	bottomButton.Paint = function(self, w, h) draw.RoundedBox( 0, 0, 0, w, h, Color( 108, 111, 114, 255 ) ) end
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Cancel" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
	end
	Button:Dock( RIGHT )
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Apply" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
		table.remove(ulxSTC:GetAllCommandHK(), hkNum)
		local args = {}
		for k, v in pairs(self.argPanels) do
			if v.GetChecked then
				table.insert(args, v:GetChecked()) -- for checkbox
			else
				table.insert(args, v:GetValue())
			end
		end
		table.insert(ulxSTC:GetAllCommandHK(), hkNum, {name=self.HKName:GetText() or "", cmd=hk.cmd, color=self.HKColorData, icon=self.HKIconData, args=args, target=hk.target})
		hook.Run("ULXSHORTCUT_COMMANDHK_ONCHANGE")
		ulxSTC:SaveCommandHK()
	end
	Button:Dock( RIGHT )
	
end

function ulxSTC.HKEditor:CreatNewHKButton( mo )

	if ulxSTC.HKEditor.DPanel == nil or not ulxSTC.HKEditor.DPanel:IsValid() then return end

	local bottomButton = vgui.Create( "DPanel", ulxSTC.HKEditor.DPanel )
	bottomButton:Dock( BOTTOM )
	bottomButton:SetWidth( 50 )
	bottomButton.Paint = function(self, w, h) draw.RoundedBox( 0, 0, 0, w, h, Color( 108, 111, 114, 255 ) ) end
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Cancel" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
	end
	Button:Dock( RIGHT )
	

	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Add" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor.DFrame:Close()
		local args = {}
		for k, v in pairs(self.argPanels) do
			table.insert(args, v:GetValue())
		end
		ulxSTC:AddCommandHK( self.HKName:GetText() or "", mo.cmd, self.HKColorData, self.HKIconData, args)
	end
	Button:Dock( RIGHT )

	
	--[[if asdf and not noSave then
		local Button = vgui.Create( "DButton", bottomButton )
		Button:SetText( "기본값 없이 추가" )
		Button:SetWide(125)
		Button.DoClick = function()
			ulxSTC.HKEditor.DFrame:Close()
			ulxSTC:AddCommandHK( self.HKName:GetText() or "", mo.cmd, self.HKColorData, self.HKIconData, nil)
		end
		Button:Dock( RIGHT )
	end]]
	
	local Button = vgui.Create( "DButton", bottomButton )
	Button:SetText( ulxSTC:Str( "Back" ) )
	Button.DoClick = function()
		ulxSTC.HKEditor:CreatModuleList( "PlayerArg" )
	end
	Button:Dock( LEFT )

end

function ulxSTC.HKEditor:StringArg( arg )

	local str = vgui.Create( "DComboBox", self.DPanel )
	str:DockMargin( 0, 10, 0, 0 )
	str:SetTall(32)
	--str:SetWide(self.DPanel:GetWide())
	str.Etry = vgui.Create( "DTextEntry", str )
	str.Etry:SetWide(440-30)
	str.Etry:Dock(LEFT)
	--str.Etry:SetSize(self.DPanel:GetWide()-30,str:GetTall())
	--str.Etry:SetPos(0,0)
	if arg.completes then
		for k, v in pairs(arg.completes) do
			str:AddChoice( v )
		end
	end
	str.OnSelect = function( self, index, value )
		str.Etry:SetText(value)
	end
	str.Etry:SetPlaceholderText( arg.hint or "" )
	
	str:Dock( TOP )
	
	return str.Etry
end

function ulxSTC.HKEditor:NumArg( arg )

	local num = vgui.Create( "DNumSlider", self.DPanel )
	num:DockMargin( 0, 10, 0, 0 )
	num:SetTall(32)
	num:SetWide(self.DPanel:GetWide())
	num:SetMin( arg.min or 0 )
	num:SetMax( arg.max or 100 )
	num:SetValue( 0 )
	num:SetDecimals( 0 )
	num:SetText( arg.hint or "" )
	
	num:Dock( TOP )
	
	return num
end

function ulxSTC.HKEditor:BoolArg( arg )

	local bools = {}
	
	if arg.hint then
	
		bools = vgui.Create( "DCheckBoxLabel", self.DPanel )
		bools:DockMargin( 0, 10, 0, 0 )
		bools:SetTall(32)
		bools:Dock( TOP )
		bools:SetValue( arg.default or false )
		bools:SetText( arg.hint or "" )
	
	else
	
		bools = vgui.Create( "DComboBox", self.DPanel )
		bools:DockMargin( 0, 10, 0, 0 )
		bools:SetTall(32)
		bools:Dock( TOP )
		
		bools:AddChoice( "true", true, true, "icon16/tick.png" )
		bools:AddChoice( "false", false, false, "icon16/cross.png" )
		--bools:AddChoice( "작동 방식: toggle", "toggle", true, "icon16/arrow_switch.png" )
		
		local margin = vgui.Create( "Panel", self.DPanel )
		margin:Dock( TOP )
		margin:SetTall(18)
		margin.Paint = function() end
		
		local help = vgui.Create( "DImageButton", margin )
		help:SetPos( self.DPanel:GetWide() - 18, 1 )
		help:SetImage( "icon16/information.png" )
		help:SizeToContents()
		help:SetTooltip( ulxSTC:Str( "Bool_Arg_Ex" ) )
		
	end
	
	return bools
end