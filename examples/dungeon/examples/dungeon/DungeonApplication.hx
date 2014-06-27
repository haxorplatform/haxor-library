/*
HAXOR HTML5 ENGINE (c) 2013 by Eduardo Pons - eduardo@thelaborat.org

HAXOR HTML5 ENGINE is licensed under a
Creative Commons Attribution-NoDerivs 3.0 Unported License.

You should have received a copy of the license along with this
work.  If not, see <http://creativecommons.org/licenses/by-nd/3.0/>.
 */

package examples.dungeon;
import examples.dungeon.Wizard;
import haxe.Timer;
import js.html.audio.DynamicsCompressorNode;
import js.html.idb.Transaction;
import haxor.component.AnimationClip;
import haxor.component.AnimationClip.AnimationWrap;
import haxor.component.AssetData;
import haxor.component.Camera;
import haxor.component.CameraOrbit;
import haxor.component.Component;
import haxor.component.Light;
import haxor.component.MeshRenderer;
import haxor.component.ParticleRenderer;
import haxor.component.ParticleRenderer.ParticleEmitter;
import haxor.component.SkinnedMeshRenderer;
import haxor.component.Transform;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IRenderable;
import haxor.core.IUpdateable;
import haxor.core.Resource;
import haxor.core.Stats;
import haxor.core.Time;
import haxor.editor.Gizmo;
import haxor.graphics.BlendMode;
import haxor.graphics.CullMode;
import haxor.graphics.filters.BloomFX;
import haxor.graphics.filters.BlurFX;
import haxor.graphics.filters.Fog;
import haxor.graphics.filters.RenderFX;
import haxor.graphics.filters.FXAA;
import haxor.graphics.Graphics;
import haxor.graphics.Material;
import haxor.graphics.Mesh;
import haxor.graphics.Screen;
import haxor.importer.ColladaFile;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.AABB2;
import haxor.math.AABB3;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector2;
import haxor.math.Vector3;
import haxor.media.Sound;
import haxor.net.Web;
import haxor.physics.Physics;
import haxor.texture.RenderTexture;
import haxor.texture.Texture;
import haxor.texture.Texture2D;
import haxor.ui.form.FPSCounter;
import haxor.ui.HaxorLoader;
import haxor.ui.TextField;



//Main application class. Your entry point after everything is loaded.
class DungeonApplication extends Application implements IUpdateable implements IRenderable
{ 
	
	static function main() { } 
	
	public var game : GameController;
	
	public var log : TextField;
	
	private var m_light_multiplier : Float = 1.0;
	
	private var m_camera_move_accel : Float = 500.0;
	
	private var m_camera_move_speed : Float = 0.0;
	
	private var particles : ParticleRenderer;
	
	
	//================ LOADS THE BIG DUNGEON LEVEL ================
	
	private var m_load_big_dungeon :Bool = false;	
	
	//==============================================================
	
	override public function Initialize():Void 
	{			
		name = "application";		
		
		var fpsc:FPSCounter = new FPSCounter();		
		fpsc.selectable = false;
		stage.AddChild(fpsc);
		
		game = (new Entity()).AddComponent(GameController);
		game.name = "game";
		game.Initialize();
		
		var e : Entity;		
		
		//e = new Entity();		
		//particles = e.AddComponent(ParticleTorch);
		//e.transform.position = new Vector3(0, 30, 0);
		//Gizmo.particles = true;
		
		/*
		e = new Entity();
		e.name = "displacement";
		e.AddComponent(DisplacementRenderer);
		e.transform.scale = new Vector3(300, 300, 300);
		e.transform.position = new Vector3(353, 150, -3795);
		//*/
		
		log = new TextField();
		log.selectable = false;
		log.text = "";
		log.layout.margin = AABB2.FromMinMax(5, 0, 5, 0);
		log.color = Color.yellow;
		log.font = "Lucida Console";
		log.fontSize = 10;
		log.width = 900;
		log.layout.FitHeight();
		stage.AddChild(log);
		
		Engine.Add(this);
	}	
	
