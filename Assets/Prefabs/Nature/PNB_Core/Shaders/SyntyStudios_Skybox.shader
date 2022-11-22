// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SyntyStudios/SkyboxUnlit"
{
	Properties
	{
		_ColorTop("Color Top", Color) = (0,1,0.7517242,0)
		_ColorBottom("Color Bottom", Color) = (0.8161765,0.9087222,1,0)
		_Offset("Offset", Float) = 0
		_Distance("Distance", Float) = 0
		_Falloff("Falloff", Range( 0.001 , 100)) = 0.001
		[Toggle(_UV_BASED_TOGGLE_ON)] _UV_Based_Toggle("UV_Based_Toggle", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _UV_BASED_TOGGLE_ON
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float4 _ColorBottom;
		uniform float4 _ColorTop;
		uniform float _Offset;
		uniform float _Distance;
		uniform float _Falloff;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float clampResult13 = clamp( ( ( _Offset + ase_worldPos.y ) / _Distance ) , 0.0 , 1.0 );
			float4 lerpResult18 = lerp( _ColorBottom , _ColorTop , saturate( pow( clampResult13 , _Falloff ) ));
			float4 lerpResult4 = lerp( _ColorBottom , _ColorTop , i.uv_texcoord.y);
			#ifdef _UV_BASED_TOGGLE_ON
				float4 staticSwitch20 = lerpResult4;
			#else
				float4 staticSwitch20 = lerpResult18;
			#endif
			o.Emission = staticSwitch20.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
-3426;2;2923;1371;1931.5;82.5;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;8;-1162.978,627.1809;Float;False;Property;_Offset;Offset;2;0;Create;True;0;0;0;False;0;False;0;-19.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-1191.739,724.1008;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-993.366,819.235;Float;False;Property;_Distance;Distance;3;0;Create;True;0;0;0;False;0;False;0;97.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-976.9778,678.1809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;11;-818.9956,755.6576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-791.4061,910.952;Float;False;Property;_Falloff;Falloff;4;0;Create;True;0;0;0;False;0;False;0.001;0.7;0.001;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-666.3611,743.8828;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-475.7605,741.1777;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-770.5,-143.5;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-587.2416,148.7785;Float;False;Property;_ColorBottom;Color Bottom;1;0;Create;True;0;0;0;False;0;False;0.8161765,0.9087222,1,0;0.8620691,1,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-389.5,-105.5;Inherit;True;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;17;-586.8671,356.3854;Float;False;Property;_ColorTop;Color Top;0;0;Create;True;0;0;0;False;0;False;0,1,0.7517242,0;1,0.6323529,0.6323529,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-299.046,644.3723;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-120.2613,325.0965;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;4;-121.5,1.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;20;111.5,220.5;Inherit;False;Property;_UV_Based_Toggle;UV_Based_Toggle;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;450,57;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SyntyStudios/SkyboxUnlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;2;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;8;0
WireConnection;10;1;7;2
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;13;0;11;0
WireConnection;14;0;13;0
WireConnection;14;1;12;0
WireConnection;22;0;21;2
WireConnection;16;0;14;0
WireConnection;18;0;15;0
WireConnection;18;1;17;0
WireConnection;18;2;16;0
WireConnection;4;0;15;0
WireConnection;4;1;17;0
WireConnection;4;2;22;0
WireConnection;20;1;18;0
WireConnection;20;0;4;0
WireConnection;0;2;20;0
ASEEND*/
//CHKSM=B616A517AB2C2DAE6D1EF1D4149C3BA97CB81C17