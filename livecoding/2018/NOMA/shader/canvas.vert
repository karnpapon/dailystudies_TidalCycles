/*{
    "pixelRatio": 1,
    "vertexCount": 3000,
    "osc": 4000,
    "vertexMode": "POINTS",
    "PASSES": [{
        "fs": "./canvas.frag",
    }]
}*/
precision mediump float;
attribute float vertexId;
uniform float vertexCount;
uniform float time;
uniform vec2 resolution;
varying vec4 v_color;
uniform sampler2D osc_tidal;

float map(float value, float low1, float high1, float low2, float high2) {
  return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  float t = time * .7;
  float i = vertexId * .8 + sin(vertexId) * 1.;

  vec2  trigger =  texture2D(osc_tidal , vec2(t)).rg;

  float randf = rand(vec2(t));


  float mappedTrigger = map(randf,0.0,.9,0.01,0.05);

  float rr = texture2D(osc_tidal, vec2(.0)).r * .2;
  float gg = texture2D(osc_tidal, vec2(.4)).r * .8;
  float bb = texture2D(osc_tidal, vec2(.7)).r * mappedTrigger;


  vec3 pos = vec3(
    sin(t + i * (.2 + rr) - bb),
    cos(t + i * (.1 + gg)  ),
    .1
  ) * .7;

  gl_Position = vec4(pos.x, pos.y * resolution.x / resolution.y, pos.z * .1, 1);
  gl_PointSize = 5.;

  v_color = vec4(
    sin(i + 1.),
    sin(i + 2.),
    sin(i + 3.),
    1
  );
}
