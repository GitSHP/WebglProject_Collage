#version 300 es

precision mediump float;

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vNormal; // 법선 벡터
layout(location = 2) in vec2 vTexCoord; // 이미지 텍스처 좌표
layout(location = 3) in vec3 vTangent;  // 탄젠트 스페이스

out vec3 fViewTS, fLightTS, fNormal, worldPos;
out vec2 fTexCoord;

uniform mat4 worldMat, viewMat, projMat;
uniform vec3 eyePos, lightDir;

void main()
{
    // normal 벡터와 tangent 벡터는 현재 오브젝트 공간에 있기 때문에 월드 공간으로 변환하기 위한 다음과 같은 계산이 필요하다
    vec3 normal = normalize(transpose(inverse(mat3(worldMat))) * vNormal);
    vec3 tangent = normalize(transpose(inverse(mat3(worldMat))) * vTangent);
    vec3 bitangent = normalize(cross(normal, tangent));
    mat3 tbnMat = transpose(mat3(tangent, bitangent, normal));

    worldPos = (worldMat * vec4(vPosition, 1)).xyz;

    fViewTS = tbnMat * normalize(eyePos - worldPos);
    fLightTS = tbnMat * normalize(lightDir);

    gl_Position = projMat * viewMat * vec4(worldPos, 1.0);
    fTexCoord = vTexCoord;
}