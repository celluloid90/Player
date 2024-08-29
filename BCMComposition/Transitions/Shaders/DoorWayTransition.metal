//
//  DoorWayTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

constant float4 black = float4(0.0, 0.0, 0.0, 1.0);
constant float2 boundMin = float2(0.0, 0.0);
constant float2 boundMax = float2(1.0, 1.0);

METAL_FUNC bool inBounds (float2 p) {
    
  return all(boundMin < p) && all(p < boundMax);
}

float2 project (float2 p) {
  return p * float2(1.0, -1.2) + float2(0.0, -0.02);
}

fragment float4 DoorWayTransitionFragment( VertexOut vertexIn [[stage_in]],
                                    texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                    texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                    
                                    constant float & reflection [[ buffer(0) ]],
                                    constant float & perspective [[ buffer(1) ]],
                                    constant float & depth [[ buffer(2) ]],
                                    
                                    
                                    constant float & ratio [[ buffer(3) ]],
                                    constant float & progress [[ buffer(4) ]]
                                    ){
    float2 p = vertexIn.textureCoordinate;
    p.y = 1.0 - p.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float2 pfr = float2(-1.), pto = float2(-1.);
    float middleSlit = 2.0 * abs(p.x-0.5) - progress;
    if (middleSlit > 0.0) {
      pfr = p + (p.x > 0.5 ? -1.0 : 1.0) * float2(0.5*progress, 0.0);
      float d = 1.0/(1.0+perspective*progress*(1.0-middleSlit));
      pfr.y -= d/2.;
      pfr.y *= d;
      pfr.y += d/2.;
    }
    float size = mix(1.0, depth, 1.-progress);
     pto = (p + float2(-0.5, -0.5)) * float2(size, size) + float2(0.5, 0.5);
    
    if (inBounds(pfr)) {
      return getFromColor(pfr,fromTexture, ratio,_fromR);
    }
    else if (inBounds(pto)) {
      return getToColor(pto, toTexture, ratio, _toR);
    }
    else {
        
        float4 c = black;
        pto = project(pto);
       if (inBounds(pto)) {
         c += mix(black, getToColor(pto,toTexture,ratio,_toR), reflection * mix(1.0, 0.0, pto.y));
       }
        
      return c;
    }
    
}
