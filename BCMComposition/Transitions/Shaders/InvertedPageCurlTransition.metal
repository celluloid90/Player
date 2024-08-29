//
//  InvertedPageCurlTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

constant float MIN_AMOUNT = -0.16;
constant float MAX_AMOUNT = 1.5;

constant float scale = 512.0;
constant float sharpness = 3.0;

//float cylinderCenter = amount;
//// 360 degrees * amount
//float cylinderAngle = 2.0 * PI * amount;
struct GloblalInfo{
    texture2d<float, access::sample> fromTexture;
    texture2d<float, access::sample> toTexture;

    float ratio;
    float _fromR;
    float _toR;
    
    float progress;
};

constant float cylinderRadius = 1.0 / PI / 2.0;

METAL_FUNC float getAmount(float progress){
    return progress * (MAX_AMOUNT - MIN_AMOUNT) + MIN_AMOUNT;
}

METAL_FUNC float3 hitPoint(float hitAngle, float yc, float3 point, float3x3 rrotation)
{
        float hitPoint = hitAngle / (2.0 * PI);
        point.y = hitPoint;
        return rrotation * point;
}

METAL_FUNC float4 antiAlias(float4 color1, float4 color2, float distanc)
{
        distanc *= scale;
        if (distanc < 0.0) return color2;
        if (distanc > 2.0) return color1;
        float dd = pow(1.0 - distanc / 2.0, sharpness);
        return ((color2 - color1) * dd) + color1;
}

METAL_FUNC float distanceToEdge(float3 point)
{
        float dx = abs(point.x > 0.5 ? 1.0 - point.x : point.x);
        float dy = abs(point.y > 0.5 ? 1.0 - point.y : point.y);
        if (point.x < 0.0) dx = -point.x;
        if (point.x > 1.0) dx = point.x - 1.0;
        if (point.y < 0.0) dy = -point.y;
        if (point.y > 1.0) dy = point.y - 1.0;
        if ((point.x < 0.0 || point.x > 1.0) && (point.y < 0.0 || point.y > 1.0)) return sqrt(dx * dx + dy * dy);
        return min(dx, dy);
}

METAL_FUNC float4 seeThrough(float yc, float2 p, float3x3 rotation, float3x3 rrotation,GloblalInfo globalInfo)
{
    float cylinderAngle = 2.0 * PI * getAmount(globalInfo.progress);
        float hitAngle = PI - (acos(yc / cylinderRadius) - cylinderAngle);
        float3 point = hitPoint(hitAngle, yc, rotation * float3(p, 1.0), rrotation);
        if (yc <= 0.0 && (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0))
        {
            return getToColor(p,globalInfo.toTexture, globalInfo.ratio, globalInfo._toR);
        }

        if (yc > 0.0) return getFromColor(p, globalInfo.fromTexture, globalInfo.ratio, globalInfo._fromR);

        float4 color = getFromColor(point.xy, globalInfo.fromTexture, globalInfo.ratio, globalInfo._fromR);
        float4 tcolor = float4(0.0);

        return antiAlias(color, tcolor, distanceToEdge(point));
}

METAL_FUNC float4 seeThroughWithShadow(float yc, float2 p, float3 point, float3x3 rotation, float3x3 rrotation, GloblalInfo globalInfo)
{
        float shadow = distanceToEdge(point) * 30.0;
        shadow = (1.0 - shadow) / 3.0;

        if (shadow < 0.0) shadow = 0.0; else shadow *= getAmount(globalInfo.progress);

        float4 shadowColor = seeThrough(yc, p, rotation, rrotation, globalInfo);
        shadowColor.r -= shadow;
        shadowColor.g -= shadow;
        shadowColor.b -= shadow;

        return shadowColor;
}

METAL_FUNC float4 backside(float yc, float3 point, GloblalInfo globalInfo)
{
        float4 color = getFromColor(point.xy, globalInfo.fromTexture, globalInfo.ratio, globalInfo._fromR);
        float gray = (color.r + color.b + color.g) / 15.0;
        gray += (8.0 / 10.0) * (pow(1.0 - abs(yc / cylinderRadius), 2.0 / 10.0) / 2.0 + (5.0 / 10.0));
        color.rgb = float3(gray);
        return color;
}

