local TOOL=TOOL
TOOL.Base="base_brush"
TOOL.Description="Anti prop spawn,player can spawn prop inside if they outside the zone!"
function TOOL:ObjectCreated()
    TOOL:GetBase().ObjectCreated(self)
end
function TOOL:EntSetup( ent )
    self.ent=ent
    ent:SetSolidFlags( FSOLID_CUSTOMBOXTEST )
    if SERVER then 
        ent:SetTrigger( true ) 
        self.ents_playersinzone={}
    end
end
function TOOL:EntStartTouch( ent )
    if ent.MapPatcherObject then return end

    if ent:IsPlayer() then
        self.ents_playersinzone[ent]=true
    end
end
function TOOL:EntEndTouch( ent )
    if ent.MapPatcherObject then return end

    if ent:IsPlayer() then
        self.ents_playersinzone[ent]=false
    end
end
function TOOL:EntShouldCollide( ent )
    return false
end
hook.Add("MakeProp","MapPatcher-TEA-Anti prop spawn",function(ply,mdl,pos,_ang)
  if(self.ents_playersinzone[ply])then
    ply:SystemMessage("You cannot spawn props in this zone!", Color(255,205,205,255), true)
    return false -- No.
  end
end)
