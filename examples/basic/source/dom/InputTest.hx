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
 * ...
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class InputTest extends Application implements IUpdateable
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
		trace("InputTest> Build");
		
		//Search for elements in the HTML
		button 	 = cast Browser.document.getElementById("button");
		field  	 = cast Browser.document.getElementById("field");
		logo   	 = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Hide not necessary
		logo.style.display = "none"; 
		button.style.display = "none";
		progress.style.display = "none";
				
	}
	
	override function Initialize():Void 
	{
		trace("InputTest> Initialize");
		
		//Ignore UI Stage for now.
		//Stage will hold mouse interactions
		//stage.visible = false;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{		
		field.innerText = "Mouse\nx["+Input.mouse.x+"] y["+Input.mouse.y+"]\nrx["+Mathf.RoundPlaces(Input.relativeMouse.x,2)+"] ry["+Mathf.RoundPlaces(Input.relativeMouse.y,2)+"]\nstate["+Input.GetInputState(KeyCode.Mouse0)+"]\nhold["+Mathf.Floor(Input.GetHoldTime(KeyCode.Mouse0))+"]";
	}
	
}