//
//  HalfDirectionalSwipe.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;


fragment float4 HalfDirectionalWipeTransitionFragment( VertexOut vertexIn [[stage_in]],
                                                  texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                                  texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                                  constant float & direction [[ buffer(0) ]],
                                              constant float & ratio [[ buffer(5) ]],
                                              constant float & progress [[ buffer(6) ]])
{
    float2 p = vertexIn.textureCoordinate;
    p.y = 1.0 - p.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float4 a=getFromColor(p,fromTexture,ratio,_fromR);
    float4 b=getToColor(p,toTexture,ratio,_toR);
    
    if (direction == 0){
      if (p.y  < 0.5){
          return mix(a, b, step(p.x,progress) );
        }else{
          return mix(a, b, step(1. - p.x, progress) );
        }
    }else{
        if (p.x  < 0.5){
          return mix(a, b, step(p.y,progress) );
        }else{
          return mix(a, b, step(1. - p.y, progress) );
        }
    }
}
