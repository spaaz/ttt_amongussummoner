local TROPHY = {}
TROPHY.id = "sus"
TROPHY.title = "Sus"
TROPHY.desc = "Kill an amongus"
TROPHY.rarity = 2

function TROPHY:Trigger()
    self.roleMessage = ROLE_INNOCENT

    self:AddHook("OnNPCKilled", function(tgt,att,wep)
	if IsPlayer(att) and (tgt:GetClass() == "npc_zombine") and (tgt:GetName() == "amongusz") then
		self:Earn(att)	
	end
    end)
end

function TROPHY:Condition()
    return scripted_ents.Get("npc_amongus_zombine") ~= nil
end

RegisterTTTTrophy(TROPHY)