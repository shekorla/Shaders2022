Shader "Unlit/lambert"
{
    Properties //put stuff here to be quickly changed in editor
    {
        //_Color ("Color", Color) = (1,1,1,1)
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {

        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            
            CGPROGRAM
            #pragma vertex vert //this is the vertext shader
            // this is the fragment shader, that means this is what tells the pixels what color to be
            #pragma fragment frag 

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f //take the vertex data and convert to data for fragment to use
            {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0;//the lighting color--is ambient or spot??????-Q
                float4 vertex : SV_POSITION; // clip space position. like for camera clipping
            };

            

            v2f vert (appdata_base v) //actual shading of the vertex. 
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //convert transform pos to clip space
                o.uv = v.texcoord;//only pass the info needed not all info
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);// grab obj normal info
                //this is the dot thing! it deals with light and normal map
                half nl =max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                //check what color is light
                o.diff=nl*_LightColor0;
                o.diff.rgb +=ShadeSH9(half4(worldNormal,1));
                return o;
            }

            sampler2D _MainTex;//texture we are working with
            //fixed4 _Color;//the color brought in from editor
            
            
            //this is where we return the data to the pixels on screen and they light up
            //the fixed 4 type is what is returned, and it is low precision, whatever that means
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                //multiply the texture by the lighting
                col*=i.diff;
                return col;
            }
            ENDCG
        }
    }
}
//(type of variable or function etc) (name of variable) : (SEMANTIC TO HELP COMPUTER AND HUMANS READ FAST)

//shader works by taking individual vertex, grabbing their texture from the corresponding loc
//on the uv map, then they check where in the camera view that vertex is, then they give the 
//color data to the correct pixel for the camera view.