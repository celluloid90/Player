//
//  BorderSwipe.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 27/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 BorderSwipeFragment( VertexOut vertexIn [[stage_in]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
            
                                        constant float2 & dir [[buffer(0)]],
                                             constant float & len [[buffer(1)]],

                                            constant float & ratio [[ buffer(3) ]],
                                            constant float & progress [[ buffer(4) ]]
){
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float4 color = float4(0);
     
      if(dir.x == 0. && dir.y == 0.){
        if (uv.x < progress + len){
          color = getToColor(uv,toTexture,ratio,_toR);
          if (uv.x > progress) {
          color =  float4(0.9);
          }
        }
        else{
          color = getFromColor(uv,fromTexture,ratio,_fromR);
        }
      } else if (dir.x == 1. && dir.y == 0.){
        if (uv.x > (1.0 - progress) - len){
          color = getToColor(uv,toTexture,ratio,_toR);
          if (uv.x < (1.0 - progress)) {
          color =  float4(0.9);
          }
        }
        else{
          color = getFromColor(uv,fromTexture,ratio,_fromR);
        }
      }else if(dir.x == 0. && dir.y == 1.){
        if (uv.y < progress + len){
          color = getToColor(uv,toTexture,ratio,_toR);
          if (uv.y > progress) {
          color =  float4(0.9);
          }
        }
        else{
          color = getFromColor(uv,fromTexture,ratio,_fromR);
        }
      }else if (dir.x == 1. && dir.y == 1.){
         if (uv.y > (1.0 - progress) - len){
          color = getToColor(uv,toTexture,ratio,_toR);
          if (uv.y < (1.0 - progress)) {
          color =  float4(0.9);
          }
        }
        else{
          color = getFromColor(uv,fromTexture,ratio,_fromR);
        }
      }
     
    return color;
}
