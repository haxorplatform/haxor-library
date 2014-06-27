package canvas;
import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IRenderable;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.math.Mathf;
import js.Browser;
import js.html.ButtonElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Event;
import js.html.Image;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Most simple demo. Register the application in the render pool and draw stuff using canvas.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class RedCircle extends Application implements IRenderable
{
	
	var canvas : CanvasElement;
	
	var c : CanvasRenderingContext2D;
	
	var image : Image;
	
	var px : Float;	
	var py : Float;	
	var r : Float;
	
	var tx : Float;
	var ty : Float;
	var tr : Float;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("RedCircle> Build");
		
		//Search for elements in the HTML
		canvas = cast Browser.document.getElementById("canvas");
			
		//Gets the RenderingContext2D
		c = canvas.getContext2d();
		
		//Initialize first position of the circle
		tx = px = Mathf.Lerp(20.0, 300.0, Math.random());
		ty = py = Mathf.Lerp(20.0, 300.0, Math.random());
		tr = r  = Mathf.Lerp(20.0, 60.0, Math.random());
	}
	
	override function Initialize():Void 
	{
		trace("RedCircle> Initialize");
		
		//Ignore UI Stage for now.
		stage.visible = false;
		
		//Register the interface IRenderable in the render pool if the context exists.
		if (c != null) Engine.Add(this);		
		
		//Default = 45fps
		// 60fps = smoothier but heavier on CPU
		fps = 60;
		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnRender():Void
	{
		
		canvas.width  = Browser.window.innerWidth;
		canvas.height = Browser.window.innerHeight;
		
		var cw : Int = canvas.width;
		var ch : Int = canvas.height;
		
		//Fills the rectangle
		c.setFillColor(0.1, 0.1, 0.1,1.0);
		c.fillRect(0, 0, cw, ch);
		
		//Draws the circle
		c.setFillColor(1.0, 0.0, 0.0, 1.0);
		c.beginPath();
		c.arc(px,py,r,0,2.0*Math.PI,false);
		c.fill();
		
		//Moves the position of the circle to the target position during 1.0/3.0 seconds.
		px = Mathf.Lerp(px, tx, Time.deltaTime * 3.0);
		py = Mathf.Lerp(py, ty, Time.deltaTime * 3.0);
		r  = Mathf.Lerp(r,  tr, Time.deltaTime * 3.0);
		
		//Each 60 frames change the target position.
		if ((Std.int(Time.frame) % 60)==0)
		{
			tr = Mathf.Lerp(5.0, 200.0, Math.random());
			tx = Mathf.Lerp(0.0, cw-tr-tr, Math.random());						
			ty = Mathf.Lerp(0.0, ch-tr-tr, Math.random());
		}
		
	}
	
}