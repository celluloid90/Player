// Author: Fernando Kuteken
// License: MIT

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

METAL_FUNC float getAngle(float angle,float2 center, float2 uv){
    float offset = angle * 3.141659 / 180.0;
    return (atan2( center.y - uv.y, center.x - uv.x) + offset);
}

METAL_FUNC float getReverseAngle(float angle,float2 center, float2 uv){
    float offset = (angle +( angle * 2. + 90.)) * 3.141659 / 180.0;
    return atan2(uv.x - center.x, uv.y - center.y)  + offset;
}

METAL_FUNC float normalizeAngle(float angle){
    float normalizedAngle = (angle + PI) / (2.0 * PI);
    return normalizedAngle - floor(normalizedAngle);
}

fragment float4 AngularFragment(VertexOut vertexIn [[ stage_in ]],
                                texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                constant float & startingAngle [[ buffer(0) ]],
                                constant float2 & center [[ buffer(1) ]],
                                constant int &direction [[ buffer(2) ]],
                                constant int &isTwoDirectional [[ buffer(3) ]],
                                
                                constant float & ratio [[ buffer(4) ]],
                                constant float & progress [[ buffer(5) ]],
                                
                                sampler textureSampler [[ sampler(0) ]])
{
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float p = progress;
    
    if (center.x != 0.5 || center.y != 0.5){
        p = progress / 4.0;
    }
    
    if (isTwoDirectional == 1){
        p = 0.5 + p/2;
    }
    
    float sAngle = 360. - startingAngle;
        
    float angle = 0.;
    
    if (direction == 0){
        angle = getAngle(sAngle,center,uv);
    }else{
        angle = getReverseAngle(sAngle,center,uv);
    }
    
    float normal = normalizeAngle(angle);
    
    float mixValue = step(normal, p);
    
    if (isTwoDirectional == 1){
        
        if (direction == 0){
            angle = getReverseAngle(sAngle,center,uv);
        }else{
            angle = getAngle(sAngle,center,uv);
        }
        
        normal = normalizeAngle(angle);
        mixValue *= step(normal,p);
    }
    
    return mix(
               getFromColor(uv,fromTexture,ratio,_fromR),
               getToColor(uv,toTexture,ratio,_toR),
               mixValue
               );
}

