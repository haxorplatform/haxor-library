package examples.dungeon;

import haxor.component.Behaviour;
import haxor.component.ColliderDebugger;
import haxor.component.Component;
import haxor.component.Light;
import haxor.component.MeshRenderer;
import haxor.component.PointLight;
import haxor.component.Rotator;
import haxor.component.Transform;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Entity;
import haxor.core.Resource;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.RenderQueue;
import haxor.importer.ColladaFile;
import haxor.math.Vector3;
import haxor.physics.BoxCollider;
import haxor.physics.SphereCollider;
import haxor.texture.Texture;
import haxor.texture.Texture2D;

/**
 * ...
 * @author dude
 */
class Dungeon extends Behaviour
{
	
	public var asset : Entity;
	
	

	override public function OnStart():Void 
	{
		
		var f : ColladaFile = Asset.Get("dungeon");		
		asset = f.GetAsset();		
		asset.transform.parent = transform;
		
		var rl : Array<Component> = asset.GetComponentsInChildren(MeshRenderer);
		
		//var checker : Texture = Asset.Get("Checker");
		//checker.wrap = TextureWrap.RepeatX | TextureWrap.RepeatY;
		
		for (i in 0...rl.length)
		{
			var mr  	: MeshRenderer  = cast rl[i];
			
			if (mr.material == null)
			{
				trace(mr.name+" material is null");
				continue;
			}
			
			var mp  	: Array<String> = mr.material.name.split("///");
			
			var mat_id 	: String 	    = mp[0];
			
			if (mp.length <= 1)
			{
				mp = [""];
			}
			else
			{
				mp = mp[1].split("//");
			}
			
			
			
			var tex_id 	: String 		= mp[0];
			var lm_id	: String		= mp.length >= 2 ? mp[1] : "";
			
			var mat		: Material  	= Asset.Get(mat_id);
			
			if (mat == null)
			{
				trace(mr.name+" material ["+mat_id+"] is null");
				continue;
			}
			
			
			var tex		: Texture		= 
			//checker;
			Asset.Get(tex_id);
			//Asset.Get("DungeonAtlas01");
			
			if (tex == null)
			{
				trace(tex_id + " is null.");
				tex = Texture2D.white;
			}
			
			if (tex_id.indexOf("Tile") >= 0)
			{
				tex.wrap = TextureWrap.RepeatX | TextureWrap.RepeatY;
			}
			
			var lm		: Texture		= lm_id == "" ? null : Asset.Get(lm_id);
			
			//trace("["+mat_id+"]["+tex_id+"]["+lm_id+"]["+(tex!=null)+"]");
			
			var new_mat_id : String = mat_id + "@" + tex_id +lm_id + "Material";
			
			
			if (Asset.Get(new_mat_id) != null)
			{
				mat = Asset.Get(new_mat_id);
			}
			else
			{
				//trace(mat.name + " " + mat.queue+" "+mat.blend+" "+new_mat_id);
				mat = Resource.Instantiate(mat);				
				if (!mat.blend) mat.queue = RenderQueue.Geometry - 100;				
				mat.name = new_mat_id;			
				
				mat.SetUniform("DiffuseTexture",tex);
				if(lm != null) mat.SetUniform("Lightmap", lm);
				Asset.Add(new_mat_id, mat);
			}
			//*/
			
			mr.material = mat;
			
			
		}
		
		
		var colliders : Transform = asset.transform.Search("Colliders");
		if (colliders != null)
		{
			for (i in 0...colliders.childCount)
			{
				var t : Transform 	= colliders.GetChild(i);				
				var c : BoxCollider = t.entity.AddComponent(BoxCollider);
				c.size = new Vector3(50, 50, 50);
				//if (t.name == "Collider_Wall_144") t.entity.AddComponent(Rotator);
				//trace(t.name + " " + t.scale.ToString()+" "+t.LocalMatrix.scale.diagonalLR.ToString());
				//t.scale = new Vector3(1, 1, 1);
			}
		}
		
		var triggers : Transform = asset.transform.Search("Triggers");
		if (triggers != null)
		{
			for (i in 0...triggers.childCount)
			{
				var t : Transform 	= triggers.GetChild(i);
				var c : BoxCollider = t.entity.AddComponent(BoxCollider);
				if (c.name.indexOf("Camera") >= 0)
				{
					t.entity.layer = GameLayer.CameraArea;				
				}
				if (c.name.indexOf("Hole") >= 0)   t.entity.layer = GameLayer.Hole;
				c.trigger = true;
				c.size = new Vector3(50, 50, 50);
				t.entity.AddComponent(ColliderDebugger);
				//trace(c.name+" "+c.entity.layer);
				
			}
		}
		
		asset.transform.Traverse(TraverseLevel);
		
		var app : DungeonApplication = cast application;
		app.game.OnDungeonLoaded();
		
	}
	
	private function TraverseLevel(p_target : Transform):Bool
	{
		if (p_target.name == "Colliders") 	return false;
		if (p_target.name == "Triggers") 	return false;
		
		var t : Transform = p_target;
		
		if (t.name.indexOf("Torch") >= 0)
		{
			if (t.GetComponentsInChildren(ParticleTorch).length <= 0)
			{
				var tp : ParticleTorch = (new Entity()).AddComponent(ParticleTorch);
				tp.entity.name = "Torch";
				tp.entity.transform.parent = t;
				tp.entity.transform.position = new Vector3(10, 0, 0);
			}
		}
		
		if (t.name.indexOf("Collider_") >= 0)
		{
			var c : BoxCollider = t.entity.AddComponent(BoxCollider);
			c.size = new Vector3(50,50,50);
		}
		
		if (t.name.indexOf("Trigger_") >= 0)
		{
			var c : BoxCollider = t.entity.AddComponent(BoxCollider);
			if (c.name.indexOf("Camera") >= 0)
			{
				t.entity.layer = GameLayer.CameraArea;				
			}
			
			if (c.name.indexOf("Hole") >= 0)
			{
				t.entity.layer = GameLayer.Hole;
			}
			
			if (c.name.indexOf("Door") >= 0)
			{
				t.entity.layer = GameLayer.Door;
			}
			
			c.trigger = true;
			c.size = new Vector3(50, 50, 50);
			//t.entity.AddComponent(ColliderDebugger);
			t.entity.AddComponent(TriggerListener);
			//trace(c.name+" "+c.entity.layer);
		}
		
		if (t.name.indexOf("Door") == 0)
		{	
			if (t.name.indexOf("Frame") >= 0) return true;
			if (t.name.indexOf("Right") >= 0) return true;
			if (t.name.indexOf("Left") >= 0) return true;
			
			t.entity.AddComponent(DungeonDoor);
			
			
		}
		
		return true;
	}
	
	public function GetSpawnPosition(p_path:String):Vector3
	{		
		var res : Transform = asset.transform.Navigate("Spawns." + p_path);
		if (res == null) return Vector3.zero;
		var p : Vector3 = Vector3.zero;
		p  = res.WorldMatrix.Transform3x4(p);
		
		//trace("Dungeon> Finding Spawn [" + p_path + "]["+(res!=null)+"]");
		return p;
	}
}