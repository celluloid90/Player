//
//  SwipeFromMiddleTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 SwipeFromMiddleTransitionFragment( VertexOut vertexIn [[stage_in]],
                                          texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                          texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                          constant int & direction [[ buffer(0) ]],
                                          
                                          constant float & ratio [[ buffer(1) ]],
                                          constant float & progress [[ buffer(2) ]])

{
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float dis = 0.;
    
    if (direction == 0){
        dis = abs(0.5 - uv.x);
    }else{
        dis = abs (0.5 - uv.y);
    }
    
    if (dis < progress/2.){
        return getToColor(uv,toTexture,ratio,_toR);
    }else{
        return getFromColor(uv,fromTexture,ratio,_fromR);
    }
    
    return float4(1);
}
