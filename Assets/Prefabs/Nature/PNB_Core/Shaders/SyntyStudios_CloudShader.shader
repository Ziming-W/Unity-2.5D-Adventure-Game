// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/CloudShader"
{
	Properties
	{
		_Colour("Colour", Color) = (0.5,0.5,0.5,0)
		[Header(Emissive)]_EmissiveColour("EmissiveColour", Color) = (0.7215686,0.8078431,1,0)
		_lightDirMulti("lightDirMulti", Float) = 0.1
		_minEmit("minEmit", Range( 0 , 1)) = 0.03
		_minEmit_dir("minEmit_dir", Range( 0 , 1)) = 0.19
		_maxEmit("maxEmit", Range( 0 , 1.5)) = 1
		[Header(Light)]_DirectLight("DirectLight", Float) = 0.01
		_lightMin("lightMin", Range( 0 , 1)) = 0
		_lightingContrast("lightingContrast", Float) = 6.47
		_lightMax("lightMax", Range( 0 , 1)) = 1
		[Header(Wind)]_WindEffect("WindEffect", Range( 0 , 2)) = 1
		_PanningSpeed("PanningSpeed", Range( 0 , 1)) = 0.1
		_PanningNoise("PanningNoise", 2D) = "white" {}
		_WindNoiseScale("WindNoiseScale", Range( 0 , 1)) = 0.1
		_WindWorldScale("WindWorldScale", Float) = 0.05
		[Header(Multipliers)]_X_Multiplier("X_Multiplier", Range( 0 , 2)) = 1
		_Y_Multiplier("Y_Multiplier", Range( 0 , 2)) = 1
		_Z_Multiplier("Z_Multiplier", Range( 0 , 2)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _WindEffect;
		uniform float _X_Multiplier;
		uniform sampler2D _PanningNoise;
		uniform float _PanningSpeed;
		uniform float _WindWorldScale;
		uniform float _WindNoiseScale;
		uniform float _Y_Multiplier;
		uniform float _Z_Multiplier;
		uniform float4 _Colour;
		uniform float4 _EmissiveColour;
		uniform float _lightDirMulti;
		uniform float _minEmit;
		uniform float _minEmit_dir;
		uniform float _maxEmit;
		uniform float _lightingContrast;
		uniform float _DirectLight;
		uniform float _lightMin;
		uniform float _lightMax;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_output_112_0 = ( ase_worldPos * 0.5 );
			float simplePerlin3D118 = snoise( temp_output_112_0*_WindNoiseScale );
			simplePerlin3D118 = simplePerlin3D118*0.5 + 0.5;
			float3 temp_cast_0 = (simplePerlin3D118).xxx;
			float3 lerpResult125 = lerp( temp_cast_0 , sin( temp_output_112_0 ) , float3( 0,0,0 ));
			float2 panner131 = ( ( _PanningSpeed * _Time.y ) * float2( 1,1 ) + ( ase_worldPos * _WindWorldScale * lerpResult125 ).xy);
			float4 tex2DNode133 = tex2Dlod( _PanningNoise, float4( panner131, 0, 0.0) );
			float4 appendResult152 = (float4(( _X_Multiplier * tex2DNode133.r ) , ( _Y_Multiplier * tex2DNode133.g ) , ( _Z_Multiplier * tex2DNode133.b ) , 0.0));
			v.vertex.xyz += ( _WindEffect * appendResult152 ).xyz;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult38 = dot( ase_worldlightDir , ase_worldNormal );
			float clampResult104 = clamp( ( exp2( ( dotResult38 * _lightingContrast ) ) * _DirectLight ) , _lightMin , _lightMax );
			c.rgb = ( ase_lightColor * clampResult104 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Albedo = _Colour.rgb;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float4 appendResult53 = (float4(( 1.0 - i.viewDir.x ) , ( 1.0 - i.viewDir.y ) , ( 1.0 - i.viewDir.z ) , 0.0));
			float dotResult50 = dot( float4( ase_worldlightDir , 0.0 ) , appendResult53 );
			float grayscale93 = Luminance(appendResult53.xyz);
			float grayscale98 = Luminance(ase_worldlightDir);
			float clampResult96 = clamp( max( ( dotResult50 * _lightDirMulti * grayscale93 ) , ( _minEmit + ( grayscale98 * _minEmit_dir ) ) ) , 0.0 , _maxEmit );
			o.Emission = ( _EmissiveColour * clampResult96 ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
-3426;2;2923;1371;2227.689;913.1183;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;150;-1945.406,1029.011;Inherit;False;2270.997;991.7048;Wobble;25;135;133;131;129;127;122;121;124;114;125;118;117;113;112;110;111;152;153;154;156;157;160;161;162;163;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1860.071,1710.505;Inherit;False;Constant;_Tiling;Tiling;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;110;-1910.071,1506.505;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1635.071,1526.505;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1736.934,1411.248;Inherit;False;Property;_WindNoiseScale;WindNoiseScale;13;0;Create;True;0;0;0;False;0;False;0.1;0.126;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;158;-1730.593,-773.0697;Inherit;False;2060.4;912.5;Emissive;20;100;44;46;96;77;97;55;99;78;56;50;93;101;98;53;49;51;48;52;54;;0.1179245,0.8453805,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;117;-1445.071,1589.505;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;54;-1623.958,-306.7023;Inherit;True;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;159;-1819.165,210.4328;Inherit;False;2134.551;704.6536;Lighting;13;109;104;108;106;103;73;68;74;64;65;38;41;37;;1,0.7426714,0.3726415,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;118;-1456.934,1459.248;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1612.95,1750.756;Inherit;False;Property;_PanningSpeed;PanningSpeed;11;0;Create;True;0;0;0;False;0;False;0.1;0.551;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1281.958,-234.7023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-1281.958,-314.7023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;48;-1281.958,-152.7023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;124;-1216.95,1255.756;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;37;-1612.592,398.7391;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;122;-1165.95,1403.756;Inherit;False;Property;_WindWorldScale;WindWorldScale;14;0;Create;True;0;0;0;False;0;False;0.05;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;49;-1596.958,-535.7023;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;114;-1560.521,1857.361;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;125;-1263.934,1495.248;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;41;-1578.755,609.9402;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;53;-1121.958,-266.7022;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCGrayscale;98;-1364.384,-109.7892;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-1200.384,-65.78925;Inherit;False;Property;_minEmit_dir;minEmit_dir;4;0;Create;True;0;0;0;False;0;False;0.19;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1310.95,1741.756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-1253.515,400.3323;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1224.993,652.7733;Inherit;False;Property;_lightingContrast;lightingContrast;8;0;Create;True;0;0;0;False;0;False;6.47;6.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-945.9496,1395.756;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-943.9927,402.7734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;131;-828.6915,1535.711;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;93;-976.383,-687.7894;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-756.383,-99.78925;Inherit;False;Property;_minEmit;minEmit;3;0;Create;True;0;0;0;False;0;False;0.03;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-909.383,-43.78926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-918.2716,-126.9541;Inherit;False;Property;_lightDirMulti;lightDirMulti;2;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;50;-958.9574,-359.7023;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-526.2782,1137.749;Inherit;False;Property;_X_Multiplier;X_Multiplier;15;1;[Header];Create;True;1;Multipliers;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-623.9499,1509.756;Inherit;True;Property;_PanningNoise;PanningNoise;12;0;Create;True;0;0;0;False;0;False;-1;4aaf5eafc291ee24ba7cefe12e6677a8;796e3706ceb704247adb957915a9edaf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-459.3831,-68.78925;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-579.2716,-380.9541;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;68;-759.9928,400.7734;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-862.9927,671.7734;Inherit;False;Property;_DirectLight;DirectLight;6;1;[Header];Create;True;1;Light;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-546.7931,1299.029;Inherit;False;Property;_Y_Multiplier;Y_Multiplier;16;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-555.2782,1428.75;Inherit;False;Property;_Z_Multiplier;Z_Multiplier;17;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-284.3831,-82.78925;Inherit;False;Property;_maxEmit;maxEmit;5;0;Create;True;0;0;0;False;0;False;1;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-234.7932,1358.829;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-413.9926,406.7734;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-227.2783,1500.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-439.7867,637.8105;Inherit;False;Property;_lightMin;lightMin;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;77;-342.3831,-307.7892;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-214.2783,1197.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-435.7867,733.8105;Inherit;False;Property;_lightMax;lightMax;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;108;-194.7868,303.8105;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;46;-213.3529,-605.8589;Inherit;False;Property;_EmissiveColour;EmissiveColour;1;1;[Header];Create;True;1;Emissive;0;0;False;0;False;0.7215686,0.8078431,1,0;0.759,0.8125556,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;96;-64.38319,-288.7892;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.89;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-209.5927,1097.63;Inherit;False;Property;_WindEffect;WindEffect;10;1;[Header];Create;True;1;Wind;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;104;-148.7867,444.8105;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.89;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;152;-88.69327,1331.63;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;16.21322,286.8105;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;35;555.9285,-574.5895;Inherit;False;Property;_Colour;Colour;0;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0.887,0.9320744,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;85.52962,-379.3114;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;135;124.9261,1455.404;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;118.0073,1145.73;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;786.5472,-142.416;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SyntyStudios/CloudShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;112;0;110;0
WireConnection;112;1;111;0
WireConnection;117;0;112;0
WireConnection;118;0;112;0
WireConnection;118;1;113;0
WireConnection;52;0;54;2
WireConnection;51;0;54;1
WireConnection;48;0;54;3
WireConnection;125;0;118;0
WireConnection;125;1;117;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;53;2;48;0
WireConnection;98;0;49;0
WireConnection;129;0;121;0
WireConnection;129;1;114;0
WireConnection;38;0;37;0
WireConnection;38;1;41;0
WireConnection;127;0;124;0
WireConnection;127;1;122;0
WireConnection;127;2;125;0
WireConnection;64;0;38;0
WireConnection;64;1;65;0
WireConnection;131;0;127;0
WireConnection;131;1;129;0
WireConnection;93;0;53;0
WireConnection;100;0;98;0
WireConnection;100;1;101;0
WireConnection;50;0;49;0
WireConnection;50;1;53;0
WireConnection;133;1;131;0
WireConnection;99;0;78;0
WireConnection;99;1;100;0
WireConnection;55;0;50;0
WireConnection;55;1;56;0
WireConnection;55;2;93;0
WireConnection;68;0;64;0
WireConnection;153;0;154;0
WireConnection;153;1;133;2
WireConnection;73;0;68;0
WireConnection;73;1;74;0
WireConnection;163;0;162;0
WireConnection;163;1;133;3
WireConnection;77;0;55;0
WireConnection;77;1;99;0
WireConnection;161;0;160;0
WireConnection;161;1;133;1
WireConnection;96;0;77;0
WireConnection;96;2;97;0
WireConnection;104;0;73;0
WireConnection;104;1;103;0
WireConnection;104;2;106;0
WireConnection;152;0;161;0
WireConnection;152;1;153;0
WireConnection;152;2;163;0
WireConnection;109;0;108;0
WireConnection;109;1;104;0
WireConnection;44;0;46;0
WireConnection;44;1;96;0
WireConnection;157;0;156;0
WireConnection;157;1;152;0
WireConnection;0;0;35;0
WireConnection;0;2;44;0
WireConnection;0;13;109;0
WireConnection;0;11;157;0
ASEEND*/
//CHKSM=C0AD92799C6C6583AA028E23823178E38C677B7F