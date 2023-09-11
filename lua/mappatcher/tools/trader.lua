local TOOL = TOOL

TOOL.Base = "base_point"
TOOL.Description = "Spawns trader."

--------------------------------------------------------------------------------

TOOL.TextureColor = Color(0,255,0,87)
TOOL.TextureText = "Trader"

--------------------------------------------------------------------------------

function TOOL:PreviewPaint( panel, w, h )
    local x, y = panel:LocalToScreen( 0, 0 )
    cam.Start3D(Vector(-35,-35,74), Angle(35,45,0), 90, x, y, w, h)
        render.Model( {
            model = "models/editor/playerstart.mdl",
            pos = self.point,
            angle = Angle(0,RealTime()*40,0),
        } )

        render.SetColorMaterial()
        render.DrawBox( Vector(), Angle(0,RealTime()*40,0), Vector(-16.5,-16.5,0), Vector(16.5,16.5,73), self.TextureColor, true )
        render.DrawWireframeBox( Vector(), Angle(0,RealTime()*40,0), Vector(-16.5,-16.5,0), Vector(16.5,16.5,73), Color(255,255,255), true )
    cam.End3D()
end

function TOOL:ObjectCreated()
    self.point = nil
    self.ang = nil
    self.name = ""
end

function TOOL:LeftClick( pos, ang )
    self.point = pos
    self.ang = ang.y
end

function TOOL:EditorRender( selected )
    local angle = Angle( 0,self.ang, 0 )
    angle:RotateAroundAxis( angle:Up(), -90 )
	  angle:RotateAroundAxis( angle:Forward(), 90 )
    cam.Start3D2D( self.point, angle, 0.1 )
    surface.SetFont( "Default" )
    local tW, tH = surface.GetTextSize(self.TextureText)
    local pad = 5
    surface.SetDrawColor(self.TextureColor)
		surface.DrawRect( -tW / 2 - pad, -pad, tW + pad * 2, tH + pad * 2 )
    draw.SimpleText(self.TextureText, "Default", -tW / 2, 0, color_white )
    --[[
    render.Model( {
        model = "models/editor/playerstart.mdl",
        pos = self.point,
        angle = Angle(0, self.ang, 0),
    } )
    
    render.SetColorMaterial()
    render.DrawBox( self.point, Angle(), Vector(-16.5,-16.5,0), Vector(16.5,16.5,73), self.TextureColor, true )
    --]]
    cam.End3D2D()
    if selected then
        render.DrawWireframeBox( self.point, Angle(), Vector(-16.5,-16.5,0), Vector(16.5,16.5,73), Color(255,255,255), false )
    else
        render.DrawWireframeBox( self.point, Angle(), Vector(-16.5,-16.5,0), Vector(16.5,16.5,73), Color(255,255,255,20), false )
    end
end

function TOOL:GetOrigin( )
    return self.point
end

function TOOL:IsValid( )
    return self.point ~= nil
end

function TOOL:ToString( )
    if getmetatable(self) == self then
        return "[class] " .. self.ClassName
    end
    return "["..self.ID.."] "..self.ClassName.." \""..self.name.."\""
end

--------------------------------------------------------------------------------
function TOOL:WriteToBuffer( buffer )
    buffer:WriteVector( self.point or Vector() )
    buffer:WriteUInt16( self.ang or 0 )
    buffer:WriteString( self.name )
end

function TOOL:ReadFromBuffer( buffer, len )
    self.point = buffer:ReadVector( )
    self.ang = buffer:ReadUInt16()
    self.name = buffer:ReadString()
end
--------------------------------------------------------------------------------
local spawntraders=function()
    for object_id, object in pairs(MapPatcher.Objects) do
      if(object:IsDerivedFrom("trader"))then
        if(object.traderent and object.traderent:IsValid())then
          object.traderent:Remove()
        end
        local pos=object:GetOrigin()
        local thisent = ents.Create( "trader" )--copyed from trader's spawn funtion
    		thisent:SetPos(pos)
    		thisent:SetAngles(Angle(0,object.ang, 0))
    		thisend:SetNetworkedString( "Owner", "World" )
    		thisent:Spawn()
    		thisent:Activate()
        object.traderent=thisent
      end
    end
end
hook.Add("InitPostEntity","Mappatcher-TEA Trader IP spawn",spawntraders)
hook.Add("PostCleanupMap","Mappatcher-TEA Trader CU spawn",spawntraders)
hook.Add("SpawnTraders","Mappatcher-TEA Trader ST spawn",spawntraders)
