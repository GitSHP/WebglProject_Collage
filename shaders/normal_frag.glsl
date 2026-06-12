#version 300 es

precision mediump float;

uniform sampler2D texImage, normalMap;
uniform vec3 matSpec, matAmbi, matEmit; // 재질
uniform float matSh;
uniform vec3 srcDiff, srcSpec, srcAmbi; // 광원 (srcDiff = 난반사됐을 때 보이는 전체적인 빛, srcSpec = 정반사됐을 때 나타나는 반짝이는 하이라이트 부분)
uniform vec3 lightDir; // directional Light, 빛의 위치 값을 저장하는 변수, 이 변수는 배열로 관리할 수 있다

// 안개 쉐이더 추가를 위한 코드
uniform vec3 eyePos;
uniform float fogStart, fogEnd, fogColor; // 안개

in vec3 fViewTS, fLightTS, fNormal, worldPos;
in vec2 fTexCoord;

layout(location = 0) out vec4 fragColor;

void main()
{
    // normalization
    vec3 normal = normalize(2.0 * texture(normalMap, fTexCoord).xyz - 1.0);
    vec3 view = normalize(fViewTS);
    vec3 light = normalize(fLightTS);

    // diffuse term
    vec3 matDiff = texture(texImage, fTexCoord).rgb;
    vec3 diff = max(dot(normal, light), 0.0) * srcDiff * matDiff;

    // specular term
    // vec3 refl = 2.0 * normal * dot(normal, light) - light; 
    // vec3 spec = pow(max(dot(refl, view), 0.0), matSh) * srcSpec * matSpec;
    // Phong Model 
    // -> 퐁 모델은 수학적 계산했을 때 큐브의 어두운 부분에 빛의 하이라이트 부분이 보인다. 
    // 수학적으로 오류는 아니지만 현실적이지 못하기 때문에 Blinn Model을 사용함

    vec3 halfv = normalize(light + view);
    vec3 spec = pow(max(dot(normal, halfv), 0.0), matSh) * srcSpec * matSpec;
    // Blinn Model

    // ambient term
    vec3 ambi = srcAmbi * matAmbi;

    // 임시 코드 - 벽의 테두리에 검은색 선분을 그려 칸 마다 구별하기 쉽도록 함 - AI
    // float edgeThreshold = 0.02;
    // if (fTexCoord.x < edgeThreshold || fTexCoord.x > 1.0 - edgeThreshold ||
    //    fTexCoord.y < edgeThreshold || fTexCoord.y > 1.0 - edgeThreshold) {
    //    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    //    return;
    // }

    // 벽에도 안개 적용을 위한 코드
    float fogDepth = length(eyePos - worldPos);
    float fogFactor = smoothstep(fogStart, fogEnd, fogDepth);
    vec3 fColor = mix((diff + spec + ambi + matEmit), vec3(fogColor), fogFactor);

    fragColor = vec4(fColor, 1.0);

    // fragColor = vec4(diff + spec + ambi + matEmit, 1.0);

    // fragColor = texture(texImage, fTexCoord); 
	// fragColor = vec4(fTexCoord, 1, 1);

    // 그림을 렌더링할 때 그 그림의 크기(한림대 로고의 경우 128 x 128)에 따라서 계단 현상 (앨리어싱)이 나타날 수 있다
    // 이 계단 현상을 최소화하기 위해서는 gl.NEAREST -> gl.LINEAR로 변경한다
}