METAL_FUNC float4 behindSurface(float2 p, float yc, float3 point, float3x3 rrotation, GloblalInfo globalInfo)
{
        float amount = getAmount(globalInfo.progress);
        float cylinderAngle = 2.0 * PI * amount;

        float shado = (1.0 - ((-cylinderRadius - yc) / amount * 7.0)) / 6.0;
        shado *= 1.0 - abs(point.x - 0.5);

        yc = (-cylinderRadius - cylinderRadius - yc);

        float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;
        point = hitPoint(hitAngle, yc, point, rrotation);

        if (yc < 0.0 && point.x >= 0.0 && point.y >= 0.0 && point.x <= 1.0 && point.y <= 1.0 && (hitAngle < PI || amount > 0.5))
        {
                shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / (71.0 / 100.0));
                shado *= pow(-yc / cylinderRadius, 3.0);
                shado *= 0.5;
        }
        else
        {
                shado = 0.0;
        }
        return float4(getToColor(p, globalInfo.toTexture, globalInfo.ratio, globalInfo._toR).rgb - shado, 1.0);
}

fragment float4 InvertedPageCurlTransitionFragment( VertexOut vertexIn [[stage_in]],
                                          texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                          texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                          constant int & direction [[ buffer(0) ]],
                                          
                                          constant float & ratio [[ buffer(1) ]],
                                          constant float & progress [[ buffer(2) ]])

{
    
    float2 p = vertexIn.textureCoordinate;
    p.y = 1.0 - p.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    GloblalInfo globalInfo;
    globalInfo.fromTexture = fromTexture;
    globalInfo.toTexture = toTexture;
    globalInfo.ratio = ratio;
    globalInfo._fromR = _fromR;
    globalInfo._toR = _toR;
    globalInfo.progress = progress;
    
    float amount = getAmount(progress);
    float cylinderAngle = 2.0 * PI * amount;
    
    const float angle = 100.0 * PI / 180.0;
          float c = cos(-angle);
          float s = sin(-angle);

      float3x3 rotation = float3x3( c, s, 0,
                                                                  -s, c, 0,
                                                                  -0.801, 0.8900, 1
                                                                  );
          c = cos(angle);
          s = sin(angle);

      float3x3 rrotation = float3x3(    c, s, 0,
                                                                          -s, c, 0,
                                                                          0.98500, 0.985, 1
                                                                  );

          float3 point = rotation * float3(p, 1.0);

          float yc = point.y - getAmount(progress);

          if (yc < -cylinderRadius)
          {
                  // Behind surface
                  return behindSurface(p,yc, point, rrotation, globalInfo);
          }

          if (yc > cylinderRadius)
          {
                  // Flat surface
                  return getFromColor(p,fromTexture, ratio, _fromR);
          }

          float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;

          float hitAngleMod = mod(hitAngle, 2.0 * PI);
          if ((hitAngleMod > PI && amount < 0.5) || (hitAngleMod > PI/2.0 && amount < 0.0))
          {
                  return seeThrough(yc, p, rotation, rrotation,globalInfo);
          }

          point = hitPoint(hitAngle, yc, point, rrotation);

          if (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0)
          {
                  return seeThroughWithShadow(yc, p, point, rotation, rrotation,globalInfo);
          }

          float4 color = backside(yc, point,globalInfo);

          float4 otherColor;
          if (yc < 0.0)
          {
                  float shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / 0.71);
                  shado *= pow(-yc / cylinderRadius, 3.0);
                  shado *= 0.5;
                  otherColor = float4(0.0, 0.0, 0.0, shado);
          }
          else
          {
                  otherColor = getFromColor(p,fromTexture, ratio, _fromR);
          }

          color = antiAlias(color, otherColor, cylinderRadius - abs(yc));

          float4 cl = seeThroughWithShadow(yc, p, point, rotation, rrotation, globalInfo);
          float dist = distanceToEdge(point);

          return antiAlias(color, cl, dist);
    
}

