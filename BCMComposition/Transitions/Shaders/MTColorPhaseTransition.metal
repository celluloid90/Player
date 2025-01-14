// Author: gre
// License: MIT

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

fragment float4 ColorPhaseFragment(VertexOut vertexIn [[ stage_in ]],
                                   texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                   texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                   constant float4 & fromStep [[ buffer(0) ]],
                                   constant float4 & toStep [[ buffer(1) ]],
                                   constant float & ratio [[ buffer(2) ]],
                                   constant float & progress [[ buffer(3) ]],
                                   sampler textureSampler [[ sampler(0) ]])
{
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float4 a = getFromColor(uv, fromTexture, ratio, _fromR);
    float4 b = getFromColor(uv, toTexture, ratio, _toR);
    return mix(a, b, smoothstep(fromStep, toStep, float4(progress)));
}

