package examples.dungeon;

import haxe.Timer;
import js.html.rtc.NavigatorUserMediaSuccessCallback;
import haxor.component.Animation;
import haxor.component.AnimationClip;
import haxor.component.AnimationClip.AnimationWrap;
import haxor.component.Behaviour;
import haxor.component.CameraOrbit;
import haxor.component.ColliderDebugger;
import haxor.component.Component;
import haxor.component.Light;
import haxor.component.MeshRenderer;
import haxor.component.RigidBody;
import haxor.component.SkinnedMeshRenderer;
import haxor.component.Transform;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Resource;
import haxor.core.Time;
import haxor.graphics.BlendMode;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.graphics.RenderQueue;
import haxor.importer.ColladaFile;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector2;
import haxor.math.Vector3;
import haxor.physics.SphereCollider;
import haxor.texture.Texture;

/**
 * ...
 * @author dude
 */
class Player extends Behaviour implements IUpdateable
{
	
	public var asset : Entity;

	public var animation : Animation;
	
	public var character : String;
	
	public var speed : Float;
	
	private var m_animation_speed : Float;
	
	private var m_is_attack : Bool;
	
	private var m_clips : Map<String,AnimationClip>;
	
	private var m_velocity : Vector3;
	
	private var m_shadow : Transform;
	
	private var m_dust_particle : ParticleRunning;
	
	public var state(get_state, set_state):String;
	private function get_state():String { return m_state; }
	private function set_state(v:String):String 
	{
		
		if (m_state != v) { OnStateChange(m_state, v); }
		m_state = v;
		return v;
	}
	private var m_state : String;
	
	private var m_falloff_mat : Material;
	
	override public function OnStart():Void 
	{
		var f : ColladaFile = Asset.Get(character);		
		asset = f.GetAsset();
		asset.transform.scale = new Vector3(400, 400, 400);
		
		asset.transform.parent = transform;
		
		speed = 150.0;
		m_velocity = Vector3.zero;
		
		m_is_attack = false;
		
		var rl : Array<Component> = asset.GetComponentsInChildren(MeshRenderer);
		
		for (i in 0...rl.length)
		{
			var mr  	: MeshRenderer  = cast rl[i];
			var mat_id 	: String 	    = mr.material.name;
			mat_id = StringTools.replace(mat_id,"DiffuseSkin", "ToonSkin");
			var mat		: Material  	= Asset.Get(mat_id);			
			
			var tex 	: Texture       = Asset.Get(character+"/diffuse");			
			var new_mat_id : String = mat_id + "_"+character;			
			if (Asset.Get(new_mat_id) != null)
			{
				mat = Asset.Get(new_mat_id);
			}
			else
			{
				m_falloff_mat = mat = Resource.Instantiate(mat);
				
				mat.name = new_mat_id;					
				mat.shader = Asset.Get("haxor/diffuse/ToonSkinFalloff");
				mat.SetUniform("DiffuseTexture", tex);
				mat.SetUniform("Falloff", 1.50001);
				mat.SetUniform("FalloffIntensity", 1.00001);
				tex = Asset.Get("player/ramp");
				mat.SetUniform("RampTexture", tex);
				Asset.Add(new_mat_id, mat);				
			}
			//*/			
			mr.material = mat;
			
			mat = Asset.Get("PlayerHilight");
			if (mat == null)
			{
				mat = new Material();				
				mat.shader = Asset.Get("haxor/unlit/FlatSkin");
				mat.name = "PlayerHilight";
				mat.queue  = RenderQueue.Geometry-5;
				mat.ztest  = false;
				mat.zwrite = false;
				//mat.cull   = CullMode.None;
				//mat.SetBlending(BlendMode.DstColor, BlendMode.Zero);
				mat.SetUniform("Tint", Color.FromBytes(45, 90, 125));
				Asset.Add("PlayerHilight", mat);
			}
			
			var  skr : SkinnedMeshRenderer = cast mr;
			var nskr : SkinnedMeshRenderer = mr.entity.AddComponent(SkinnedMeshRenderer);
			nskr.mesh   	= skr.mesh;
			nskr.joints 	= skr.joints;			
			nskr.material 	= mat;
		}
		
		var sc : SphereCollider = entity.AddComponent(SphereCollider);
		sc.radius = 80;
		sc.center = new Vector3(0, 40, 0);
		
		entity.AddComponent(RigidBody);
		entity.layer = GameLayer.Player;
		
		
		m_clips = new Map<String,AnimationClip>();
	
		m_state = "";
		
		m_shadow = (new Entity()).transform;
		m_shadow.name = "shadow";		
		m_shadow.parent = transform;		
		m_shadow.scale = new Vector3(110, 0, 110);
		m_shadow.position = new Vector3(0, 5, 0);
		m_shadow.entity.AddComponent(BlobShadow);
		
		
		m_dust_particle = (new Entity()).AddComponent(ParticleRunning);
		m_dust_particle.transform.parent = transform;
		m_dust_particle.transform.position = new Vector3(0, 10, 0);
		
		
	}
	
