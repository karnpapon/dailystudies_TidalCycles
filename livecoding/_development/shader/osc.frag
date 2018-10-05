/*{
  "osc": 4000 ,
  "audio": true
}*/

precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform sampler2D osc_tidal;
uniform sampler2D spectrum;
uniform float volume;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

    vec2 rotate(in vec2 p, in float t) {
        return mat2(cos(t), -sin(t), sin(t), cos(t)) * p;
    }
    float random(in vec2 st) {
        return fract(abs(sin(dot(st, vec2(94.2984, 488.923))) * 234.9892));
    }
    float rects(in vec2 p, in float t) {
        return random(vec2(p.x * .0001 + t * .008, floor(p.y * 17.)));
    }
    void main() {
        vec2 uv = gl_FragCoord.xy / resolution;
        vec2 p = (gl_FragCoord.xy * 2. - resolution) / min(resolution.x, resolution.y);
        p *= 4.4;

        p = rotate(p, time * .2);

        float v = volume * 0.008; //sensitivity
        float hi = texture2D(spectrum, vec2(20)).r;
        float vv = v + 0.1;

        float l = length(p);
        float r = texture2D(osc_tidal, vec2(.0)).r * sin(l * 2. + v);
        float g = texture2D(osc_tidal, vec2(.4)).g * sin(l * 2. + hi);
        float b = texture2D(osc_tidal, vec2(.7)).b * sin(l * 2. + 4.);

        float n = rects(p, time);
        gl_FragColor = vec4(r ,g ,b + 0.3 ,0.5) * n ;
        gl_FragColor += texture2D(backbuffer, rotate(uv - .5, time) * .9 +.5, time) * .95 ;
        // gl_Fraglor = vec4(0);
    }
