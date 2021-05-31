
function ulxSTC:SaveCommandHK( commandPanels )
	
	file.Write( "UlxShortcut_Setting_Server.txt", util.TableToJSON(commandPanels) )

end

local commandPanels = {}

function ulxSTC:ReadCommandHK()
	
	if not file.Find( "UlxShortcut_Setting_Server.txt", "DATA" ) then
		commandPanels = {}
	else
		commandPanels = util.JSONToTable( file.Read( "UlxShortcut_Setting_Server.txt", "DATA" ) or "{}" )
	end

end
