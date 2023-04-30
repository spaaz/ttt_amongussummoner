if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName       = "AmongSummoner"
	SWEP.ShopName = "Amongus Summoner"
	SWEP.Author			= "Spaaz (with credit to AviLouden,TRGraphix,Mangonaut,Jenssons)"
	SWEP.Contact			= "";
	SWEP.Instructions	= "Target on upside of a flat surface"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.IconLetter		= "M"
end

	SWEP.Base = "weapon_tttbase"
	SWEP.InLoadoutFor = nil
	SWEP.AllowDrop = true
	SWEP.IsSilent = false
	SWEP.NoSights = false
	SWEP.LimitedStock = false
	SWEP.UseHands = true

	SWEP.Spawnable = false
	SWEP.AdminOnly = false

	SWEP.HoldType		= "pistol"
	SWEP.ViewModel  = "models/weapons/cstrike/c_pist_fiveseven.mdl"
	SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
	SWEP.Kind = 42
	SWEP.CanBuy = { ROLE_TRAITOR }
	SWEP.AutoSpawnable = false

	SWEP.Primary.ClipSize		= GetConVar("ttt_amongus_number"):GetInt()
	SWEP.Primary.DefaultClip	= GetConVar("ttt_amongus_number"):GetInt()
	SWEP.Primary.Automatic		= false
	SWEP.Primary.Ammo		= "none"

	SWEP.Weight					= 7
	SWEP.DrawAmmo				= true
    
if SERVER then
    function SWEP:Initialize()
        -- Override the "thrower" of the zombine's grenade to be the original owner
        hook.Add("OnEntityCreated", "OnEntityCreated_Grenade_" .. self:EntIndex(), function(ent)
            if not IsValid(ent) then return end
            if ent:GetClass() ~= "npc_grenade_frag" then return end

            -- Get the grenade's owner, make sure it is a zombine, and make sure it is one spawned by us
            local entOwner = ent:GetOwner()
            if not IsValid(entOwner) or entOwner:GetClass() ~= "npc_zombine" or entOwner:GetName() ~= "amongusz" then return end

            -- Then get the zombine's owner and make sure it's a player
            local plyOwner = entOwner:GetOwner()
            if not IsValid(plyOwner) or not plyOwner:IsPlayer() then return end

            -- Wait a short delay ot make sure the grenade's key values are populated
            timer.Simple(0.1, function()
                -- And then override the thrower, as long as the grenade and the owner are both still valid
                if not IsValid(ent) then return end
                if not IsValid(plyOwner) then return end
                ent:SetSaveValue("m_hThrower", plyOwner)
            end)
        end)
    end

    function SWEP:OnRemove()
        hook.Remove("OnEntityCreated", "OnEntityCreated_Grenade_" .. self:EntIndex())
    end
end

local function FindRespawnLocCust(pos)
    local offsets = {Vector(0,0,0)}

    for i = 0, 360, 15 do
        table.insert( offsets, Vector( math.sin( i ), math.cos( i ), 0 ) )
    end

        local midsize = Vector( 34, 34, 76 )
        local tstart   = pos + Vector( 0, 0, midsize.z / 2 )

        for i = 1, #offsets do
            local o = offsets[ i ]
            local v = tstart + o * midsize * 1.5

            local t = {
                start = v,
                endpos = v,
                --filter = target,
                mins = midsize / -2,
                maxs = midsize / 2
            }
            local tr = util.TraceHull( t )

            if not tr.Hit then return ( v - Vector( 0, 0, midsize.z/2 ) ) end
            
        end 

        return false
end

local function place_amongus( pos, self)
	
	if ( CLIENT ) then return end

	local amongus = ents.Create( "amongus_spawner" )


	if ( !IsValid( amongus ) ) then return end

    local spawnereasd = FindRespawnLocCust(pos)
    if spawnereasd == false then
    else
        amongus:SetOwner(self:GetOwner())
		amongus:SetPos( spawnereasd )
		amongus:Spawn()

    end
	
end

function SWEP:PrimaryAttack()

	local ply = self:GetOwner()
	
	local tr = ply:GetEyeTrace()
	local tracedata = {}
	
	tracedata.pos = tr.HitPos + Vector(0,0,2)
    
	if (!SERVER) then return end
	
	if self:Clip1() > 0 then
		
		
		local myPosition = ply:EyePos() + ( ply:GetAimVector() * 16 )
		local data = EffectData()
		data:SetOrigin( myPosition )

		util.Effect("MuzzleFlash", data)

            	local spawnereasd = FindRespawnLocCust(tracedata.pos)
        if spawnereasd == false then
			ply:PrintMessage(HUD_PRINTTALK, "Can't Place there." )
        else
			self:TakePrimaryAmmo(1)
       	 	place_amongus(tracedata.pos, self)
		end

	else
		self:EmitSound( "Weapon_AR2.Empty" )
	end
end
	
function SWEP:SecondaryAttack()

		self:PrimaryAttack()

	end

	function SWEP:Reload()
		return false
end

function SWEP:Equip()
	if ( !IsValid( self.Owner ) ) then return end
		if engine.ActiveGamemode() == "terrortown" then
			self.Owner:PrintMessage(HUD_PRINTTALK, "Amongus Summoner:\nSummons hidden Amongus.\nTraitors can see where they're\nhiding.")
		end
end


if CLIENT then

   -- Path to the icon material
   SWEP.Icon = "vgui/ttt/icon_amongus"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Summons hidden Amongus.\nTraitors can see where they're\nhiding. "
   };
end