/*{
    frameskip: 1,
    "audio": true,
    "osc": 4000,
    vertexMode: "TRIANGLES",
    PASSES: [{
      MODEL: { PATH: './models/statue.obj' },
      BLEND: 'ADD',
    }]
}*/
precision mediump float;
attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

attribute float vertexId;
uniform float vertexCount;

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D spectrum;
uniform mat3 uvTransform;
uniform float volume;
varying vec4 v_color;
varying vec2 vUv;
uniform sampler2D osc_tidal;

vec2 rot(in vec2 p, in float t) {
  float s = sin(t);
  float c = cos(t);
  return mat2(s, c, -c, s) * p;
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {
  vec3 pos = position;
  pos *= 1.0; //size
  pos.xz = rot(pos.xz, time * 1.); // time
  float v = volume * 0.0001; //sensitivity
  float rr = texture2D(osc_tidal, vec2(.0)).r * sin( 2. + v);
  float gg = texture2D(osc_tidal, vec2(.4)).r * sin( 2. + 2.);
  float bb = texture2D(osc_tidal, vec2(.7)).r * sin(2. + 4.);

  float hi = texture2D(spectrum, vec2(20)).r;
  pos.x += (rr * 0.25)* sin(vertexId + time);
  pos *= v * sin(vertexId * .1 + time * 0.01) * 20.8 + 1. ;

  float r = sin(vertexId * sin(time * .2 + vertexId * (gg * 0.25)) * .002);
  pos.xy = rot(pos.yx, bb * .2 );

  pos.y *= resolution.x / resolution.y;
  gl_Position = vec4(pos - bb, 1);

  gl_PointSize = 20. + 30. * sin(time + vertexId) * volume * .04;

  v_color = vec4(vec2(normalize(normal)), .4, 1.);
  v_color *= random(vec2(gg, rr)) + dot(normalize(normal), vec3(1.));
  v_color.a = 1. ;
}
