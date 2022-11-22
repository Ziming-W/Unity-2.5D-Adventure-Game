// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/WaterShader"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_OpacityFalloff("Opacity Falloff", Float) = 1
		_OpacityMin("Opacity Min", Range( 0 , 1)) = 0.5
		_Specular("Specular", Range( 0 , 1)) = 0.141
		_Smoothness("Smoothness", Float) = 2
		_ReflectionPower("Reflection Power", Range( 0 , 1)) = 0.346
		[Header(Colour)]_ShallowColour("Shallow Colour", Color) = (0.9607843,0.7882353,0.5764706,0)
		_DeepColour("Deep Colour", Color) = (0.04705882,0.3098039,0.1960784,0)
		_VeryDeepColour("Very Deep Colour", Color) = (0.05959199,0.08247829,0.191,0)
		_ShallowFalloff("ShallowFalloff", Float) = 0.4
		_OverallFalloff("OverallFalloff", Range( 0 , 10)) = 0.76
		_Depth("Depth", Float) = 0.28
		[Header(Caustics)]_CausticColour("Caustic Colour", Color) = (0.496,0.496,0.496,0)
		_CausticScale("Caustic Scale", Float) = 1
		_CausticDepthFade("CausticDepthFade", Float) = 0.05
		_CausticSpeed("Caustic Speed", Float) = 1
		[Header(Refraction)]_DistortionMap("Distortion Map", 2D) = "bump" {}
		_DistortionTiling("Distortion Tiling", Float) = 0.33
		_Distortion("Distortion", Range( 0 , 1)) = 0.292
		_DistortionSpeed("Distortion Speed", Range( 0 , 1)) = 0.236
		[Header(Foam)]_FoamColor("Foam Color", Color) = (0.5215687,0.8980392,0.8470588,0)
		_FoamSmoothness("Foam Smoothness", Float) = 0
		_FoamShoreline("Foam Shoreline", Range( 0 , 1)) = 0
		_FoamSpread("Foam Spread", Float) = 0.019
		_FoamFalloff("Foam Falloff", Float) = -56
		_Foam_Texture("Foam_Texture", 2D) = "white" {}
		[Header(Waves)]_RipplesNormal("Ripples Normal", 2D) = "white" {}
		_NormalTiling("Normal Tiling", Float) = 0.2
		_RipplesNormal2("Ripples Normal 2", 2D) = "bump" {}
		_NormalTiling2("Normal Tiling 2", Float) = 0.2
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0.669
		_RippleSpeed("Ripple Speed", Range( 0 , 1)) = 0.092
		_WaveDirection("Wave Direction", Range( 0 , 6.25)) = 0
		_WaveWavelength("Wave Wavelength", Float) = -0.18
		_WaveAmplitude("Wave Amplitude", Range( 0 , 1)) = 0.958
		_WaveSpeed("Wave Speed", Range( 0 , 1)) = 0.303
		_WaveFoamOpacity("Wave Foam Opacity", Range( 0 , 1)) = 0.5
		_WaveMask("Wave Mask", 2D) = "white" {}
		_FoamMask("Foam Mask", 2D) = "white" {}
		_WaveNoiseAmount("Wave Noise Amount", Float) = 0.1
		_WaveNoiseScale("Wave Noise Scale", Float) = 1
		[Header(Glow)]_DepthGlowColour("Depth Glow Colour", Color) = (0,0,0,0)
		_GlowDepth("Glow Depth", Float) = 0.1
		_GlowFalloff("Glow Falloff", Range( 0 , 1)) = 0.1
		_FoamEmitColour("Foam Emit Colour", Color) = (0,0,0,0)
		_FoamGlowMultiplier("Foam Glow Multiplier", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _WaveMask;
		uniform float _WaveSpeed;
		uniform half _WaveNoiseScale;
		uniform half _WaveNoiseAmount;
		uniform half _WaveDirection;
		uniform half _WaveWavelength;
		uniform float _WaveAmplitude;
		uniform sampler2D _RipplesNormal;
		uniform float _RippleSpeed;
		uniform half _NormalTiling;
		uniform sampler2D _RipplesNormal2;
		uniform half _NormalTiling2;
		uniform float _NormalScale;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _OverallFalloff;
		uniform half _ShallowFalloff;
		uniform float4 _ShallowColour;
		uniform float4 _DeepColour;
		uniform float4 _VeryDeepColour;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _DistortionMap;
		uniform float _DistortionSpeed;
		uniform half _DistortionTiling;
		uniform float _Distortion;
		uniform float4 _FoamColor;
		uniform half _FoamSpread;
		uniform float _FoamShoreline;
		uniform float _FoamFalloff;
		uniform sampler2D _Foam_Texture;
		uniform sampler2D _FoamMask;
		uniform half _WaveFoamOpacity;
		uniform half4 _DepthGlowColour;
		uniform half _GlowDepth;
		uniform half _GlowFalloff;
		uniform half _FoamGlowMultiplier;
		uniform half4 _FoamEmitColour;
		uniform half _CausticScale;
		uniform half _CausticSpeed;
		uniform half4 _CausticColour;
		uniform half _CausticDepthFade;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform float _FoamSmoothness;
		uniform float _ReflectionPower;
		uniform half _OpacityFalloff;
		uniform half _OpacityMin;
		uniform float _Opacity;


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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
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


		float2 voronoihash110( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi110( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -2; j <= 2; j++ )
			{
				for ( int i = -2; i <= 2; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash110( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		half2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		half3 InvertDepthDir72_g4( half3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half2 temp_cast_0 = (_WaveSpeed).xx;
			half mulTime307 = _Time.y * 0.001;
			half2 temp_cast_1 = (mulTime307).xx;
			float2 uv_TexCoord312 = v.texcoord.xy + temp_cast_1;
			half simplePerlin2D320 = snoise( uv_TexCoord312*_WaveNoiseScale );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			half2 appendResult59 = (half2(ase_worldPos.x , ase_worldPos.z));
			float cos302 = cos( _WaveDirection );
			float sin302 = sin( _WaveDirection );
			half2 rotator302 = mul( ( ( simplePerlin2D320 * _WaveNoiseAmount ) + appendResult59 ) - float2( 0,0 ) , float2x2( cos302 , -sin302 , sin302 , cos302 )) + float2( 0,0 );
			half2 temp_output_60_0 = ( rotator302 * _WaveWavelength );
			half2 panner127 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_60_0);
			half4 temp_cast_2 = 0;
			half4 lerpResult149 = lerp( tex2Dlod( _WaveMask, float4( panner127, 0, 1.0) ) , temp_cast_2 , ( 1.0 - _WaveAmplitude ));
			half4 waveCrestVertoffset153 = lerpResult149;
			half grayscale298 = Luminance(waveCrestVertoffset153.rgb);
			half4 appendResult301 = (half4(0.0 , grayscale298 , 0.0 , 0.0));
			v.vertex.xyz += appendResult301.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			half2 temp_cast_0 = (_RippleSpeed).xx;
			float3 ase_worldPos = i.worldPos;
			half2 appendResult93 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 panner119 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult93 * _NormalTiling ));
			half2 temp_cast_2 = (-_RippleSpeed).xx;
			half2 panner118 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult93 * _NormalTiling2 ));
			half3 waveNormalMaps157 = UnpackScaleNormal( half4( BlendNormals( tex2D( _RipplesNormal, panner119 ).rgb , UnpackNormal( tex2D( _RipplesNormal2, panner118 ) ) ) , 0.0 ), _NormalScale );
			o.Normal = waveNormalMaps157;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth170 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth170 = abs( ( screenDepth170 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			half temp_output_99_0 = pow( distanceDepth170 , _OverallFalloff );
			half temp_output_235_0 = ( temp_output_99_0 + _ShallowFalloff );
			half4 lerpResult115 = lerp( _ShallowColour , _DeepColour , temp_output_235_0);
			half4 lerpResult177 = lerp( _DeepColour , _VeryDeepColour , saturate( ( temp_output_99_0 - 1.0 ) ));
			half4 temp_output_175_0 = ( temp_output_235_0 < 1.0 ? lerpResult115 : lerpResult177 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			half2 temp_cast_4 = (_DistortionSpeed).xx;
			half2 appendResult19 = (half2(ase_worldPos.x , ase_worldPos.z));
			half2 panner45 = ( 1.0 * _Time.y * temp_cast_4 + ( appendResult19 * _DistortionTiling ));
			float4 screenColor100 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( (ase_grabScreenPosNorm).xy + (( UnpackNormal( tex2D( _DistortionMap, panner45 ) ) * _Distortion )).xy ));
			half4 Refraction107 = screenColor100;
			half4 lerpResult121 = lerp( temp_output_175_0 , Refraction107 , temp_output_175_0);
			half2 temp_output_14_0 = (ase_worldPos).xz;
			half2 panner166 = ( 0.1 * _Time.y * float2( 1,0 ) + temp_output_14_0);
			half simplePerlin3D44 = snoise( half3( ( panner166 * 1.5 ) ,  0.0 ) );
			half2 panner22 = ( 0.1 * _Time.y * float2( -1,0 ) + temp_output_14_0);
			half simplePerlin3D43 = snoise( half3( ( panner22 * 3 ) ,  0.0 ) );
			half2 panner37 = ( 1.0 * _Time.y * float2( -0.01,0.01 ) + i.uv_texcoord);
			half foam62 = ( saturate( pow( ( distanceDepth170 + _FoamShoreline ) , _FoamFalloff ) ) * tex2D( _Foam_Texture, panner37 ).r );
			half4 foamNoise114 = saturate( ( ( _FoamColor * ( 1.0 - step( ( simplePerlin3D44 + simplePerlin3D43 ) , ( distanceDepth170 * _FoamSpread ) ) ) ) + ( _FoamColor * foam62 ) ) );
			half4 lerpResult141 = lerp( lerpResult121 , float4(1,1,1,0) , foamNoise114);
			half4 temp_cast_7 = 0;
			half4 temp_cast_8 = 0;
			half2 temp_cast_9 = (_WaveSpeed).xx;
			half mulTime307 = _Time.y * 0.001;
			half2 temp_cast_10 = (mulTime307).xx;
			float2 uv_TexCoord312 = i.uv_texcoord + temp_cast_10;
			half simplePerlin2D320 = snoise( uv_TexCoord312*_WaveNoiseScale );
			half2 appendResult59 = (half2(ase_worldPos.x , ase_worldPos.z));
			float cos302 = cos( _WaveDirection );
			float sin302 = sin( _WaveDirection );
			half2 rotator302 = mul( ( ( simplePerlin2D320 * _WaveNoiseAmount ) + appendResult59 ) - float2( 0,0 ) , float2x2( cos302 , -sin302 , sin302 , cos302 )) + float2( 0,0 );
			half2 temp_output_60_0 = ( rotator302 * _WaveWavelength );
			half2 panner70 = ( 1.0 * _Time.y * temp_cast_9 + temp_output_60_0);
			half2 temp_output_13_0 = (ase_worldPos).xz;
			half2 panner20 = ( 0.1 * _Time.y * float2( 1,0 ) + temp_output_13_0);
			half simplePerlin3D46 = snoise( half3( ( panner20 * 2 ) ,  0.0 ) );
			half2 panner27 = ( 0.1 * _Time.y * float2( -1,0 ) + temp_output_13_0);
			half simplePerlin3D41 = snoise( half3( ( panner27 * 0.8 ) ,  0.0 ) );
			half waveCrestNoise0277 = step( ( simplePerlin3D46 + simplePerlin3D41 ) , 0.0 );
			half4 lerpResult97 = lerp( temp_cast_8 , tex2D( _FoamMask, panner70 ) , waveCrestNoise0277);
			half2 temp_output_25_0 = (ase_worldPos).xz;
			half2 panner34 = ( 0.1 * _Time.y * float2( 1,0 ) + temp_output_25_0);
			half simplePerlin3D58 = snoise( half3( ( panner34 * 0.05 ) ,  0.0 ) );
			half2 panner28 = ( 0.1 * _Time.y * float2( -1,0 ) + temp_output_25_0);
			half simplePerlin3D56 = snoise( half3( ( panner28 * 0.08 ) ,  0.0 ) );
			half waveCrestNoise0182 = step( ( simplePerlin3D58 + simplePerlin3D56 ) , 0.0 );
			half4 lerpResult109 = lerp( temp_cast_7 , lerpResult97 , waveCrestNoise0182);
			half4 lerpResult116 = lerp( float4( 0,0,0,0 ) , lerpResult109 , _WaveFoamOpacity);
			half4 waveCrestColour131 = lerpResult116;
			half4 waterAlbedo155 = ( lerpResult141 + waveCrestColour131 );
			o.Albedo = waterAlbedo155.rgb;
			float screenDepth333 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth333 = abs( ( screenDepth333 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _GlowDepth ) );
			half4 lerpResult337 = lerp( _DepthGlowColour , float4( 0,0,0,0 ) , ( 1.0 - pow( distanceDepth333 , _GlowFalloff ) ));
			half4 lerpResult329 = lerp( _FoamEmitColour , float4( 0,0,0,0 ) , ( 1.0 - foamNoise114 ));
			half mulTime90 = _Time.y * _CausticSpeed;
			half time110 = mulTime90;
			half2 voronoiSmoothId0 = 0;
			half2 temp_output_73_0_g4 = ase_screenPosNorm.xy;
			half2 UV22_g5 = half4( temp_output_73_0_g4, 0.0 , 0.0 ).xy;
			half2 localUnStereo22_g5 = UnStereo( UV22_g5 );
			half2 break64_g4 = localUnStereo22_g5;
			half clampDepth69_g4 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, half4( temp_output_73_0_g4, 0.0 , 0.0 ).xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g4 = ( 1.0 - clampDepth69_g4 );
			#else
				float staticSwitch38_g4 = clampDepth69_g4;
			#endif
			half3 appendResult39_g4 = (half3(break64_g4.x , break64_g4.y , staticSwitch38_g4));
			half4 appendResult42_g4 = (half4((appendResult39_g4*2.0 + -1.0) , 1.0));
			half4 temp_output_43_0_g4 = mul( unity_CameraInvProjection, appendResult42_g4 );
			half3 In72_g4 = ( (temp_output_43_0_g4).xyz / (temp_output_43_0_g4).w );
			half3 localInvertDepthDir72_g4 = InvertDepthDir72_g4( In72_g4 );
			half4 appendResult49_g4 = (half4(localInvertDepthDir72_g4 , 1.0));
			float2 coords110 = (mul( unity_CameraToWorld, appendResult49_g4 )).xz * _CausticScale;
			float2 id110 = 0;
			float2 uv110 = 0;
			float voroi110 = voronoi110( coords110, time110, id110, uv110, 0, voronoiSmoothId0 );
			half smoothstepResult122 = smoothstep( 0.0 , 1.0 , voroi110);
			float screenDepth237 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth237 = abs( ( screenDepth237 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _CausticDepthFade ) );
			half4 Caustics152 = ( saturate( smoothstepResult122 ) * _CausticColour * ( 1.0 - saturate( distanceDepth237 ) ) );
			o.Emission = ( lerpResult337 + ( _FoamGlowMultiplier * lerpResult329 ) + Caustics152 ).rgb;
			half lerpResult147 = lerp( _Specular , 0.0 , foam62);
			half specular154 = lerpResult147;
			half3 temp_cast_21 = (specular154).xxx;
			o.Specular = temp_cast_21;
			half lerpResult132 = lerp( _Smoothness , _FoamSmoothness , foam62);
			half smoothness156 = ( lerpResult132 * _ReflectionPower );
			o.Smoothness = smoothness156;
			float screenDepth234 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth234 = abs( ( screenDepth234 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			half waterOpacity218 = ( (_OpacityMin + (saturate( ( distanceDepth234 / _OpacityFalloff ) ) - 0.0) * (1.0 - _OpacityMin) / (1.0 - 0.0)) * _Opacity );
			o.Alpha = waterOpacity218;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
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
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
-3426;2;2923;1371;2299.098;588.6959;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;35;-2275.503,1436.048;Inherit;False;3021.961;1379.129;Comment;32;153;149;137;136;135;131;127;116;109;105;97;96;89;85;83;70;63;60;59;54;49;302;303;304;307;308;312;316;320;322;323;324;WavesColour+Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;65;-4224.18,-361.3934;Inherit;False;1231.201;672.2004;Water Depth;12;170;115;176;101;108;111;235;236;179;99;84;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-6626.414,455.986;Inherit;False;2598.697;932.0704;foamNoise;20;43;44;164;30;166;22;14;9;29;73;75;64;50;51;79;80;71;114;106;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-2228.47,1675.124;Inherit;False;Constant;_waveNoiseOffset;waveNoiseOffset;39;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-4023.742,2208.384;Inherit;False;1681.965;569.5239;Comment;11;77;61;57;46;41;36;31;27;20;13;10;WaveNoise02;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-3799.968,407.3676;Inherit;False;915.4021;475.1005;Foam;9;55;47;39;38;37;26;24;23;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;11;-4662.681,-2200.141;Inherit;False;2526.922;883.8828;Refraction;15;107;100;87;72;69;68;66;53;52;45;33;32;21;19;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-4015.208,1497.28;Inherit;False;1674.172;674.7285;Comment;11;82;74;67;58;56;48;42;34;28;25;15;WaveNoise01;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-3990.818,2446.165;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;307;-2215.47,1786.124;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;9;-6556.702,971.6641;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;78;-4162.374,17.06741;Float;False;Property;_Depth;Depth;11;0;Create;True;0;0;0;False;0;False;0.28;4.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;312;-2011.47,1724.124;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-3972.986,1766.486;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DepthFade;170;-3888.993,-13.53784;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3777.567,469.8686;Float;False;Property;_FoamShoreline;Foam Shoreline;22;0;Create;True;0;0;0;False;0;False;0;0.94;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;14;-6325.447,971.9692;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;323;-2027.47,1853.124;Inherit;False;Property;_WaveNoiseScale;Wave Noise Scale;40;0;Create;True;0;0;0;False;0;False;1;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;13;-3759.563,2446.47;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-4550.332,-2037.595;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;320;-1785.47,1788.124;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;22;-6115.146,1121.009;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;20;-3551.085,2274.944;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-3549.263,2595.509;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4250.544,-1861.494;Inherit;False;Property;_DistortionTiling;Distortion Tiling;17;0;Create;True;0;0;0;False;0;False;0.33;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;25;-3716.405,1782.376;Inherit;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-4230.121,-2036.668;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3770.768,713.8698;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-3775.566,554.4685;Float;False;Property;_FoamFalloff;Foam Falloff;24;0;Create;True;0;0;0;False;0;False;-56;-56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-3471.365,451.868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;49;-2083.097,2211.906;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;166;-6116.969,800.4429;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;316;-1830.47,1904.124;Inherit;False;Property;_WaveNoiseAmount;Wave Noise Amount;39;0;Create;True;0;0;0;False;0;False;0.1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;34;-3507.927,1610.85;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleNode;31;-3326.583,2281.775;Inherit;False;2;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;-1592.47,1843.124;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;36;-3335.135,2590.119;Inherit;False;0.8;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-4033.073,-1958.964;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-4200.212,-1658.344;Float;False;Property;_DistortionSpeed;Distortion Speed;19;0;Create;True;0;0;0;False;0;False;0.236;0.073;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-1758.142,2070.838;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleNode;30;-5901.019,1115.619;Inherit;False;3;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleNode;164;-5892.467,807.274;Inherit;False;1.5;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;28;-3506.104,1931.415;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;37;-3504.566,717.1693;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;38;-3322.466,451.9684;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-5658.734,615.3004;Inherit;False;Property;_FoamSpread;Foam Spread;23;0;Create;True;0;0;0;False;0;False;0.019;2.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;44;-5717.427,792.6299;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-3166.865,452.5684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;42;-3291.976,1926.025;Inherit;False;0.08;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-3145.134,2570.119;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;43;-5711.02,1095.619;Inherit;True;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-3298.166,682.169;Inherit;True;Property;_Foam_Texture;Foam_Texture;25;0;Create;True;0;0;0;False;0;False;-1;953aee88aa8b49347a6abd3be0f0eb54;729fd1c6753e02647915f7e70c13bfd9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-3151.542,2267.131;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-1781.093,2192.075;Inherit;False;Property;_WaveDirection;Wave Direction;32;0;Create;True;0;0;0;False;0;False;0;0;0;6.25;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;45;-3816.269,-1801.945;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;324;-1619.77,2057.724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleNode;48;-3283.424,1617.681;Inherit;False;0.05;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;56;-3101.977,1906.025;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-3561.771,-1877.115;Inherit;True;Property;_DistortionMap;Distortion Map;16;1;[Header];Create;True;1;Refraction;0;0;False;0;False;-1;edddba054057d7c49b0669dc00b76644;170efe27af94aa4419889e36f1001bda;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-2852.687,2413.885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3604.534,-1543.365;Float;False;Property;_Distortion;Distortion;18;0;Create;True;0;0;0;False;0;False;0.292;0.139;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;302;-1482.093,2084.075;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1523.664,2299.913;Inherit;False;Property;_WaveWavelength;Wave Wavelength;33;0;Create;True;0;0;0;False;0;False;-0.18;-0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-3020.865,452.9688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-5399.079,962.855;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;58;-3108.384,1603.037;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-5395.875,621.2463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;68;-3197.912,-1842.635;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-1345.888,2389.438;Float;False;Property;_WaveSpeed;Wave Speed;35;0;Create;True;0;0;0;False;0;False;0.303;0.094;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2847.634,453.3721;Inherit;False;foam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;61;-2698,2400.026;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2828.424,1757.772;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-3192.125,-1603.63;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;64;-5218.126,800.2936;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1232.394,2202.442;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-3925.55,114.8916;Float;False;Property;_OverallFalloff;OverallFalloff;10;0;Create;True;0;0;0;False;0;False;0.76;0.45;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-5247.173,1028.769;Float;False;Property;_FoamColor;Foam Color;20;1;[Header];Create;True;1;Foam;0;0;False;0;False;0.5215687,0.8980392,0.8470588,0;0.5199804,0.8962264,0.8460602,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;72;-2999.031,-1605.829;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;74;-2673.558,1760.037;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-5016.305,1163.625;Inherit;False;62;foam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;-4470.706,-1278.627;Inherit;False;1925.338;788.0121;WaterMovement;15;145;143;129;120;119;118;104;103;93;92;91;81;211;212;151;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;99;-3612.844,2.55405;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-5067.238,885.2521;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;70;-1038.966,2167.406;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;86;-4402.796,-2850.77;Inherit;False;1784.409;617.0061;Caustics;15;152;150;139;134;122;110;90;167;183;237;238;239;241;210;95;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;69;-2942.232,-1825.728;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-2557.104,2406.612;Inherit;False;waveCrestNoise02;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-3555.924,-82.34265;Inherit;False;Property;_ShallowFalloff;ShallowFalloff;9;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-4236.945,-2554.691;Inherit;False;Property;_CausticSpeed;Caustic Speed;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;83;-537.3453,1717.519;Inherit;False;Constant;_Int2;Int 2;21;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;95;-4376.003,-2784.129;Inherit;True;Reconstruct World Position From Depth 2;-1;;4;77f0ddcb9389679448ffee807314bb3a;0;1;73;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;179;-3355.729,200.4629;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;81;-4389.266,-1087.674;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;85;-996.4259,1845.485;Inherit;True;Property;_FoamMask;Foam Mask;38;0;Create;True;0;0;0;False;0;False;-1;6bfe966529c67c6459070998a6bffc49;77c465e84959d4b40b1d80c93f73a186;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-4830.104,921.4755;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-2713.826,-1753.627;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-792.4869,2047.841;Inherit;False;77;waveCrestNoise02;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-2541.465,1777.057;Inherit;False;waveCrestNoise01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-4834.547,1052.871;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-4442.452,-863.2895;Float;False;Property;_RippleSpeed;Ripple Speed;31;0;Create;True;0;0;0;False;0;False;0.092;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-297.9904,2028.288;Inherit;False;82;waveCrestNoise01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;90;-4023.454,-2572.111;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;167;-4014.769,-2745.871;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-4026.794,-2436.425;Inherit;False;Property;_CausticScale;Caustic Scale;13;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;176;-3406.729,7.462919;Float;False;Property;_VeryDeepColour;Very Deep Colour;8;0;Create;True;0;0;0;False;0;False;0.05959199,0.08247829,0.191,0;0.01176471,0.172549,0.2745098,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;108;-3755.145,-321.7485;Float;False;Property;_ShallowColour;Shallow Colour;6;1;[Header];Create;True;1;Colour;0;0;False;0;False;0.9607843,0.7882353,0.5764706,0;0.9529412,0.7882354,0.5882353,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;101;-3501.157,-266.0128;Float;False;Property;_DeepColour;Deep Colour;7;0;Create;True;0;0;0;False;0;False;0.04705882,0.3098039,0.1960784,0;0.07450981,0.4313726,0.4,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;235;-3313.924,-103.3427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;325;-1603.032,-1078.376;Inherit;False;1558;551;WaterOpacity;9;218;214;161;216;217;220;226;234;227;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenColorNode;100;-2559.633,-1785.656;Float;False;Global;_ScreenGrab0;Screen Grab 0;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;212;-4105.4,-669.8775;Inherit;False;Property;_NormalTiling2;Normal Tiling 2;29;0;Create;True;0;0;0;False;0;False;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-4617.115,1009.083;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;111;-3151.482,174.123;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-4066.328,-1046.987;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;241;-3818.788,-2326.225;Inherit;False;Property;_CausticDepthFade;CausticDepthFade;14;0;Create;True;0;0;0;False;0;False;0.05;11.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;-538.7614,1903.256;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-4105.522,-858.5355;Inherit;False;Property;_NormalTiling;Normal Tiling;27;0;Create;True;0;0;0;False;0;False;0.2;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;338;-1517.092,-444.7377;Inherit;False;1064.405;701.74;Glow;15;333;331;332;334;335;336;337;326;160;327;328;329;330;339;340;Glow;0,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;110;-3809.104,-2655.918;Inherit;True;1;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LerpOp;115;-3216.13,-318.6596;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;177;-2976.729,-9.537081;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;103;-3855.079,-656.4675;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-3869.281,-963.2824;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;102;-2739.099,-401.6354;Inherit;False;1148.59;655.2657;WaterAlbedoLayering;8;155;146;141;140;125;123;121;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;106;-4456.256,1010.581;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;127;-1038.69,2386.066;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-3902.159,-761.6244;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;234;-1518.856,-960.1423;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-16.71037,2184.112;Inherit;False;Property;_WaveFoamOpacity;Wave Foam Opacity;36;0;Create;True;0;0;0;False;0;False;0.5;0.069;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2369.555,-1755.626;Inherit;False;Refraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-798.4999,2585.578;Float;False;Property;_WaveAmplitude;Wave Amplitude;34;0;Create;True;0;0;0;False;0;False;0.958;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;109;-82.55627,1919.347;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1427.244,-831.1747;Inherit;False;Property;_OpacityFalloff;Opacity Falloff;1;0;Create;True;0;0;0;False;0;False;1;9.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;237;-3607.188,-2356.989;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;118;-3715.25,-820.6505;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;331;-1467.092,-241.7378;Inherit;False;Property;_GlowDepth;Glow Depth;42;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;226;-1224.244,-947.1747;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;238;-3320.611,-2438.261;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;122;-3605.942,-2763.084;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-4265.466,999.9451;Inherit;False;foamNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;117;-1706.364,749.5282;Inherit;False;1050;443;Smoothness;7;156;148;138;132;130;128;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Compare;175;-2901.729,-270.5371;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;136;-303.2123,2498.351;Inherit;False;Constant;_Int0;Int 0;21;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-2705.278,-146.4805;Inherit;False;107;Refraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;119;-3704.783,-1146.988;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.04,0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;135;-850.222,2285.847;Inherit;True;Property;_WaveMask;Wave Mask;37;0;Create;True;0;0;0;False;0;False;-1;4aaf5eafc291ee24ba7cefe12e6677a8;796e3706ceb704247adb957915a9edaf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;116;297.3297,1895.515;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;304;-529.4344,2501.744;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;129;-3464.382,-1189.888;Inherit;True;Property;_RipplesNormal;Ripples Normal;26;1;[Header];Create;True;1;Waves;0;0;False;0;False;-1;943fbf4e2ff77624595e60ac401208bf;65daf7c31bf358c468feca82d558eecd;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;333;-1291.092,-265.7377;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;-3537.521,-2607.857;Inherit;False;Property;_CausticColour;Caustic Colour;12;1;[Header];Create;True;1;Caustics;0;0;False;0;False;0.496,0.496,0.496,0;0.355,0.355,0.355,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;239;-3183.611,-2513.261;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;134;-3386.623,-2723.834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;-1700.364,288.5282;Inherit;False;956.0001;443;Specular;5;154;147;144;142;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1630.712,915.0829;Float;False;Property;_FoamSmoothness;Foam Smoothness;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1609.334,827.0519;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;125;-2649.173,49.14542;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2382.342,162.5208;Inherit;False;114;foamNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-1313.688,102.071;Inherit;False;114;foamNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;510.9448,1911.873;Inherit;False;waveCrestColour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;120;-3427.848,-910.5505;Inherit;True;Property;_RipplesNormal2;Ripples Normal 2;28;0;Create;True;0;0;0;False;0;False;-1;943fbf4e2ff77624595e60ac401208bf;82cd055e7c798f64ab98d2be4b731524;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;220;-1017.1,-926.3068;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-2512.888,-281.4709;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;149;-367.8016,2207.679;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;332;-1269.092,-149.7378;Inherit;False;Property;_GlowFalloff;Glow Falloff;43;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-1154.1,-818.3068;Inherit;False;Property;_OpacityMin;Opacity Min;2;0;Create;True;0;0;0;False;0;False;0.5;0.32;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1592.723,1081.916;Inherit;False;62;foam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-1595.371,384.1271;Float;False;Property;_Specular;Specular;3;0;Create;True;0;0;0;False;0;False;0.141;0.026;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-1565.409,602.0158;Inherit;False;62;foam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;4.679822,2489.583;Inherit;False;waveCrestVertoffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;141;-2235.325,-197.9272;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;334;-1009.092,-204.7378;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-3074.134,-2653.234;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1575.787,479.4994;Float;False;Constant;_FoamSpecular;Foam Specular;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-1148.682,-713.468;Float;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;0;False;0;False;1;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;145;-3085.755,-946.999;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-2188.266,-15.55185;Inherit;False;131;waveCrestColour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;328;-1138.688,107.071;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;330;-1212.688,-72.92902;Inherit;False;Property;_FoamEmitColour;Foam Emit Colour;44;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;216;-829.1001,-927.3068;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-3106.056,-1075.82;Float;False;Property;_NormalScale;Normal Scale;30;0;Create;True;0;0;0;False;0;False;0.669;0.264;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;132;-1305.898,872.8879;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1330.087,1032.311;Float;False;Property;_ReflectionPower;Reflection Power;5;0;Create;True;0;0;0;False;0;False;0.346;0.32;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;-1149.148,554.225;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-2035.133,-188.3362;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;335;-849.0917,-205.7378;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;336;-994.0917,-394.7377;Inherit;False;Property;_DepthGlowColour;Depth Glow Colour;41;1;[Header];Create;True;1;Glow;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-2829.404,-2622.793;Inherit;False;Caustics;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-606.1001,-845.3068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-555.503,438.0984;Inherit;False;153;waveCrestVertoffset;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;151;-2798.458,-945.5594;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;340;-973.0979,-70.69592;Inherit;False;Property;_FoamGlowMultiplier;Foam Glow Multiplier;45;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1037.584,852.4713;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;329;-969.6872,25.071;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;157;-2438.871,-918.4479;Inherit;False;waveNormalMaps;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-976.4514,565.5849;Inherit;False;specular;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;337;-675.0917,-322.7377;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-807.7825,143.2098;Inherit;False;152;Caustics;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-295.1001,-830.3068;Inherit;False;waterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-1804.758,-178.1924;Inherit;False;waterAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;-749.0979,-2.695923;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-864.2643,863.967;Inherit;False;smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;298;-318.0319,440.3906;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-374.9481,249.2891;Inherit;False;156;smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-367.9481,164.289;Inherit;False;154;specular;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;301;-118.0319,455.3906;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;326;-589.0692,52.32371;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-397.5821,-91.17996;Inherit;False;155;waterAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-400.42,9.915314;Inherit;False;157;waveNormalMaps;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;219;-357.1001,344.6932;Inherit;False;218;waterOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;SyntyStudios/WaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;307;0;308;0
WireConnection;312;1;307;0
WireConnection;170;0;78;0
WireConnection;14;0;9;0
WireConnection;13;0;10;0
WireConnection;320;0;312;0
WireConnection;320;1;323;0
WireConnection;22;0;14;0
WireConnection;20;0;13;0
WireConnection;27;0;13;0
WireConnection;25;0;15;0
WireConnection;19;0;16;1
WireConnection;19;1;16;3
WireConnection;23;0;170;0
WireConnection;23;1;17;0
WireConnection;166;0;14;0
WireConnection;34;0;25;0
WireConnection;31;0;20;0
WireConnection;322;0;320;0
WireConnection;322;1;316;0
WireConnection;36;0;27;0
WireConnection;32;0;19;0
WireConnection;32;1;21;0
WireConnection;59;0;49;1
WireConnection;59;1;49;3
WireConnection;30;0;22;0
WireConnection;164;0;166;0
WireConnection;28;0;25;0
WireConnection;37;0;26;0
WireConnection;38;0;23;0
WireConnection;38;1;24;0
WireConnection;44;0;164;0
WireConnection;47;0;38;0
WireConnection;42;0;28;0
WireConnection;41;0;36;0
WireConnection;43;0;30;0
WireConnection;39;1;37;0
WireConnection;46;0;31;0
WireConnection;45;0;32;0
WireConnection;45;2;33;0
WireConnection;324;0;322;0
WireConnection;324;1;59;0
WireConnection;48;0;34;0
WireConnection;56;0;42;0
WireConnection;52;1;45;0
WireConnection;57;0;46;0
WireConnection;57;1;41;0
WireConnection;302;0;324;0
WireConnection;302;2;303;0
WireConnection;55;0;47;0
WireConnection;55;1;39;1
WireConnection;51;0;44;0
WireConnection;51;1;43;0
WireConnection;58;0;48;0
WireConnection;50;0;170;0
WireConnection;50;1;29;0
WireConnection;62;0;55;0
WireConnection;61;0;57;0
WireConnection;67;0;58;0
WireConnection;67;1;56;0
WireConnection;66;0;52;0
WireConnection;66;1;53;0
WireConnection;64;0;51;0
WireConnection;64;1;50;0
WireConnection;60;0;302;0
WireConnection;60;1;54;0
WireConnection;72;0;66;0
WireConnection;74;0;67;0
WireConnection;99;0;170;0
WireConnection;99;1;84;0
WireConnection;73;0;64;0
WireConnection;70;0;60;0
WireConnection;70;2;63;0
WireConnection;69;0;68;0
WireConnection;77;0;61;0
WireConnection;179;0;99;0
WireConnection;85;1;70;0
WireConnection;79;0;75;0
WireConnection;79;1;73;0
WireConnection;87;0;69;0
WireConnection;87;1;72;0
WireConnection;82;0;74;0
WireConnection;80;0;75;0
WireConnection;80;1;71;0
WireConnection;90;0;210;0
WireConnection;167;0;95;0
WireConnection;235;0;99;0
WireConnection;235;1;236;0
WireConnection;100;0;87;0
WireConnection;98;0;79;0
WireConnection;98;1;80;0
WireConnection;111;0;179;0
WireConnection;93;0;81;1
WireConnection;93;1;81;3
WireConnection;97;0;83;0
WireConnection;97;1;85;0
WireConnection;97;2;89;0
WireConnection;110;0;167;0
WireConnection;110;1;90;0
WireConnection;110;2;183;0
WireConnection;115;0;108;0
WireConnection;115;1;101;0
WireConnection;115;2;235;0
WireConnection;177;0;101;0
WireConnection;177;1;176;0
WireConnection;177;2;111;0
WireConnection;103;0;91;0
WireConnection;104;0;93;0
WireConnection;104;1;92;0
WireConnection;106;0;98;0
WireConnection;127;0;60;0
WireConnection;127;2;63;0
WireConnection;211;0;93;0
WireConnection;211;1;212;0
WireConnection;107;0;100;0
WireConnection;109;0;83;0
WireConnection;109;1;97;0
WireConnection;109;2;96;0
WireConnection;237;0;241;0
WireConnection;118;0;211;0
WireConnection;118;2;103;0
WireConnection;226;0;234;0
WireConnection;226;1;227;0
WireConnection;238;0;237;0
WireConnection;122;0;110;0
WireConnection;114;0;106;0
WireConnection;175;0;235;0
WireConnection;175;2;115;0
WireConnection;175;3;177;0
WireConnection;119;0;104;0
WireConnection;119;2;91;0
WireConnection;135;1;127;0
WireConnection;116;1;109;0
WireConnection;116;2;105;0
WireConnection;304;0;137;0
WireConnection;129;1;119;0
WireConnection;333;0;331;0
WireConnection;239;0;238;0
WireConnection;134;0;122;0
WireConnection;131;0;116;0
WireConnection;120;1;118;0
WireConnection;220;0;226;0
WireConnection;121;0;175;0
WireConnection;121;1;113;0
WireConnection;121;2;175;0
WireConnection;149;0;135;0
WireConnection;149;1;136;0
WireConnection;149;2;304;0
WireConnection;153;0;149;0
WireConnection;141;0;121;0
WireConnection;141;1;125;0
WireConnection;141;2;123;0
WireConnection;334;0;333;0
WireConnection;334;1;332;0
WireConnection;150;0;134;0
WireConnection;150;1;139;0
WireConnection;150;2;239;0
WireConnection;145;0;129;0
WireConnection;145;1;120;0
WireConnection;328;0;327;0
WireConnection;216;0;220;0
WireConnection;216;3;217;0
WireConnection;132;0;130;0
WireConnection;132;1;128;0
WireConnection;132;2;126;0
WireConnection;147;0;133;0
WireConnection;147;1;142;0
WireConnection;147;2;144;0
WireConnection;146;0;141;0
WireConnection;146;1;140;0
WireConnection;335;0;334;0
WireConnection;152;0;150;0
WireConnection;214;0;216;0
WireConnection;214;1;161;0
WireConnection;151;0;145;0
WireConnection;151;1;143;0
WireConnection;148;0;132;0
WireConnection;148;1;138;0
WireConnection;329;0;330;0
WireConnection;329;2;328;0
WireConnection;157;0;151;0
WireConnection;154;0;147;0
WireConnection;337;0;336;0
WireConnection;337;2;335;0
WireConnection;218;0;214;0
WireConnection;155;0;146;0
WireConnection;339;0;340;0
WireConnection;339;1;329;0
WireConnection;156;0;148;0
WireConnection;298;0;163;0
WireConnection;301;1;298;0
WireConnection;326;0;337;0
WireConnection;326;1;339;0
WireConnection;326;2;160;0
WireConnection;0;0;165;0
WireConnection;0;1;159;0
WireConnection;0;2;326;0
WireConnection;0;3;158;0
WireConnection;0;4;162;0
WireConnection;0;9;219;0
WireConnection;0;11;301;0
ASEEND*/
//CHKSM=2A8E92FE6B8AB95B3ABB0FE58323CFC99F24A702