s.reboot;
s.quit;
s.freeAll;
s.meter.window.alwaysOnTop;
s.plotTree;

FreqScope.new;
Stethoscope(s, 2);
SuperDirt.start


// ------------------------------------------------------------

Server.default.options.inDevice = "Soundflower (64ch)"; //for using input from External Instruments.
Server.default.options.outDevice = "Soundflower (64ch)";

ServerOptions.devices

(
s.options.numBuffers = 2048 * 16;
s.options.memSize = 8192 * 16;
s.options.maxNodes = 1024 * 32;
s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 4;

s.waitForBoot {
	~dirt = SuperDirt(2, s);
	~dirt.loadSoundFiles;
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	s.sync;
	~dirt.start(57120, [0, 2, 4, 6, 8, 10]);
}
)


(
MIDIClient.init;
MIDIClient.list;
)

~midiOut = MIDIOut.newByName("Scarlett 2i4 USB", "Scarlett 2i4 USB");
//~midiOut = MIDIOut.newByName("LoopBe Internal MIDI", "LoopBe Internal MIDI");
~midiOut.latency = 0.45;
~dirt.soundLibrary.addMIDI(\midi, ~midiOut);

// ------------------------------------------------------------


// coded by Jonatan Liljedahl.
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
	arg freq=65, gate = 1, out = 0, amp = 0.15, rel=16, cf=440, rq=1;
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

x = Synth(\fffuccckk);

x.set(\freq, 65)
x.set(\cf, 5000)
x.set(\rq, 1)
x.set(\rel, 2)
x.set(\amp, 0.09)
x.set(\gate, 0)

x.stop;
