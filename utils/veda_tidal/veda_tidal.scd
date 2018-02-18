SuperDirt.start();

(
~params = ();
~sounds = ();
b = NetAddr.new("127.0.0.1", 4567);
OSCdef(\test,{|msg, time|
	forBy(1,msg.size,2,{|i|
		if(msg[i+1].class===Symbol,
			{~sounds[msg[i+1]]=1.0;},
			{~params[msg[i]]=msg[i+1];});
	});
	~params.keys.do({|k| b.sendMsg("/"++k, ~params[k]);});
}, '/play2', n);
~decay={~sounds.keys.do({|k|
	~sounds[k] = ~sounds[k]*0.8;
	~sounds.keys.do({|k| b.sendMsg("/"++k, ~sounds[k]);});
});};
t=TempoClock.new;
t.sched(0,{~decay.();1/60;});
);