	private function SplitClip(p_name:String, p_start:Int, p_end:Int,p_lib : AnimationClip,p_loop:Bool=true,p_speed:Float=1.0):Void
	{
		var c : AnimationClip = p_lib.Split(p_start, p_end);
		c.wrap  = p_loop ? AnimationWrap.Loop : AnimationWrap.Clamp;
		c.speed = p_speed;
		m_clips.set(p_name, c);
		asset.animation.Add(c);
	}
	
	private function LoadClip(p_id:String, p_name:String,p_loop:Bool=true,p_speed:Float=1.0):AnimationClip
	{
		var cf : ColladaFile;		
		cf = Asset.Get(p_id);
		cf.AddAnimations(asset); 
		var cid:Int = asset.animation.clips.length - 1;
		var c : AnimationClip = asset.animation.clips[cid];
		c.name = p_name;
		c.wrap  = p_loop ? AnimationWrap.Loop : AnimationWrap.Clamp;
		c.speed = p_speed;		
		m_clips.set(p_name, c);
		return c;
	}
	
	public function PlayClip(p_name:String,p_fade:Float=0.0):Void
	{
		var c : AnimationClip = m_clips.get(p_name);
		if (c == null) return;
		asset.animation.Stop();
		asset.animation.Fade(c, 0.0, p_fade);		
	}
	
	public function GetClip(p_name:String):AnimationClip
	{
		return m_clips.get(p_name);
	}
	
	public function Stop():Void
	{		
		m_velocity.Set();
	}
	
	public function Move(p_direction : Vector3):Void
	{
		m_velocity.Set(p_direction.x, p_direction.y, p_direction.z);
		//m_velocity.Normalize();		
	}	
	
	private function OnStateChange(p_from:String, p_to:String):Void 
	{
		//trace("change: " + p_from + " " + p_to);
		switch(p_to)
		{
			case "idle_attack":
				PlayClip("idle_attack");
				
			case "idle":
				Timer.delay(function()
				{
					if (m_state != "run") m_dust_particle.Reset();
				}, 1500);
				PlayClip("idle", 2);
				
				
			case "attack01":
				rigidbody.velocity = Vector3.zero;
				PlayClip("attack01", 2);
				
				
			case "attack02":
				rigidbody.velocity = Vector3.zero;
				PlayClip("attack02");
				
			case "run":
				PlayClip("run", 0.5);
				
				
		}
	}
	
	private function OnFSM():String 
	{
		var s : String = m_state;
		switch(s)
		{
			case "idle_attack":
				
				if (m_velocity.length > 0) s = "run";
				
			case "idle":
				
				if (m_velocity.length > 0) s = "run";
								
			case "attack01":
				
				if (!m_is_attack) s = "idle";
				
			case "attack02":
				
				//if (!Input.IsDown(KeyCode.Space)) s = "idle";
				
			case "run":				
				var nv : Vector3 = m_velocity.clone;
				nv.y = 0.0;
				var spd : Float = speed;
				
				//if (Input.IsDown(KeyCode.ShiftKey)) spd *= 5;
				nv.Scale(spd);
				var v : Vector3  = rigidbody.velocity;
				var vy : Float = v.y;
				v = Vector3.Lerp(v, nv, Time.deltaTime * 20);
				v.y = vy;
				rigidbody.velocity = v;	
				
				if (v.length < 0.1)
				{
					rigidbody.velocity = Vector3.zero;
					s = "idle";
				}
				
				v.y = 0.0;
				transform.rotation = Quaternion.LookRotation(v.Invert(), Vector3.up);
				
			default:
				s = "idle";
		}
		
		return s;
	}
	
