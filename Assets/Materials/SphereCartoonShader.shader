Shader "Unlit/SphereCartoonShader"
{
    // anything declared here will show up in the inspector
    Properties
    {
        _Shadows("Shadows", Range(1,15)) = 5
        
        // colors! and brightness!
        _Colors("Colors", Color) = (0,0,0,0)
        _Brightness("Brightness", Range(0,1)) = 0.2
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        // everything in here will render all at once during a single shader pass
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION; // vertex position
                float3 normal : NORMAL; // normalized vertex
            };

            struct v2f
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 worldNormal : TEXCOORD0; // texture coordinate
            };

            float4 _Colors;
            float _Shadows;
            float _Brightness;
            
            //vertex shader
            // this runs on each vertex of your 3D model
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            // fragment shader
            // a program that unrs on each and every pixel that object occupies on screen
            fixed4 frag (v2f i) : SV_Target
            {
                //normalize both vectors (normal vector and light direction vector) and get the dot product
                float cosAngle = dot(normalize(i.worldNormal), normalize(_WorldSpaceLightPos0.xyz)) + _Brightness;

                // get the max of the cosAngle and 0
                cosAngle = max(cosAngle, 0.0);

                // create levels of shading
                // floor
                cosAngle = floor(cosAngle * _Shadows) / _Shadows;

                return cosAngle * _Colors;
            }
            ENDCG
        }
    }
}
