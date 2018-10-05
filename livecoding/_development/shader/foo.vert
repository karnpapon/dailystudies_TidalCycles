
/*{ "vertexCount": 100, "midi": true }*/

precision mediump float;
attribute float vertexId;
uniform float vertexCount;
uniform float time;
uniform vec2 resolution;
varying vec4 v_color;
uniform sampler2D midi;
uniform sampler2D note;

void main() {
  float i = vertexId + time * 0.01;

  // float k = texture2D(midi, vec2(181. / 256., 119. / 256.)).x;

  float k = (
    texture2D(note, vec2(60. / 128.)).x * 1. +
    texture2D(note, vec2(62. / 128.)).x * 2. +
    texture2D(note, vec2(64. / 128.)).x * 3. +
    texture2D(note, vec2(65. / 128.)).x
  ) * 20.;

  vec3 pos = vec3(cos(i * k), sin(i * 5.), cos(i * 2.));
  gl_Position = vec4(pos.x, pos.y, pos.z, 1);
  v_color = vec4(fract(vertexId / 1.), 1,1,1);
}
