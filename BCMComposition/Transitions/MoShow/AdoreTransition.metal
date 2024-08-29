//
//  AdoreTransition.metal
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/8/23.
//

#include <metal_stdlib>
#include "MTTransitionLib.h"

using namespace metalpetal;

METAL_FUNC float getSine(float theta){
  return sin(0.5*PI*theta);
}

METAL_FUNC matrix_float2x2 getRotationMatrix(float per){

  float theta = per*PI*0.5;

  return matrix_float2x2(cos(theta),sin(theta),-sin(theta),cos(theta));
}

METAL_FUNC float4 Heart(float2 uv,float r){
  uv.x *= 0.75;
  if(r > 0.3) uv.y -= sqrt(abs(uv.x))*0.6;
  else uv.y -= sqrt(abs(uv.x))*0.25;
  float d = length(uv);
  float c = step(r,d);
  return float4(1.0-c);
}

METAL_FUNC float2 getCenter(int pos, float ps){

  float x = 0.0;
  float y = 0.0;

  if(pos == 10){
    x = -0.25 + 1.5*ps;
    y = 0.4 + 0.2*ps;
  }
  else if(pos == 11){
    x = 0.6 - 0.15*sin(0.5*PI*ps);
    y = 0.5 - 0.7*ps;
  }
  else if(pos == 12){
    x = 0.3;
    y = 0.8 - 0.5*ps;
  }
  else if(pos == 13){
    x = -0.5 + 1.0*ps;
    y = 0.2;
  }
  else if(pos == 14){
    x = 0.8 - 0.3*ps;
    y = 0.8 - 0.2*ps;
  }
  else if(pos == 15){
    x = 0.8 - 0.2*ps;
    y = 0.35*ps;
  }
  else if(pos == 16){
    x = -0.5 + 0.8*ps;
    y = -0.5 + 0.8*ps;
  }
  else if(pos == 17){
    x = -0.5 + 0.9*ps;
    y = 0.5 + 0.1*ps;
  }
  else if(pos == 18){
    x = 0.2 + 0.2*ps;
    y = 2.1 - 1.9*ps;
  }

  return float2(x,y);
}

METAL_FUNC float2 getPositionForHeart(matrix_float2x2 mul,float2 uv,int pos, float ps){

  float theta = ps;

  if(pos == 10 || pos == 15) theta = (1.0-ps)*-0.3;
  else if(pos == 11 || pos == 14 || pos == 17) theta = (1.0-ps)*0.3;
  else if(pos == 12) theta = (1.0-ps)*0.6;
  else if(pos == 13 || pos == 16) theta = -0.5;
  else if(pos == 18){
    if(ps < 0.5) theta = 0.5;
    else theta = (1.0 - ((ps - 0.5) / 0.5))*0.5;
  }

  return getRotationMatrix(theta)*mul*(uv - getCenter(pos,ps));
}

METAL_FUNC float getRadius(int pos, float ps){

  if(pos == 10) return 0.05 + ps*0.05;
  else if(pos == 11 || pos == 12 || pos == 14) return 0.1*ps;
  else if(pos == 13) return 0.1 + 0.1*ps;
  else if(pos == 15) return 0.2*ps;
  else if(pos == 16) return 0.15;
  else if(pos == 17) return 0.1 + 0.05*ps;
  else if(pos == 18) return 0.2 + 0.4*ps;

  return 0.0;
}

METAL_FUNC float4 getBiasedColor(float4 col,int pos, float ps){
  // 0 is red and 1 is trans
  if(pos != 0){
    float m;
    if(ps > 0.7){
      m = (ps - 0.7) / 0.3;
    }
    else m = 0.0;

    float grey = dot(col.rgb,float3(0.2125, 0.7154, 0.0721));

    return float4(float3(1.0,0.5,0.5) * grey,1.0);
  }

  return col;
}

METAL_FUNC float2 getRotatedPos(float2 uv,float theta){
  uv -= 0.5;
  uv = getRotationMatrix(theta)*uv;
  uv += 0.5;
  return uv;
}

// 10 - 13 trans, 14 - 17 red, 18 big red

METAL_FUNC float4 getHeartColor(float2 uv,float theta,int pos, float ps){
  return Heart(getPositionForHeart(
      getRotationMatrix(
        theta),getRotatedPos(uv,-theta),pos,ps
      ),
      getRadius(pos, ps)
    );
}

fragment float4 adoreTransitionFragment( VertexOut vertexIn [[stage_in]],
                                                  texture2d<float, access::sample> fromTexture [[ texture(0) ]],
                                        texture2d<float, access::sample> toTexture [[ texture(1) ]],
                                        constant matrix_float4x4 & rot [[ buffer(0) ]],
                                                      
                                              constant float & ratio [[ buffer(1) ]],
                                                      constant float & progress [[ buffer(2) ]])
{
    
    float2 uv = vertexIn.textureCoordinate;
    uv.y = 1.0 - uv.y;
    float _fromR = float(fromTexture.get_width())/float(fromTexture.get_height());
    float _toR = float(toTexture.get_width())/float(toTexture.get_height());
    
    float ps = getSine(getSine(progress));
  
    float4 c = getFromColor(uv,fromTexture,ratio,_fromR);
    float4 h,to;
  
    for(int i = 0; i<9; i++){
      to = getBiasedColor(getToColor(uv,toTexture, ratio, _toR),int(i > 3), ps);
      h = getHeartColor(float2(uv.x,uv.y/ratio),rot[i/4][(i - (i/4)*4)],i+10,ps);
      c = mix(mix(c,h,h.a),to,h.a);
    }
  
    if(ps > 0.8){
      float pro = (ps - 0.8) / 0.2;
      c = mix(c,getToColor(uv,toTexture, ratio, _toR),pro);
    }
    return c;
    
}

