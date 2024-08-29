//
//  BCMBlendMaskFilter.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 13/7/23.
//

#include <metal_stdlib>
#include "MTFilterLib.h"

using namespace metalpetal;


fragment float4 BCMBlendMaskFilterFragment( VertexOut vertexIn [[stage_in]],
                                          texture2d<float, access::sample> input [[ texture(0) ]],
                                          texture2d<float, access::sample> background [[ texture(1) ]],
                                           texture2d<float, access::sample> mask [[ texture(2) ]],

                                          constant int & maskComponent [[ buffer(0) ]],
                                           constant float & intensity [[ buffer(1) ]],
                                           constant float & ratio [[ buffer(2) ]]

                                          ){
    
    float2 p = vertexIn.textureCoordinate;
    p.y = 1.0 - p.y;
    
    float inR = float(input.get_width())/float(input.get_height());
    float bgR = float(background.get_width())/float(background.get_height());
    float maskR = float(mask.get_width())/float(mask.get_height());
    
    if (getColor(p, mask, ratio, maskR)[maskComponent] > 0.09){
        return mix(getColor(p, background, ratio, bgR), getColor(p, input, ratio, inR), intensity);
    }
    
    return getColor(p, input, ratio, inR);
}
