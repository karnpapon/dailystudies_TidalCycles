/*{
    "pixelRatio": 1,
    "vertexCount": 3000,
    "vertexMode": "TRIANGLES",
    "PASSES": [{
        "vs": "./canvas.vert",
    }]
}*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
varying vec4 v_color;

void main() {
    vec2 uv = gl_FragCoord.xy / resolution;

    // Change particle color
    gl_FragColor = vec4(
        fract(length(uv) * 3.),
        fract(length(uv) * .6),
        fract(length(uv) * 7.),
        1.
    );
}
