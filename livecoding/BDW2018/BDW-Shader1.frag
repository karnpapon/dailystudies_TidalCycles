/*{ "osc": 4000 }*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D osc_foo;      // OSC on /foo

void main() {
    vec2 m = vec2(0.5, 0.5 * (resolution.y / resolution.x));
    vec2 p = gl_FragCoord.xy / resolution.x;
    float foo = texture2D(osc_foo, p).r;
    float t = 0.0;
    t = time*foo*10.2;
    float r = pow(sin(length(m - p.x) * 2.0), 3.0);
    float g = pow(sin(length(m - p.x) * 15.0 - t*0.5), 3.9);
    float b = pow(sin(length(m - p.x) * 1.0), 1.25);
    vec3 bw = vec3(r + g + b) / 3.0;
    gl_FragColor = vec4(bw, 1.0);
}
