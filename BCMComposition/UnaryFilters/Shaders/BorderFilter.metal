//
//  BorderFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

#include <metal_stdlib>
#include "MTFilterLib.h"

using namespace metalpetal;


bool isBorder(float2 uv,float borderWidth){
    return (uv.x < borderWidth || 1.0 - uv.x < borderWidth || uv.y < borderWidth || 1.0 - uv.y < borderWidth) || (uv.x * uv.y * (1.-uv.x) * (1.-uv.y) < pow(.15,4.));
}

fragment float4 BorderFilterFragment( VertexOut vertexIn [[stage_in]],
                                  texture2d<float, access::sample> sourceTexture [[texture(0)]],
                                  sampler sourceSampler [[sampler(0)]],
                                  constant float & borderWidth [[ buffer(0) ]],
                                        constant float4 & borderColor [[buffer(1)]],
                                     constant float & ratio [[ buffer(2) ]]

                                     ) {
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float toR = float(sourceTexture.get_width())/float(sourceTexture.get_height());
    
    return isBorder(uv,ratio) ? borderColor : getColor(uv,sourceTexture,ratio,toR);

}
