
-- gmod version 2021.05.24

--ulxSTC:CreatUITamplete( "SandBox_Default", "sandbox" )

surface.CreateFont( "CommandButtonDefault", {
	font	= "Helvetica",
	size	= 18,
	weight	= 800
} )

surface.CreateFont( "ScoreboardDefault", {
	font	= "Helvetica",
	size	= 22,
	weight	= 800
} )

surface.CreateFont( "ScoreboardDefaultTitle", {
	font	= "Helvetica",
	size	= 32,
	weight	= 800
} )

if shortcut_Scoreboard then shortcut_Scoreboard:Remove() end
shortcut_Scoreboard = nil
--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.

local SelectedPlayers = {}

local PLAYER_LINE = {

	Init = function( self )

		self.PlayerPanel = self:Add( "Panel" )
		self.PlayerPanel:Dock( FILL )
		
		self.CommandPanel = self:Add( "Panel" )
		self.CommandPanel:Dock( RIGHT )
		self.CommandPanel:SetWidth( 0 )
		self.CommandPanel.Paint = function(self, w, h) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 255 ) ) end

		self.AvatarButton = self.PlayerPanel:Add("DButton", self.PlayerPanel)
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )
		
		local MyColor = Color(0,0,0,0)
		self.PlayerSelect = self.PlayerPanel:Add("DButton")
		self.PlayerSelect:Dock( FILL )
		self.PlayerSelect:SetText("")
		self.PlayerSelect.IsSelected = false
		self.PlayerSelect.DoClick = function() self:PlayerSelectionClicked(self.Player) end
		MyColor = Color(0,0,0,0)
		self.PlayerSelect.Paint = function(self, w, h) draw.RoundedBox( 4, 0, 0, w, h, MyColor ) end
		self.PlayerSelect.SetColor = function(color) 
			MyColor = color or Color(0,0,0,0) 
		end

		self.Name = vgui.Create("DLabel", self.PlayerSelect)
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:SetTextColor( Color( 93, 93, 93 ) )
		self.Name:DockMargin( 8, 0, 0, 0 )
		self.Name:SetMouseInputEnabled( false )

		self.Mute = self.PlayerPanel:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping = self.PlayerPanel:Add( "DLabel" )
		self.Ping:SetWidth( 50 )
		self.Ping:Dock( RIGHT )
		self.Ping:SetFont( "ScoreboardDefault" )
		self.Ping:SetTextColor( Color( 93, 93, 93 ) )
		self.Ping:SetContentAlignment( 5 )

		self.Deaths = self.PlayerPanel:Add( "DLabel" )
		self.Deaths:Dock( RIGHT )
		self.Deaths:SetWidth( 50 )
		self.Deaths:SetFont( "ScoreboardDefault" )
		self.Deaths:SetTextColor( Color( 93, 93, 93 ) )
		self.Deaths:SetContentAlignment( 5 )

		self.Kills = self.PlayerPanel:Add( "DLabel" )
		self.Kills:Dock( RIGHT )
		self.Kills:SetWidth( 50 )
		self.Kills:SetFont( "ScoreboardDefault" )
		self.Kills:SetTextColor( Color( 93, 93, 93 ) )
		self.Kills:SetContentAlignment( 5 )

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3 * 2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,
	
	PlayerSelectionClicked = function(self, ply, bool, rotate)
		self.PlayerSelect.IsSelected = self.PlayerSelect.IsSelected or false
		if bool != nil and not rotate then
			if bool then -- select all or unselect all
				self:SelectPlayers(ply)
			else
				self:RemovePlayers(ply)
			end
			self.PlayerSelect.IsSelected = bool
		elseif rotate then -- rotate selection
			if self.PlayerSelect.IsSelected then
				self:RemovePlayers(ply)
			else
				self:SelectPlayers(ply)
			end
			self.PlayerSelect.IsSelected = !self.PlayerSelect.IsSelected
		else -- select or unselect self
			if self.PlayerSelect.IsSelected then
				self:RemovePlayers(ply)
			else
				self:SelectPlayers(ply)
			end
			self.PlayerSelect.IsSelected = !self.PlayerSelect.IsSelected
			hook.Run("ULXSHORTCUT_PlayerSelectionClicked", self.PlayerSelect.IsSelected)
		end
	end,
	
	SelectPlayers = function( self, ply )
	
		table.insert(SelectedPlayers, ply)
		self.PlayerSelect.SetColor( Color( 101, 149, 255, 255 ) )
		self.Name:SetTextColor( Color( 255, 255, 255 ) )
		self.PlayerSelect:SetIcon( "icon16/tick.png" )
		self.Name:SetText( "    " .. self.PName )
		surface.PlaySound( "UI/buttonclick.wav" )
		
	end,
	
	RemovePlayers = function( self, ply )
	
		table.RemoveByValue(SelectedPlayers, ply)
		self.PlayerSelect.SetColor( Color( 0, 0, 0, 0 ) )
		self.Name:SetTextColor( Color( 93, 93, 93 ) )
		self.PlayerSelect:SetIcon( nil )
		self.Name:SetText( self.PName )
		surface.PlaySound( "UI/buttonclickrelease.wav" )
		
	end,

	RefreshCommandPanel = function( self )
		self.CommandPanel:Clear()
		self.CommandPanel:SetWidth(0)
		
		if #ulxSTC:GetAllCommandHK() == 0 then
			self:AddCommandPanel( ulxSTC:Str( "Make_New" ), ulxSTC.HKEditor.Open, Color(255,255,255,255), "icon16/add.png", 1, true )
		else
			for k, v in pairs(ulxSTC:GetAllCommandHK()) do
				local panel = self:AddCommandPanel( v.name, v.cmd, v.color, v.icon, k, false, self.Player )
				panel.DoRightClick = function(self)
					self.Options = DermaMenu()
					--self.Options:AddOption( "\"" .. v.name .. "\" 실행", function() ulxSTC:RunCommandByHKNum( k, self.Player, nil ) end ):SetIcon( "icon16/resultset_first.png" )
					self.Options:AddOption( ulxSTC:Str( "Edit_Shortcut", v.name ), function() ulxSTC.HKEditor:Open( v, k ) end):SetIcon( "icon16/pencil.png" )
					self.Options:AddOption( ulxSTC:Str( "Delete_Shortcut", v.name ), function() ulxSTC:RemoveCommandHKByName( v.name ) end):SetIcon( "icon16/bin.png" )
					self.Options:AddOption( ulxSTC:Str( "Make_New_Shortcut" ), ulxSTC.HKEditor.Open ):SetIcon( "icon16/add.png" )
					self.Options:AddOption( ulxSTC:Str( "CopyToClipboard" ), function() ulxSTC:CopyHKListToClipboard() end ):SetIcon( "icon16/page_copy.png" )
					self.Options:AddOption( ulxSTC:Str( "SetListTo" ), function() ulxSTC.HKEditor:Open( nil, nil, true ) end ):SetIcon( "icon16/page_save.png" )
					self.Options:Open()
				end
			end
		end

		if self.CommandPanel:GetWide() > 900/2 then
			SCORE_BOARD_SIZE_W = 900 + ( self.CommandPanel:GetWide() - 900/2 )
			SCORE_BOARD_SIZE_T = ScrH() - 200
			SCORE_BOARD_POS_X = ScrW()/2 - (900 + ( self.CommandPanel:GetWide() - 900/2 ))/2
			SCORE_BOARD_POS_Y = 100
			
		else
			SCORE_BOARD_SIZE_W = 900
			SCORE_BOARD_SIZE_T = ScrH() - 200
			SCORE_BOARD_POS_X = ScrW() / 2 -450
			SCORE_BOARD_POS_Y = 100
		end
		
		shortcut_Scoreboard:SetSize( SCORE_BOARD_SIZE_W, SCORE_BOARD_SIZE_T )
		shortcut_Scoreboard:SetPos( SCORE_BOARD_POS_X, SCORE_BOARD_POS_Y )
		
	end,
	
	AddCommandPanel = function( self, name, module, color, icon, num, new )
	
		local num = num or 1
		local comBack = vgui.Create( "DButton", self.CommandPanel )
		local name = name or ""
		local color = color or Color(255,255,255,255)
		local icon = icon or "icon16/add.png"
		
		surface.SetFont( "CommandButtonDefault" )
		local w, h = surface.GetTextSize( name )
		comBack:SetSize( 32 + w + 10, 32 )
		comBack:Dock( RIGHT )
		comBack:SetIcon( icon )
		comBack:SetText( "  " .. name)
		comBack:SetFont("CommandButtonDefault")
		
		local left = false
		local right = false
		
		if num == 1 then 
			right = true 
		end
		if num == #ulxSTC:GetAllCommandHK() then 
			left = true 
		end
		
		comBack.HKModule = module
		comBack.HKColor = color
		
		comBack.Paint = function(self, w, h) 
			draw.RoundedBoxEx( 4, 0, 0, w, h, self.HKColor, left, right, left, right )
		end
		
		self.CommandPanel:SetWidth( 32 + w + 10 + self.CommandPanel:GetWide() )
		
		comBack.DoClick = function()
			if new then
				module()
			else
				local selectedPlayer = {}
				if self.PlayerSelect.IsSelected then
					for k, v in pairs(player.GetAll()) do
						if v.scoreBoardPanel.PlayerSelect.IsSelected then
							table.insert(selectedPlayer, v)
						end
					end
				end
				if table.IsEmpty( selectedPlayer ) then 
					table.Empty(selectedPlayer)
					table.insert(selectedPlayer, self.Player)
				end
				ulxSTC:RunCommandByHKNum( num, selectedPlayer, InstantArgs )
			end
		end
		
		comBack.OnCursorEntered = function()
			comBack.HKColor = Color(comBack.HKColor.r, comBack.HKColor.g, comBack.HKColor.b, 100)
			self.BGAlpha = 150
		end
		comBack.OnCursorExited = function()
			comBack.HKColor = color
			self.BGAlpha = 255
		end

		
		return comBack
	end,
	
	GetPlayerData = function(self)
		return self.Player
	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )

		self:Think( self )
		
		self:RefreshCommandPanel()
		
		pl.scoreBoardPanel = self

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:SetZPos( 9999 ) -- Causes a rebuild
			self:Remove()
			return
		end	

		if ( self.PName == nil || self.PName != self.Player:Nick() ) then
			self.PName = self.Player:Nick()
			self.Name:SetText( self.PName )
		end
		
		if ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) then
			self.NumKills = self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumDeaths == nil || self.NumDeaths != self.Player:Deaths() ) then
			self.NumDeaths = self.Player:Deaths()
			self.Deaths:SetText( self.NumDeaths )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			self.NumPing = self.Player:Ping()
			self.Ping:SetText( self.NumPing )
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING ) then
			self:SetZPos( 2000 + self.Player:EntIndex() )
			return
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( ( self.NumKills * -50 ) + self.NumDeaths + self.Player:EntIndex() )

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		if ( self.Player:Team() == TEAM_CONNECTING ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 200, 200, (self.BGAlpha or 255) - 55 ) )
			return
		end

		if ( !self.Player:Alive() ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 200, 200, self.BGAlpha or 255 ) )
			return
		end

		if ( self.Player:IsAdmin() ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 255, 230, self.BGAlpha or 255 ) )
			return
		end

		draw.RoundedBox( 4, 0, 0, w, h, Color( 230, 230, 230, self.BGAlpha or 255 ) )

	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" )

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--

