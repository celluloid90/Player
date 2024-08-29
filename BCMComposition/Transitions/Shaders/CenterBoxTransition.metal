//
//  CenterBoxFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;



fragment float4 CenterBoxTransitionFragment( VertexOut vertexIn [[stage_in]],
                                        texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
            
                                        constant float & radius [[buffer(0)]],
                                             constant float & angle [[buffer(1)]],

                                             constant float2 & center [[buffer(2)]],
                                            constant float & ratio [[ buffer(3) ]],
                                            constant float & progress [[ buffer(4) ]]
){

    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float rot = angle * PI / 180.0;
    
    float2 suv = rotate(float2(uv.x * xRatio(ratio), uv.y * yRatio(ratio)), rot);

    float2 cen = rotate(float2(center.x * xRatio(ratio), center.y * yRatio(ratio)),rot);

    if (abs(cen.x - suv.x) < radius * xRatio(ratio) /2. && abs(cen.y - suv.y) < radius * yRatio(ratio)/2.){
        
     return getToColor(uv,toTexture,ratio,_toR);

   }else{
       
     return getFromColor(uv,fromTexture,ratio,_fromR);

   }
}

