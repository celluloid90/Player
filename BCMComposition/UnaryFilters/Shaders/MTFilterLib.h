//
//  MTFilterLib.h
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/3/23.
//

#ifndef MTFilterLib_h
#define MTFilterLib_h

#define PI 3.141592653589
#define M_PI   3.14159265358979323846

#include <metal_stdlib>
#include "MTIShaderLib.h"
#include "ShaderUtil.h"

namespace metalpetal {

enum class ResizeMode { cover, contains, stretch };

METAL_FUNC float2 cover(float2 uv, float ratio, float r) {
    
    return 0.5 + (uv - 0.5) * float2(min(ratio/r, 1.0), min(r/ratio, 1.0));
}

//    METAL_FUNC float2 resize(ResizeMode mode, float ratio, float2 uv, float4 texture) {
//        if (mode == ResizeMode::cover) {
//
//        } else if (mode == ResizeMode::contains) {
//
//        } else {
//            return uv;
//        }
//        return float2(1.0);
//    }

METAL_FUNC float4 getColor(float2 uv, texture2d<float, access::sample> texture, float ratio, float _fromR) {
    constexpr sampler s(coord::normalized, address::clamp_to_edge, filter::linear);
    float2 _uv = cover(uv, ratio, _fromR);
    return texture.sample(s, _uv);
}

}

#endif /* MTFilterLib_h */
