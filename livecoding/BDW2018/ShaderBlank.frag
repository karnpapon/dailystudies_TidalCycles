/*{ "camera": true }*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D camera;

float rnd(int i){
	return fract(cos(float(i)*564.5))+cos(0.1+20.0*float(i));
}

float map(vec2 p){
	float color = 0.0;
	for(int i=0;i<5;i++){
	color+=cos(45.0*distance(vec2(rnd(i),rnd(10-i)),p))*0.015;
	}
	//color+=cos(distance(vec2(0.0,0.0),p)*50.0+time)*0.01;
    color+=sin(acos(distance(vec2(0.0,0.0)/2.,p)*2.5))*9.0;
return color*0.1;}

vec3 norm(vec2 p){
	float r=0.01;
	float c=map(p);
	float x=map(p+vec2(r,0.0));
	float y=map(p+vec2(0.0,r));
	vec3 cc=vec3(p.x,  p.y,  c);
	vec3 xx=vec3(p.x+r,p.y,  x)-cc;
	vec3 yy=vec3(p.x,  p.y+r,y)-cc;
	return normalize(cross(xx,yy).xyz);
}
// float light(vec3 norm){
// 	vec3 light=vec3(cos(0.5),sin(time),0.5);
// light=normalize(light);
// 	float lum=dot(norm,light);
// 	return lum*0.5+0.5;
// }
vec3 tex(vec2 p){
    vec3 n=norm(p);
    vec2 pp;
    pp.x=atan(n.z,n.x);
    pp.y=atan(n.z,n.y);
    vec2 sp=norm(pp).xy*0.5+0.5;
    vec2 goodUV=3.0-pp;
    return texture2D(camera,goodUV*0.3).xyz;
}


void main( )
{
 	vec2 uv = gl_FragCoord.xy / resolution.xy - vec2(0.5);
    uv=vec2(uv.x*(resolution.x/resolution.y),uv.y);

    // vec3 color=vec3(light(norm(uv)));
    vec3 color=tex(uv);
	gl_FragColor = vec4( color, 1.0 );
}
