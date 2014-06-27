package examples.dungeon;
import haxor.component.Behaviour;
import haxor.component.CameraOrbit;
import haxor.component.Light;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Entity;
import haxor.graphics.filters.Fog;
import haxor.graphics.filters.FXAA;
import haxor.math.Color;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import haxor.media.Sound;
import haxor.physics.Collider;
import haxor.physics.Physics;

/**
 * ...
 * @author dude
 */
class GameController extends Behaviour
{
	public var app : Main;
	
	public var orbit : CameraOrbit;
	
	public var dungeon : Dungeon;
	
	public var player : Player;
	
	public var ambiance 	: Sound;
	
	public var fog		 	: Fog;
	
	public var fxaa : FXAA;
	
	public function new(e:Entity) 
	{
		super(e);
	}
	
	public function Initialize():Void
	{
		trace("GameController> Initialize");
		app = cast application;
		
		
		Physics.gravity = new Vector3(0, -980, 0);		
		
		//Physics.gravity = new Vector3(0, 0, 0);
		
		Physics.SetInteraction(GameLayer.Default, GameLayer.Default, true);
		Physics.SetInteraction(GameLayer.Default, GameLayer.Player, true);
		Physics.SetInteraction(GameLayer.Player, GameLayer.CameraArea, true);
		Physics.SetInteraction(GameLayer.Player, GameLayer.Door, true);
		
		
		
		Light.ambient = Color.FromBytes(130, 140, 160);
		
		
		dungeon = (new Entity()).AddComponent(Dungeon);
		dungeon.name = "dungeon";
		
		//dungeon.transform.rotation = Quaternion.FromAxisAngle(Vector3.right, 90);
		
		
		player = (new Entity()).AddComponent(Knight); 
		player.name = "player";
		player.transform.position = new Vector3(0, 1000, 0);
		//player.enabled = false;
		//*/
		
		orbit = CameraOrbit.Create(700, -135, -45);
		//orbit = CameraOrbit.Create(-0.1, 2, -10);
		orbit.transform.position = new Vector3(0, 9, 26);
		orbit.smooth = 5;		
		orbit.camera.background = Color.FromBytes(0, 0, 0);		
		orbit.camera.near = 150.0;
		orbit.camera.far  = 2000;
		
		orbit.camera.fov  = 40;
		orbit.target = player.transform;
		
		//orbit.camera.near = 3.0;
		//orbit.camera.far  = 210;
		
		var orbit_input : CameraOrbitInput = orbit.entity.AddComponent(CameraOrbitInput);
		orbit_input.zoomSpeed = 15;
		//orbit_input.zoomSpeed = 35;
		
		fxaa = new FXAA();
		fxaa.iterations = 2;
		
		fog = new Fog();
		
		orbit.camera.filters = [fxaa,fog];		
		
		//fog.enabled = false;
		
		fog.color  = Color.FromBytes(10, 0, 40);
		fog.exp	   = 3.2;
		fog.factor = 
		//33;
		293;
		
		
		
		
		ambiance = Asset.Get("sound/ambiance");
		if (ambiance != null)
		{
			ambiance.volume = 0.1;
			ambiance.loop = true;		
			ambiance.Play();
		}		
		
	}
	
	public function OnDungeonLoaded():Void
	{
		trace("GameController> Dungeon Loaded");
		//Console.Breakpoint();
		var p : Vector3 = dungeon.GetSpawnPosition("Player_Start_001");
		
		if(player != null) player.transform.position = p;
		orbit.pivot.position      = p;		
	}
	
	public function OnTriggerEnter(p_entity:Entity, p_collider:Collider):Void
	{
		trace("GameController> TriggerEnter ["+p_entity.name+"]["+p_collider.name+"]");
		switch(p_entity.layer)
		{
			case GameLayer.Door:
				if (p_collider.layer == GameLayer.Player)
				{
					trace("GameController> Door Trigger Enter");
					var d : DungeonDoor = p_entity.transform.parent.GetComponent(DungeonDoor);
					if (d != null) d.Open();
				}
				
			case GameLayer.Player:
				
			default:
		}
	}
	
	public function OnTriggerExit(p_entity:Entity, p_collider:Collider):Void
	{
		trace("GameController> TriggerExit ["+p_entity.name+"]["+p_collider.name+"]");
		switch(p_entity.layer)
		{
			case GameLayer.Door:
				if (p_collider.layer == GameLayer.Player)
				{
					trace("GameController> Door Trigger Exit");
					var d : DungeonDoor = p_entity.transform.parent.GetComponent(DungeonDoor);
					if (d != null) d.Close();
				}
			
			default:
		}
	}
}