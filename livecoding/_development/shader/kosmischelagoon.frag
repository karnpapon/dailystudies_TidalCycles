/*{
    frameskip: 1,
    "audio": true,
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D spectrum;
uniform float volume;

void main() {
    vec2 p = gl_FragCoord.xy / resolution.x * 0.7;
    vec3 col;
    // float foo = texture2D(spectrum, vec2(abs(p.x * 0.8), 0.5)).r;
    float foo = volume * 0.01; //sensitivity
    float hi = texture2D(spectrum, vec2(20)).r;
    // p.x += hi * sin(vertexId + time);
    // pos *= v * sin(vertexId * .1 + time * 0.01) * 20.8 + 1.;

    for(float j = 0.0; j < 6.0; j++){
        for(float i = 1.0; i < 10.0; i++){
            p.x += 0.1 / (i + foo) * sin(i * 10.0 * p.y + hi );
            p.y += 0.1 / (i + foo)* cos(i * 10.0 * p.x + time );
        }
        col[int(j)] = abs(p.x + p.y) * 0.65;
    }
    gl_FragColor = vec4(col, 1.);
}
