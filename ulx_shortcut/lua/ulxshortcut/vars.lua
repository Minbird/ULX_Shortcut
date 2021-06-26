
ulxSTC:AddNumVar( "os_time", function( ps )
	return os.time()
end)

ulxSTC:AddNumVar( "deaths", function( ps )
	return ps[1]:Deaths()
end)

ulxSTC:AddNumVar( "kills", function( ps )
	return ps[1]:Frags()
end)

ulxSTC:AddNumVar( "duck_spd", function( ps )
	return ps[1]:GetDuckSpeed()
end)

ulxSTC:AddNumVar( "unduck_spd", function( ps )
	return ps[1]:GetUnDuckSpeed()
end)

ulxSTC:AddNumVar( "jump_pwr", function( ps )
	return ps[1]:GetJumpPower()
end)

ulxSTC:AddNumVar( "ladder_climb_spd", function( ps )
	return ps[1]:GetLadderClimbSpeed()
end)

ulxSTC:AddNumVar( "max_spd", function( ps )
	return ps[1]:GetMaxSpeed()
end)

ulxSTC:AddNumVar( "walk_spd", function( ps )
	return ps[1]:GetWalkSpeed()
end)

ulxSTC:AddNumVar( "run_spd", function( ps )
	return ps[1]:GetRunSpeed()
end)

ulxSTC:AddNumVar( "slw_walk_spd", function( ps )
	return ps[1]:GetSlowWalkSpeed()
end)

ulxSTC:AddNumVar( "step_sz", function( ps )
	return ps[1]:GetStepSize()
end)

ulxSTC:AddNumVar( "hp", function( ps )
	return ps[1]:Health()
end)

ulxSTC:AddNumVar( "max_hp", function( ps )
	return ps[1]:GetMaxHealth()
end)

ulxSTC:AddNumVar( "high_hp", function( ps )
	local hps = {}
	for k, v in pairs(ps) do
		table.insert(hps, v:Health())
	end
	return math.max(unpack(hps))
end)
 
ulxSTC:AddNumVar( "low_hp", function( ps ) 
	local hps = {}
	for k, v in pairs(ps) do
		table.insert(hps, v:Health())
	end
	return math.min(unpack(hps))
end )

ulxSTC:AddNumVar( "armor", function( ps )
	return ps[1]:Armor()
end)

ulxSTC:AddNumVar( "max_armor", function( ps )
	return ps[1]:GetMaxArmor()
end)

ulxSTC:AddNumVar( "high_armor", function( ps )
	local hps = {}
	for k, v in pairs(ps) do
		table.insert(hps, v:Armor())
	end
	return math.max(unpack(hps))
end)
 
ulxSTC:AddNumVar( "low_armor", function( ps ) 
	local hps = {}
	for k, v in pairs(ps) do
		table.insert(hps, v:Armor())
	end
	return math.min(unpack(hps))
end )