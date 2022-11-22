// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/TriplanarBasic"
{
	Properties
	{
		_FallOff("FallOff", Range( 0 , 100)) = 100
		_Tiling("Tiling", Range( 0 , 10)) = 1
		_Sides("Sides", 2D) = "white" {}
		_SidesNormal("SidesNormal", 2D) = "white" {}
		_Top("Top", 2D) = "white" {}
		_TopNormal("TopNormal", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _TopNormal;
		uniform sampler2D _SidesNormal;
		uniform float _Tiling;
		uniform float _FallOff;
		uniform sampler2D _Top;
		uniform sampler2D _Sides;


		inline float4 TriplanarSampling8( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling5( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar8 = TriplanarSampling8( _TopNormal, _SidesNormal, _SidesNormal, ase_worldPos, ase_worldNormal, _FallOff, _Tiling, float3( 1,1,1 ), float3(0,0,0) );
			o.Normal = UnpackNormal( triplanar8 );
			float4 triplanar5 = TriplanarSampling5( _Top, _Sides, _Sides, ase_worldPos, ase_worldNormal, _FallOff, _Tiling, float3( 1,1,1 ), float3(0,0,0) );
			o.Albedo = triplanar5.xyz;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3210;486;2382;1069;1551.333;75.99957;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;10;-582.704,352.9987;Float;True;Property;_TopNormal;TopNormal;5;0;Create;True;0;0;0;True;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;9;-642.9031,624.2561;Float;True;Property;_SidesNormal;SidesNormal;3;0;Create;True;0;0;0;True;0;False;None;9e88b336bd16b1e4b99de75f486126c1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1;-895.0966,382.8673;Float;False;Property;_FallOff;FallOff;0;0;Create;True;0;0;0;False;0;False;100;6.24;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-948.3328,521.0004;Float;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;1;6.24;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-887.0956,128.6251;Float;True;Property;_Sides;Sides;2;0;Create;True;0;0;0;True;0;False;None;9e88b336bd16b1e4b99de75f486126c1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;2;-888.0966,-100.1325;Float;True;Property;_Top;Top;4;0;Create;True;0;0;0;True;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;8;-343.0234,493.2465;Inherit;True;Cylindrical;World;False;Top Texture 1;_TopTexture1;white;2;None;Mid Texture 1;_MidTexture1;white;1;None;Bot Texture 1;_BotTexture1;white;3;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT;1;False;4;FLOAT;100;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;5;-595.0159,84.01523;Inherit;True;Cylindrical;World;False;Top Texture 0;_TopTexture0;white;2;None;Mid Texture 0;_MidTexture0;white;1;None;Bot Texture 0;_BotTexture0;white;3;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT;1;False;4;FLOAT;100;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnpackScaleNormalNode;12;236.6672,594.0004;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;230.1,32.5;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SyntyStudios/TriplanarBasic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;10;0
WireConnection;8;1;9;0
WireConnection;8;2;9;0
WireConnection;8;3;13;0
WireConnection;8;4;1;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;5;2;3;0
WireConnection;5;3;13;0
WireConnection;5;4;1;0
WireConnection;12;0;8;0
WireConnection;0;0;5;0
WireConnection;0;1;12;0
ASEEND*/
//CHKSM=B29C0D0EA824C025AF6BD068CCA2270E9BA3DD86