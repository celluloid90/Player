//
//  LineDrawOutTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

METAL_FUNC float2 pointInLine(float2 p, float2 q, float m, float n){
    float x = (m * p.x + n * q.x) / (m + n);
    float y = (m * p.y + n * q.y) / (m + n);
    
    return float2(x,y);
}

METAL_FUNC float drawLine(float2 p1, float2 p2,float2 p3, float thickness) {
    
    float2 p12 = p2 - p1;
    float2 p13 = p3 - p1;
    
    float d = dot(p12, p13) / length(p12);
    float2 p4 = p1 + normalize(p12) * d;
    
    if (length(p4 - p3) < thickness
        && length(p4 - p1) <= length(p12)
        && length(p4 - p2) <= length(p12)) {
        return 1.;
    }
    
    return 0.;
    
}

fragment float4 LineDrawOutFragment( VertexOut vertexIn [[stage_in]],
                                    texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                    texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                    constant float & ratio [[ buffer(0) ]],
                                    constant float & progress [[buffer(1)]],
                                    constant float2 & p1 [[buffer(2)]],
                                    constant float2 & p2 [[buffer(3)]],
                                    constant float & thickness [[buffer(4)]]

                                    ){
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float m = smoothstep(0.,0.2,progress) ;
    float n = 1.0 - m;
    
    float thick = thickness +  smoothstep(0.2,0.6,progress);
    
    if (drawLine(p1,pointInLine(p1,p2,n,m) ,uv,thick) == 1.0){
        return getToColor(uv,toTexture,ratio,_toR);
    }else{
        return getFromColor(uv,fromTexture,ratio,_fromR);
    }
    
    
}

