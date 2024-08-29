//
//  CrossZoomFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/3/23.
//

#include <metal_stdlib>
#include "MTFilterLib.h"

using namespace metalpetal;


fragment float4 CrossZoomFilterFragment( VertexOut vertexIn [[stage_in]],
                                  texture2d<float, access::sample> sourceTexture [[texture(0)]],
                                  sampler sourceSampler [[sampler(0)]],
                                  constant float & ratio [[ buffer(0) ]],
                                  constant float & intensity [[buffer(1)]]) {
    
    
    float2 uv = vertexIn.textureCoordinate;
    //uv.y = 1.0 - uv.y;
    float toR = float(sourceTexture.get_width())/float(sourceTexture.get_height());
    
    float4 color = float4(0.0);
    float total = 0.0;
    float2 toCenter = float2(.5,.5) - uv;

    float offset = abs(length(float2(.5,.5)) - length(uv));

    for (float t = 0.0; t <= 20.0; t++) {
        float percent = (t + offset) / 40.0;
        float weight = 4.0 * (percent - percent * percent);
        color += getColor(uv + toCenter * percent * intensity,sourceTexture,ratio,toR) * weight;
        total += weight;
    }
    
    return color/total;
    
}

