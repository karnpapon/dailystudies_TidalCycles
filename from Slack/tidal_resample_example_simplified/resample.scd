
(
	// !!!!!!!!!! RUN THIS WHOLE BLOCK AT ONCE !!!!!!!!!!!!
s.options.numBuffers = 1024 * 16; // increase this if you need to load more samples
s.options.memSize = 8192 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 8; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
// boot the server and start SuperDirt
s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	s.sync; // wait for samples to be read
	~dirt.start(57120, [0,2,4,6]);   // start listening on port 57120, create four busses each sending audio to channel 0
	// ---- //

	// ------------------------------------------------- //
	// ----- THE CODE BELOW ALLOWS US TO RESAMPLE! ----- //
	// ------------------------------------------------- //
	(
	if(~nextbuf==nil,{~nextBuf = Buffer.alloc(s,~dirt.server.sampleRate*10,2);});
	if(~dirt.buffers['rec']==nil,{~dirt.buffers['rec']=[];});
	if(~dirt.buffers['rec'].size>0,
		{~dirt.buffers['rec'][0] = Buffer.alloc(s,~dirt.server.sampleRate*10,2);},
		{~dirt.buffers['rec'] = ~dirt.buffers['rec'].add(Buffer.alloc(s,~dirt.server.sampleRate*10,2));});
	s.sync;
	OSCdef(\test,{|msg, time|
	    forBy(1,msg.size,2,{|i|
			var spc = 1;
	        if(msg[i]=='rec',{
				var recc = msg[i+1];
				if(recc>0,{
					SystemClock.sched(0, {
						var temp = ~nextBuf;
						~nextBuf = ~dirt.buffers['rec'][0];
						~dirt.buffers['rec'][0] = temp;
						'rec'.postln;
						Ndef(\rec,
						{
							var line = Line.ar(0, BufFrames.kr(~nextBuf), 1, doneAction:2);
							BufWr.ar(In.ar(0,2), ~nextBuf, line);
						}
						);
					});
				});
	        });
		});
	}, '/play2', n);
	);
	// ------------------------------------------------- //
	// --------------- HECK YEAH, THAT'S IT! ----------- //
	// ------------------------------------------------- //
};
s.latency = 0.3; // increase this if you get "late" messages
);
