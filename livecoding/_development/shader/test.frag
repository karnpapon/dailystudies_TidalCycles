/*{
    "midi": true,
    "frameskip": 1
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D spectrum;
uniform sampler2D midi;
uniform sampler2D note;
uniform sampler2D osc_tidal;



void main(void){

  vec2 mouse = vec2(mouse.x * 2.0 - 1.0, mouse.y * 2.0 - 1.0);

  vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

  float l = length(p);
  float rr = texture2D(osc_tidal, vec2(.9)).r ;
  float gg = texture2D(osc_tidal, vec2(.4)).r * sin(l * 2. + 2.);
  float bb = texture2D(osc_tidal, vec2(.7)).r * sin(l * 2. + 4.);

  // orb
  // float orb = 0.05 / length(vec2(p));
  // gl_FragColor = vec4(vec3(orb), 1.0);
  //
  // ring
  // float ring = 0.02 / abs(0.5 - length(p));
  // gl_FragColor = vec4(vec3(ring), 1.0);

  // zoom
  // float zoom = atan(p.y, p.x) + time;
  // zoom = sin(zoom * 10.0);
  // gl_FragColor = vec4(vec3(zoom), 1.0);

  // flower
  // float flower = sin((atan(p.y, p.x) + time * 0.5) * 6.0);
  // flower = 0.01 / abs(flower - length(p));
  // gl_FragColor = vec4(vec3(flower), 1.0);

  // fan
  // float fan = abs(sin((atan(p.y, p.x) - length(p) + time) * 10.0) * 0.5) + 0.2;
  // fan = 0.01 / abs(fan - length(p));
  // gl_FragColor = vec4(vec3(fan), 1.0);

  // noisering
  float noisering = sin((atan(p.y, p.x) + time * 0.5) * 6.) * 0.01;
  noisering = 0.1 + rr + gg + bb / abs(0.5 + noisering - length(p));
  gl_FragColor = vec4(vec3(noisering), 1.0);

}
