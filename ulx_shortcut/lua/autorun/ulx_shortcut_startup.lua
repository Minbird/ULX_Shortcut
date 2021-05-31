print("[ULX Shortcut] Start Up System!")


ulxSTC = {}
ulxSTC.CurVersion = 1.01
ulxSTC.CurVersionString = "1.01"
ulxSTC.NewerVersion = 1.01
ulxSTC.NewerVersionString = "1.01"

print("///////////////////////////////")
print("//	ULX Shortcut StartUp	//")
print("///////////////////////////////")
print("[ULX Shortcut] Loading...")
print("[ULX Shortcut] Loading Main Files...")

print("[ULX Shortcut] Try add File: ulxshortcut/ulxshortcut.lua")
AddCSLuaFile("ulxshortcut/ulxshortcut.lua")
include("ulxshortcut/ulxshortcut.lua")

print("[ULX Shortcut] Try add Client side File: ulxshortcut/ui.lua")
AddCSLuaFile("ulxshortcut/ui.lua")
if CLIENT then
	include("ulxshortcut/ui.lua")
end

print("[ULX Shortcut] Try add Client side File: ulxshortcut/ui/ui_list/ui_list.lua")
AddCSLuaFile("ulxshortcut/ui/ui_list/ui_list.lua")
if CLIENT then
	include("ulxshortcut/ui/ui_list/ui_list.lua")
end

print("[ULX Shortcut] Try add Client side File: ulxshortcut/hkEditor.lua")
AddCSLuaFile("ulxshortcut/hkEditor.lua")
if CLIENT then
	include("ulxshortcut/hkEditor.lua")
end

print("[ULX Shortcut] Loading Language Files...")
local folder = "ulxshortcut/lang"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[ULX Shortcut] Try add Client side Language File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
	if CLIENT then
		include(folder .. "/" .. file)
	end
end

print("[ULX Shortcut] Loading Scoreboard Tamplete Files...")
local folder = "ulxshortcut/ui"
local files = file.Find( folder .. "/" .. "*.lua", "LUA" )
for _, file in ipairs( files ) do
	print("[ULX Shortcut] Try add Scoreboard Tamplete File: " .. file)
	AddCSLuaFile( folder .. "/" .. file )
end

print("[ULX Shortcut] Try add Client side File: ulxshortcut/cl_init.lua")
AddCSLuaFile("ulxshortcut/cl_init.lua")
if CLIENT then
	include("ulxshortcut/cl_init.lua")
end

print("[ULX Shortcut] Checking Newer Version...")
http.Fetch( "https://minbird.github.io/versions/ulxshortcutNewerVer", function(data)
	print(data)
	if data == "" or data == nil then return end
	local ver = util.JSONToTable( data )
	if ver == nil or ver.Num == nil or ver.Str == nil then return end
	ulxSTC.NewerVersion = ver.Num
	ulxSTC.NewerVersionString = ver.Str
	print("[ULX Shortcut] System Version is " .. ulxSTC.CurVersionString .. ", Newer Version is " .. ulxSTC.NewerVersionString)
	if ulxSTC.NewerVersion > ulxSTC.CurVersion then
		print("[ULX Shortcut] There is a newer version can install! (" .. ulxSTC.NewerVersionString .. ")")
		if CLIENT then chat.AddText("[ULX Shortcut] There is a newer version can install! (" .. ulxSTC.NewerVersionString .. ")") end
	elseif ulxSTC.NewerVersion == ulxSTC.CurVersion then
		print("[ULX Shortcut] It's a latest version of ULX Shortcut that is installed.")
	end
end,
	function(data)
		print("[ULX Shortcut] Version check failed.")
	end
)

print("[ULX Shortcut] Done!")

if table.IsEmpty( ulxSTC:GetUlxModules() ) then
	print("[ULX Shortcut] Warning! ULX's modules has not loaded.")
end
--[[if CLIENT then
	ulxSTC.HKEditor:Open()
end]]