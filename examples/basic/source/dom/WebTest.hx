package dom;

import haxe.Timer;
import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.input.Input;
import haxor.input.KeyCode;
import haxor.math.Mathf;
import haxor.net.Web;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.Image;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Application that shows the basic functionalities of the 'Web' class to load stuff.
 * It creates a queue of images that each click enqueues some elements and after each load it process the next one on queue.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class WebTest extends Application implements IUpdateable
{
	
	var button : ButtonElement;
	
	var field : ParagraphElement;

	var logo : ImageElement;
	
	var progress : ProgressElement;
	
	var queue : Array<String>;
	
	var queue_length : Float;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("WebTest> Build");
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		field  = cast Browser.document.getElementById("field");
		logo   = cast Browser.document.getElementById("logo");
		progress = cast Browser.document.getElementById("progress");
		
		//Hide not necessary
		logo.style.display   = "none"; 
		field.style.display   = "none";
		
		queue_length = 0.0;
		queue = [];
		
		//Detect the click event and adds some icons
		button.onclick = function(ev : Event) 
		{ 
			for (i in 0...15)
			{
				LoadImage();
			}
		};
		
	}
	
	override function Initialize():Void 
	{
		trace("WebTest> Initialize");
		
		//No need for stage on this demo
		//UI / Haxor / HTML interactions are WIP
		stage.visible = false;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	private function ProcessLoad():Void
	{
		//Checks if the queue is empty and ignore if necessary.
		if (queue.length <= 0)
		{	
			if (queue.length <= 0)
			{			
				progress.value = 0.0;
				queue_length = 0.0;
			}					
			return;		
		}
		
		
		//Updates the progress bar
		progress.max   = 1.0;
		progress.value = (1.0 - (queue.length / queue_length));
		
		//Fetches the first link of the queue.
		var url : String = queue[0];
		
		//Request the load and handle the events in the callback.
		Web.LoadImage(url, function(img : Image, p : Float):Void
		{
			//100% progress
			if (p >= 1.0)
			{
				//Check if the load img is not null (in case of error)
				if (img != null)
				{
					
					var e : ImageElement = img;
					
					//Adjust CSS
					e.style.position = "absolute";
					
					e.style.left  = Mathf.Lerp(-20, -50, Math.random()) + "px";
					e.style.top   = Mathf.Lerp(0, 800, Math.random()) + "px";
					
					//Define transition.
					e.style.transition = "left 0.5s, top 0.5s";
					
					//Wait a bit and animate
					Timer.delay(function()
					{
						e.style.left  = Mathf.Lerp(0, 1000, Math.random()) + "px";
						e.style.top   = Mathf.Lerp(0, 800, Math.random()) + "px";
					},500);					 
					
					//Adds the image in the document.
					Browser.document.body.appendChild(e);
					
					//Remove the element from the queue.
					queue.pop();
					
					//Process the next element.
					ProcessLoad();
				}
			}
		});
	}
	
	private function LoadImage()
	{
		//Sets the root of loading ('./' will be replaced by this URL)
		Web.root = "http://haxor.thelaborat.org/resources/";	
		
		var rnd : Float = Math.random();
		
		//Generate links with random garbage to break cache and allow the load to show progress.
		var links : Array<String> = 
		[
		"./texture/misc/compatible_ie.gif?"+rnd,
		"./texture/misc/compatible_firefox.gif?"+rnd,
		"./texture/misc/compatible_chrome.gif?"+rnd
		];
		
		//Scramble list
		links.sort(function(a:String, b:String):Int { return Math.random() < 0.5 ? -1 : 1; } );
	
		//Enqueue the link
		queue.push(links[0]);		
		queue_length = Mathf.Max([queue.length, queue_length]);	
		
		
		
		//Process the first of the queue.
		if (queue.length <= 1) ProcessLoad();
		
		
		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{	
		
	}
	
}