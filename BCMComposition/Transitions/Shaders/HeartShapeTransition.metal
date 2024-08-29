//
//  HeartShapeFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

float getHeartShape(float2 p,float2 center,float radius){
    p.x = p.x - center.x;
    p *= 0.8;
    p.y = -0.1 - p.y*1.1 + abs(p.x)*(1.0-abs(p.x)) + center.y;
    
    float r = length(p);
    
    return smoothstep( -0.001, 0.001, radius - r);
}

fragment float4 HeartShapeTransitionFragment( VertexOut vertexIn [[stage_in]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                        
                                        constant float & ratio [[ buffer(0) ]],
                                        constant float & progress [[ buffer(1) ]],

                                        constant float & radius [[buffer(2)]],
                                        constant float2 & center [[buffer(3)]])
{
    
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    return mix(getFromColor(uv,fromTexture,ratio,_fromR), getToColor(uv,toTexture,ratio,_toR),getHeartShape(float2(uv.x * ratio, uv.y),float2(center.x * ratio  , center.y),radius));
    
}




