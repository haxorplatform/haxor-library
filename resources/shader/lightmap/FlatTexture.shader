<shader id="haxor/lightmap/FlatTexture">	

		<vertex precision="medium">
		
		
		
		uniform mat4  WorldMatrix;
		uniform mat4  ViewMatrix;
		uniform mat4  ProjectionMatrix;		
		
		attribute vec3 vertex;					
		attribute vec4 color;
		attribute vec3 uv0;
		attribute vec3 uv1;
		
		varying vec3 v_uv0;
		varying vec3 v_uv1;
		varying vec4 v_color;
		
		void main(void) 
		{		
			gl_Position = ((vec4(vertex, 1.0) * WorldMatrix) * ViewMatrix) * ProjectionMatrix;
			v_uv0   = uv0;
			v_uv1   = uv1;
			v_color = color;
		}		
		</vertex>
		
		<fragment precision="medium">
			
			
			varying vec3 v_uv0;
			varying vec3 v_uv1;
			varying vec4 v_color;
			
			uniform sampler2D DiffuseTexture;
			
			uniform sampler2D Lightmap;
			
			void main(void) 
			{	
				vec4 tex_diffuse  = texture2D(DiffuseTexture, v_uv0.xy);
				vec4 tex_lightmap = texture2D(Lightmap, v_uv1.xy);
				vec3 c			  = tex_diffuse.xyz * (tex_lightmap.w * 8.0) * tex_lightmap.xyz;
				//c = tex_lightmap.xyz;
				gl_FragColor.xyz = c.xyz * v_color.xyz;
				gl_FragColor.a 	 = tex_diffuse.a * v_color.a;
			}
		</fragment>	
	</shader>