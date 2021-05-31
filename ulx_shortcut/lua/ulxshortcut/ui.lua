
function ulxSTC:MakeUI( typeName )
	
	if not ulxSTC.UI then return end
	
	for k, v in pairs(ulxSTC.UI) do
		if typeName == v.type then
			include("ulxshortcut/ui/" .. v.type .. ".lua")
			print("[ULX Shortcut] Loaded Scorebaord... (" .. v.type .. ")")
		end
	end
	
end

function ulxSTC:GetUITampleteByGamemode( gamemode )
	if not ulxSTC.UI then return end
	
	for k, v in pairs(ulxSTC.UI) do
		if v.gamemode == gamemode then
			return v
		end
	end
	
	return
end

function ulxSTC:CreatUITamplete( typeName, gamemode, uniName )

	if not ulxSTC.UI then ulxSTC.UI = {} end
	
	table.insert(ulxSTC.UI, {type=typeName, gamemode=gamemode})
	
end