#ifndef LIGHTING
#define LIGHTING


struct GetColorData {
    float3 ColorData;
    float3 NormData;
};

float3 FindCustomLighting(GetColorData d) {
    return d.ColorData;
}

float3 LightHandle(GetColorData d, float3 lightDir, float3 lightColor) {
    float3 Brightness = lightColor;
    float shadows= saturate(dot(d.NormData, lightDir));
    float3 color = d.ColorData * Brightness * shadows;
    return color;
}


float3 FindCustomLighting(GetColorData d,float3 lightDir, float3 lightColor) {
    // Get the main light. Located in URP/ShaderLibrary/Lighting.hlsl
    float3 color = 0;
    color += LightHandle(d, lightColor, lightDir);

    return color;
}
void FindLighting_float(float3 colord, float3 normd, float3 lightDir, float3 lightColor, out float3 Color) {
    GetColorData d;
    d.ColorData = colord;
    d.NormData=normd;

    Color = FindCustomLighting(d, lightColor, lightDir);
}

#endif