/*

███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗ ██╗██╗███████╗██╗  ██╗██╗     ██████╗ ███████╗ █████╗ ████████╗███████╗
████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝██╔╝██║██╔════╝██║  ██║╚██╗    ██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝
██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝ ██║ ██║███████╗███████║ ██║    ██████╔╝█████╗  ███████║   ██║   ███████╗
██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗ ██║ ██║╚════██║██╔══██║ ██║    ██╔══██╗██╔══╝  ██╔══██║   ██║   ╚════██║
██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗╚██╗██║███████║██║  ██║██╔╝    ██████╔╝███████╗██║  ██║   ██║   ███████║
╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝

"Because matrix-based not-beats is just so 1950s."

This document demonstrates some necessary classes and heuristics to get you started with your beat-making programs. It does not contain the complete set of working functions you will need to write for your projects.

The Matrix and sounds I've chosen are below.

(k),(s),h,h2,k,s,(h),(h2)

Ordered Matrices (with repetition)

k,h,H,h,s,h,H,h
h,k,s,k,H,k,s,k
s,H,k,H,h,H,k,H
h,k,s,k,H,k,s,k
H,s,h,s,k,s,h,s
h,k,s,k,H,k,s,k
s,H,k,H,h,H,k,H
h,k,s,k,H,k,s,k

*/
(

s.waitForBoot { // the way all your programs should be formatted unless they are interactive...

t = TempoClock.default; // the default clock
t.tempo = 160/60; // 120 beats per second

// the following loads sounds from the directory in which this file is located. the sound files are made available to the user in Buffers -- client-side representations of sampled audio stored in memory and available to the server for playing.
b = [\kick, \sd, \hh1, \hh2, \guitar].collect{|val| Buffer.read(s,(val++".wav").resolveRelative) };

// a very simple sample-playing instrument.
SynthDef(\playBuf,
		{ |buffer, start = 0, dur = 0.25, amp = 1|
	var sig = PlayBuf.ar(1,buffer,startPos: start, loop: 0);
	var env = EnvGen.kr(Env.linen(0.01,dur,0.01,level:amp),doneAction:2);
	Out.ar(0,(sig*env) !2);
}
	).add;

//	Synth(\playBuf, [\buffer, b[2]]); // uncomment and use this line to hear indiviual sounds stored in buffers.

	// ~p = [\k, \r, \h, \r, \s, \r, \h, \r]; // 1D drum pattern
	// ~p = [\k, \h, \r, \h, \s, \r, \h, \h]; // 1D drum pattern
	// ~p = [\k, \h, \hH, \h, \s, \h, \hH, \h]; // 1D drum pattern
	~p = [\h, Rest(), Rest(), \h, Rest(), Rest(), \h, Rest()]; //drill pattern
	// ~p = [\guitar];
	// ~p = ~p.reverse;

/* // THIS WILL NOT WORK WITHOUT THE ~invFunc FUNCTION -- YOU HAVE TO MAKE THAT ;)
~invInts = ~invFunc.([0,-3,-2,-3,1,-3,-2,-3]);
~beat = List[];
~p.size.do {|i| ~beat.add(~kit.wrapAt(~start + ~invInts[i]))};
~p = ~beat.copy;
*/

~k = List[]; // list for the kick drum
~s = List[]; // list for the snare drum
~h = List[]; // list for the hi-hat
~hH = List[]; // list for the other hi-hat
~guitar = List[];

// create separate "parts" for each drum. Fills the array with short values where the symbol is present in the original beat, and with Rests where there are no symbols.
~p.size.do {|i|
	if (~p[i] == \k, {~k.add(0.25)}, {~k.add(Rest(0.25))});
	if (~p[i] == \s, {~s.add(0.25)}, {~s.add(Rest(0.25))});
	if (~p[i] == \h, {~h.add(0.25)}, {~h.add(Rest(0.25))});
	if (~p[i] == \hH, {~hH.add(0.25)}, {~hH.add(Rest(0.25))});
	if (~p[i] == \guitar, {~guitar.add(0.25)}, {~guitar.add(Rest(0.25))});
};










	// testing testing 123


// see them all
~k.postln; // the kick line -- feed to \kick
~s.postln;
~h.postln;
~hH.postln;
~guitar.postln;

s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

	~kick = Pbind(\instrument, \playBuf, \dur, Pseq(~k, inf), \buffer, b[0], \amp, 1.0);
	~snare = Pbind(\instrument, \playBuf, \dur, Pseq(~s, inf), \buffer, b[1], \amp, 1.0);
	~hat = Pbind(\instrument, \playBuf, \dur, Pseq(~h, inf), \buffer, b[2], \amp, 0.55);
	~hatOpen = Pbind(\instrument, \playBuf, \dur, Pseq(~hH, inf), \buffer, b[3], \amp, 0.35);
	~guitar = Pbind(\instrument, \playBuf, \dur, Pseq(~guitar, inf), \buffer, b[4], \amp, 1.0);

// Here your simple, yet lit beat

	Ppar([~kick, ~snare, ~hat, ~hatOpen, ~guitar], inf).play;

}
)