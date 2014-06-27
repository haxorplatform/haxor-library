package dom;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.math.Mathf;
import haxor.media.Sound;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Interact with the button to play a sound using the Sound class.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ButtonSound extends Application implements IUpdateable
{
	
	var clicks : Int;
	
	var timer : Float;
	
	var button : ButtonElement;
	
	var field : ParagraphElement;

	var logo : ImageElement;
	
	var progress : ProgressElement;
	
	/**
	 * Preloads some assets before running.
	 */
	override function Load():Void 
	{
		//Loads the 'ogg' file and stores it in a Sound class instance.
		Asset.LoadSound("hit", "http://haxor.thelaborat.org/resources/sound/hit_sword_00.ogg");
	}
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("ButtonSound> Build");
		//Click count of the button.
		clicks = 0;
		
		//Time counter
		timer = 0.0;
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		field  = cast Browser.document.getElementById("field");
		logo   = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Sets the main volume to 50%
		Sound.main = 0.5;
		
		//Detect the click event and increment the 'clicks' variable
		button.onclick = function(ev : Event) 
		{ 
			var snd : Sound = Asset.Get("hit");			
			//Sets the sound volume to 50%
			//The combined volume from Sound.main and this volume results in a 25% overall volume
			snd.volume = 0.5;			
			snd.Play();
		};
		
		//Hide logo - not necessary for this demo.
		logo.style.display = "none"; 
		progress.style.display = "none";
				
	}
	
	override function Initialize():Void 
	{
		trace("ButtonSound> Initialize");
		
		//Ignore UI Stage for now.
		stage.visible = false;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{
		
		
	}
	
}