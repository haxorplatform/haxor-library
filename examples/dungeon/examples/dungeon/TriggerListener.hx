package examples.dungeon;
import haxor.component.Component;
import haxor.core.ITriggerable;
import haxor.physics.Collider;

/**
 * ...
 * @author dude
 */
class TriggerListener extends Component implements ITriggerable
{

	public function OnTriggerEnter(c:Collider):Void
	{
		var app : DungeonApplication = cast application;
		app.game.OnTriggerEnter(entity,c);
	}
	
	public function OnTriggerExit(c:Collider):Void
	{
		var app : DungeonApplication = cast application;
		app.game.OnTriggerExit(entity,c);
	}
	
	public function OnTriggerStay(c:Collider):Void 
	{ 
	}
	
}