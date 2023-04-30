AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:SpawnFunction( tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( "npc_amongus_zombine" )
	---ent:SetPos( tr.HitPos + tr.HitNormal * 8 )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:Initialize()	

	self:SetModel( "models/items/battery.mdl" )
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetName(self.PrintName)

	self.npc = ents.Create( "npc_zombine" )
	self.npc:SetPos(self:GetPos())
	self.npc:SetAngles(self:GetAngles())
	self.npc:SetSpawnEffect(false)
	self.npc:SetOwner(self:GetOwner())
	self.npc:Spawn()
	self.npc:Activate()
	self.npc:SetName("amongusz")
	self:SetParent(self.npc)
 	self.npc:SetKeyValue("spawnflags",256)
	local amongus = GetConVar("ttt_amongus_health"):GetFloat()
	self.npc:SetHealth(amongus)
	self.npc:SetMaxHealth(amongus)

	if( IsValid(self.npc))then
		local min,max = self.npc:GetCollisionBounds()
		local hull = self.npc:GetHullType()
		local crSprint = false
		if CR_VERSION then
			crSprint = GetConVar("ttt_sprint_enabled"):GetBool()
		end
		if ((GetGlobalBool( "SprintIsMounted", false ) or crSprint) and (GetConVar("ttt_amongus_force_fast"):GetInt() == -1)) or (GetConVar("ttt_amongus_force_fast"):GetInt() == 1) then
			self.npc:SetModel("models/amongus/amongus_zombine_fast.mdl")
		else
			self.npc:SetModel("models/amongus/amongus_zombine.mdl")
		end
		self.npc:SetSolid(SOLID_BBOX)
		self.npc:SetName("amongusz")
		self.npc:SetMoveType( MOVETYPE_STEP ) 
		self.npc:SetPos(self.npc:GetPos())
		self.npc:SetHullType(hull)
		self.npc:SetHullSizeNormal()
		self.npc:SetCollisionBounds(min,max)
		self.npc:DropToFloor()
		self.npc:SetModelScale(1)
	end
	
end


if ( SERVER ) then

	local function AmongusZDamage(target, dmginfo)

		if dmginfo:GetAttacker():GetClass() == "npc_zombine" and dmginfo:GetAttacker():GetName() == "amongusz" then
			if CR_VERSION and engine.ActiveGamemode() == "terrortown" then
				if target:IsPlayer() then
					if target:IsJesterTeam() then
						dmginfo:SetDamage(0)
					end
				end
			end		
		end
	end

	hook.Add( "EntityTakeDamage", "AmongusZDamage", AmongusZDamage)
end