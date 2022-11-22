// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/InvisibleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half3 worldRefr: TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (float4 vertex : POSITION, float3 normal: NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);

                float3 posW = mul(unity_ObjectToWorld, vertex).xyz;
                float3 dirW = normalize(UnityWorldSpaceViewDir(posW));
                float3 normalW = UnityObjectToWorldNormal(normal);
                o.worldRefr = refract(-dirW, normalW,0.1);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.worldRefr);
                return c;

            }
            ENDCG
        }
    }
}
