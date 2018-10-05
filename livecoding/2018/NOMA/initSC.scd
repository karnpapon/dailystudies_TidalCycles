Server.default.options.inDevice = "Built-in Microph"; // so using Spectrum in Veda is possible, by setting {audio: true}
Server.default.options.outDevice = "Soundflower (64ch)";

ServerOptions.devices

// s.options.memSize = 65536;  // in case using hall reverb(avoid memory failed).

(
s.options.numBuffers = 2048 * 16;
s.options.memSize = 8192 * 16;
s.options.maxNodes = 1024 * 32;
s.options.numOutputBusChannels = 12;
s.options.numInputBusChannels = 2;
)

s.plotTree;

(
s.waitForBoot {
	~dirt = SuperDirt(2, s);
	~dirt.loadSoundFiles;
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	s.sync;
	~dirt.start(57120, [0, 2, 4, 6, 8, 10]);
}
)

MIDIClient.init;
~midiOut = MIDIOut.newByName("IAC Driver", "Tidal1");
~midiOut2 = MIDIOut.newByName("Scarlett 2i4 USB", "Scarlett 2i4 USB");

~midiOut.latency = 0.0;
~midiOut2.latency = 0.0;

~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
~dirt.soundLibrary.addMIDI(\a4, ~midiOut2);


// OSC sending to Veda.
b = NetAddr.new("127.0.0.1", 4000);

(
OSCdef(\test,  { |msg, time|
	var midichan2 = false;
	var midichan3 = false;
	var midichan1 = false;
	var chan2 = false;
	var chan3 = false;
	var chan1 = false;

	for(1, msg.size, {
		arg i;
		midichan2 = if(msg[i] == 'midichan',{ if(msg[8] == 2, {chan2 = true},{ chan2 = false }) });
		midichan3 = if(msg[i] == 'midichan',{ if(msg[8] == 3, {chan3 = true},{ chan3 = false }) });
		midichan1 = if(msg[i] == 'midichan',{ if(msg[8] == 1, {chan1 = true},{ chan1 = false }) });
	});
	b.sendMsg("/tidal",chan2,chan3,chan1);
}, '/play2', n);
)

OSCdef.freeAll

b = NetAddr.new("127.0.0.1", 4000);

(
OSCdef(\test2,  { |msg, time|
	var stabb = false;
	var akuma5 = false;
	var smash = false;
	for(1, msg.size, {
		arg i;
		stabb = if(msg[i] == 'stabb', true, stabb);
		akuma5 = if(msg[i] == 'akuma5', true, akuma5);
		smash = if(msg[i] == 'smash', true, smash);
	});
	b.sendMsg("/tidal",stabb,akuma5,smash);
}, '/play2', n);
)


// foward OSC from TidalCycles

r = NetAddr.new("127.0.0.1", 3333);


r.free

(
OSCFunc({ |msg, time, tidalAddr|
	var latency = time - Main.elapsedTime;
	msg = msg ++ ["time", time, "latency", latency];
	// msg.postln;
	r.sendBundle(latency, msg)
}, '/play2').fix;
)







