CreateConVar( "ttt_amongus_health", 100 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Initial health of an Amongus" )
CreateConVar( "ttt_amongus_number", 3 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Amount of Amongus that can be summoned" )
CreateConVar( "ttt_amongus_range", 1.5 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "Distance Amongus will summon from a hidden state" )
CreateConVar( "ttt_amongus_force_fast", -1 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "1: forces fast vesion, 0: forces slow, -1 is default" )


sound.Add 
{
	name = "Zombine.Charge",
	channel = CHAN_VOICE,
	volume = 0.9,
	pitch = {90, 110},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_charge1.wav", "npc/zombine/zombine_alert6.wav"}
}

sound.Add 
{
	name = "Zombine.ReadyGrenade",
	channel = CHAN_VOICE,
	volume = 0.9,
	pitch = {95, 104},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_readygrenade1.wav", "npc/zombine/zombine_readygrenade2.wav"}
}

sound.Add 
{
	name = "Zombine.StrafeRight",
	channel = CHAN_BODY,
	volume = 0.95,
	pitch = {92, 105},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/gear1.wav", "npc/zombine/gear2.wav"}
}

sound.Add 
{
	name = "Zombine.StrafeLeft",
	channel = CHAN_BODY,
	volume = 0.95,
	pitch = {92, 105},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/gear1.wav", "npc/zombine/gear3.wav"}
}

sound.Add 
{
	name = "Zombine.Pain",
	channel = CHAN_VOICE,
	volume = 1,
	pitch = {95, 104},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_pain1.wav", "npc/zombine/zombine_pain2.wav", "npc/zombine/zombine_pain3.wav", "npc/zombine/zombine_pain4.wav"}
}

sound.Add 
{
	name = "Zombine.Alert",
	channel = CHAN_VOICE,
	volume = 0.80,
	pitch = {95, 104},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_alert1.wav", "npc/zombine/zombine_alert3.wav", "npc/zombine/zombine_alert4.wav", "npc/zombine/zombine_alert5.wav", "npc/zombine/zombine_alert7.wav"}
}

sound.Add 
{
	name = "Zombine.Idle",
	channel = CHAN_VOICE,
	volume = 0.75,
	pitch = {92, 105},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_alert2.wav", "npc/zombine/zombine_idle1.wav", "npc/zombine/zombine_idle2.wav", "npc/zombine/zombine_idle3.wav", "npc/zombine/zombine_idle4.wav"}
}

sound.Add 
{
	name = "Zombine.Die",
	channel = CHAN_VOICE,
	volume = 0.95,
	pitch = {90, 110},
	level = SNDLVL_NORM,
	sound = {"npc/zombine/zombine_die1.wav", "npc/zombine/zombine_die2.wav", "npc/zombie/zombie_die3.wav"}
}

sound.Add 
{
	name = "Amongus_Appear",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	sound = "Amongus_Appear.mp3"
}

local NPC = {	Name = "Amongus",
				Class = "npc_amongus_zombine",
				Category = "Zombies + Enemy Aliens" }

list.Set( "NPC", "iamongus", NPC )

if engine.ActiveGamemode() ~= "terrortown" then return end
if SERVER then
  	resource.AddWorkshop( "2887757921" )
	SetGlobalBool( "SprintIsMounted", false )
	for k, addon in ipairs( engine.GetAddons()) do
		if addon.mounted then
			if addon.wsid == "933056549" then
				SetGlobalBool( "SprintIsMounted", true )
			end
		end
	end

	hook.Add( "Think", "amongThink" , function()
		if SERVER then
			for i, ent in ipairs(ents.FindByClass( "amongus_spawner" )) do
				for _, ply in ipairs( player.GetAll()) do
					if ply:Alive() then
						local dis = 0.01905 * ((ply:GetPos() - ent:GetPos()):Length() - ply:BoundingRadius())
						local maxDis = GetConVar("ttt_amongus_range"):GetFloat()
						if dis < maxDis then
						
							local t = {
								start = ply:GetPos() + Vector(0,0,30),
								endpos = ent:GetPos() + Vector(0,0,30),
								filter = {ent,ply}
							}
							local tr = util.TraceLine(t)
							
							if not tr.Hit then 
								local amongus = ents.Create( "npc_amongus_zombine" )


								if IsValid( amongus ) then
									
									local spawnereasd = false
									local pos = ent:GetPos() + Vector(0,0,2)
									local offsets = {Vector(0,0,0)}

									for i = 0, 360, 15 do
										table.insert( offsets, Vector( math.sin( i ), math.cos( i ), 0 ) )
									end

									local midsize = Vector( 34, 34, 76 )
									local tstart   = pos + Vector( 0, 0, midsize.z / 2 )

									for i = 1, #offsets do
										local o = offsets[ i ]
										local v = tstart + o * midsize * 1.5

										t = {
											start = v,
											endpos = v,
											filter = ent,
											mins = midsize / -2,
											maxs = midsize / 2
										}
										tr = util.TraceHull( t )

										if not tr.Hit then 
											spawnereasd = ( v - Vector( 0, 0, midsize.z/2 ) )
											break
										end
										
									end 
								
								
								
									if spawnereasd == false then
										amongus:Remove()
									else
										ent:EmitSound("Amongus_Appear")
										amongus:SetOwner(ent:GetOwner())
										amongus:SetPos( spawnereasd )
										amongus:SetAngles((ply:GetPos()- spawnereasd):Angle())
										amongus:Spawn()									
									end
									ent:Remove()
								end
							end
						end
					end
				end
			end
		end
	end)
end

if CLIENT then
	hook.Add("HUDPaint", "drawAmongusWarning", function()
		if engine.ActiveGamemode() == "terrortown" then
			local ply = LocalPlayer()

			if ply:IsActiveTraitor() or (CR_VERSION and ply:IsActiveTraitorTeam()) then
				for _, ent in ipairs(ents.FindByClass( "amongus_spawner" )) do
					local screenPos = (ent:GetPos() + Vector(0,0,30)):ToScreen()
					if screenPos.visible then
						local DisText = tostring(math.floor(0.01905 * (ply:GetPos() - ent:GetPos()):Length()))
						surface.SetMaterial( Material( "vgui/amongus_icon" ) )
						surface.SetDrawColor( 255, 255, 255, 150 )
						surface.DrawTexturedRect( screenPos.x - 30, screenPos.y - 30, 60, 60 )
						local font = "TargetIDSmall"
						local text = "(HIDDEN)"
						surface.SetFont(font)
						
						local w, h = surface.GetTextSize(text)
						local x = screenPos.x
						local y = screenPos.y + 34
						
						draw.SimpleText(text, font, x - w/2 + 1,  y + 1, Color(0,0,0,150))
						draw.SimpleText(text, font, x - w/2, y,  Color(255,0,0,150))
						
						text = DisText.."m"
						w, h = surface.GetTextSize(text)
						
						y = y + h + 4
						
						draw.SimpleText(text, font, x - w/2 + 1,  y + 1, Color(0,0,0,150))
						draw.SimpleText(text, font, x - w/2, y, Color(255,0,0,150))				
						
						
					end
				end	
			end
		end
	end)
end




