/*{
  frameskip: 1,
  "osc": 4000,
  "audio" : true,
  vertexMode: "TRIANGLES",
  PASSES: [{
    MODEL: {
      PATH: './models/statue.obj',
    },
    vs: './khan1.vert',
    TARGET: 'statue',
  }, {}]
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform int PASSINDEX;
uniform sampler2D statue;
uniform sampler2D map;
varying vec4 v_color;
varying vec2 vUv;
uniform sampler2D osc_tidal;


void main() {

    vec2 uv = gl_FragCoord.xy / resolution.xy;
    if (PASSINDEX == 0) {
      gl_FragColor = vec4(.4);
    }
    else {
      vec2 m = vec2(0.5, 0.5 * (resolution.y / resolution.x));
      vec4 statue = texture2D( statue, uv);
      float t = 0.0;
      t = time*.2;

      float l = length(m);
      float rr = texture2D(osc_tidal, vec2(.9)).r ;
      float gg = texture2D(osc_tidal, vec2(.4)).r * sin(l * 2. + 2.);
      float bb = texture2D(osc_tidal, vec2(.7)).r * sin(l * 2. + 4.);

      float r = pow(sin(length(m - uv) * 3.0 - t - (gg + 1.5)), 22.0) ;
      float g = pow(sin(length(m - uv) * 2.0 - t + rr), 20.);
      float b = pow(sin(length(m - uv) * 1.0 - t + bb), 3.0);

      vec3 bw = vec3(r + g + b) / 2.0;
      gl_FragColor = vec4(r,0,b, 0.002)+ statue;
    }
}
