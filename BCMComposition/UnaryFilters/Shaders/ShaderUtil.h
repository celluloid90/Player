//
//  ShaderUtil.h
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/3/23.
//

#ifndef ShaderUtil_h
#define ShaderUtil_h
#include <metal_stdlib>

using namespace metal;

//Random function borrowed from everywhere
METAL_FUNC float rand(float2 co){
    return fract(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
}

METAL_FUNC float2 pointInLine(float2 p, float2 q, float m, float n){
    float x = (m * p.x + n * q.x) / (m + n);
    float y = (m * p.y + n * q.y) / (m + n);
    
    return float2(x,y);
}

METAL_FUNC float drawLine(float2 p1, float2 p2,float2 p3, float thickness) {
    
    float2 p12 = p2 - p1;
    float2 p13 = p3 - p1;
    
    float d = dot(p12, p13) / length(p12);
    float2 p4 = p1 + normalize(p12) * d;
    
    if (length(p4 - p3) < thickness
        && length(p4 - p1) <= length(p12)
        && length(p4 - p2) <= length(p12)) {
        return 1.;
    }
    
    return 0.;
    
}


//    METAL_FUNC float2 zoom(float2 uv, float amount) {
//        return 0.5 + ((uv - 0.5) * (1.0-amount));
//    }
METAL_FUNC float2 zoom(float2 uv, float amount) {
    return 0.5 + ((uv - 0.5) * amount);
}

METAL_FUNC float2 rotate(float2 v, float a) {
    
    float2x2 rm = float2x2(cos(a), -sin(a),
                 sin(a), cos(a));
  return rm*v;
}

//return uv * float2x2(float2(cos(angle), -sin(angle)),
//                     float2(sin(angle), cos(angle)));

#endif /* ShaderUtil_h */
