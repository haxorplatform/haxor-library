package examples.dungeon;

import haxor.component.Animation;
import haxor.component.Behaviour;
import haxor.component.Component;
import haxor.component.MeshRenderer;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Entity;
import haxor.core.Resource;
import haxor.graphics.CullMode;
import haxor.graphics.Material;
import haxor.importer.ColladaFile;
import haxor.math.Vector3;
import haxor.texture.Texture;

/**
 * ...
 * @author dude
 */
class Paladin extends Player
{
	
	
	override public function OnStart():Void 
	{
		character = "paladin";
		super.OnStart();
		
		LoadClip("player/animation/all/idle01", 	"idle");
		LoadClip("player/animation/all/walk",   	"walk");
		LoadClip("player/animation/all/run", 		"run");
		LoadClip("player/animation/kp/attack01", 	"attack01");
		LoadClip("player/animation/kp/attack02", 	"attack02");
		LoadClip("player/animation/kp/idle01",  	"idle_attack");		
		LoadClip("player/animation/kp/die01",	  	"die");	
		LoadClip("player/animation/kp/hit01",  		"hit");
		
	}
	
}