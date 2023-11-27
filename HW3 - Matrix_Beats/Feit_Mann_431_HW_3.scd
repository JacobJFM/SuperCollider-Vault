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

	/*
	*** USER INPUT SECTION ***
	Basic Instructions: For each input section, the first variable is a bool that determines whether to read values inputted by the user or to use the default values.
	For each input you would like to specify, change the corresponding bool from 'False' to 'True'.
	e.g. If you want to replace the default tempo with one of your choosing, first change the value of 'tempo_given' from 'False' to 'True'.
	*/


	// Tempo in beats per minute
	var tempo_given = False;
	var tempo = 120;

	/*
	Each sample is given an array of size 16 corresponding to the 16th notes of each measure.
	For each point in time at which you would like a sample to trigger, replace the corresponding '0' with a '1'.
	e.g. if you would like the snare sample to trigger on the 3rd 1/4 note, AKA the 9th 1/8th note,
	replace the '0' at snare_pattern[8] with a '1'.

	By default, you must enable user input for each sample by changing the corresponding bool from 'False' to 'True'.
	However, if you would like to give input for all of the samples, you can leave the bools for the individual patterns alone,
	and simply change the value of 'all_patterns_given' to 'True'.
	This will override any bools for individual samples/patterns that read 'False'.
	*/
	var all_patterns_given = False;

	var kick_given = False;
	var kick_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var snare_given = False;
	var snare_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var hat1_given = False;
	var hat1_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var hat2_given = False;
	var hat2_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


	// *** END OF USER INPUT SECTION ***


	// set tempo
	t = TempoClock.default; // the default clock
	if(tempo_given) {
		t.tempo = tempo/60; } {
		t.tempo = 120/60; }

	// load files from subdirectory labeled "samples"
	b = [\kick, \sd, \hh1, \hh2].collect{|val| Buffer.read(s,("samples/"++val++".wav").resolveRelative) };


	// a very simple sample-playing instrument (as given in starter code)
	SynthDef(\playBuf,
		{ |buffer, start = 0, dur = 0.25, amp = 1|
			var sig = PlayBuf.ar(1,buffer,startPos: start, loop: 0);
			var env = EnvGen.kr(Env.linen(0.01,dur,0.01,level:amp),doneAction:2);
			Out.ar(0,(sig*env) !2);
		}
	).add;

	/*	// create arrays for each sample. Fill each with rests, which will be replaced with a single play of the sample

	~k = Array.fill(16, {Rest(0.25)}); // array for the kick drum
	~s = Array.fill(16, {Rest(0.25)}); // array for the snare drum
	~h1 = Array.fill(16, {Rest(0.25)}); // array for hi-hat 1
	~h2 = Array.fill(16, {Rest(0.25)}); // array for hi-hat 2
	*/


	// set patterns

	// place all patterns in an array to be looped through more easily
	~allPatterns = [kick_pattern, snare_pattern, hat1_pattern, hat2_pattern];

	if(all_patterns_given) {
		for(0, ~allPatterns.size)



		s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

		// create Pbinds for each sample
		~kick = Pbind(\instrument, \playBuf, \dur, Pseq(~k, inf), \buffer, b[0], \amp, 1.0);
		~snare = Pbind(\instrument, \playBuf, \dur, Pseq(~s, inf), \buffer, b[1], \amp, 1.0);
		~hat1 = Pbind(\instrument, \playBuf, \dur, Pseq(~h1, inf), \buffer, b[2], \amp, 0.55);
		~hat2 = Pbind(\instrument, \playBuf, \dur, Pseq(~h2, inf), \buffer, b[3], \amp, 0.35);
		~guitar = Pbind(\instrument, \playBuf, \dur, Pseq(~guit, inf), \buffer, b[4], \amp, 0.20);



		// Play each Pbind in parallel

		Ppar([~kick, ~snare, ~hat1, ~hat2, ~guitar], inf).play;




		// 0.exit;

	}
)
