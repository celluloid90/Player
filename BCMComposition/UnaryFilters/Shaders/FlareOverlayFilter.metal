//
//  FlareOverlayFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/8/23.
//

#include <metal_stdlib>
#include "MTFilterLib.h"

using namespace metalpetal;

METAL_FUNC float2 getEllipse(float y,float a, float b,float h, float k){
    
    float x = sqrt((1.0 / (b * b)) - (( (y - k) * (y - k) ) / ((a * a) * (b * b)))) - h;
    return float2(x,y);
}

METAL_FUNC float dis(float2 a,float2 b){
    return sqrt((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y));
}

METAL_FUNC float4 oneShade(float2 uv, float progress,float oneRadius, float4 oneColor){
    float2 center = getEllipse(1.0 - progress,0.4,1.0,0.4,0.5);
    float d = dis(center,uv);
    float radius = sin(oneRadius * progress + 0.4);
    
    float4 color = float4(0.0)* sin(1.0 - d/(radius));
    
    return (d < radius) ? mix(oneColor* (1.0 - d/(radius)),float4(0.0),smoothstep(0.3,1.0,progress)) + color : float4(0.0);
}


METAL_FUNC float4 twoShade(float2 uv, float progress, float twoRadius, float4 twoColor){
    float d = dis(float2(0.0,progress),uv);
    return (d < twoRadius) ? twoColor* sin (progress * 3.0)* (1.0 - d/twoRadius) : float4(0.0);
}

fragment float4 flareOverlayFragment( VertexOut vertexIn [[stage_in]],
                                     texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                     
                                     constant float4 & oneColor [[ buffer(0) ]],
                                     constant float & oneRadius [[ buffer(1) ]],
                                     constant float4 & twoColor [[ buffer(2) ]],
                                     constant float & twoRadius [[ buffer(3) ]],
                                     constant int & flareType [[ buffer(4) ]],

                                     constant float & ratio [[ buffer(5) ]],
                                     constant float & progress [[ buffer(6) ]])
{
    
    float2 uv = vertexIn.textureCoordinate;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    
    if (flareType == 1){
        return  getColor(uv,fromTexture,ratio,_fromR) + oneShade(uv,progress,oneRadius, oneColor);
    }else if (flareType == 2){
        return  getColor(uv,fromTexture,ratio,_fromR) + twoShade(uv,progress, twoRadius, twoColor);
        
    }
    
    return  getColor(uv,fromTexture,ratio,_fromR) + oneShade(uv,progress,oneRadius,oneColor) + twoShade(uv,progress,twoRadius, twoColor);
}
