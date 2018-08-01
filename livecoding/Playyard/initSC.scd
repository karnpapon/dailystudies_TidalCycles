SuperDirt.start

SuperDirt.stop


Server.default.options.inDevice = "Built-in Microph"; // so using Spectrum in Veda is possible, by setting {audio: true}
Server.default.options.outDevice = "Built-in Output";

ServerOptions.devices

(
s.options.numBuffers = 2048 * 16;
s.options.memSize = 8192 * 16;
s.options.maxNodes = 1024 * 32;
s.options.numOutputBusChannels = 12;
s.options.numInputBusChannels = 2;

s.waitForBoot {
	~dirt = SuperDirt(2, s);
	~dirt.loadSoundFiles;
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	s.sync;
	~dirt.start(57120, [0, 2, 4, 6, 8, 10]);
}
)

// -------------------------------------------------------------------

n = LFNoise1;
(Ndef(\x,{
	a = SinOsc.ar(65,Ndef(\x).ar * n.ar(0.1,3),n.ar(3,6)).tanh;
	9.do{
		a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)
	};
	a.tanh}))

// transfered to SynthDef.
(
SynthDef(\fffuccckk,{
	arg freq=65, gate = 1, out = 0, amp = 0.25, rel=16, cf=440, rq=1;
	var env = EnvGen.kr(Env.adsr(releaseTime: rel), gate, doneAction:2);
	var sig = SinOsc.ar(freq,Ndef(\x).ar * LFNoise1.ar(0.1,3), LFNoise1.ar(3,6)).tanh;
	cf = MouseX.kr(200, 8000,1);
	rq = MouseY.kr(0.01, 1,1);
	// sig = RLPF.ar(sig,8000,rq, 0.5);
	10.do{
		sig = AllpassL.ar(sig,0.3,{0.2.rand + 0.2}!2,5)
	};
	sig = sig * env;
	sig.tanh;
	Out.ar(out,sig * amp);
}).add
)

(
	SynthDef.new(\sine, {
	arg freq = 440, amp = 0.25, rel= 0.2;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.perc(0.001, rel), doneAction: 2);
	sig = sig * env * amp;
	Out.ar(0, sig!2);
	}).add;
)

s.meter;
s.reboot;
s.quit;
s.plotTree;
Synth.new(\sine);

(
	p = Pbind(
		\type, \note,
		\instrument, \sine,
		\dur, Pwhite(0.5, 1, inf),
		\freq, Pfuncn({
			Array.fill(1, {exprand(150, 5000).round})
		}, inf),
		\amp, 0.05,
		\rel, Pexprand(4,5, inf),
	).play
)

(
	SynthDef.new(\drone, {
		arg freq = 440, amp = 0.25,  rel=0.2;
		var env, sig;
		sig = LFSaw.ar(freq);
		env = EnvGen.kr(Env.perc(0.001, rel), doneAction: 2);
		sig = sig * env * amp;
		Out.ar(0, sig!2);
	})
).add


Synth(\drone)
p.stop;


x = Synth(\fffuccckk);

s.meter

x.set(\freq, 65)
x.set(\cf, 1000)
x.set(\rq, 1)
x.set(\rel, 2)
x.set(\amp, 0.05)
x.set(\gate, 0)

x.stop;
