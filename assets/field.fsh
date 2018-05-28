//
// Field描画用
//
$version$
$precision$

uniform sampler2DShadow uShadowMap;

in vec4 vColor;
in vec4 vShadowCoord;

// NOTICE カメラのViewMatrixで変換
uniform vec4 uLightPosition;

uniform float uAmbient;
uniform float uShininess;
uniform vec4 uSpecular;

uniform vec4 u_color; 

uniform float uDiffusePower;

in vec4 vPosition;
in vec3 vNormal;

out vec4 Color;


void main(void)
{
	vec4 ShadowCoord = vShadowCoord / vShadowCoord.w;
	float shadow = 1.0;
	
	// if ( ShadowCoord.z > -1 && ShadowCoord.z < 1 )
  {
		shadow = mix(0.0, 1.0, textureProj(uShadowMap, ShadowCoord, -0.0005));
	}

  // ライティング
  vec3 light   = normalize(uLightPosition.xyz * vPosition.w - vPosition.xyz * uLightPosition.w);
  vec3 view    = -normalize(vPosition.xyz);
  vec3 fnormal = normalize(vNormal);

  // 平行光源+影
  float diffuse = max(dot(light, fnormal) * shadow * uDiffusePower, uAmbient);

  // スペキュラは反射ベクトルを求める方式
  vec3 reflect    = reflect(-light, fnormal);
  float specular  = pow(max(dot(reflect, view), 0.0), uShininess);
  vec4 spec_color = uSpecular * specular;

	Color = (vColor * diffuse + spec_color) * u_color;
}
