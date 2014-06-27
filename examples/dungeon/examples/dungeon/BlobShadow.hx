package examples.dungeon;
import js.html.Uint16Array;
import haxor.component.MeshRenderer;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Entity;
import haxor.graphics.BlendMode;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.graphics.RenderQueue;
import haxor.math.Color;
import haxor.math.Vector3;
import haxor.texture.Texture;

/**
 * ...
 * @author dude
 */
class BlobShadow extends MeshRenderer
{

	public function new(p_entity : Entity) 
	{
		super(p_entity);
		
		var m : Mesh3 = new Mesh3();
		m.name = "BlobShadowMesh";
		var s : Float = 0.5;
		m.vertex = 
		[
		new Vector3( -s, 0, s), new Vector3(s, 0, s),		
		new Vector3( -s, 0,-s), new Vector3(s, 0,-s)			
		];
		
		m.color = [Color.white, Color.white, Color.white, Color.white];
		
		m.uv0	 = 
		[
		new Vector3( 0, 1, 0), new Vector3(1, 1, 0),		
		new Vector3( 0, 0, 0), new Vector3(1, 0, 0)
		];
		
		m.topology = new Uint16Array
		([
		0, 1, 2,
		1, 3, 2		
		]);
		
		mesh = m;
		
		
		material = new Material();
		material.name = "BlobShadowMaterial";		
		material.zwrite = false;
		material.queue = RenderQueue.Transparent;
		material.SetBlending(BlendMode.Zero, BlendMode.SrcColor);
		material.shader = Asset.Get("haxor/unlit/FlatTexture");
		var tex : Texture = Asset.Get("BlobShadow");
		material.SetUniform("DiffuseTexture", tex);
		
		
	}
	
}