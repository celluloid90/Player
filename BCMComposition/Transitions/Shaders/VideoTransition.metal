//
//  VideoTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 2/4/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;


fragment float4 VideoTransitionFragment( VertexOut vertexIn [[stage_in]],
                                                      texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                                      texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                                      texture2d<float, access::sample> vTexture [[ texture(2) ]],
                                                      
                                                      constant float & ratio [[ buffer(0) ]],
                                                      constant float & progress [[ buffer(1) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    float _vR = float(vTexture.get_width())/float(vTexture.get_height());
    
    
    if (all(getToColor(float2(uv.x, 1.0 - uv.y), vTexture, ratio, _vR) > float4(0.8))){
        return getFromColor(uv, fromTexture, ratio, _fromR);
    }else{
        return getToColor(uv, toTexture, ratio, _toR);
    }
    
}
