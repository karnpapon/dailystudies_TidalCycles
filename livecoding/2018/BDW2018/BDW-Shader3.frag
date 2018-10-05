/*{ "osc": 4000 }*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D osc_foo;      // OSC on /foo

void main() {
    vec2 p = gl_FragCoord.xy / resolution.xy * 3.0;
    float foo = texture2D(osc_foo, p).r;
    for(float i = 1.0; i < 10.0; i++){
        p.x += 0.3 / i * sin(i * 3.0 * p.y + time * 0.1 + cos((time / (100. * i)) * i));
        p.y += 0.4 / i * cos(i * 2.0 * p.y + time * 1.2 + sin((time / (200. * i)) * i));
    }
    float r = cos(p.x + p.y + 100.0)*5.4*0.5;
    float g = sin(p.y + p.x)*0.5+0.05;
    float b = sin(p.y + foo)-smoothstep(foo, 10.8, foo);
    vec3 bw = vec3(r + g + b) / 3.0;
    gl_FragColor = vec4(bw,1);
}
