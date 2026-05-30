#version 300 es

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vNormal; // 법선 벡터
layout(location = 2) in vec2 vTexCoord; // 이미지 텍스처 좌표

out vec3 fNormal, fView;
out vec2 fTexCoord;
uniform mat4 worldMat, viewMat, projMat;
uniform vec3 eyePos;

void main()
{
    fNormal = normalize(transpose(inverse(mat3(worldMat))) * normalize(vNormal));   
    vec3 worldPos = (worldMat * vec4(vPosition, 1)).xyz;
    fView = normalize(eyePos - worldPos);
    gl_Position = projMat * viewMat * vec4(worldPos, 1.0);
    fTexCoord = vTexCoord;
}