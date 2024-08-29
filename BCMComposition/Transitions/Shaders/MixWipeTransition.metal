//
//  MixWipeFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;


fragment float4 MixWipeTransitionFragment( VertexOut vertexIn [[stage_in]],
                                          texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                          texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                          
                                          constant float & width [[ buffer(0) ]],
                                          constant int & direction [[ buffer(1) ]],
                                          constant float & ratio [[ buffer(2) ]],
                                          constant float & progress [[ buffer(3) ]]
                                          ){
    
    float2 p = vertexIn.textureCoordinate;
    p.y = 1.0 - p.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 a=getFromColor(p,fromTexture,ratio,_fromR);
    float4 b=getToColor(p,toTexture,ratio,_toR);
    
    float q = p.x;
    if (direction != 0){
        q = p.y;
    }
    
    float m = smoothstep(q  ,q + width ,progress + smoothstep(0.,1.0,progress) * width);
    
    return mix(a, b, m );
}
