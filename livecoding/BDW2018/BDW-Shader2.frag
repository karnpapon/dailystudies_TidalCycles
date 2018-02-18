/*{ "osc": 4000 }*/
precision mediump float;
uniform float time;
uniform vec2  resolution;
uniform sampler2D mouse;
uniform sampler2D osc_foo;

void main (void) {
    vec2 uv = gl_FragCoord.xy / resolution.x;
    uv = abs(uv);
    float foo = texture2D(osc_foo, vec2(abs(uv.x * 0.3), 0.5)).r;
    float col = 0.0;
    col += uv.y*0.1;
    col += pow(sin(uv.y*65.0+uv.y*foo*4.2+time*0.2), 500.0);
    gl_FragColor = vec4(col,col,col,1.0);
}
