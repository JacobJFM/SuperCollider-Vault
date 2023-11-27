/*
       __________  ___   ____             __     _____
      / / ____/  |/  /  / __ )___  ____ _/ /_   / ___/___  ____ ___  _____  ____  ________  _____
 __  / / /_  / /|_/ /  / __  / _ \/ __ `/ __/   \__ \/ _ \/ __ `/ / / / _ \/ __ \/ ___/ _ \/ ___/
/ /_/ / __/ / /  / /  / /_/ /  __/ /_/ / /_    ___/ /  __/ /_/ / /_/ /  __/ / / / /__/  __/ /
\____/_/   /_/  /_/  /_____/\___/\__,_/\__/   /____/\___/\__, /\__,_/\___/_/ /_/\___/\___/_/
                                                           /_/



*** OVERVIEW ***

- measures are divided into 16th notes

- user input determines:
-- global tempo
-- pattern for each sample

- instructions for user input are given in USER INPUT SECTION

- for each parameter, default values will be used if user input is not specified

*/
(

s.waitForBoot {


	// *** USER INPUT SECTION ***

	// Input time in beats per minute
	var tempo = 120;

	/*
	Each sample is given an array of size 16 corresponding to the 16th notes of each measure.
	For each point in time at which you would like a sample to trigger, replace the corresponding '0' with a '1'.
	e.g. if you would like the snare sample to trigger on the 3rd 1/4 note, AKA the 9th 1/8th note,
	replace the '0' at snare_pattern[8] with a '1'.
	*/

	var kick_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


	t = TempoClock.default; // the default clock
	t.tempo = 160/60; // beats per second

	// load files from subdirectory labeled "samples"
	b = [\kick, \sd, \hh1, \hh2, \guitar].collect{|val| Buffer.read(s,("samples/"++val++".wav").resolveRelative) };


	// a very simple sample-playing instrument.
	SynthDef(\playBuf,
		{ |buffer, start = 0, dur = 0.25, amp = 1|
			var sig = PlayBuf.ar(1,buffer,startPos: start, loop: 0);
			var env = EnvGen.kr(Env.linen(0.01,dur,0.01,level:amp),doneAction:2);
			Out.ar(0,(sig*env) !2);
		}
	).add;

	// create arrays for each sample. Fill each with rests, which will be replaced with a single play of the sample

	~k = Array.fill(16, {Rest(0.25)}); // array for the kick drum
	~s = Array.fill(16, {Rest(0.25)}); // array for the snare drum
	~h = Array.fill(16, {Rest(0.25)}); // array for the hi-hat
	~hH = Array.fill(16, {Rest(0.25)}); // array for the other hi-hat
	~guit = Array.fill(16, {Rest(0.25)});


	s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

	// create Pbinds for each sample
	~kick = Pbind(\instrument, \playBuf, \dur, Pseq(~k, inf), \buffer, b[0], \amp, 1.0);
	~snare = Pbind(\instrument, \playBuf, \dur, Pseq(~s, inf), \buffer, b[1], \amp, 1.0);
	~hat = Pbind(\instrument, \playBuf, \dur, Pseq(~h, inf), \buffer, b[2], \amp, 0.55);
	~hatOpen = Pbind(\instrument, \playBuf, \dur, Pseq(~hH, inf), \buffer, b[3], \amp, 0.35);
	~guitar = Pbind(\instrument, \playBuf, \dur, Pseq(~guit, inf), \buffer, b[4], \amp, 0.20);



	~kick.play;

	// Play each Pbind in parallel

	Ppar([~kick, ~snare, ~hat, ~hatOpen, ~guitar], inf).play;




	// 0.exit;

}
)
