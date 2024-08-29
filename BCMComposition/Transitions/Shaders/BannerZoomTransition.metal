//
//  BannerZoomTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

float drawLine(float2 p1, float2 p2,float2 uv,float thickness) {
    
    float a = abs(distance(p1, uv));
    float b = abs(distance(p2, uv));
    float c = abs(distance(p1, p2));
    
    if ( a >= c || b >=  c ) return 0.0;
    
    float p = (a + b + c) * 0.5;
    
    // median to (p1, p2) vector
    float h = 2. / c * sqrt( p * ( p - a) * ( p - b) * ( p - c));
    
    return mix(1.0, 0.0, smoothstep(0.5 * thickness, 1.5 * thickness, h));
}

fragment float4 BannerZoomTransitionFragment( VertexOut vertexIn [[stage_in]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],

                                        constant int & direction [[buffer(0)]],
                                        constant float & thickness [[buffer(1)]],
                                        constant float & zoomFactor [[buffer(2)]],
                                             constant float & ratio [[ buffer(3) ]],
                                             constant float & progress [[ buffer(4) ]]
){
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float time = progress * (2.0 + thickness + thickness) - thickness;
    
    float2 p1, p2 = float2(0.);
    
    float ext = thickness;
    
    if (direction == 0){
        if (progress <= 0.5){
            p1 = float2(-ext, time + ext );
            p2 = float2(time + ext, -ext);
        }else{
            p1 = float2(time - 1. - ext, 1. + ext);
            p2 = float2(1. + ext, time - 1. - ext);
        }
    }else{
        if (progress <= 0.5){
            p1 = float2(-ext, 1.0 - (time + ext) );
            p2 = float2((time + ext), (1.0 + ext));
        }else{
            p1 = float2(time - 1. - ext, -ext);
            p2 = float2(1. + ext,1.0 - (time - 1. - ext));
        }
    }
    
    if (drawLine(p1, p2,uv,thickness) == 1.0){
        return getToColor(zoom(uv, zoomFactor),toTexture,ratio,_toR);
    }else{
        return getFromColor(uv,fromTexture,ratio,_fromR);
    }
}
