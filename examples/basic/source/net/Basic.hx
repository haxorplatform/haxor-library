package net;
import haxor.core.Application;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.JSON;
import haxor.core.Time;
import haxor.math.Mathf;
import haxor.net.client.ClientUser;
import haxor.net.client.Network;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Most basic demo.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class Basic extends Application implements IUpdateable
{
	
	var field : Element;
		
	var button : ButtonElement;
	
	var input : InputElement;
	
	var net : BasicNetwork;
	
	/**
	 * Initialize already created elements here.
	 */
	override function Build():Void 
	{
		trace("Basic> Build");
		
		//Search for elements in the HTML
		button = cast Browser.document.getElementById("button");
		input  = cast Browser.document.getElementById("input");		
		field  = cast Browser.document.getElementById("field");
		
				
				
	}
	
	override function Initialize():Void 
	{
		trace("Basic> Initialize");
		
		//Checks if the demo is running locally or in the internet.		
		var is_local : Bool = Application.protocol == ApplicationProtocol.File;
		
		//Sets the URL to try locally or in the internet.
		//This is my personal server (might be down anytime)
		var url : String    = "ws://54.186.99.218";
		
		
		var e : Entity = new Entity();
		
		net = cast e.AddComponent(BasicNetwork);						
		net.Connect(url, 30000, "", 0, true);	
		
		//Detect the click event and increment the 'clicks' variable
		button.onclick = function(ev : Event) 
		{ 
			net.SendMessage(input.value);
			input.value = "";
		};
		
		field.innerText += "Connecting: " + url + ":3000\n";
		
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

/**
 * Class that extends the Network communication component.
 */
class BasicNetwork extends Network implements IUpdateable
{		
	var field : Element;
	
	var show_count : Bool = true;
	
	/**
	 * Method called when the instance connected to server.
	 */	
	override private function OnConnect():Void 
	{
		field  = cast Browser.document.getElementById("field");
		field.innerText += "Connection Success!\n";
	}
	
	
	
	/**
	 * Method called when someone entered or left the server.
	 */	
	override private function OnUsersListUpdate():Void 
	{
		if (show_count)
		{
			field.innerText += "Users Online [" + users.length + "]\n";
			show_count = false;
		}
	}
	
	/**
	 * Method called when someone entered on server.
	 * @param	p_user
	 */
	override private function OnUserEnter(p_user:ClientUser):Void 
	{		
		field.innerText += "User ["+p_user.id+"] Entered!\n";
	}
	
	/**
	 * Method called when someone left the server.
	 * @param	p_user
	 */
	override private function OnUserLeave(p_user:ClientUser):Void 
	{
		field.innerText += "User ["+p_user.id+"] Left!\n";
	}
	
	/**
	 * Method called when someone sent any data (if the sent data does not fall in any method implemented in server)
	 * @param	p_user
	 */
	override private function OnData(p_data:String):Void
	{
		var d : Dynamic = JSON.FromJSON(p_data);
		Console.LogWarning("BasicNetwork> OnData "+p_data);
		if (d != null)
		{
			field.innerText += p_data+"\n";
		}
	}
	
	/**
	 * Method called when the user sent some data using 'SendMessage'
	 * @param	p_user
	 * @param	p_msg
	 */
	override function OnUserMessage(p_user:ClientUser, p_msg:String):Void 
	{
		field.innerText += "user["+p_user.id+"]  is_me["+(me.id == p_user.id)+"] sent ["+p_msg+"]"+"\n";
	}
	
	/**
	 * Update method to do some syncing when needed.
	 */
	public function OnUpdate():Void
	{	
		
	}
}