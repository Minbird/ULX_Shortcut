
function ulxSTC:IsUlxInstalled()
	if not ulx or not ULib then
		return false
	end
	return true
end

function ulxSTC:GetUlxModules()
	if !ulxSTC:IsUlxInstalled() then return {} end
	return ULib.cmds.translatedCmds or {}
end

function ulxSTC:GetUlxCategory()
	if !ulxSTC:IsUlxInstalled() then return {} end
	return table.GetKeys( ulx.cmdsByCategory )
end

function ulxSTC:GetModule( cmdName ) -- return module table, recieve string
	if !ulxSTC:IsUlxInstalled() then return {} end
	if !isstring(cmdName) then return {} end
	return ULib.cmds.translatedCmds[cmdName]
end

function ulxSTC:FilterModulesWithType( mds, type ) -- filtering modules by arg type...
	local list = {}
	
	for k, v in pairs(mds) do
		if type == "PlayerArg" or type == "PlayersArg" then
			if ulxSTC:hasPlayerArg( v ) then
				table.insert(list, v)
			end
		else
			if ulxSTC:hasArg( type, v ) then
				table.insert(list, v)
			end
		end
	end
	
	return list
end

function ulxSTC:hasArg( arg, mo ) -- this funtion receive module(table) and arg type name(string), and return bool.
	if not istable( mo ) then return false end
	
	for k, v in pairs(mo.args) do
		if v.type == ULib.cmds[arg] then
			return true
		end
	end

	return false
end

function ulxSTC:GetArgType( arg )
	
	for k, v in pairs(ULib.cmds) do
		if arg.type == v then
			return k
		end
	end
	
	return nil
	
end

function ulxSTC:GetArgsType( mo ) -- receive module, return table(Types List)

	local argsN = {}
	if mo == nil or mo.args == nil or #mo.args == 0 then return argsN end
	
	for k, v in pairs(mo.args) do
		table.insert(argsN, ulxSTC:GetArgType( v ))
	end
	
	return argsN

end

function ulxSTC:GetArgOnHKByNum( num, argType, index )
	
	local args = ulxSTC:GetAllCommandHK()[num].args or {}
	local argsCount = 1
	
	for k, v in pairs(args) do
		if v.type == argType then
			if index and argsCount != index then 
				argsCount = argsCount + 1
				continue 
			end
			return v.arg
		end
	end
	
	return nil
	
end

function ulxSTC:RunCommandByHKNum( num, targetPlys, InstantArgs )
	
	local hk = ulxSTC:GetAllCommandHK()[num]
	ulxSTC:RunCommandByCmdStr( ulxSTC:GetAllCommandHK()[num].cmd, targetPlys, hk.args )
	
end

function ulxSTC:RunCommandByCmdStr( cmdStr, targetPlys, InstantArgs )
	
	local mo = ulxSTC:GetModule( cmdStr )
	
	if mo == nil or mo == {} then
		chat.AddText( Color( 255, 0, 0 ), ulxSTC:Str( "MoLodingError", cmdStr or "Unknown command" ) )
		return 
	end
	
	local argsList = ulxSTC:GetArgsType( mo )
	local args = string.Explode( " ", cmdStr )
	local targetPlys = targetPlys or {}
	local plys = {}
	
	local StringArgCount = 1
	local NumArgCount = 1
	local InstantArgsCount = 1
	
	if argsList != {} then
		for k, v in pairs(argsList) do
			if v == "PlayersArg" or v == "PlayerArg" then
				for k, v in pairs(targetPlys) do
					table.insert( plys, "$" .. ULib.getUniqueIDForPlayer( v ) )
					table.insert( plys, "," )
				end
				table.remove( plys )
				table.insert( args, table.concat( plys ) )
			end
		
			if v == "StringArg" then
				StringArgCount = StringArgCount + 1
				--local strArg = ulxSTC:GetArgOnHKByNum( num, "StringArg", StringArgCount )
				table.insert(args,InstantArgs[InstantArgsCount])
				if strArg == nil then InstantArgsCount = InstantArgsCount + 1 end
			end
			
			if v == "NumArg" then
				NumArgCount = NumArgCount + 1
				--local numArg = ulxSTC:GetArgOnHKByNum( num, "NumArg", NumArgCount )
				table.insert(args,InstantArgs[InstantArgsCount])
				if numArg == nil then InstantArgsCount = InstantArgsCount + 1 end
			end

			if v == "BoolArg" and table.Count(argsList) == k then
				if InstantArgs[InstantArgsCount] == "false" then
					args[2] = string.Explode( " ", mo.opposite )[2]
				end
				if boArg == nil then InstantArgsCount = InstantArgsCount + 1 end
			elseif v == "BoolArg" and table.Count(argsList) != k then
				if InstantArgs[InstantArgsCount] == true then
					table.insert(args,"1")
				else
					table.insert(args,"0")
				end
				if boArg == nil then InstantArgsCount = InstantArgsCount + 1 end
			end
			
		end
	end
	
	RunConsoleCommand( unpack( args ) )

