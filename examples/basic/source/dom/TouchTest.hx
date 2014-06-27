package dom;

import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.Mathf;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Application that shows the basic functionalities of the 'Input' class and the touch structures.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class TouchTest extends Application implements IUpdateable
{
	
	var button : ButtonElement;
	
	var field : ParagraphElement;

	var logo : ImageElement;
	
	var progress : ProgressElement;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("TouchTest> Build");
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		field  = cast Browser.document.getElementById("field");
		logo   = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Hide not necessary
		logo.style.display   = "none"; 
		button.style.display = "none";
		progress.style.display = "none";
		
		field.style.fontSize = "16px";
				
	}
	
	override function Initialize():Void 
	{
		trace("TouchTest> Initialize");
				
		//Stage will hold mouse interactions so it must be available
		//UI / Haxor / HTML interactions are WIP
		//stage.visible = false;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{	
		var tl : Array<Touch> = Input.touch;
		
		if (tl.length <= 0)
		{
			field.innerText = "No Touches!";
		}
		else
		{		
			field.innerText = "";
			
			for (i in 0...tl.length)
			{
				var t : Touch = tl[i];
				
				field.innerText += "Touch["+t.id+"]\nx["+t.position.x+"] y["+t.position.y+"]\ndx["+t.delta.x+"] dy["+t.delta.y+"]\nstate["+t.state+"]\nhold["+Mathf.Floor(t.hold)+"]\n";
			}
		}
		
		
	}
	
}