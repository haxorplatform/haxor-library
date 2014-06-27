package webgl;
import haxor.component.Camera;
import haxor.component.MeshRenderer;
import haxor.core.Application;
import haxor.core.Asset;
import haxor.core.Console;
import haxor.core.Engine;
import haxor.core.Entity;
import haxor.core.IUpdateable;
import haxor.core.Time;
import haxor.graphics.CullMode;
import haxor.graphics.filters.BlurFX;
import haxor.graphics.Material;
import haxor.graphics.MeshTemplate.Mesh3;
import haxor.math.Color;
import haxor.math.Mathf;
import haxor.math.Quaternion;
import haxor.math.Vector3;
import js.Browser;
import js.html.ButtonElement;
import js.html.Event;
import js.html.ImageElement;
import js.html.ParagraphElement;
import js.html.ProgressElement;

/**
 * Creates a Quad with 2 trianglesand shows it with a texture and apply a BlurFX filter in the camera
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
class BlurFilter extends Application implements IUpdateable
{
	
	var quad : Entity;
	
	var blur : BlurFX;
	
	/**
	 * Loads the basic 'Flat' shader.
	 */
	override function Load():Void 
	{		
		//Loads the shader 'FlatTexture' and stores it in the id 'haxor/unlit/FlatTexture'
		Asset.LoadShader("haxor/unlit/FlatTexture", "http://haxor.thelaborat.org/resources/shader/unlit/FlatTexture.shader");
		
		//Loads the shader of the ImageProcessing filter.
		Asset.LoadShader("haxor/filter/Blur", "http://haxor.thelaborat.org/resources/shader/filter/Blur.shader");
		
		//Loads the ImageElement 'flower.jpg' and stores it as a TextureHTML in 'flower'
		Asset.LoadTextureHTML("flower", "http://haxor.thelaborat.org/resources/texture/misc/flower.jpg");
		
	}
	
	override function Initialize():Void 
	{
		trace("BlurFilter> Initialize");
		
		
		
		quad = new Entity();
		quad.name = "quad";
		
		//Adds component responsible of rendering meshes using the passed material.
		var mr : MeshRenderer = quad.AddComponent(MeshRenderer);
		
		//Creates a material that handles rendering information like shader, depth test, render queue.
		var mat : Material = new Material();
		mat.name = "QuadMaterial";
		mat.shader = Asset.Get("haxor/unlit/FlatTexture"); 		//Gets the shader loaded in the 'Load' method		
		mat.SetUniform("DiffuseTexture", Asset.Get("flower")); 	//Sets the 'DiffuseTexture' Uniform to the loaded texture.
		mat.cull = CullMode.None;								//Indicates that both front and back face will be rendered
				
		//Creates a Mesh with Vector3 components.
		var msh : Mesh3 = new Mesh3();
		msh.name = "QuadMesh";
		
		//sets the mesh vertex in the render order (no need for indexes)
		msh.vertex =
		[
		new Vector3( -0.5, 1.0, 0.0),
		new Vector3( -0.5, 0.0, 0.0),
		new Vector3(  0.5, 1.0, 0.0),
		
		new Vector3(  0.5, 1.0, 0.0),
		new Vector3( -0.5, 0.0, 0.0),
		new Vector3(  0.5, 0.0, 0.0)
		];
		
		//sets the mesh uv for each vertex
		msh.uv0 = 
		[
			new Vector3(0.0, 1.0),
			new Vector3(0.0, 0.0),
			new Vector3(1.0, 1.0),
			
			new Vector3(1.0, 1.0),
			new Vector3(0.0, 0.0),
			new Vector3(1.0, 0.0)
		];
		
		//sets each vertex color
		msh.color =
		[
		Color.white,
		Color.white,
		Color.white,
		Color.white,
		Color.white,
		Color.white
		];
		
		//Sets the renderer mesh
		mr.mesh = msh;
		//Sets the material
		mr.material = mat;
		
		
		//Creates an entity and adds a camera in it
		//It is necessary to have at least one camera in the scene
		var cam : Camera = (new Entity()).AddComponent(Camera);
		
		//Sets the clear color
		cam.background = new Color(0.1, 0.1, 0.1);
		
		//moves the camera slightly back so we can see the triangle
		cam.transform.position = new Vector3(0, 0.5, 1);
		
		blur = new BlurFX();
		//Adds the filter in the filters array.
		//The filters are then blit in the order they are passed.
		cam.filters = [blur];
		
		//The more iterations the smoothier (and slower) the blur
		blur.iterations = 15;
		
		//Default FPS = 45
		fps = 60;
		
		//Register the interface IUpdateable in the execution pool.
		Engine.Add(this);		
	}
	
	/**
	 * Execution loop.
	 */
	public function OnUpdate():Void
	{		
		
		var r : Float = (Mathf.Sin(Time.elapsed * Mathf.Deg2Rad * 360.0) + 1.0) * 0.5;
		
		blur.strength = Mathf.Lerp(0.0, 12.0, r);

		
	}
	
}