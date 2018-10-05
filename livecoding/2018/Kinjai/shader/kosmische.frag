/*{
    frameskip: 1,
    "audio": true,
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D spectrum;
uniform float volume;
uniform sampler2D backbuffer;
// uniform sampler2D osc_foo;      // OSC on /foo

vec2 rotate(in vec2 p, in float t) {
    return mat2(cos(t), -sin(t), sin(t), cos(t)) * p;
}
float random(in vec2 st) {
    return fract(abs(sin(dot(st, vec2(94.2984, 488.923))) * 234.9892));
}
float rects(in vec2 p, in float t) {
    return random(vec2(p.x * .0001 + t * .008, floor(p.y * 17.)));
}

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main() {
    vec2 uv = gl_FragCoord.xy/resolution.xy;
    vec3 col;
    float v = volume * 1.01; //sensitivity
    float hi = texture2D(spectrum, vec2(20)).r;


    col.r = abs(sin(uv.x * v + 3.0 + cos(uv.y * 4.0 + time * 5.0) * 0.5));
    col.g = abs(sin(uv.y * 3.0 + time * -1.0 + cos(uv.y * 1.2 + time * 6.0) * 0.5));
    col.b = abs(sin(uv.x * 1.0 + time * 1.0 + cos(uv.y * 4.5 + time * 7.0) * 0.5));
    col += uv.x*0.1;
    float bw = (col.r + col.g, + col.b)/ 3.;
    gl_FragColor=vec4(czm_saturation(col, .3), 1.0);
}
