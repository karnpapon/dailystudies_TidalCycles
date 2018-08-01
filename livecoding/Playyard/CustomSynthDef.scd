// playyard SynthDef




(
SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
    var sig, plfo, fcurve, env;
    plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
    freq = Lag.kr(freq, freqlag * Rand(1,8)) * plfo * 0.25;
    fcurve = EnvGen.kr(Env.adsr(0.1, 0.3, 0.4, 0.2), gate);
	env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: 2);
    fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
    sig = SinOsc.ar(freq*[1.001,3/2,1/2.001,1/4,1/2,3.001/2,1], phase: SinOsc.ar(1/2).range(0.1,2) * SinOsc.ar(freq*2) + (SinOsc.ar(freq*3) * XLine.ar(3,0.001,0.1)));
    sig = RLPF.ar(sig, fcurve / 2, 0.8)
        * env
        * amp;
    Out.ar(out, Splay.ar(sig * 2, 1));
}).add;
)

Synth(\sawpulse)

(
	p = Pbind(
		\type, \note,
		\instrument, \sawpulse,
	).play
)


// =====================================


(SynthDef(\fm, {|note = 40, s = 0.01, f = 0.5, dur = 1|
var tone, mod;
//note = note + (LFNoise2.ar(12).range(1,-1)*(1/12));
note = [note.midicps,note.midicps+Rand(1,2)].cpsmidi;
mod = SinOsc.ar(note.midicps*Rand(2,3).round(1)*(1/Rand(1,2).round(1))) * XLine.ar(s,f,dur);
tone = SinOsc.ar(note.midicps, phase: mod);
tone = tone * XLine.ar(1,1/1000,dur*8,doneAction:2);
Out.ar(0, tone * 0.1);
}).store();)

Synth(\fm, [\note, 50-12]);
Synth(\fm, [\note, 53]);
Synth(\fm, [\note, 50+10]);
Synth(\fm, [\note, 65]);

(Pbind(
       \instrument, \fm,
       \note, Array.series(8,0,2).degreeToKey([0,2,5,7,9])+50+Pstep([0,0,0,0,-2,-2,-2,-7],1,inf),
       \amp, 1/100,
       \s, Pwhite(0.1,1.1,inf).trace,
       \f, 1/20,
       \dur, Pseq([1/2,1/2,1,1,1/4,1/4,1/4,1/4],inf)*0.5
       ).play;)


// =====================================
// *******

({
var points,s,sel,freq;
freq = (47).midicps;
points = LFNoise2.ar(0.8!40);
sel = VarSaw.ar(freq * [0.999,2,0.499,0.5,2,1.01] * 0.5, width: LFNoise2.ar(1/2).range(0.2,0.5)).range(0, points.size-1);
s = SelectX.ar(sel, points);
s = LeakDC.ar(Splay.ar(s, 1)) * 0.3;
s = s + SinOsc.ar(freq/2, width: 0.3).dup * 0.6;
RLPF.ar(s, VarSaw.ar(MouseButton.kr(3,8), width: 0.2).exprange(10,2000), 0.8);
}.play;)

// /=====================================

(SynthDef(\pluck, {|freq = 440, dur = 1|
var klang,note;
dur = dur * 2;
note = freq.cpsmidi;
note = note + (LFNoise2.ar(20).range(-1,1) * (1/8));
klang = SinOsc.ar((note * [1,1.002]).midicps, phase: VarSaw.ar(note.midicps, width: Line.ar(1,0.2,dur))) * 0.3;
klang = klang * XLine.ar(1,1/10000,dur,doneAction:2);
Out.ar(0, klang);
}).store;)

(Pbind(
\instrument, \pluck,
\degree, Pn(Pseries(0, Pwrand([Pwhite(-3,3,inf).round(1),1],[32,1],inf), 4),inf)-1 + [0,2,-1,-14],
\dur, Pseq([4, [5,2,1]].convertRhythm / 2, inf),
\strum, Pwhite(0,1/8,inf),
\octave, 5
).play;)

// /=====================================

Synth(\ch, [\freq, 290])
x = Synth(\pip)

x.set(\freq, 220)

(SynthDef(\blopp, { | freq = 240, sustain = 1, o = 1 |
var s = Splay.ar(Blip.ar(freq * [1.99,1,0.498,1.01,2.001], o),0.4).dup / 5;
s = s * XLine.ar(1,1/1000,sustain,doneAction:2);
s = RLPF.ar(s,XLine.ar(1/10000,1,0.001) * XLine.ar(2000,200,sustain/2), 0.8);
s = s * AmpComp.kr(freq) * 0.4;
Out.ar(0, s);
}).store;


// ******

SynthDef(\pip, { | freq = 240, sustain = 1, amp = 1 |
var mfreq = freq;
mfreq = mfreq.cpsmidi + (LFNoise2.ar(12).range(-1,1) * (1/8));
mfreq = mfreq.midicps;
Out.ar(0, XLine.ar(1, 1/1000, sustain * 2, doneAction: 2) * Splay.ar(VarSaw.ar(mfreq * [0.99,0.499,2.001,0.5001,1] * 2, width: XLine.ar(0.5,0.05,sustain)) ,1) * 0.3 * amp);
}).store;
)


// /=====================================


SynthDef(\cfcf,{|freq = 40,amp = 2, sustain = 1|
var saw,blok,tone,gate,freq_env,res_env,note;
sustain = Clip.kr(sustain, (35/60)*2, 100);
note = freq.cpsmidi + LFNoise2.ar(12).range(1/12,-1/12);
gate = Impulse.ar(0);
freq_env = EnvGen.ar(Env.new([note.midicps, 2000, 20], [3*sustain/8, 3*sustain/8]/2,'exponential'),gate);
res_env = XLine.ar(0.1,0.9,sustain/2);
saw = VarSaw.ar(note.midicps, width: 0.4, mul: 0.5) + VarSaw.ar(note.midicps*4, width: 0.4, mul: 0.4);
blok = Pulse.ar(note.midicps, width: 0.4);
tone = XFade2.ar(saw,blok,XLine.ar(1,1/2,sustain)) * 0.2;
tone = MoogLadder.ar(tone, XLine.ar(8000,100,sustain/3), res_env) * 4;
tone = tone + SinOsc.ar(note.midicps, mul: 0.5);
tone = Compander.ar(tone, tone, thresh: 1/4, slopeAbove:1/40, clampTime: 1/80) * 4;
tone = tone * XLine.ar(1,1/1000,sustain, doneAction:2);
Out.ar(0,tone.dup * amp);
}).store;

Synth(\cfcf, [\freq, 40.midicps]);

// /=====================================



// /=====================================


/*(
SynthDef("sinepluck", {
arg freq = 440, amp = 1, dur;
var mod,tone;
amp = amp * 0.8;
dur = 1/8;
mod = VarSaw.ar(freq*2, mul: XLine.ar(0.2,0.8,dur/2), width: XLine.ar(1,0.95,dur/2));
tone = SinOsc.ar(freq, mod).dup * 0.1 * XLine.ar(1,1/1000,dur*2, doneAction:2) * amp;
tone = tone.dup * XLine.ar(1/10000,1,0.005);
Out.ar(0,tone);
}).store;
)

Synth(\imogen, [\freq, 40.midicps]);*/
