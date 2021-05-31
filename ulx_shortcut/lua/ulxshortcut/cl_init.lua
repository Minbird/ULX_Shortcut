
print("[ULX Shortcut] Init...")

local gamemode = GetConVar("gamemode"):GetString()
local tam = ulxSTC:GetUITampleteByGamemode( gamemode )

--[[if tam != nil then
	ulxSTC:MakeUI( tam )
end]]

ulxSTC:MakeUI( "SandBox_Default" )

ulxSTC:ChangeLang("SystemLang")

function LanguageChanged( lang )
	print(lang)
	ulxSTC:ChangeLang(lang) 
end

print("[ULX Shortcut] Init Complete.")