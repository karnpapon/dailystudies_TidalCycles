/*{
  vertexMode: "TRIANGLES",
  PASSES: [{
    OBJ: './deer.obj',
    vs: './obj.vert',
    fs: './obj.frag',
    TARGET: 'deer',
  }, {}]
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform int PASSINDEX;
uniform sampler2D deer;
uniform sampler2D osc_foo;      // OSC on /foo

void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    float foo = texture2D(osc_foo, uv).r;
    if (PASSINDEX == 0) {
        gl_FragColor = vec4(1);
    }
    else {
        vec4 deer = texture2D(deer, uv*foo);
        gl_FragColor = deer;
        gl_FragColor += vec4(uv, 1, 1);
    }
}
