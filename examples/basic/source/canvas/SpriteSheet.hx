package canvas;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IRenderable;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.input.Input;
import haxor.input.KeyCode;
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
 * Loads an image with the SpriteSheet and plays a simple animation.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class SpriteSheet extends Application implements IRenderable implements IUpdateable
{
	
	var canvas : CanvasElement;
	
	var c : CanvasRenderingContext2D;
	
	var image : Image;
	
	var sheet_fps : Float;
	
	var sheet_frame : Int;
	
	var sheet_length : Int;
	
	var sheet_elapsed : Float;
	
	var sheet_time : Float;
	
	var sheet_hcell_count : Int;
	
	var speed : Float;
	
	var px : Float;
	
	var py : Float;
	
	var vx : Float;
	
	var vy : Float;
	
	var is_moving : Bool;
		
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("SpriteSheet> Build");
		
		//Search for elements in the HTML
		canvas = cast Browser.document.getElementById("canvas");
		
		//Gets the image from the HTML
		image = cast Browser.document.getElementById("sheet");
		
		//Gets the RenderingContext2D
		c = canvas.getContext2d();
		
		//Time until next frame
		sheet_elapsed = 0.0;
		
		//FPS of the sheet animation
		sheet_fps     = 30;
		
		//Sheet frame count
		sheet_length = 27;
		
		//Sheet current frame
		sheet_frame = 0;
		
		//number of horizontal frame cells 
		sheet_hcell_count = 7;
		
		//Starts the player position, velocity and speed
		px = 20;
		py = 20;
		vx = vy = 0;
		speed = 0;
	}
	
	override function Initialize():Void 
	{
		trace("SpriteSheet> Initialize");
		
		//Ignore UI Stage for now.
		stage.visible = false;
		
		//Sets the spritesheet framerate
		sheet_fps  = 40;
		
		//Register the interface IRenderable in the render pool if the context exists.
		if (c != null) Engine.Add(this);		
		
		//Default = 45fps
		//60fps = smoothier but heavier on CPU
		fps = 60;
		
	}
	
	/**
	 * Execution loop
	 */
	public function OnUpdate():Void
	{
	
		//Max movement speed
		var max_speed : Float = 400.0;		
		
		//Check if arrow keys are down and adds velocity x and y
		if (Input.IsDown(KeyCode.Left))  { vx += -1 * Time.deltaTime * max_speed; }		
		if (Input.IsDown(KeyCode.Right)) { vx +=  1 * Time.deltaTime * max_speed; }
		if (Input.IsDown(KeyCode.Up))    { vy += -1 * Time.deltaTime * max_speed; }
		if (Input.IsDown(KeyCode.Down))  { vy +=  1 * Time.deltaTime * max_speed; }
		
		//Damps the velocity
		vx = Mathf.Lerp(vx, 0.0, Time.deltaTime * 2.0);
		vy = Mathf.Lerp(vy, 0.0, Time.deltaTime * 2.0);
		
		//Increments player position
		px += vx * Time.deltaTime;
		py += vy * Time.deltaTime;
		
		//increments the frame time based on the delta time and player speed vs max_speed
		sheet_elapsed += Time.deltaTime * Mathf.Sqrt(vx*vx + vy*vy) /max_speed;
		
		//checks if the frame needs to be changed
		if (sheet_elapsed >= (1.0 / sheet_fps))
		{
			//returns the time accounting for fractions (avoid error accumulation)
			sheet_elapsed -= (1.0 / sheet_fps);
			
			//changes the next frame and loops if it ended.
			sheet_frame = (sheet_frame+1) % sheet_length;
		}
	}
		
	/**
	 * Render loop.
	 */
	public function OnRender():Void
	{
		//Resizes the canvas
		canvas.width  = Browser.window.innerWidth;
		canvas.height = Browser.window.innerHeight;
		
		//Stores its size
		var cw : Int = canvas.width;
		var ch : Int = canvas.height;
		
		//Fills the rectangle
		c.setFillColor(0.1, 0.1, 0.1,1.0);
		c.fillRect(0, 0, cw, ch);
		
		//Size of cell frame.
		var cell_w : Float = 130;
		var cell_h : Float = 150;
		
		//'x' and 'y' of the cell in the sheet
		var cx : Float = ((sheet_frame % sheet_hcell_count)) * cell_w;
		var cy : Float = Mathf.Floor(sheet_frame / sheet_hcell_count) * cell_h;
		c.drawImage(image, cx, cy, cell_w, cell_h, px, py, 134, 150);		
	}
	
}