/*{
    frameskip: 3,
    "audio": true,
    "vertexCount": 30000,
    "vertexMode": "TRIANGLES",
    // "vertexMode": "POINTS",
    // "vertexMode": "LINES",
    PASSES: [{
      OBJ: './deer.obj'
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
  float t = time * 10.1;
  float i = vertexId * 3.2 + sin(vertexId) * 1.;

  vec3 pos = position;
  // pos.xyz = pos.yzx;
  pos *= .6;
  pos.xz = rot(pos.xz, time);
  // pos.xy = rot(pos.xy, time * .2);

  float v = volume * .01;
  float hi = texture2D(spectrum, vec2(.7)).r * .3;
  pos.x += hi * sin(vertexId + time);
  // pos.x += smoothstep(.0, .3, sin(time + pos.y * 3.) * .8) - .5;
  // pos *= v * sin(vertexId * .1 + time * 0.1) * 20.8 + 1.;

  // Morphing
  float rz = 1. - (vertexId / 1000.) * .1;
  float h = sqrt(1. - rz * rz);
  vec3 pSphere = vec3(
    cos(vertexId *.3 + time) * h,
    sin(vertexId *.3 + time) * h,
    rz
  ) * .3;
  float xo = mod(floor(vertexId / 768.), 2.) - 1.;
  float yo = mod(floor(vertexId / 768. / 2.), 2.) - 1.;
  vec3 pRects = vec3(
    mod(vertexId * 4.3, 2.0) / 2.0,
    mod(vertexId * 8.3, 3.0) / 3.0,
    mod(vertexId * 3.3, 4.0) / 4.0
  ) - .5;
  pRects.xz = rot(pRects.xz, time);
  pRects.x += xo * 1.3;
  pRects.y += yo * 1.3;
  pRects += .6;
  pRects *= .4;

  float tt = time * 2.;
  float d = mod(tt, 9.) * .5;
  pos = mix(pos, pSphere, clamp(max(d - 3., 1.5 - d), 0., 1.));
  pos = mix(pos, pRects, clamp(min(d - 2., 4.5 - d), 0., 1.));

  float r = sin(vertexId * sin(time * .1 + vertexId * hi) * .002);
  // pos.xy = rot(pos.xy, r * 2.8);

  pos.y *= resolution.x / resolution.y;
  gl_Position = vec4(pos, 1);

  // gl_PointSize = 20. + 30. * sin(time + vertexId) * volume * .4;
  gl_PointSize = 3.;

  v_color = vec4(
    // dot(normalize(normal), vec3(1))
    normalize(normal),
    1.
  );
  v_color.a = 1.;

  // float vi = pos.y * 3.1;
  // v_color *= vec4(
  //   sin(vi),
  //   sin(vi + 2.),
  //   sin(vi + 3.),
  //   1.
  // );

  // v_color = vec4(
  //   sin(vertexId),
  //   sin(vertexId + 2.),
  //   sin(vertexId + 3.),
  //   1.
  // );
}