local SCORE_BOARD = {


	Init = function(self)

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont( "ScoreboardDefaultTitle" )
		self.Name:SetTextColor( color_white )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		self.AllPlayerPanel = self:Add( "Panel" )
		self.AllPlayerPanel:Dock( TOP )
		self.AllPlayerPanel:SetHeight( 32 )
		self.AllPlayerPanel:DockMargin( 0, 0, 0, 5)
		
		local selectCount = 0
		local MyColor = Color( 151, 199, 255, 255 )
		self.AllPlayerSelect = self.AllPlayerPanel:Add("DButton") -- All select or unselect
		self.AllPlayerSelect:DockMargin( 5,0,0,0 )
		self.AllPlayerSelect:Dock( LEFT )
		self.AllPlayerSelect:SetWide( 150 )
		self.AllPlayerSelect:SetText( ulxSTC:Str( "Select_All" ) )
		self.AllPlayerSelect:SetFont("CommandButtonDefault")
		self.AllPlayerSelect:SetIcon( "icon16/tick.png" )
		self.AllPlayerSelect.IsSelected = false
		self.AllPlayerSelect.DoClick = function() 
			self.AllPlayerSelect.IsSelected = !self.AllPlayerSelect.IsSelected
			self:SelectAllPlayers(self.AllPlayerSelect.IsSelected)
			if self.AllPlayerSelect.IsSelected then
				self.AllPlayerSelect.SetColor(Color( 255, 199, 151, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "De_Select_All" ) )
				selectCount = #player.GetAll()
				self.AllPlayerSelect:SetIcon( "icon16/cross.png" )
			else
				self.AllPlayerSelect.SetColor(Color( 151, 199, 255, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "Select_All" ) )
				selectCount = 0
				self.AllPlayerSelect:SetIcon( "icon16/tick.png" )
			end
		end
		self.AllPlayerSelect.Paint = function(self, w, h) draw.RoundedBox( 4, 0, 0, w, h, MyColor ) end
		self.AllPlayerSelect.SetColor = function(color) 
			MyColor = color or Color(0,0,0,0) 
		end
		
		self.AllPlayerSelectMirror = self.AllPlayerPanel:Add("DButton") -- Mirror select
		self.AllPlayerSelectMirror:DockMargin( 5,0,0,0 )
		self.AllPlayerSelectMirror:Dock( LEFT )
		self.AllPlayerSelectMirror:SetWide( 150 )
		self.AllPlayerSelectMirror:SetText( ulxSTC:Str( "Mirror" ) )
		self.AllPlayerSelectMirror:SetFont("CommandButtonDefault")
		self.AllPlayerSelectMirror:SetIcon( "icon16/arrow_switch.png" )
		self.AllPlayerSelectMirror.IsSelected = false
		self.AllPlayerSelectMirror.DoClick = function() 
		
			selectCount = math.abs(#SelectedPlayers - #player.GetAll())
			self.AllPlayerSelectMirror.IsSelected = !self.AllPlayerSelectMirror.IsSelected
			self:SelectAllPlayers(self.AllPlayerSelectMirror.IsSelected, true)
			
			if selectCount < 0 then selectCount = 0 end
			
			if selectCount > 0 then
				self.AllPlayerSelect.SetColor(Color( 255, 199, 151, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "De_Select_All" ) )
				self.AllPlayerSelect:SetIcon( "icon16/cross.png" )
				self.AllPlayerSelect.IsSelected = true
			else
				self.AllPlayerSelect.SetColor(Color( 151, 199, 255, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "Select_All" ) )
				self.AllPlayerSelect:SetIcon( "icon16/tick.png" )
				self.AllPlayerSelect.IsSelected = false
			end
			
		end
		self.AllPlayerSelectMirror.Paint = function(self, w, h) draw.RoundedBox( 4, 0, 0, w, h, Color(255,255,255) ) end
		
		hook.Add("ULXSHORTCUT_PlayerSelectionClicked", "AllPlayerSelect", function(bo)
			
			if selectCount < 0 then selectCount = 0 end
			
			if bo then
				selectCount = selectCount + 1
			else
				selectCount = selectCount - 1
			end
			
			if selectCount > 0 then
				self.AllPlayerSelect.SetColor(Color( 255, 199, 151, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "De_Select_All" ) )
				self.AllPlayerSelect:SetIcon( "icon16/cross.png" )
				self.AllPlayerSelect.IsSelected = true
			else
				self.AllPlayerSelect.SetColor(Color( 151, 199, 255, 255 ))
				self.AllPlayerSelect:SetText( ulxSTC:Str( "Select_All" ) )
				self.AllPlayerSelect:SetIcon( "icon16/tick.png" )
				self.AllPlayerSelect.IsSelected = false
			end
			
		end)

		--self.NumPlayers = self.Header:Add( "DLabel" )
		--self.NumPlayers:SetFont( "ScoreboardDefault" )
		--self.NumPlayers:SetTextColor( color_white )
		--self.NumPlayers:SetPos( 0, 100 - 30 )
		--self.NumPlayers:SetSize( 300, 30 )
		--self.NumPlayers:SetContentAlignment( 4 )
		
		
		--[[self.CommandsB = self:Add("Panel")
		self.CommandsB:Dock( BOTTOM )
		self.CommandsB:SetHeight( 100 )]]
		
		--[[self.MadeBy = self.AllPlayerPanel:Add( "Panel" )
		self.MadeBy:Dock( LEFT )
		self.MadeBy:SetWidth( 200 )
		self.MadeBy.Paint = function(self, w, h) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 255 ) ) end]]
		
		local Name = self.AllPlayerPanel:Add("DLabel")
		Name:SetFont( "DermaDefault" )
		Name:SetTextColor( color_white )
		Name:DockMargin( 5,0,0,0 )
		Name:Dock( LEFT )
		--Name:SetHeight( 40 )
		Name:SetWidth( 300 )
		Name:SetContentAlignment( 1 )
		Name:SetText( "'Ulx Shortcut " .. ulxSTC.CurVersionString .. "' | Made by MINBIRD" )
		Name:SetAlpha( 150 )
		
		self.Scores = self:Add("DScrollPanel")
		self.Scores:Dock( FILL )

	end,
	
	SelectAllPlayers = function( self, bool, rotate )
		local plyrs = player.GetAll()
		for id, pl in pairs(plyrs) do
			pl.scoreBoardPanel:PlayerSelectionClicked(pl,bool,rotate)
		end
	end,
	
	Paint = function( self, w, h )
	end,

	PerformLayout = function( self )
		
		SCORE_BOARD_SIZE_W = SCORE_BOARD_SIZE_W or 900
		SCORE_BOARD_SIZE_T = SCORE_BOARD_SIZE_T or ScrH() - 200
		SCORE_BOARD_POS_X = SCORE_BOARD_POS_X or ScrW() / 2 -450
		SCORE_BOARD_POS_Y = SCORE_BOARD_POS_Y or 100
		
		self:SetSize( SCORE_BOARD_SIZE_W, SCORE_BOARD_SIZE_T )
		self:SetPos( SCORE_BOARD_POS_X, SCORE_BOARD_POS_Y )

	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() ) -- GetHostName()

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then continue end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			pl.ScoreEntry:RefreshCommandPanel()
			
			pl.Margin = vgui.Create( "Panel", pl.ScoreEntry )
			pl.Margin:Dock( RIGHT )
			pl.Margin:SetWidth( 30 )

			self.Scores:AddItem( pl.ScoreEntry )

		end

	end
	
}

