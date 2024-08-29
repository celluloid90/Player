//
//  TwoTriangleTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

float mysign (float2 p1, float2 p2, float2 p3)
{
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

float pointInTriangle (float2 pt, float2 v1, float2 v2, float2 v3,float angle, float sRatio)
{
    
    if (all (v1 == v2) && all(v2 == v3)){
        return 0.0;
    }
    
    float rot = angle * 3.1416 / 180.0;
    
    pt -= 0.5;
    pt = rotate(float2(pt.x * sRatio, pt.y ),rot);
    pt += 0.5;
    
    float d1, d2, d3;
    bool has_neg, has_pos;
    
    d1 = mysign(pt, v1, v2);
    d2 = mysign(pt, v2, v3);
    d3 = mysign(pt, v3, v1);
    
    has_neg = (d1 < 0.) || (d2 < 0.) || (d3 < 0.);
    has_pos = (d1 > 0.) || (d2 > 0.) || (d3 > 0.);
    
    return !(has_neg && has_pos) ? 1.0 : 0.0 ;
}

float2 pointInLine(float2 p, float2 q, float m, float n){
    float x = (m * p.x + n * q.x) / (m + n);
    float y = (m * p.y + n * q.y) / (m + n);
    
    return float2(x,y);
}


fragment float4 TwoTriangleTransitionFragment( VertexOut vertexIn [[stage_in]],
                                                  texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                                  texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                                  constant float & angle [[ buffer(0) ]],
                                              constant float2 & center [[ buffer(1) ]],

                                                  constant float2 & a [[ buffer(2) ]],
                                                  constant float2 & b [[ buffer(3) ]],
                                                  constant float2 & c [[ buffer(4) ]],

                                                  constant float & ratio [[ buffer(5) ]],
                                                  constant float & progress [[ buffer(6) ]])

{
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    
    float m = smoothstep(0.,0.2,progress) * 0.5;
    float n = 1.0 - m;
    
    if (progress > 0.55){
        m = m + smoothstep(0.55,0.7,progress) * 4.;
        n = 1.0 -m;
    }
    
    float2 A = pointInLine(a,center,m,n);
    float2 B = pointInLine(b,center,m,n);
    float2 C = pointInLine(c,center,m,n);
    
    float degree = angle;
    degree = degree + smoothstep(0.4,0.5,progress) * 10.;
    
    float fTri = pointInTriangle(float2(uv.x ,uv.y),A,B,C,smoothstep(0.2,0.4,progress) * degree,ratio);
    
    m = smoothstep(0.1,0.2,progress) * 0.5;
    n = 1.0 - m;
    
    if (progress > 0.55){
        m = m + smoothstep(0.6,0.8,progress) * 4.;
        n = 1.0 -m;
    }
    
    A = pointInLine(a,center,m,n);
    B = pointInLine(b,center,m,n);
    C = pointInLine(c,center,m,n);
    degree = angle;
    degree = degree + smoothstep(0.45,0.55,progress) * 10.;
    
    float sTri = pointInTriangle(float2(uv.x,uv.y),A,B,C,smoothstep(0.27,0.4,progress) * degree,ratio);
    
    float4 color = getToColor(uv,toTexture,ratio,_toR);
    
    if (fTri + sTri > 0.0){
        
        color = mix(color,float4(1.0),0.3);
        return mix(color,getToColor(uv,toTexture,ratio,_toR),step(fTri,1.0) * step(1.0,sTri));
        
    }
    
    return getFromColor(uv,fromTexture,ratio,_fromR);
    
}

