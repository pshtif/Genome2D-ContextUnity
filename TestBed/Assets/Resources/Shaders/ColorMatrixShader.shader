Shader "Genome2D/ColorMatrixShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        BlendSrcMode ("BlendSrcMode", Float) = 0
        BlendDstMode ("BlendDstMode", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        
        ZWrite Off
        // No reason just for Genome2D other contexts consistency, inverted axes
        Cull Off
        Blend [BlendSrcMode] [BlendDstMode]

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ColorMatrix[20];

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * i.color;
                
                fixed4 result = fixed4(0,0,0,0);

                if (col.a > 0.0) {
                    col.rgb /= col.a;
                }

                result.r = (_ColorMatrix[0] * col.r);
                    result.r += (_ColorMatrix[1] * col.g);
                    result.r += (_ColorMatrix[2] * col.b);
                    result.r += (_ColorMatrix[3] * col.a);
                    result.r += _ColorMatrix[4];

                result.g = (_ColorMatrix[5] * col.r);
                    result.g += (_ColorMatrix[6] * col.g);
                    result.g += (_ColorMatrix[7] * col.b);
                    result.g += (_ColorMatrix[8] * col.a);
                    result.g += _ColorMatrix[9];

                result.b = (_ColorMatrix[10] * col.r);
                   result.b += (_ColorMatrix[11] * col.g);
                   result.b += (_ColorMatrix[12] * col.b);
                   result.b += (_ColorMatrix[13] * col.a);
                   result.b += _ColorMatrix[14];

                result.a = (_ColorMatrix[15] * col.r);
                   result.a += (_ColorMatrix[16] * col.g);
                   result.a += (_ColorMatrix[17] * col.b);
                   result.a += (_ColorMatrix[18] * col.a);
                   result.a += _ColorMatrix[19];
                
                result.rgb *= result.a;

                return result;
            }
            ENDCG
        }
    }
}