	private function UpdateKeyboardInput():Void
	{
		if (Input.IsDown(KeyCode.ControlKey)) return;
		
		var app : DungeonApplication = cast application;
		var c 	: CameraOrbit = app.game.orbit;
		var dir : Vector3 = Vector3.zero;
		var fv  : Vector3 = c.pivot.transform.forward.Invert();
		var rv  : Vector3 = c.pivot.transform.right;
		
		m_is_attack = false;
		
		var is_joystick : Bool = false;
		
		if (Joystick.available)
		{
			if (Input.joystick.length > 0)
			{
				var js : Joystick = Input.joystick[0];
				
				m_animation_speed = Mathf.Clamp01(js.analogLeft.length * 1.1);
				m_animation_speed = Mathf.Lerp(0.3, 1.2, m_animation_speed);
				
				GetClip("run").speed = m_animation_speed;
				speed = 150 * m_animation_speed;
				
				dir.Add(fv.Scale(js.analogLeft.y));
				dir.Add(rv.Scale(js.analogLeft.x));
				dir.y = 0;
				
				if (js.IsDown(Joystick.FACE_1))
				{
					Stop();
					state = "attack01";
					m_is_attack = true;
					is_joystick = true;
				}				
				
				if (dir.length > 0) is_joystick = true;
			}
			
		}
		
		
		
		if(!is_joystick)
		if (dir.length <= 2)
		{
			if (Input.IsDown(KeyCode.Down))
			{
				dir.Add(fv.Invert());		
				m_animation_speed = 1.0;
			}
			
			if (Input.IsDown(KeyCode.Up))
			{
				dir.Add(fv);
				m_animation_speed = 1.0;
			}
			
			if (Input.IsDown(KeyCode.Right))
			{
				dir.Add(rv);			
				m_animation_speed = 1.0;
			}
			
			if (Input.IsDown(KeyCode.Left))
			{
				dir.Add(rv.Invert());
				m_animation_speed = 1.0;
			}
			
			if (Input.IsDown(KeyCode.C))
			{
				
				Stop();
				state = "attack01";
				m_is_attack = true;
			}
			
			dir.y = 0;
			dir.Normalize();
			
			if (Input.IsDown(KeyCode.Z))
			{
				
				GetClip("run").speed = 1.3;
				speed = 150 * 1.3;
			}
			else if(speed > 150)
			{
				GetClip("run").speed = 1;
				speed = 150;
			}
		
		}
				
		if (dir.length <= 0.5)
		{
			Stop();		
		}
		else
		{
			Move(dir);
		}
		
		
	}
	
	
	public function OnUpdate():Void
	{
		UpdateKeyboardInput();
		
		state = OnFSM();
	
		/*		
		if (Input.IsDown(KeyCode.D))
		{
			var fe : Float = m_falloff_mat.GetUniform("Falloff");
			fe -= Time.deltaTime * 0.5;
			m_falloff_mat.SetUniform("Falloff", fe + 0.00001);
			if((Time.frame % 10) == 0)trace("falloff: " + fe);
		}
		
		if (Input.IsDown(KeyCode.F))
		{
			var fe : Float = m_falloff_mat.GetUniform("Falloff");
			fe += Time.deltaTime * 0.5;
			m_falloff_mat.SetUniform("Falloff", fe + 0.00001);
			if((Time.frame % 10) == 0)trace("falloff: " + fe);
		}
		
		if (Input.IsDown(KeyCode.C))
		{
			var fe : Float = m_falloff_mat.GetUniform("FalloffIntensity");
			fe -= Time.deltaTime * 0.5;
			m_falloff_mat.SetUniform("FalloffIntensity", fe + 0.00001);
			if((Time.frame % 10) == 0)trace("falloff intensity: " + fe);
		}
		
		if (Input.IsDown(KeyCode.V))
		{
			var fe : Float = m_falloff_mat.GetUniform("FalloffIntensity");
			fe += Time.deltaTime * 0.5;
			m_falloff_mat.SetUniform("FalloffIntensity", fe + 0.00001);
			if((Time.frame % 10) == 0)trace("falloff intensity: " + fe);
		}
		//*/
		
	}
	
}