SCORE_BOARD  = vgui.RegisterTable( SCORE_BOARD , "EditablePanel" )

local SCORE_BOARD_SIZE_W = 900
local SCORE_BOARD_SIZE_T = ScrH() - 200
local SCORE_BOARD_POS_X = ScrW() / 2 -450
local SCORE_BOARD_POS_Y = 100

hook.Add("InitPostEntity", "ULXSHORTCUT_INIT", function()

	function GAMEMODE:ScoreboardShow()

		if ( !IsValid( shortcut_Scoreboard ) ) then
			shortcut_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
		end

		shortcut_Scoreboard:Show()
		shortcut_Scoreboard:MakePopup()
		shortcut_Scoreboard:SetKeyboardInputEnabled( false )
		shortcut_Scoreboard:MoveToFront()

	end

	--[[---------------------------------------------------------
		Name: gamemode:ScoreboardHide( )
		Desc: Hides the scoreboard
	-----------------------------------------------------------]]
	function GAMEMODE:ScoreboardHide()

		if ( IsValid( shortcut_Scoreboard ) ) then
			shortcut_Scoreboard:Hide()
		end

	end
	
end)

hook.Add("ULXSHORTCUT_COMMANDHK_ONCHANGE", "RefreshCommandPanel", function()
	local plyrs = player.GetAll()
	for k, pl in pairs(plyrs) do
		pl.ScoreEntry:RefreshCommandPanel()
	end
end)