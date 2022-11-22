// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/Basic_LOD_Shader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoColour("AlbedoColour", Color) = (1,1,1,0)
		_Metallic("Metallic", Float) = 0
		_Smoothness("Smoothness", Float) = 0.2
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalAmount("NormalAmount", Float) = 0
		[Header(LOD Crossfade)]_LOD_DitheringMap("LOD_DitheringMap", 2D) = "white" {}
		[Toggle(LOD_FADE_CROSSFADE)] _LOD_FADE_CROSSFADE_out("LOD_FADE_CROSSFADE_out", Float) = 1
		[Toggle(LOD_FADE_CROSSFADE)] _LOD_FADE_CROSSFADE_in("LOD_FADE_CROSSFADE_in", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local LOD_FADE_CROSSFADE
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPosition;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalAmount;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _AlbedoColour;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _LOD_DitheringMap;
		float4 _LOD_DitheringMap_TexelSize;
		uniform float _Cutoff = 0.5;


		inline float DitherNoiseTex( float4 screenPos, sampler2D noiseTexture, float4 noiseTexelSize )
		{
			float dither = tex2Dlod( noiseTexture, float4(screenPos.xy * _ScreenParams.xy * noiseTexelSize.xy, 0, 0) ).g;
			float ditherRate = noiseTexelSize.x * noiseTexelSize.y;
			dither = ( 1 - ditherRate ) * dither + ditherRate;
			return dither;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalAmount );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( tex2D( _Albedo, uv_Albedo ) * _AlbedoColour ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float dither17 = DitherNoiseTex(ase_screenPosNorm, _LOD_DitheringMap, _LOD_DitheringMap_TexelSize);
			#ifdef LOD_FADE_CROSSFADE
				float staticSwitch13 = 1.0;
			#else
				float staticSwitch13 = ( unity_LODFade.x < 0.0 ? (0.0 + (sqrt( ( 1.0 - abs( unity_LODFade.x ) ) ) - 0.0) * (1.0 - 0.0) / (0.7 - 0.0)) : 1.0 );
			#endif
			#ifdef LOD_FADE_CROSSFADE
				float staticSwitch14 = 1.0;
			#else
				float staticSwitch14 = ( unity_LODFade.x > 0.0 ? (0.0 + (sqrt( unity_LODFade.x ) - 0.0) * (1.0 - 0.0) / (0.7 - 0.0)) : 1.0 );
			#endif
			dither17 = step( dither17, ( staticSwitch13 * staticSwitch14 ) );
			float LOD_Dithering18 = dither17;
			clip( LOD_Dithering18 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3426;2;2923;1371;2420.549;540.4844;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1818.488,502.6237;Inherit;False;1625.614;778.9801;LOD Fade;17;18;17;16;15;14;13;12;11;10;9;8;7;6;5;4;3;2;;0.5849056,0.5102917,0,1;0;0
Node;AmplifyShaderEditor.LODFadeNode;2;-1811.432,770.5997;Inherit;False;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;3;-1709.321,594.5995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-1570.109,580.9626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;6;-1636.109,848.9626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;5;-1425.109,614.9626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;7;-1285.109,583.9626;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1529.432,964.5995;Inherit;False;Constant;_Float1;Float 1;35;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1534.432,1089.6;Inherit;False;Constant;_Float2;Float 2;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-1498.109,782.9627;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;11;-1093.321,588.5995;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;12;-1291.432,835.5995;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;14;-1100.432,862.5995;Inherit;False;Property;_LOD_FADE_CROSSFADE_out;LOD_FADE_CROSSFADE_out;7;0;Create;True;0;0;0;False;0;False;0;1;1;True;LOD_FADE_CROSSFADE;Toggle;2;Key0;Key1;Create;True;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;13;-926.3207,654.5995;Inherit;False;Property;_LOD_FADE_CROSSFADE_in;LOD_FADE_CROSSFADE_in;8;0;Create;True;0;0;0;False;0;False;0;1;1;True;LOD_FADE_CROSSFADE;Toggle;2;Key0;Key1;Create;True;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-916.298,1028.848;Inherit;True;Property;_LOD_DitheringMap;LOD_DitheringMap;6;1;[Header];Create;True;1;LOD Crossfade;0;0;False;0;False;16d574e53541bba44a84052fa38778df;4199a601545ad164badaad1fe1733439;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-806.3207,864.5995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;17;-645.4319,928.5995;Inherit;False;2;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-906.3538,-111.4103;Inherit;False;Property;_NormalAmount;NormalAmount;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-603.3538,-641.4103;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-411.2982,936.8476;Inherit;False;LOD_Dithering;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-515.3538,-445.4103;Inherit;False;Property;_AlbedoColour;AlbedoColour;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-305.7405,327.6179;Inherit;False;18;LOD_Dithering;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-619.3538,-127.4103;Inherit;True;Property;_NormalMap;NormalMap;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-288.3538,192.5897;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-276.3538,104.5897;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-272.3538,-466.4103;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SyntyStudios/Basic_LOD_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;9;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;1
WireConnection;4;0;3;0
WireConnection;6;0;2;1
WireConnection;5;0;4;0
WireConnection;7;0;5;0
WireConnection;10;0;6;0
WireConnection;11;0;2;1
WireConnection;11;1;8;0
WireConnection;11;2;7;0
WireConnection;11;3;9;0
WireConnection;12;0;2;1
WireConnection;12;1;8;0
WireConnection;12;2;10;0
WireConnection;12;3;9;0
WireConnection;14;1;12;0
WireConnection;14;0;9;0
WireConnection;13;1;11;0
WireConnection;13;0;9;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;26;5;27;0
WireConnection;24;0;23;0
WireConnection;24;1;20;0
WireConnection;0;0;24;0
WireConnection;0;1;26;0
WireConnection;0;3;25;0
WireConnection;0;4;21;0
WireConnection;0;10;19;0
ASEEND*/
//CHKSM=61895DA9A7A58FAEAE2EB3DE2D08340EA737350C