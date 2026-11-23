Shader "DeathWish/MovementUnlit"
{
    Properties
    {
        _Color ("Color", Color) = (0.2, 0.65, 0.75, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _Color;

            struct VertexInput
            {
                float4 position : POSITION;
            };

            struct VertexOutput
            {
                float4 position : SV_POSITION;
            };

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.position = UnityObjectToClipPos(input.position);
                return output;
            }

            fixed4 frag(VertexOutput input) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
