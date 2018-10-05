Server.default.options.inDevice = "Built-in Microph"; // so using Spectrum in Veda is possible, by setting {audio: true}
Server.default.options.outDevice = "Soundflower (64ch)";

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