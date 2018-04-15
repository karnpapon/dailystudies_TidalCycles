/*{
    frameskip: 1,
    "audio": false,
    "vertexMode": "TRIANGLES",
    // "vertexMode": "POINTS",
    PASSES: [{
      // "fs": './myshader.frag',
      OBJ: './model/deer.obj'
    }]
}*/
precision mediump float;
attribute vec3 position;
attribute vec3 normal;
attribute float vertexId;
uniform float vertexCount;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D spectrum;
uniform float volume;
varying vec4 v_color;

vec2 rot(in vec2 p, in float t) {
  float s = sin(t);
  float c = cos(t);
  return mat2(s, c, -c, s) * p;
}

void main() {
  vec3 pos = position;
  pos *= .7; //size
  pos.xz = rot(pos.xz, time * 1.); // time

  float v = volume * 0.01;
  float hi = texture2D(spectrum, vec2(20)).r;
  pos.x += hi * sin(vertexId + time);
  pos *= v * sin(vertexId * .1 + time * 0.01) * 20.8 + 1.;

  // float r = sin(vertexId * sin(time * .2 + vertexId * hi) * .002);
  // pos.xy = rot(pos.yx, r * .2);

  pos.y *= resolution.x / resolution.y;
  gl_Position = vec4(pos, 1);

  gl_PointSize = 50. + 30. * sin(time + vertexId) * volume * .04;

  v_color = vec4(normalize(normal), 1.);
  v_color *= 1. + dot(normalize(normal), vec3(.5));
  v_color.a = 1.;
}