end

local commandPanels = commandPanels or {}
function ulxSTC:AddCommandHK( name, moduleCmd, color, icon, args, target)
	local args = args or false
	table.insert(commandPanels, {name=name, cmd=moduleCmd, color=color, icon=icon, args=args, target=target})
	hook.Run("ULXSHORTCUT_COMMANDHK_ONCHANGE")
	ulxSTC:SaveCommandHK()
end

function ulxSTC:OpenHKEditorByName( name )
	
	local hk = ulxSTC:GetCommandHKByName( name )
	
	ulxSTC.HKEditor:Open( hk )
	
end

function ulxSTC:GetAllCommandHK()
	return commandPanels or {}
end

function ulxSTC:GetCommandHKByName( name )
	
	for k, v in pairs(commandPanels) do
		if v.name == name then return v end
	end
	
	return nil
	
end

function ulxSTC:RemoveCommandHKByName( name )

	for k, v in pairs(commandPanels) do
		if v.name == name then
			table.remove(commandPanels, k)
		end
	end
	
	hook.Run("ULXSHORTCUT_COMMANDHK_ONCHANGE")
	ulxSTC:SaveCommandHK()

end

function ulxSTC:SaveCommandHK()
	
	if Use_Server_Default then print("[ULX Shortcut] Warning. Shortcut List Table Data has changed and saved to Server Default...") end
	file.Write( "UlxShortcut_Setting.txt", util.TableToJSON(commandPanels) )

end

function ulxSTC:ReadCommandHK()
	
	if not file.Find( "UlxShortcut_Setting.txt", "DATA" ) then
		commandPanels = {}
	else
		commandPanels = util.JSONToTable( file.Read( "UlxShortcut_Setting.txt", "DATA" ) or "{}" )
	end
	
	hook.Run("ULXSHORTCUT_COMMANDHK_ONCHANGE")

end

function ulxSTC:CopyHKListToClipboard()
	chat.AddText(ulxSTC:Str( "CopiedToClipboard_HKList" ))
	SetClipboardText( util.TableToJSON(commandPanels) )
end

function ulxSTC:SetHKListFromJSON( json )
	commandPanels = util.JSONToTable(json)
	if commandPanels == nil or table.IsEmpty(commandPanels) or not commandPanels[1].cmd then
		ulxSTC:ReadCommandHK()
		chat.AddText(ulxSTC:Str( "SetListToError" ))
		return
	end
	ulxSTC:SaveCommandHK()
end

--[[
Arg list
3	=	NumArg *
7	=	CallingPlayerArg *
9	=	PlayersArg *
10	=	PlayerArg *
16	=	StringArg *
17	=	BoolArg *
19	=	BaseArg
]]

function ulxSTC:hasPlayerArg( mo ) -- this funtion receive module table, and return bool.
	return ulxSTC:hasArg( "PlayersArg", mo ) or ulxSTC:hasArg( "PlayerArg", mo )
end

function ulxSTC:hasStringArg( mo ) -- this funtion receive module table, and return bool.
	return ulxSTC:hasArg( "StringArg", mo )
end

function ulxSTC:hasNumArg( mo ) -- this funtion receive module table, and return bool.
	return ulxSTC:hasArg( "NumArg", mo )
end

--ulxSTC:AddCommandHK( "테스트", nil, Color(255,150,255), "icon16/add.png" )

if CLIENT then
	ulxSTC:ReadCommandHK()
end

local CurLangData = {}
local CurLang = nil
local Lang = {}

function ulxSTC:AddLanguage( name, uniName )
	
	for k, v in pairs(CurLangData) do
		if v.LangUni == uniName then
			v.Data = {}
			return v.Data
		end
	end
	
	table.insert( CurLangData, {
		Lang = name,
		LangUni = uniName
	}
	)
	
	print("[ULX Shortcut] Language Loaded: " .. name)
	
	for k, v in pairs(CurLangData) do
		if v.LangUni == uniName then
			v.Data = {}
			return v.Data
		end
	end
	
end

local DoDefaultSet = false
function ulxSTC:ChangeLang(uniName)
			
	if uniName == "SystemLang" then
		CurLang = GetConVarString("gmod_language")
	elseif uniName != nil then
		CurLang = uniName
	end
		
	for k, v in pairs(CurLangData) do
		if v.LangUni == CurLang then
			Lang = v.Data
			print("[ULX Shortcut] Changed Language to: " .. v.Lang)
			return v.Lang
		end
		if #CurLangData == k and not DoDefaultSet then
			DoDefaultSet = true
			ulxSTC:ChangeLang("en")
		end
	end
	
end

function ulxSTC:Str( tag, ... )

	local f = { ... }
	local s = Lang[tag]
	if s != nil then
		if f != nil then

			return string.format( tostring(s), ... )

		end
		return s
	end
	return tag

end