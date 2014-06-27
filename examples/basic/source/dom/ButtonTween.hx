package dom;
import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.core.Tween;
import haxor.math.Easing;
import haxor.math.Mathf;
import haxor.ui.Container;
import haxor.ui.Sprite;
import haxor.ui.UIEntity;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Interact with the button to animate the logo using the Tween class
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ButtonTween extends Application implements IUpdateable
{
	
	var clicks : Int;
	
	var timer : Float;
	
	var button : ButtonElement;
	
	var field : ParagraphElement;

	var logo : ImageElement;
	
	var progress : ProgressElement;
	
	var sprite : Sprite;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("ButtonTween> Build");
		//Click count of the button.
		clicks = 0;
		
		//Time counter
		timer = 0.0;
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		field  = cast Browser.document.getElementById("field");
		logo   = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Hide logo - not necessary for this demo.
		logo.style.display = "none"; 
		progress.style.display = "none";
		field.style.display = "none";
				
	}
	
	override function Initialize():Void 
	{
		trace("ButtonTween> Initialize");
		
		//Adds the button in the stage Element
		stage.element.appendChild(button.parentElement);
		stage.overflow = "hidden";
		
		//Creates a new Sprite (WIP)
		sprite = new Sprite("./assets/img/logo.png");
						
		//Adds it to the stage
		stage.AddChild(sprite);
		
		//Sets some attributes
		sprite.width = sprite.height = 256;
		sprite.y = 50;
		sprite.alpha = 0.0;
		
		
		
		//Animates the 'alpha' property to 1.0 during 2.0 seconds after waiting 3.0 seconds using a 'Cubic.Out' easing
		Tween.Add(sprite, "alpha", 1.0, 2.0, 3.0, Cubic.Out);
		
		//Detect the click event
		button.onclick = function(ev : Event) 
		{ 
			//Generates some random position
			var px : Float = Mathf.Lerp(0.0, stage.width - sprite.width, Math.random());
			
			//Animates the 'x' property to 'px' during 0.8 seconds using the Elastic.OutBig easing
			Tween.Add(sprite, "x", px, 0.8, 0.0, Elastic.OutBig);
		};
		
		
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