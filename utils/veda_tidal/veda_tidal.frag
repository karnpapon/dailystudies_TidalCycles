/* { "osc": 4567, "audio": true } */
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
uniform sampler2D osc_bd;
uniform sampler2D osc_sd;
uniform sampler2D osc_hh;
uniform sampler2D osc_bass;
uniform sampler2D osc_cycle;
uniform sampler2D samples;
uniform sampler2D spectrum;
vec2 rotate(in vec2 p, in float t) {
    return mat2(cos(t), -sin(t), sin(t), cos(t)) * p;
}
float random(in vec2 st) {
    return fract(abs(sin(dot(st, vec2(94.2984, 488.923))) * 234.9892));
}
float rects(in vec2 p, in float t) {
    return random(vec2(p.x * .0001 + t * .008, floor(p.y * 17.)));
}
vec2 uv2p(vec2 uv) {return ((uv*resolution) * 2. - resolution) / min(resolution.x, resolution.y);}
vec2 p2uv(vec2 p) {return ((p*min(resolution.x, resolution.y))+resolution)/(2.*resolution);}
void main() {
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 p = uv2p(uv);
    vec2 oldp = p;

    p *= 3.4;
    p = rotate(p, time * .2);

    float bd = texture2D(osc_bd,vec2(0.0)).r;
    float sd = texture2D(osc_sd,vec2(0.0)).r;
    float hh = texture2D(osc_hh,vec2(0.0)).r;
    float bass = texture2D(osc_bass,vec2(0.0)).r;

    float pi = 3.145;
    float cycle = mod(texture2D(osc_cycle, vec2(0.)).r,8.)*2.*pi/8.;
    float shade = 0.;
    if(length(p)<2.5+(bass*0.5)&&length(p)>2.5&&atan(p.x,p.y)+pi>cycle) shade = 1.0;

    vec2 uvScaled = p2uv(oldp*1.25);
    vec2 uvScaled2 = p2uv(oldp*1.25*bass);

    float interp = mod(texture2D(osc_cycle, vec2(0.)).r,2.)/2.;

    gl_FragColor = vec4(vec3(shade)*vec3(bd,sd,hh),1.0);
    gl_FragColor += texture2D(backbuffer, vec2(uvScaled.x,uvScaled.y+0.005))*vec4(0.8,0.9,0.9,1.0)*(1.-interp);
    gl_FragColor += texture2D(backbuffer, vec2(uvScaled2.x,uvScaled2.y+0.005))*vec4(0.8,0.9,0.9,1.0)*interp;
    //gl_FragColor = vec4(0.);
}
