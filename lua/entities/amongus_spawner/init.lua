AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )


function ENT:Initialize()	
	util.PrecacheSound( "Amongus_Appear" )
	self:SetModel( "models/items/battery.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
		
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetName(self.PrintName)
	self:SetOwner(self.Owner)		
	self:Activate()
	amongID = tostring(self:EntIndex())
	
end