	public function OnRender():Void
	{	
		//var c : Dynamic = orbit.camera;
		//var rt : RenderTexture = c.m_grab;
		//Graphics.RenderTexture(rt, 0, 0, 512, 512);
	}
	
	public function OnUpdate():Void
	{
		
		if (Input.Hit(KeyCode.D1)) Gizmo.transforms = !Gizmo.transforms;		
		if (Input.Hit(KeyCode.D2)) Gizmo.colliders 	= !Gizmo.colliders;		
		if (Input.Hit(KeyCode.D3)) Gizmo.lights 	= !Gizmo.lights;		
		if (Input.Hit(KeyCode.D4)) Gizmo.meshes 	= !Gizmo.meshes;		
		if (Input.Hit(KeyCode.D5)) Gizmo.particles 	= !Gizmo.particles;
		
		if (Input.IsDown(KeyCode.Q)) { 	game.fog.exp    -= 0.01; trace("exp: " + game.fog.exp); }
		if (Input.IsDown(KeyCode.W)) { 	game.fog.exp    += 0.01; trace("exp: " + game.fog.exp); }
		if (Input.IsDown(KeyCode.A)) { 	game.fog.factor -= 0.2; trace("factor: " + game.fog.factor); }
		if (Input.IsDown(KeyCode.S)) { 	game.fog.factor += 0.2; trace("factor: " + game.fog.factor); }		
		//*/
		if (Input.Hit(KeyCode.Z)) { 	game.fog.enabled = !game.fog.enabled; trace("fog: " + game.fog.enabled); }
		
		if (Input.Hit(KeyCode.X)) { 	game.fxaa.enabled = !game.fxaa.enabled; trace("FXAA: " + game.fxaa.enabled); }
		
		
		if (Input.Hit(KeyCode.B))
		{
			if (game.player != null)
			{
				game.orbit.target = (game.orbit.target == null) ? game.player.transform : null;
			}
		}
		
		if (Input.IsDown(KeyCode.M)) { 	game.orbit.camera.fov += Time.deltaTime * 5.0; }
		if (Input.IsDown(KeyCode.N)) { 	game.orbit.camera.fov -= Time.deltaTime * 5.0; }
		
		var p 	: Vector3 = game.orbit.pivot.transform.position;
		var dir : Vector3 = Vector3.zero;
		var fv  : Vector3 = game.orbit.pivot.transform.forward;
		var rv  : Vector3 = game.orbit.pivot.transform.right;
		
		var is_camera_control : Bool = Input.IsDown(KeyCode.ControlKey) || game.orbit.distance < 0.0;
		
		if(is_camera_control)if (Input.IsDown(KeyCode.Down))	 dir.Add(fv);		
		if(is_camera_control)if (Input.IsDown(KeyCode.Up))	 	 dir.Add(fv.Invert());		
		if(is_camera_control)if (Input.IsDown(KeyCode.Right)) 	 dir.Add(rv);		
		if (is_camera_control) if (Input.IsDown(KeyCode.Left))  	 dir.Add(rv.Invert());
		
		if(game.orbit.distance > 0.0) dir.y = 0;
		
		if (Input.IsDown(KeyCode.PageUp)) 	 dir.Add(Vector3.up);		
		if (Input.IsDown(KeyCode.PageDown))   dir.Add(Vector3.up.Invert());
		
		var ac : Color = Light.ambient;
		if (Input.IsDown(KeyCode.J))  
		{
			ac.r += Time.deltaTime * 0.1;
			ac.g += Time.deltaTime * 0.1;
			ac.b += Time.deltaTime * 0.1;
			trace(Light.ambient);
		}
		
		if (Input.IsDown(KeyCode.K))  
		{
			ac.r -= Time.deltaTime * 0.1;
			ac.g -= Time.deltaTime * 0.1;
			ac.b -= Time.deltaTime * 0.1;
			trace(Light.ambient);
		}
		
		Light.ambient = ac;
		
		
		
		
		if (dir.length > 0)
		{
			m_camera_move_speed += Time.deltaTime * m_camera_move_accel;
			if (m_camera_move_speed >= 500) m_camera_move_speed = 500;
			p.Add(dir.Normalize().Scale(Time.deltaTime * m_camera_move_speed));
			game.orbit.pivot.position = p;
		}
		else
		{
			m_camera_move_speed = 0.0;
		}
		
		
		if (Input.IsDown(KeyCode.N))  
		{
			game.orbit.camera.fov -= Time.deltaTime * 2.0;
		}
		
		if (particles != null)
		{
			var pp : Vector3 = particles.transform.position;
			var a : Float = Time.elapsed * 90.0;
			var s : Float = Mathf.Sin(a * Mathf.Deg2Rad);
			pp.x = s * 200.0;
			//particles.transform.position = pp;
		}
		
		//if (Input.IsDown(KeyCode.Mouse0) || (Input.wheel != 0))
		if ((Time.frame % 30)==0)
		{
			var o : CameraOrbit = game.orbit;
			//trace
			log.text  = "";
			if (particles != null)
			{
				log.text += "Elapsed: " + particles.elapsed+"/"+particles.duration+"<br>";
				log.text += "Emitted: " + particles.emitted + "<br>";
				log.text += "Local: " + particles.local + "<br>";
				

				
			}
			/*
			log.text += ("a: " + o.angle.ToString() + " d: " + o.distance + " p: " + o.pivot.position.ToString() + " fov: " + o.camera.fov + " follow: " + (o.target!=null)) + "<br>";
			if (Joystick.available)
			{
				if (Input.joystick.length > 0)
				{
					var js : Joystick = Input.joystick[0];
					log.text += "left: " + js.analogLeft.ToString()+" right: "+js.analogRight.ToString()+" tl: "+js.triggerLeft+"<br>";
				}
			}
			log.text += "Render Count: " + Stats.renderCount + "/" + MeshRenderer.list.length + "<br>";
			log.text += "Visible Count: " + Stats.visibleCount+"<br>";
			log.text += "Invisible Count: " + Stats.invisibleCount + "<br>";
			log.text += "Cull Tests: " + Stats.cullTests + "<br>";
			//*/
		}
		//*/
	}
	
