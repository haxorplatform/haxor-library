package dom;
import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.math.Mathf;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Most basic demo. Interact with the button to control a timer.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class ButtonTimer extends Application implements IUpdateable
{
	
	var clicks : Int;
	
	var timer : Float;
	
	var button : ButtonElement;
	
	var field : ParagraphElement;

	var logo : ImageElement;
	
	var progress : ProgressElement;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("ButtonTimer> Build");
		//Click count of the button.
		clicks = 0;
		
		//Time counter
		timer = 0.0;
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		field  = cast Browser.document.getElementById("field");
		logo   = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Detect the click event and increment the 'clicks' variable
		button.onclick = function(ev : Event) 
		{ 
			clicks = (clicks + 1) % 4; 
		};
		
		//Hide logo - not necessary for this demo.
		logo.style.display = "none"; 
		progress.style.display = "none";
				
	}
	
	override function Initialize():Void 
	{
		trace("ButtonTimer> Initialize");
		
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
		switch(clicks)
		{
			case 0:
				//Reset timer.
				timer = 0.0;
				field.innerText = "Haxor Hello World";
			case 1:
				//Increments the timer with the difference of time between frames.
				timer += Time.deltaTime;				
				field.innerText = "Clock: " + Mathf.RoundPlaces(timer, 1);
			case 2:
				//Increments the timer with triple of the speed. 				
				timer += Time.deltaTime * 3.0;								
				field.innerText = "Clock: " + Mathf.RoundPlaces(timer, 1);
				
			case 3: 
				//Don't update
		}
		
		
	}
	
}