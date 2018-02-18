/*{ "osc": 4000 }*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D osc_foo;      // OSC on /foo

void main( ){
	vec3 c;
	float l,z = (time*0.5);

	for(int i=0;i<3;i++) {
		vec2 uv , p = gl_FragCoord.xy / resolution.xy;
    float foo = texture2D(osc_foo, uv).r;
		uv = p;
		p -= 0.5;
		p.x *= resolution.x/resolution.y;
		z += 0.02; // c
		l = length(p);
		uv += p/l * (sin(z)+0.6) * abs(sin(l * 6.0 + foo * 1.0));
		c[i] = 0.01 / length(abs(mod(uv,1.0)-0.5));
	}
	gl_FragColor = vec4(c/l,1.0);
}
