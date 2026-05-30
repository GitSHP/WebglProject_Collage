#version 300 es
precision mediump float;

uniform vec4 uColor; // 기존의 색은 RGB 값만 받았지만 이번에는 불투명도를 포함해 4개의 값을 받아야하기 때문에 vec4를 사용한다

layout(location = 0) out vec4 fragColor;

void main()
{
    fragColor = uColor;
}