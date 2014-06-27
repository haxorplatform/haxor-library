package examples.dungeon;
import js.html.Uint16Array;
import haxor.component.Behaviour;
import haxor.component.Camera;
import haxor.component.MeshRenderer;
import haxor.core.Asset;
import haxor.core.Entity;
import haxor.core.IRenderable;
import haxor.core.IUpdateable;
import haxor.core.Resource;
import haxor.core.Time;
import haxor.graphics.BlendMode;
import haxor.graphics.CullMode;
import haxor.graphics.Graphics;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.graphics.RenderQueue;
import haxor.math.Color;
import haxor.math.Vector2;
import haxor.math.Vector3;
import haxor.texture.RenderTexture;
import haxor.texture.Texture;

/**
 * ...
 * @author dude
 */
class DisplacementRenderer extends MeshRenderer implements IUpdateable
{
	
	public var speed : Vector2;
	
	public var offset : Vector2;

	public function new(e:Entity) 
	{
		super(e);
		speed  = Vector2.zero;
		offset = Vector2.zero;
		
		var m : Mesh3 = new Mesh3();
		m.name = "DisplacmentPlane";
		var s : Float = 0.5;
		m.vertex = 
		[
		new Vector3( -s, s), new Vector3(s, s),		
		new Vector3( -s, -s), new Vector3(s, -s)
		
		//,new Vector3( 0, s,-s), new Vector3(0, s,s),				
		//new Vector3( 0, -s,-s), new Vector3(0, -s,s)	
		
		];
		
		
		m.color = [Color.white, Color.white, Color.white, Color.white
		//,Color.white, Color.white, Color.white, Color.white
		];
		
		m.uv0	 = 
		[
		new Vector3( 0, 1, 0), new Vector3(1, 1, 0),		
		new Vector3( 0, 0, 0), new Vector3(1, 0, 0),
		
		//new Vector3( 0, 1, 0), new Vector3(1, 1, 0),
		//new Vector3( 0, 0, 0), new Vector3(1, 0, 0)
		];
		
		m.topology = new Uint16Array
		([
		0, 1, 2,
		1, 3, 2
		
		//,4, 5, 6,
		//5, 7, 6		
		]);
		
		mesh = m;
				
		material = Asset.Get("haxor/material/screen/Displacement");
		material = Resource.Instantiate(material);		
		material.name = "DisplacementMaterial";
		
		var tex : Texture = Asset.Get("Distortion");
		tex.wrap = TextureWrap.RepeatX | TextureWrap.RepeatY;
		
		material.SetUniform("Texture", tex);
		
		
		speed.y = -0.2;
	}
	
	public function OnUpdate():Void
	{
		if (speed.length > 0)
		{
			offset.x += speed.x * Time.deltaTime;
			offset.y += speed.y * Time.deltaTime;
			material.SetUniform("Offset", offset);
		}
	}
	
}