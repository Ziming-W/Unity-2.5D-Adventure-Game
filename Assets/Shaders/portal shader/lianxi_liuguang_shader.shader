// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:33223,y:32630,varname:node_4795,prsc:2|emission-2393-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32499,y:32544,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:85905a66f58b02d48bb7afc56f51e4df,ntxv:0,isnm:False|UVIN-3972-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32998,y:32727,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-9248-OUT,E-1471-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32499,y:32715,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32499,y:32873,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Vector1,id:9248,x:32499,y:33024,varname:node_9248,prsc:2,v1:2;n:type:ShaderForge.SFN_Add,id:3972,x:32315,y:32545,varname:node_3972,prsc:2|A-7269-OUT,B-1014-OUT;n:type:ShaderForge.SFN_Multiply,id:1014,x:32057,y:32643,varname:node_1014,prsc:2|A-2436-T,B-3671-OUT;n:type:ShaderForge.SFN_Time,id:2436,x:31830,y:32655,varname:node_2436,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:1568,x:31631,y:32790,ptovrint:False,ptlb:MainTex_u_speed,ptin:_MainTex_u_speed,varname:node_1568,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_ValueProperty,id:7873,x:31631,y:32870,ptovrint:False,ptlb:MainTex_v_speed,ptin:_MainTex_v_speed,varname:node_7873,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:3671,x:31830,y:32810,varname:node_3671,prsc:2|A-1568-OUT,B-7873-OUT;n:type:ShaderForge.SFN_Tex2d,id:582,x:32499,y:33128,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_582,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1007f7aec0e21fe40a3dec68a82daa52,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:1471,x:32790,y:33017,varname:node_1471,prsc:2|A-6074-A,B-582-R;n:type:ShaderForge.SFN_Time,id:6935,x:30889,y:32314,varname:node_6935,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:7301,x:30691,y:32461,ptovrint:False,ptlb:Noise_u_speed,ptin:_Noise_u_speed,varname:node_7301,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2407,x:30691,y:32554,ptovrint:False,ptlb:Noise_v_speed,ptin:_Noise_v_speed,varname:node_2407,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Append,id:8031,x:30889,y:32478,varname:node_8031,prsc:2|A-7301-OUT,B-2407-OUT;n:type:ShaderForge.SFN_Multiply,id:7617,x:31103,y:32350,varname:node_7617,prsc:2|A-6935-T,B-8031-OUT;n:type:ShaderForge.SFN_TexCoord,id:6271,x:31103,y:32194,varname:node_6271,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:4867,x:31307,y:32305,varname:node_4867,prsc:2|A-6271-UVOUT,B-7617-OUT;n:type:ShaderForge.SFN_Tex2d,id:844,x:31511,y:32305,ptovrint:False,ptlb:Noise,ptin:_Noise,varname:node_844,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4867-OUT;n:type:ShaderForge.SFN_Lerp,id:9890,x:31830,y:32308,varname:node_9890,prsc:2|A-2144-UVOUT,B-844-R,T-618-OUT;n:type:ShaderForge.SFN_TexCoord,id:2144,x:31511,y:32126,varname:node_2144,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Slider,id:618,x:31354,y:32500,ptovrint:False,ptlb:Noise_qiangdu,ptin:_Noise_qiangdu,varname:node_618,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Lerp,id:7269,x:32054,y:32308,varname:node_7269,prsc:2|A-1319-UVOUT,B-9890-OUT,T-8080-R;n:type:ShaderForge.SFN_TexCoord,id:1319,x:31830,y:32147,varname:node_1319,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Tex2d,id:8080,x:31830,y:32475,ptovrint:False,ptlb:Noise_Mask,ptin:_Noise_Mask,varname:node_8080,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:797-6074-1568-7873-844-7301-2407-618-8080-582;pass:END;sub:END;*/

Shader "Shader Forge/lianxi_liuguang_shader" {
    Properties {
        [HDR]_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _MainTex_u_speed ("MainTex_u_speed", Float ) = 0.2
        _MainTex_v_speed ("MainTex_v_speed", Float ) = 0
        _Noise ("Noise", 2D) = "white" {}
        _Noise_u_speed ("Noise_u_speed", Float ) = 0
        _Noise_v_speed ("Noise_v_speed", Float ) = 0
        _Noise_qiangdu ("Noise_qiangdu", Range(0, 1)) = 0
        _Noise_Mask ("Noise_Mask", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _TintColor;
            uniform float _MainTex_u_speed;
            uniform float _MainTex_v_speed;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Noise_u_speed;
            uniform float _Noise_v_speed;
            uniform sampler2D _Noise; uniform float4 _Noise_ST;
            uniform float _Noise_qiangdu;
            uniform sampler2D _Noise_Mask; uniform float4 _Noise_Mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_6935 = _Time;
                float2 node_4867 = (i.uv0+(node_6935.g*float2(_Noise_u_speed,_Noise_v_speed)));
                float4 _Noise_var = tex2D(_Noise,TRANSFORM_TEX(node_4867, _Noise));
                float4 _Noise_Mask_var = tex2D(_Noise_Mask,TRANSFORM_TEX(i.uv0, _Noise_Mask));
                float4 node_2436 = _Time;
                float2 node_3972 = (lerp(i.uv0,lerp(i.uv0,float2(_Noise_var.r,_Noise_var.r),_Noise_qiangdu),_Noise_Mask_var.r)+(node_2436.g*float2(_MainTex_u_speed,_MainTex_v_speed)));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_3972, _MainTex));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*2.0*(_MainTex_var.a*_Mask_var.r));
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