	override public function Load():Void 
	{
		loader = new HaxorLoader();
		
		LoadStandardLib();
		
		Web.root = 
		//"https://dl.dropboxusercontent.com/u/20655747/haxor/resources/";
		"http://haxor.thelaborat.org/resources/";
		
		//Falloff Ramp
		Asset.LoadTextureHTML("player/ramp", "./texture/misc/ramp00.jpg");
		
		Asset.LoadCollada("knight", 			"./character/medieval/knight/asset.dae");
		Asset.LoadTextureHTML("knight/diffuse", "./character/medieval/knight/DiffuseTexture.png");
		
		
		
		/*
		Asset.LoadCollada("wizard", 			 "./character/medieval/wizard/asset.dae");
		Asset.LoadTextureHTML("wizard/diffuse",  "./character/medieval/wizard/DiffuseTexture.png");		
		Asset.LoadCollada("paladin", 			 "./character/medieval/paladin/asset.dae");
		Asset.LoadTextureHTML("paladin/diffuse", "./character/medieval/paladin/DiffuseTexture.png");
		//*/
		
		Asset.LoadCollada("player/animation/all/idle01",  "./character/medieval/animations/all_idle01.DAE");
		Asset.LoadCollada("player/animation/all/run",     "./character/medieval/animations/all_run.DAE");
		Asset.LoadCollada("player/animation/all/walk",    "./character/medieval/animations/all_walk.DAE");		
		Asset.LoadCollada("player/animation/kp/idle01",   "./character/medieval/animations/kp_idle01.DAE");
		Asset.LoadCollada("player/animation/kp/die01",    "./character/medieval/animations/kp_die01.DAE");
		Asset.LoadCollada("player/animation/kp/hit01",    "./character/medieval/animations/kp_hit01.DAE");
		Asset.LoadCollada("player/animation/kp/attack01", "./character/medieval/animations/kp_attack01.DAE");
		Asset.LoadCollada("player/animation/kp/attack02", "./character/medieval/animations/kp_attack02.DAE");		
		Asset.LoadCollada("player/animation/m/idle01",    "./character/medieval/animations/m_idle01.DAE");
		Asset.LoadCollada("player/animation/m/attack01",  "./character/medieval/animations/m_attack01.DAE");
		Asset.LoadCollada("player/animation/m/attack02",  "./character/medieval/animations/m_attack02.DAE");
		Asset.LoadCollada("player/animation/m/die01",     "./character/medieval/animations/m_die01.DAE");
		Asset.LoadCollada("player/animation/m/hit01",     "./character/medieval/animations/m_hit01.DAE");
		//*/
		Asset.LoadSound("sound/ambiance", 					"./sound/ambience_serious_loop.mp3");
		Asset.LoadSound("player/sound/swing", 				"./sound/swing_sword_00.mp3");
		Asset.LoadSound("sound/run_step", 					"./sound/run_step.mp3");
		Asset.LoadSound("sound/door_metal_open", 			"./sound/door_metal_open.mp3");
		Asset.LoadSound("sound/door_metal_close_click", 	"./sound/door_metal_close_click.mp3");
		
		
		Asset.LoadTextureHTML("BlobShadow", 	"./texture/misc/shadow_blob.jpg");		
		Asset.LoadTextureHTML("ParticleColor", 	"./texture/particle/particle_ramp_color.jpg");		
		Asset.LoadTextureHTML("Dust", 			"./texture/particle/sheet/dust_alpha.png");
		Asset.LoadTextureHTML("DustColor",		"./texture/particle/sheet/dust_ramp_color.png");
		Asset.LoadTextureHTML("Fire", 			"./texture/particle/sheet/cartoon_fire_alpha.png");
		Asset.LoadTextureHTML("FireColor",		"./texture/particle/sheet/cartoon_fire_ramp_color.png");		
		//*/
		
		
		/**
		 * SMALL DUNGEON
		 */
		if (!m_load_big_dungeon)
		{
			Asset.LoadCollada("dungeon", 				"./projects/dungeon/small/asset.dae");		
			
			Asset.LoadTextureHTML("DungeonAtlas01", 	"./projects/dungeon/small/DungeonAtlas01.jpg");
			Asset.LoadTextureHTML("DungeonAtlas02", 	"./projects/dungeon/small/DungeonAtlas02.jpg");
			Asset.LoadTextureHTML("DungeonAtlas03", 	"./projects/dungeon/small/DungeonAtlas03.jpg");
			Asset.LoadTextureHTML("Lightmap01", 		"./projects/dungeon/small/Lightmap01.png");
			Asset.LoadTextureHTML("Lightmap02", 		"./projects/dungeon/small/Lightmap02.png");
			Asset.LoadTextureHTML("Lightmap03", 		"./projects/dungeon/small/Lightmap03.png");
		}
		//*/
		
		
		/**
		 * BIG DUNGEON
		 */
		if (m_load_big_dungeon)
		{
			Asset.LoadCollada("dungeon", 				"./projects/dungeon/big/asset.dae");				
			Asset.LoadTextureHTML("DungeonAtlas01", 	"./projects/dungeon/big/DungeonAtlas01.jpg");
			Asset.LoadTextureHTML("DungeonAtlas02", 	"./projects/dungeon/big/DungeonAtlas02.png");
			Asset.LoadTextureHTML("DungeonAtlas03", 	"./projects/dungeon/big/DungeonAtlas03.png");
			Asset.LoadTextureHTML("DungeonAtlas04", 	"./projects/dungeon/big/DungeonAtlas04.jpg");
			Asset.LoadTextureHTML("DungeonAtlas05", 	"./projects/dungeon/big/DungeonAtlas05.jpg");		
			Asset.LoadTextureHTML("DungeonTile01", 		"./projects/dungeon/big/DungeonTile01.jpg");
			Asset.LoadTextureHTML("DungeonTile02", 		"./projects/dungeon/big/DungeonTile02.jpg");
		}
		//*/		
		
	}
	
}

