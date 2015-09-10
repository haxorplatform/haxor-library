Shader "aquiris/bump/BumpedDiffuseFalloffSkin" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)	
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_MainTex1 ("Base 1 (RGB) RefStrGloss (A)", 2D) = "white" {}
	_ReflectColor ("Reflection Color 0", Color) = (1,1,1,0.5)
	_ReflectColor1 ("Reflection Color 1", Color) = (1,1,1,0.5)
	_Skin ("Skin", Range (0.0, 1)) = 0.0	
	_Falloff ("Falloff", Range (0.5, 10)) = 5
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300
	
CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
sampler2D _MainTex1;
sampler2D _BumpMap;

fixed4 _Color;
fixed4 _ReflectColor;
fixed4 _ReflectColor1;

half _Skin;
half _Falloff;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 worldRefl;
	float3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex0 = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 tex1 = tex2D(_MainTex1, IN.uv_MainTex);
	fixed4 tex  = tex0 + (tex1 - tex0) * _Skin;
	fixed4 c = tex * _Color;

	fixed4 reflect_color = _ReflectColor + (_ReflectColor1 - _ReflectColor) * _Skin;

	o.Albedo = c.rgb;	
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));


	half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));

	float falloff = pow(rim,_Falloff);

	o.Emission = reflect_color.rgb * falloff *0.5;
	o.Alpha = reflect_color.a;
}
ENDCG
}

FallBack "Reflective/VertexLit"
}
