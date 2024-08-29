//
//  TransformFilterWithMirror.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/3/23.
//

#include <metal_stdlib>
#include "MTFilterLib.h"

using namespace metalpetal;




fragment float4 TransformFilterWithMirrorFragment ( VertexOut vertexIn [[stage_in]],
                                                   texture2d<float, access::sample> sourceTexture [[texture(0)]],
                                                   sampler sourceSampler [[sampler(0)]],
                                                   constant float & ratio [[ buffer(0) ]],
                                                   constant float & intensity [[buffer(1)]]) {
    
    
    
    
    return float4(0);
}
