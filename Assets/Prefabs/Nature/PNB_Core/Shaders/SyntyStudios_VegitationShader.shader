// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/VegitationShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.3
		[Header(Leaves)]_LeafTex("LeafTex", 2D) = "white" {}
		_LeafNormalMap("LeafNormalMap", 2D) = "bump" {}
		_LeafNormalAmount("LeafNormalAmount", Range( 0 , 1)) = 0.5
		_LeafMetallic("LeafMetallic", Range( 0 , 1)) = 0.13
		_LeafSmoothness("LeafSmoothness", Range( 0 , 1)) = 0.5
		_LeafAmbientOcclusion("LeafAmbientOcclusion", 2D) = "white" {}
		[Header(Trunk)]_TunkTex("TunkTex", 2D) = "white" {}
		_TrunkNormalMap("TrunkNormalMap", 2D) = "bump" {}
		_TrunkNormalAmount("TrunkNormalAmount", Range( 0 , 1)) = 0.5
		_TrunkMetallic("TrunkMetallic", Range( 0 , 1)) = 0
		_TrunkSmoothness("TrunkSmoothness", Range( 0 , 1)) = 0.2
		_TrunkAmbientOcclusion("TrunkAmbientOcclusion", 2D) = "white" {}
		[Header(Colour Tinting)]_LeafBaseColour("LeafBaseColour", Color) = (0.07843138,0.02015968,0,0)
		_LeafNoiseColour("LeafNoiseColour", Color) = (0.07843138,0.02015968,0,0)
		_LeafNoiseLargeColour("LeafNoiseLargeColour", Color) = (0.07843138,0.02015968,0,0)
		[Toggle]_LeafFlatColourSwitch("LeafFlatColourSwitch", Float) = 0
		_TrunkBaseColour("TrunkBaseColour", Color) = (0.07843138,0.02015968,0,0)
		_TrunkNoiseColour("TrunkNoiseColour", Color) = (0.07843138,0.02015968,0,0)
		[Toggle]_TrunkFlatColourSwitch("TrunkFlatColourSwitch", Float) = 0
		_ColourNoiseSmallScale("ColourNoiseSmallScale", Range( 0 , 1)) = 0
		_ColourNoiseLargeScale("ColourNoiseLargeScale", Range( 0 , 1)) = 0
		[Header(Emissive)]_EmissiveAmount("EmissiveAmount", Range( 0 , 2)) = 0
		_EmissiveMask("EmissiveMask", 2D) = "white" {}
		_EmissiveColour("EmissiveColour", Color) = (0,0,0,0)
		_Emissive2Mask("Emissive2Mask", 2D) = "white" {}
		_Emissive2Colour("Emissive2Colour", Color) = (0,0,0,0)
		_TrunkEmissiveColour("TrunkEmissiveColour", Color) = (0,0,0,0)
		_TrunkEmissiveMask("TrunkEmissiveMask", 2D) = "white" {}
		_EmissivePulseMap("EmissivePulseMap", 2D) = "white" {}
		[Header(Main Wind)]_TotalWindAmount("TotalWindAmount", Range( 0 , 1)) = 0.5
		_WindDirection("WindDirection", Range( 0 , 1)) = 0
		_WindBaseline("WindBaseline", Range( 0 , 3)) = 0
		_Y_multiplier("Y_multiplier", Range( -2 , 2)) = 0.2
		_GustAmount("GustAmount", Range( 0 , 1)) = 0.5
		_GustSmallFreq("GustSmallFreq", Range( 0 , 1)) = 1
		_GustLargeFreq("GustLargeFreq", Range( 0 , 1)) = 0.5
		_GustNoiseMap("GustNoiseMap", 2D) = "white" {}
		_GustScale("GustScale", Range( 0 , 1)) = 0.5
		_GustHighlight("GustHighlight", Color) = (0,0,0,0)
		[Header(LeafSway)]_LeafBigNoiseScale("LeafBigNoiseScale", Range( 0 , 10)) = 1
		_LeafBigNoiseAmount("LeafBigNoiseAmount", Range( 0 , 1)) = 0.5
		[Header(LeafJitter)]_JitterFreq("JitterFreq", Range( 0 , 1)) = 0
		_JitterAmount("JitterAmount", Range( 0 , 1)) = 0.5
		_Leaves_NoiseTexture2("LeafJitterMap", 2D) = "white" {}
		[Header(Frosting)]_FrostingColour("FrostingColour", Color) = (1,1,1,0)
		[Toggle]_FrostingSwitch("FrostingSwitch", Float) = 0
		_FrostingHeight("FrostingHeight", Float) = 1
		_FrostingFalloff("FrostingFalloff", Float) = 1
		[Header(LOD Crossfade)]_LOD_DitheringMap("LOD_DitheringMap", 2D) = "white" {}
		[Toggle(LOD_FADE_CROSSFADE)] _LOD_FADE_CROSSFADE_out("LOD_FADE_CROSSFADE_out", Float) = 1
		[Toggle(LOD_FADE_CROSSFADE)] _LOD_FADE_CROSSFADE_in("LOD_FADE_CROSSFADE_in", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local LOD_FADE_CROSSFADE
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
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPosition;
		};

		uniform float _JitterAmount;
		uniform sampler2D _Leaves_NoiseTexture2;
		uniform float _JitterFreq;
		uniform float _LeafBigNoiseAmount;
		uniform float _LeafBigNoiseScale;
		uniform float _WindDirection;
		uniform float _GustAmount;
		uniform float _GustScale;
		uniform float _GustSmallFreq;
		uniform sampler2D _GustNoiseMap;
		uniform float _GustLargeFreq;
		uniform float _WindBaseline;
		uniform float _TotalWindAmount;
		uniform float _Y_multiplier;
		uniform sampler2D _LeafNormalMap;
		uniform float4 _LeafNormalMap_ST;
		uniform float _LeafNormalAmount;
		uniform sampler2D _TrunkNormalMap;
		uniform float4 _TrunkNormalMap_ST;
		uniform float _TrunkNormalAmount;
		uniform float _FrostingSwitch;
		uniform float _LeafFlatColourSwitch;
		uniform sampler2D _LeafTex;
		uniform float4 _LeafTex_ST;
		uniform sampler2D _TunkTex;
		uniform float4 _TunkTex_ST;
		uniform float4 _LeafNoiseColour;
		uniform float4 _LeafBaseColour;
		uniform float _ColourNoiseSmallScale;
		uniform float4 _LeafNoiseLargeColour;
		uniform float _ColourNoiseLargeScale;
		uniform float4 _GustHighlight;
		uniform float4 _FrostingColour;
		uniform float _FrostingHeight;
		uniform float _FrostingFalloff;
		uniform float _TrunkFlatColourSwitch;
		uniform float4 _TrunkNoiseColour;
		uniform float4 _TrunkBaseColour;
		uniform float4 _EmissiveColour;
		uniform sampler2D _EmissiveMask;
		uniform float4 _EmissiveMask_ST;
		uniform float4 _Emissive2Colour;
		uniform sampler2D _Emissive2Mask;
		uniform float4 _Emissive2Mask_ST;
		uniform float4 _TrunkEmissiveColour;
		uniform sampler2D _TrunkEmissiveMask;
		uniform float4 _TrunkEmissiveMask_ST;
		uniform float _EmissiveAmount;
		uniform sampler2D _EmissivePulseMap;
		uniform float _LeafMetallic;
		uniform float _TrunkMetallic;
		uniform float _LeafSmoothness;
		uniform float _TrunkSmoothness;
		uniform sampler2D _LeafAmbientOcclusion;
		uniform float4 _LeafAmbientOcclusion_ST;
		uniform sampler2D _TrunkAmbientOcclusion;
		uniform float4 _TrunkAmbientOcclusion_ST;
		uniform sampler2D _LOD_DitheringMap;
		float4 _LOD_DitheringMap_TexelSize;
		uniform float _Cutoff = 0.3;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


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
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime28 = _Time.y * (0.0 + (_JitterFreq - 0.0) * (0.06 - 0.0) / (1.0 - 0.0));
			float2 temp_cast_0 = (( ase_vertex3Pos.x + mulTime28 )).xx;
			float lerpResult50 = lerp( tex2Dlod( _Leaves_NoiseTexture2, float4( temp_cast_0, 0, 0.0) ).r , 0.0 , ( 1.0 - v.color.g ));
			float3 appendResult55 = (float3(lerpResult50 , 0.0 , 0.0));
			float4 Jitter68 = CalculateContrast((0.0 + (_JitterAmount - 0.0) * (0.3 - 0.0) / (1.0 - 0.0)),float4( (appendResult55).xz, 0.0 , 0.0 ));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float grayscale304 = Luminance(ase_worldPos);
			float3 temp_cast_2 = (grayscale304).xxx;
			float simplePerlin3D117 = snoise( temp_cast_2 );
			simplePerlin3D117 = simplePerlin3D117*0.5 + 0.5;
			float lerpResult130 = lerp( ( simplePerlin3D117 * sin( ( _LeafBigNoiseScale * ( grayscale304 + _Time.y ) ) ) ) , 0.0 , ( 1.0 - v.color.g ));
			float cos103 = cos( (0.0 + (_WindDirection - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float sin103 = sin( (0.0 + (_WindDirection - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float2 rotator103 = mul( float2( 1,1 ) - float2( 0,0 ) , float2x2( cos103 , -sin103 , sin103 , cos103 )) + float2( 0,0 );
			float2 temp_output_362_0 = (ase_worldPos).xz;
			float simplePerlin2D368 = snoise( temp_output_362_0*0.05 );
			simplePerlin2D368 = simplePerlin2D368*0.5 + 0.5;
			float cos361 = cos( (0.0 + (( 1.0 - _WindDirection ) - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float sin361 = sin( (0.0 + (( 1.0 - _WindDirection ) - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float2 rotator361 = mul( temp_output_362_0 - float2( 0,0 ) , float2x2( cos361 , -sin361 , sin361 , cos361 )) + float2( 0,0 );
			float grayscale346 = Luminance(float3( rotator361 ,  0.0 ));
			float2 temp_cast_4 = (( _SinTime.y * (0.0 + (_GustLargeFreq - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) )).xx;
			float temp_output_177_0 = ( (0.0 + (_GustAmount - 0.0) * (4.0 - 0.0) / (1.0 - 0.0)) * ( ( ( simplePerlin2D368 * sin( ( ( grayscale346 * _GustScale ) + ( _Time.y * -(0.0 + (_GustSmallFreq - 0.0) * (10.0 - 0.0) / (1.0 - 0.0)) ) ) ) ) + 0.5 ) / 2.0 ) * ( ( tex2Dlod( _GustNoiseMap, float4( temp_cast_4, 0, 0.0) ).r + 0.5 ) / 2.0 ) );
			float lerpResult101 = lerp( ( temp_output_177_0 + _WindBaseline ) , 0.0 , ( 1.0 - v.color.r ));
			float2 break99 = ( rotator103 * lerpResult101 );
			float3 appendResult100 = (float3(break99.x , 0.0 , break99.y));
			float temp_output_293_0 = (0.0 + (_TotalWindAmount - 0.0) * (2.0 - 0.0) / (1.0 - 0.0));
			float3 break169 = ( ( _LeafBigNoiseAmount * lerpResult130 ) + ( appendResult100 * temp_output_293_0 ) );
			float smoothstepResult167 = smoothstep( 0.0 , 2.0 , abs( lerpResult101 ));
			float3 appendResult168 = (float3(break169.x , ( smoothstepResult167 * _Y_multiplier * temp_output_293_0 ) , break169.z));
			float3 worldToObjDir239 = mul( unity_WorldToObject, float4( appendResult168, 0 ) ).xyz;
			float3 Wind201 = worldToObjDir239;
			v.vertex.xyz += ( Jitter68 + float4( Wind201 , 0.0 ) ).rgb;
			v.vertex.w = 1;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_LeafNormalMap = i.uv_texcoord * _LeafNormalMap_ST.xy + _LeafNormalMap_ST.zw;
			float2 uv_TrunkNormalMap = i.uv_texcoord * _TrunkNormalMap_ST.xy + _TrunkNormalMap_ST.zw;
			o.Normal = ( i.vertexColor.b > 0.5 ? UnpackScaleNormal( tex2D( _LeafNormalMap, uv_LeafNormalMap ), _LeafNormalAmount ) : UnpackScaleNormal( tex2D( _TrunkNormalMap, uv_TrunkNormalMap ), _TrunkNormalAmount ) );
			float2 uv_LeafTex = i.uv_texcoord * _LeafTex_ST.xy + _LeafTex_ST.zw;
			float2 uv_TunkTex = i.uv_texcoord * _TunkTex_ST.xy + _TunkTex_ST.zw;
			float4 temp_output_551_0 = ( i.vertexColor.b > 0.5 ? tex2D( _LeafTex, uv_LeafTex ) : tex2D( _TunkTex, uv_TunkTex ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_51_0 = ( ase_worldPos * 0.5 );
			float simplePerlin3D57 = snoise( temp_output_51_0*_ColourNoiseSmallScale );
			simplePerlin3D57 = simplePerlin3D57*0.5 + 0.5;
			float3 temp_cast_0 = (simplePerlin3D57).xxx;
			float3 lerpResult60 = lerp( temp_cast_0 , sin( temp_output_51_0 ) , float3( 0,0,0 ));
			float grayscale66 = Luminance(lerpResult60);
			float4 lerpResult71 = lerp( _LeafNoiseColour , _LeafBaseColour , grayscale66);
			float4 lerpResult508 = lerp( _LeafNoiseLargeColour , float4( 0,0,0,0 ) , float4( 0,0,0,0 ));
			float3 temp_output_502_0 = ( ase_worldPos * 0.5 );
			float simplePerlin3D500 = snoise( temp_output_502_0*(0.0 + (_ColourNoiseLargeScale - 0.0) * (0.2 - 0.0) / (1.0 - 0.0)) );
			simplePerlin3D500 = simplePerlin3D500*0.5 + 0.5;
			float3 temp_cast_1 = (simplePerlin3D500).xxx;
			float3 lerpResult499 = lerp( temp_cast_1 , sin( temp_output_502_0 ) , float3( 0,0,0 ));
			float grayscale498 = Luminance(lerpResult499);
			float4 lerpResult497 = lerp( lerpResult71 , lerpResult508 , grayscale498);
			float4 blendOpSrc73 = temp_output_551_0;
			float4 blendOpDest73 = lerpResult497;
			float2 temp_output_362_0 = (ase_worldPos).xz;
			float simplePerlin2D368 = snoise( temp_output_362_0*0.05 );
			simplePerlin2D368 = simplePerlin2D368*0.5 + 0.5;
			float cos361 = cos( (0.0 + (( 1.0 - _WindDirection ) - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float sin361 = sin( (0.0 + (( 1.0 - _WindDirection ) - 0.0) * (6.28 - 0.0) / (1.0 - 0.0)) );
			float2 rotator361 = mul( temp_output_362_0 - float2( 0,0 ) , float2x2( cos361 , -sin361 , sin361 , cos361 )) + float2( 0,0 );
			float grayscale346 = Luminance(float3( rotator361 ,  0.0 ));
			float2 temp_cast_3 = (( _SinTime.y * (0.0 + (_GustLargeFreq - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) )).xx;
			float temp_output_177_0 = ( (0.0 + (_GustAmount - 0.0) * (4.0 - 0.0) / (1.0 - 0.0)) * ( ( ( simplePerlin2D368 * sin( ( ( grayscale346 * _GustScale ) + ( _Time.y * -(0.0 + (_GustSmallFreq - 0.0) * (10.0 - 0.0) / (1.0 - 0.0)) ) ) ) ) + 0.5 ) / 2.0 ) * ( ( tex2D( _GustNoiseMap, temp_cast_3 ).r + 0.5 ) / 2.0 ) );
			float gustValue373 = temp_output_177_0;
			float4 lerpResult378 = lerp( ( _GustHighlight * gustValue373 ) , float4( 0,0,0,0 ) , ( 1.0 - i.vertexColor.g ));
			float4 temp_output_379_0 = ( (( _LeafFlatColourSwitch )?( lerpResult497 ):( 	max( blendOpSrc73, blendOpDest73 ) )) + lerpResult378 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 lerpResult461 = lerp( temp_output_379_0 , _FrostingColour , saturate( ( pow( ase_worldNormal.y , _FrostingHeight ) * _FrostingFalloff ) ));
			float4 lerpResult570 = lerp( _TrunkNoiseColour , _TrunkBaseColour , grayscale66);
			float4 blendOpSrc575 = temp_output_551_0;
			float4 blendOpDest575 = lerpResult570;
			float4 Albedo78 = ( i.vertexColor.b > 0.5 ? (( _FrostingSwitch )?( lerpResult461 ):( temp_output_379_0 )) : (( _TrunkFlatColourSwitch )?( lerpResult570 ):( 	max( blendOpSrc575, blendOpDest575 ) )) );
			o.Albedo = Albedo78.rgb;
			float2 uv_EmissiveMask = i.uv_texcoord * _EmissiveMask_ST.xy + _EmissiveMask_ST.zw;
			float4 lerpResult417 = lerp( _EmissiveColour , float4( 0,0,0,0 ) , ( 1.0 - tex2D( _EmissiveMask, uv_EmissiveMask ).r ));
			float2 uv_Emissive2Mask = i.uv_texcoord * _Emissive2Mask_ST.xy + _Emissive2Mask_ST.zw;
			float4 lerpResult457 = lerp( _Emissive2Colour , float4( 0,0,0,0 ) , ( 1.0 - tex2D( _Emissive2Mask, uv_Emissive2Mask ).r ));
			float2 uv_TrunkEmissiveMask = i.uv_texcoord * _TrunkEmissiveMask_ST.xy + _TrunkEmissiveMask_ST.zw;
			float4 lerpResult569 = lerp( _TrunkEmissiveColour , float4( 0,0,0,0 ) , ( 1.0 - tex2D( _TrunkEmissiveMask, uv_TrunkEmissiveMask ).r ));
			float2 temp_cast_5 = (0.03).xx;
			float mulTime436 = _Time.y * 0.04;
			float2 temp_cast_6 = (mulTime436).xx;
			float2 uv_TexCoord435 = i.uv_texcoord * temp_cast_5 + temp_cast_6;
			float4 appendResult441 = (float4(ase_worldPos.x , 0.0 , ase_worldPos.z , 0.0));
			float mulTime430 = _Time.y * 4.0;
			float grayscale432 = Luminance(sin( ( ( appendResult441 * 0.5 ) + mulTime430 ) ).xyz);
			float clampResult444 = clamp( max( tex2D( _EmissivePulseMap, uv_TexCoord435 ).r , grayscale432 ) , 0.0 , 1.0 );
			float4 Emissive420 = ( ( i.vertexColor.b > 0.5 ? ( lerpResult417 + lerpResult457 ) : lerpResult569 ) * _EmissiveAmount * (0.5 + (clampResult444 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
			o.Emission = Emissive420.rgb;
			float temp_output_189_0 = ( 1.0 - i.vertexColor.b );
			float lerpResult188 = lerp( _LeafMetallic , 0.0 , temp_output_189_0);
			float lerpResult195 = lerp( _TrunkMetallic , 0.0 , i.vertexColor.b);
			o.Metallic = ( lerpResult188 + lerpResult195 );
			float lerpResult191 = lerp( _LeafSmoothness , 0.0 , temp_output_189_0);
			float lerpResult190 = lerp( _TrunkSmoothness , 0.0 , i.vertexColor.b);
			o.Smoothness = ( lerpResult191 + lerpResult190 );
			float2 uv_LeafAmbientOcclusion = i.uv_texcoord * _LeafAmbientOcclusion_ST.xy + _LeafAmbientOcclusion_ST.zw;
			float2 uv_TrunkAmbientOcclusion = i.uv_texcoord * _TrunkAmbientOcclusion_ST.xy + _TrunkAmbientOcclusion_ST.zw;
			o.Occlusion = ( i.vertexColor.b > 0.5 ? tex2D( _LeafAmbientOcclusion, uv_LeafAmbientOcclusion ) : tex2D( _TrunkAmbientOcclusion, uv_TrunkAmbientOcclusion ) ).r;
			o.Alpha = 1;
			float Alpha77 = temp_output_551_0.a;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float dither535 = DitherNoiseTex(ase_screenPosNorm, _LOD_DitheringMap, _LOD_DitheringMap_TexelSize);
			#ifdef LOD_FADE_CROSSFADE
				float staticSwitch533 = 1.0;
			#else
				float staticSwitch533 = ( unity_LODFade.x < 0.0 ? (0.0 + (sqrt( ( 1.0 - abs( unity_LODFade.x ) ) ) - 0.0) * (1.0 - 0.0) / (0.7 - 0.0)) : 1.0 );
			#endif
			#ifdef LOD_FADE_CROSSFADE
				float staticSwitch532 = 1.0;
			#else
				float staticSwitch532 = ( unity_LODFade.x > 0.0 ? (0.0 + (sqrt( unity_LODFade.x ) - 0.0) * (1.0 - 0.0) / (0.7 - 0.0)) : 1.0 );
			#endif
			dither535 = step( dither535, ( staticSwitch533 * staticSwitch532 ) );
			float LOD_Dithering411 = dither535;
			clip( ( Alpha77 * LOD_Dithering411 ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
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
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.screenPosition;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.screenPosition = IN.customPack2.xyzw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
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
-3425;4;2923;1371;4573.319;278.0969;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;170;-4325.497,-193.9984;Inherit;False;2691.717;1653.247;Wind;55;309;311;98;167;148;142;152;293;100;143;99;97;103;101;175;214;104;173;177;105;303;307;306;176;299;182;367;368;308;330;184;332;369;310;178;282;346;283;106;179;361;102;201;239;168;169;171;363;362;364;146;371;372;373;549;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-3100.517,1215.123;Inherit;False;Property;_WindDirection;WindDirection;31;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;549;-4311.961,421.5781;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;364;-4268.157,811.8131;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;362;-4101.357,609.8133;Inherit;False;True;False;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;363;-4093.657,711.3132;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;6.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-4213.904,929.6496;Inherit;False;Property;_GustSmallFreq;GustSmallFreq;35;0;Create;True;0;0;0;False;0;False;1;0.306;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;372;-3931.502,891.8654;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;361;-3900.156,656.2133;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;2;FLOAT;3.19;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-3794.424,767.774;Inherit;False;Property;_GustScale;GustScale;38;0;Create;True;0;0;0;False;0;False;0.5;0.094;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;346;-3713.156,643.2133;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;106;-3754.707,855.1585;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;371;-3696.277,935.6663;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;282;-3522.824,684.1741;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-3532.206,828.6497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;-4102.317,1299.284;Inherit;False;Property;_GustLargeFreq;GustLargeFreq;36;0;Create;True;0;0;0;False;0;False;0.5;0.081;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;-3397.799,688.0146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;184;-3848.81,1070.644;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;310;-3809.417,1262.384;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;369;-3655.809,509.1217;Inherit;False;Constant;_gustNoise;gustNoise;14;0;Create;True;0;0;0;False;0;False;0.05;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1470.087,-2215.231;Inherit;False;2835.458;1702.665;Colour;60;42;66;60;57;56;52;51;47;78;480;77;461;493;379;481;378;494;75;381;73;375;495;471;492;496;377;374;71;380;70;217;218;65;63;497;498;499;500;501;502;503;504;505;506;507;508;550;551;552;553;555;570;571;572;573;574;575;576;577;578;Colour;0.004857063,1,0,1;0;0
Node;AmplifyShaderEditor.SinOpNode;330;-3269.799,699.0146;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;368;-3434.809,524.1215;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-3675.417,1113.384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;-3156.379,695.6271;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;504;-1396.588,-814.1648;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;505;-1364.588,-620.1648;Inherit;False;Constant;_Float7;Float 7;19;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;503;-1422.588,-926.1651;Inherit;False;Property;_ColourNoiseLargeScale;ColourNoiseLargeScale;21;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;182;-3508.32,1042.211;Inherit;True;Property;_GustNoiseMap;GustNoiseMap;37;0;Create;True;0;0;0;False;0;False;-1;95228cb87bc1fcf4b8b99b626dcf102c;95228cb87bc1fcf4b8b99b626dcf102c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;502;-1135.588,-781.1648;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;-3189.917,1065.384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;506;-1156.709,-974.0392;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-3473.978,417.0614;Inherit;False;Property;_GustAmount;GustAmount;34;0;Create;True;0;0;0;False;0;False;0.5;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;-3040.799,701.077;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;307;-3173.417,837.6841;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;311;-3175.417,449.384;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;500;-953.5885,-859.1647;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1365.899,-1056.184;Inherit;False;Constant;_Tint_Tiling;Tint_Tiling;20;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-1415.9,-1260.184;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;171;-4057.969,-131.5948;Inherit;False;1500;509.5001;LeafNoise;13;304;294;305;149;136;130;147;117;119;145;583;584;586;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;303;-3044,585.577;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;501;-931.5884,-737.1647;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-2866.602,551.0644;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;583;-3942.319,285.9031;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-2911.025,865.0797;Inherit;False;Property;_WindBaseline;WindBaseline;32;0;Create;True;0;0;0;False;0;False;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;304;-3967.337,175.9713;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;499;-758.5883,-813.1648;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1395.763,-1354.44;Inherit;False;Property;_ColourNoiseSmallScale;ColourNoiseSmallScale;20;0;Create;True;0;0;0;False;0;False;0;0.681;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;105;-2982.858,989.1628;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1173.899,-1237.184;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;459;-4044.318,1683.24;Inherit;False;2229.809;1721.533;Emissive;36;569;568;567;566;417;418;419;200;420;208;458;209;457;456;455;454;565;564;563;445;444;439;432;433;426;435;436;442;429;437;430;424;441;423;440;422;Emmisive;0,0.5021453,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;479;-1370.939,1163.305;Inherit;False;1625.614;778.9801;LOD Fade;17;535;534;533;532;531;530;528;527;526;525;411;409;538;543;544;547;548;;0.5849056,0.5102917,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-3937.008,41.5755;Inherit;False;Property;_LeafBigNoiseScale;LeafBigNoiseScale;40;1;[Header];Create;True;1;LeafSway;0;0;False;0;False;1;0.58;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;584;-3731.319,230.9031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;56;-994.8996,-1170.184;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;57;-1025.762,-1312.44;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;104;-2796.674,979.7733;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;23;-3675.043,-902.1522;Inherit;False;1926.561;560.5865;Jitter;15;212;62;213;37;46;68;64;58;55;50;206;205;33;28;26;Jitter;1,0,0,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;214;-2781.512,1129.085;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;6.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-2614.583,793.3908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;498;-603.5883,-814.1648;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LODFadeNode;525;-1363.883,1431.281;Inherit;False;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-3570.902,160.977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;-838.7628,-1262.44;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotatorNode;103;-2570.594,1047.077;Inherit;False;3;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;2;FLOAT;3.19;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;422;-3820.006,2045.799;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;101;-2496.217,889.6932;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;578;-547.9069,-912.1231;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3643.385,-562.1201;Float;False;Property;_JitterFreq;JitterFreq;42;1;[Header];Create;True;1;LeafJitter;0;0;False;0;False;0;0.314;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-1005.823,-1722.327;Inherit;False;Property;_LeafNoiseColour;LeafNoiseColour;14;0;Create;True;0;0;0;False;0;False;0.07843138,0.02015968,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;66;-677.0627,-1264.939;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;577;-485.5064,-1251.423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;440;-3563.298,2332.813;Inherit;False;Constant;_Float4;Float 4;37;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-1009.043,-1544.865;Inherit;False;Property;_LeafBaseColour;LeafBaseColour;13;1;[Header];Create;True;1;Colour Tinting;0;0;False;0;False;0.07843138,0.02015968,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;507;-441.8385,-1473.494;Inherit;False;Property;_LeafNoiseLargeColour;LeafNoiseLargeColour;15;0;Create;True;0;0;0;False;0;False;0.07843138,0.02015968,0,0;0.5943396,0.1052387,0.06448025,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;441;-3539.298,2044.814;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2293.123,901.2636;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;213;-3349.077,-574.2509;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-3570.006,2254.8;Inherit;False;Constant;_Tiling;Tiling;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;117;-3593.414,-65.06544;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;305;-3435.719,166.084;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;145;-3256.822,180.5266;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;526;-1261.772,1255.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;576;-8.40616,-1315.123;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;553;-721.271,-2005.515;Inherit;False;Constant;_Float6;Float 6;46;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;538;-1122.56,1241.644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;99;-2131.289,927.0841;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;424;-3345.006,2070.8;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;508;-165.7796,-1455.984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;70;-1055.394,-2158.999;Inherit;True;Property;_LeafTex;LeafTex;1;1;[Header];Create;True;1;Leaves;0;0;False;0;False;-1;527828786a11abc4db01813fca9043f9;b8cb27406d407b3499cb6a85d06c44e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;430;-3390.298,2268.813;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;373;-2604.502,469.8654;Inherit;False;gustValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-648.5624,-1603.24;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-3162.936,-542.3002;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;33;-3177.078,-710.5203;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;586;-3280.319,25.90314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;437;-3737.298,1909.813;Inherit;False;Constant;_Float3;Float 3;37;0;Create;True;0;0;0;False;0;False;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-2200.979,1185.864;Inherit;False;Property;_TotalWindAmount;TotalWindAmount;30;1;[Header];Create;True;1;Main Wind;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;147;-3055.322,215.9265;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;552;-726.271,-2171.515;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;550;-1049.25,-1955.424;Inherit;True;Property;_TunkTex;TunkTex;7;1;[Header];Create;True;1;Trunk;0;0;False;0;False;-1;None;e95713565815fd04cac167370969c884;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;496;-20.08881,-1880.129;Inherit;False;Property;_FrostingHeight;FrostingHeight;47;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;377;-350.6857,-1259.393;Inherit;False;Property;_GustHighlight;GustHighlight;39;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;374;-522.2865,-1086.493;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;293;-1911.798,1079.777;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;380;-351.9857,-1074.794;Inherit;False;373;gustValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;497;111.6742,-1493.029;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;130;-2887.246,147.985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2980.527,-587.4203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;492;-62.97,-2123.653;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;205;-2815.448,-854.6243;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;551;-543.271,-2051.515;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-3001.445,42.98514;Inherit;False;Property;_LeafBigNoiseAmount;LeafBigNoiseAmount;41;0;Create;True;0;0;0;False;0;False;0.5;0.176;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;429;-3203.298,2141.813;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;442;-3459.298,1795.813;Inherit;False;Constant;_Float5;Float 5;37;0;Create;True;0;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;-1951.287,843.084;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;544;-977.5596,1275.644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;436;-3556.298,1894.813;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;543;-1188.56,1509.644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-2805.407,-650.3812;Inherit;True;Property;_Leaves_NoiseTexture2;LeafJitterMap;44;0;Create;False;0;0;0;False;0;False;-1;e0595e1df515fa64fa99e3017d4ace24;e0595e1df515fa64fa99e3017d4ace24;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;454;-3717.798,2920.447;Inherit;True;Property;_Emissive2Mask;Emissive2Mask;25;0;Create;True;1;Emissive;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;426;-3081.006,2132.801;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-2674.318,127.1265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;435;-3253.298,1880.813;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;495;182.9112,-2004.129;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1775.979,844.8641;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;206;-2645.448,-784.6243;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;73;226.2073,-1671.782;Inherit;False;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;548;-837.5596,1244.644;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;375;-337.6862,-991.5922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;152;-2451.851,690.3052;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;-112.787,-1170.994;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;200;-3719.584,2630.946;Inherit;True;Property;_EmissiveMask;EmissiveMask;23;0;Create;True;1;Emissive;0;0;False;0;False;-1;None;ab58ff5b1650ecb44bcafab1e462d1e3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;471;73.17218,-1773.063;Inherit;False;Property;_FrostingFalloff;FrostingFalloff;48;0;Create;True;1;Triplanar;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;528;-1081.883,1625.281;Inherit;False;Constant;_Float1;Float 1;35;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;547;-1050.56,1443.644;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;527;-1086.883,1750.281;Inherit;False;Constant;_Float2;Float 2;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;218;-213.7214,-718.5309;Inherit;False;Property;_TrunkBaseColour;TrunkBaseColour;17;0;Create;True;0;0;0;False;0;False;0.07843138,0.02015968,0,0;0.07843138,0.02015968,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;432;-2941.298,2120.813;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;217;-208.499,-900.8921;Inherit;False;Property;_TrunkNoiseColour;TrunkNoiseColour;18;0;Create;True;0;0;0;False;0;False;0.07843138,0.02015968,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;456;-3416.132,2826.801;Inherit;False;Property;_Emissive2Colour;Emissive2Colour;26;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;530;-843.8826,1496.281;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;167;-2323.851,660.3051;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-2478.52,121.6265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Compare;531;-645.7717,1249.281;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;419;-3194.918,2652.3;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;433;-2998.298,1902.813;Inherit;True;Property;_EmissivePulseMap;EmissivePulseMap;29;0;Create;True;0;0;0;False;0;False;-1;bdbe94d7623ec3940947b62544306f1c;bdbe94d7623ec3940947b62544306f1c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;378;40.61205,-1137.192;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;418;-3415.918,2537.3;Inherit;False;Property;_EmissiveColour;EmissiveColour;24;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.6212285,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;455;-3195.132,2941.801;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;-2480.91,-825.1333;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;566;-3637.677,3184.796;Inherit;True;Property;_TrunkEmissiveMask;TrunkEmissiveMask;28;0;Create;True;1;Emissive;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;148;-2393.851,785.3052;Inherit;False;Property;_Y_multiplier;Y_multiplier;33;0;Create;True;0;0;0;False;0;False;0.2;-0.5;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;75;387.643,-1466.859;Inherit;False;Property;_LeafFlatColourSwitch;LeafFlatColourSwitch;16;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;494;333.9112,-1920.129;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;493;481.9112,-1916.129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2706.617,-433.0301;Float;False;Property;_JitterAmount;JitterAmount;43;0;Create;True;0;0;0;False;0;False;0.5;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;567;-3115.011,3206.15;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;417;-3015.918,2604.3;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;457;-3016.132,2893.801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;481;473.7535,-2131.432;Inherit;False;Property;_FrostingColour;FrostingColour;45;1;[Header];Create;True;1;Frosting;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;568;-3336.011,3091.15;Inherit;False;Property;_TrunkEmissiveColour;TrunkEmissiveColour;27;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;533;-478.7717,1315.281;Inherit;False;Property;_LOD_FADE_CROSSFADE_in;LOD_FADE_CROSSFADE_in;51;0;Create;True;0;0;0;False;0;False;0;1;1;True;LOD_FADE_CROSSFADE;Toggle;2;Key0;Key1;Create;True;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;532;-652.8826,1523.281;Inherit;False;Property;_LOD_FADE_CROSSFADE_out;LOD_FADE_CROSSFADE_out;50;0;Create;True;0;0;0;False;0;False;0;1;1;True;LOD_FADE_CROSSFADE;Toggle;2;Key0;Key1;Create;True;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;169;-2337.929,112.5127;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;570;173.9941,-845.4252;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;379;625.6294,-1381.735;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-2313.8,-854.5013;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;439;-2654.298,1965.813;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-2117.989,707.7839;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;534;-358.7717,1525.281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;575;331.2945,-1027.424;Inherit;False;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;168;-2196.93,108.5128;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;461;720.5997,-1631.583;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;563;-2839.508,2391.772;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;409;-468.749,1689.529;Inherit;True;Property;_LOD_DitheringMap;LOD_DitheringMap;49;1;[Header];Create;True;1;LOD Crossfade;0;0;False;0;False;16d574e53541bba44a84052fa38778df;4199a601545ad164badaad1fe1733439;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;569;-2936.011,3158.15;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;-2173.172,-754.5133;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;444;-2534.298,1980.813;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;458;-2820.298,2711.713;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;212;-2382.077,-530.0507;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-2627.999,2449.215;Inherit;False;Constant;_Float9;Float 9;46;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;572;823.5282,-1158.757;Inherit;False;Constant;_Float10;Float 10;46;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;64;-2186.586,-638.0032;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;480;847.2405,-1465.914;Inherit;False;Property;_FrostingSwitch;FrostingSwitch;46;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;565;-2560.968,2547.936;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;555;-383.271,-2164.515;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;209;-3411.365,2726.882;Inherit;False;Property;_EmissiveAmount;EmissiveAmount;22;1;[Header];Create;True;1;Emissive;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;574;502.8947,-832.4233;Inherit;False;Property;_TrunkFlatColourSwitch;TrunkFlatColourSwitch;19;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;535;-197.8829,1589.281;Inherit;False;2;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-1183.351,-251.2843;Inherit;False;Property;_LeafNormalAmount;LeafNormalAmount;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;561;-1189.049,-58.71536;Inherit;False;Property;_TrunkNormalAmount;TrunkNormalAmount;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;187;-1405.013,292.136;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformDirectionNode;239;-2075.393,155.1822;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;571;818.5282,-1324.757;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;445;-2389.298,2007.813;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-1027.013,464.1361;Inherit;False;Property;_LeafSmoothness;LeafSmoothness;5;0;Create;True;0;0;0;False;0;False;0.5;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-1041.513,291.636;Inherit;False;Property;_TrunkMetallic;TrunkMetallic;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;573;1041.428,-1207.557;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1975.886,-607.7291;Inherit;False;Jitter;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;201;-1831.163,198.8579;Inherit;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;562;-917.9802,-78.95667;Inherit;True;Property;_TrunkNormalMap;TrunkNormalMap;8;0;Create;True;0;0;0;False;0;False;-1;31a826c4d933ab64f824a0f14646243d;84675b1e4f41ea04e9a7804abad191ce;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-251.0134,-2164.854;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;559;-847.1731,-464.6424;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;558;-635.664,-407.2;Inherit;False;Constant;_Float8;Float 8;46;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-2270.364,2706.982;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1038.013,594.136;Inherit;False;Property;_TrunkSmoothness;TrunkSmoothness;11;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;189;-1211.013,306.136;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;411;36.25101,1597.529;Inherit;False;LOD_Dithering;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1052.013,155.136;Inherit;False;Property;_LeafMetallic;LeafMetallic;4;0;Create;True;0;0;0;False;0;False;0.13;0.099;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-912.2821,-271.5256;Inherit;True;Property;_LeafNormalMap;LeafNormalMap;2;0;Create;True;0;0;0;False;0;False;-1;31a826c4d933ab64f824a0f14646243d;5b08078d6e183ad4d94fdb22c38d7da9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;579;-837.1299,910.3189;Inherit;False;Constant;_Float11;Float 11;46;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-313.867,445.3131;Inherit;False;77;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;580;-842.1299,744.319;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;412;-331.2007,522.6675;Inherit;False;411;LOD_Dithering;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;557;-496.6338,-227.4788;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;420;-2080.177,2732.699;Inherit;False;Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-371.1609,642.3276;Inherit;False;68;Jitter;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;190;-743.0126,562.136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-369.1609,729.3275;Inherit;False;201;Wind;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;582;-1198.813,939.0795;Inherit;True;Property;_TrunkAmbientOcclusion;TrunkAmbientOcclusion;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;286;-1198.322,738.4786;Inherit;True;Property;_LeafAmbientOcclusion;LeafAmbientOcclusion;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;191;-744.0126,443.1361;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;1145.75,-1531.387;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;188;-745.0126,134.136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;195;-738.5123,273.636;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-172.867,14.31301;Inherit;False;78;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-134.2007,457.6676;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-537.0126,488.1361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-489.0125,245.136;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;560;-262.5151,-17.83606;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-149.1609,689.3275;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;421;-200.4588,209.9659;Inherit;False;420;Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;581;-659.1299,864.319;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;41.30931,209.989;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SyntyStudios/VegitationShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.3;True;True;0;True;TransparentCutout;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;364;0;102;0
WireConnection;362;0;549;0
WireConnection;363;0;364;0
WireConnection;372;0;179;0
WireConnection;361;0;362;0
WireConnection;361;2;363;0
WireConnection;346;0;361;0
WireConnection;371;0;372;0
WireConnection;282;0;346;0
WireConnection;282;1;283;0
WireConnection;178;0;106;0
WireConnection;178;1;371;0
WireConnection;332;0;282;0
WireConnection;332;1;178;0
WireConnection;310;0;309;0
WireConnection;330;0;332;0
WireConnection;368;0;362;0
WireConnection;368;1;369;0
WireConnection;308;0;184;2
WireConnection;308;1;310;0
WireConnection;367;0;368;0
WireConnection;367;1;330;0
WireConnection;182;1;308;0
WireConnection;502;0;504;0
WireConnection;502;1;505;0
WireConnection;306;0;182;1
WireConnection;506;0;503;0
WireConnection;299;0;367;0
WireConnection;307;0;306;0
WireConnection;311;0;176;0
WireConnection;500;0;502;0
WireConnection;500;1;506;0
WireConnection;303;0;299;0
WireConnection;501;0;502;0
WireConnection;177;0;311;0
WireConnection;177;1;303;0
WireConnection;177;2;307;0
WireConnection;304;0;549;0
WireConnection;499;0;500;0
WireConnection;499;1;501;0
WireConnection;51;0;47;0
WireConnection;51;1;42;0
WireConnection;584;0;304;0
WireConnection;584;1;583;0
WireConnection;56;0;51;0
WireConnection;57;0;51;0
WireConnection;57;1;52;0
WireConnection;104;0;105;1
WireConnection;214;0;102;0
WireConnection;175;0;177;0
WireConnection;175;1;173;0
WireConnection;498;0;499;0
WireConnection;294;0;119;0
WireConnection;294;1;584;0
WireConnection;60;0;57;0
WireConnection;60;1;56;0
WireConnection;103;2;214;0
WireConnection;101;0;175;0
WireConnection;101;2;104;0
WireConnection;578;0;498;0
WireConnection;66;0;60;0
WireConnection;577;0;578;0
WireConnection;441;0;422;1
WireConnection;441;2;422;3
WireConnection;97;0;103;0
WireConnection;97;1;101;0
WireConnection;213;0;26;0
WireConnection;117;0;304;0
WireConnection;305;0;294;0
WireConnection;526;0;525;1
WireConnection;576;0;577;0
WireConnection;538;0;526;0
WireConnection;99;0;97;0
WireConnection;424;0;441;0
WireConnection;424;1;423;0
WireConnection;508;0;507;0
WireConnection;430;0;440;0
WireConnection;373;0;177;0
WireConnection;71;0;65;0
WireConnection;71;1;63;0
WireConnection;71;2;66;0
WireConnection;28;0;213;0
WireConnection;586;0;117;0
WireConnection;586;1;305;0
WireConnection;147;0;145;2
WireConnection;293;0;143;0
WireConnection;497;0;71;0
WireConnection;497;1;508;0
WireConnection;497;2;576;0
WireConnection;130;0;586;0
WireConnection;130;2;147;0
WireConnection;37;0;33;1
WireConnection;37;1;28;0
WireConnection;551;0;552;3
WireConnection;551;1;553;0
WireConnection;551;2;70;0
WireConnection;551;3;550;0
WireConnection;429;0;424;0
WireConnection;429;1;430;0
WireConnection;100;0;99;0
WireConnection;100;2;99;1
WireConnection;544;0;538;0
WireConnection;436;0;437;0
WireConnection;543;0;525;1
WireConnection;46;1;37;0
WireConnection;426;0;429;0
WireConnection;149;0;136;0
WireConnection;149;1;130;0
WireConnection;435;0;442;0
WireConnection;435;1;436;0
WireConnection;495;0;492;2
WireConnection;495;1;496;0
WireConnection;142;0;100;0
WireConnection;142;1;293;0
WireConnection;206;0;205;2
WireConnection;73;0;551;0
WireConnection;73;1;497;0
WireConnection;548;0;544;0
WireConnection;375;0;374;2
WireConnection;152;0;101;0
WireConnection;381;0;377;0
WireConnection;381;1;380;0
WireConnection;547;0;543;0
WireConnection;432;0;426;0
WireConnection;530;0;525;1
WireConnection;530;1;528;0
WireConnection;530;2;547;0
WireConnection;530;3;527;0
WireConnection;167;0;152;0
WireConnection;146;0;149;0
WireConnection;146;1;142;0
WireConnection;531;0;525;1
WireConnection;531;1;528;0
WireConnection;531;2;548;0
WireConnection;531;3;527;0
WireConnection;419;0;200;1
WireConnection;433;1;435;0
WireConnection;378;0;381;0
WireConnection;378;2;375;0
WireConnection;455;0;454;1
WireConnection;50;0;46;1
WireConnection;50;2;206;0
WireConnection;75;0;73;0
WireConnection;75;1;497;0
WireConnection;494;0;495;0
WireConnection;494;1;471;0
WireConnection;493;0;494;0
WireConnection;567;0;566;1
WireConnection;417;0;418;0
WireConnection;417;2;419;0
WireConnection;457;0;456;0
WireConnection;457;2;455;0
WireConnection;533;1;531;0
WireConnection;533;0;527;0
WireConnection;532;1;530;0
WireConnection;532;0;527;0
WireConnection;169;0;146;0
WireConnection;570;0;217;0
WireConnection;570;1;218;0
WireConnection;570;2;66;0
WireConnection;379;0;75;0
WireConnection;379;1;378;0
WireConnection;55;0;50;0
WireConnection;439;0;433;1
WireConnection;439;1;432;0
WireConnection;98;0;167;0
WireConnection;98;1;148;0
WireConnection;98;2;293;0
WireConnection;534;0;533;0
WireConnection;534;1;532;0
WireConnection;575;0;551;0
WireConnection;575;1;570;0
WireConnection;168;0;169;0
WireConnection;168;1;98;0
WireConnection;168;2;169;2
WireConnection;461;0;379;0
WireConnection;461;1;481;0
WireConnection;461;2;493;0
WireConnection;569;0;568;0
WireConnection;569;2;567;0
WireConnection;58;0;55;0
WireConnection;444;0;439;0
WireConnection;458;0;417;0
WireConnection;458;1;457;0
WireConnection;212;0;62;0
WireConnection;64;1;58;0
WireConnection;64;0;212;0
WireConnection;480;0;379;0
WireConnection;480;1;461;0
WireConnection;565;0;563;3
WireConnection;565;1;564;0
WireConnection;565;2;458;0
WireConnection;565;3;569;0
WireConnection;555;0;551;0
WireConnection;574;0;575;0
WireConnection;574;1;570;0
WireConnection;535;0;534;0
WireConnection;535;1;409;0
WireConnection;239;0;168;0
WireConnection;445;0;444;0
WireConnection;573;0;571;3
WireConnection;573;1;572;0
WireConnection;573;2;480;0
WireConnection;573;3;574;0
WireConnection;68;0;64;0
WireConnection;201;0;239;0
WireConnection;562;5;561;0
WireConnection;77;0;555;3
WireConnection;208;0;565;0
WireConnection;208;1;209;0
WireConnection;208;2;445;0
WireConnection;189;0;187;3
WireConnection;411;0;535;0
WireConnection;81;5;211;0
WireConnection;557;0;559;3
WireConnection;557;1;558;0
WireConnection;557;2;81;0
WireConnection;557;3;562;0
WireConnection;420;0;208;0
WireConnection;190;0;192;0
WireConnection;190;2;187;3
WireConnection;191;0;185;0
WireConnection;191;2;189;0
WireConnection;78;0;573;0
WireConnection;188;0;186;0
WireConnection;188;2;189;0
WireConnection;195;0;194;0
WireConnection;195;2;187;3
WireConnection;413;0;199;0
WireConnection;413;1;412;0
WireConnection;193;0;191;0
WireConnection;193;1;190;0
WireConnection;196;0;188;0
WireConnection;196;1;195;0
WireConnection;560;0;557;0
WireConnection;204;0;202;0
WireConnection;204;1;203;0
WireConnection;581;0;580;3
WireConnection;581;1;579;0
WireConnection;581;2;286;0
WireConnection;581;3;582;0
WireConnection;0;0;198;0
WireConnection;0;1;560;0
WireConnection;0;2;421;0
WireConnection;0;3;196;0
WireConnection;0;4;193;0
WireConnection;0;5;581;0
WireConnection;0;10;413;0
WireConnection;0;11;204;0
ASEEND*/
//CHKSM=BCC5387CFE33A006BD869B60C66FF4394CEA952B