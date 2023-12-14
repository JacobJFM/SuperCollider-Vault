/*

SIMPLE BEAT SEQUENCER

*** OVERVIEW ***

- measures are divided into 16th notes
- instructions for user input are given in USER INPUT SECTION

*/
(

s.waitForBoot {
	// -----------------------------------------------------------------------------------------------------------------------
/*
	*** USER INPUT SECTION ***

	Basic Instructions:

	For each input section, 'enabled' is associated with a boolean that determines whether to read values inputted by the user or to use the default values.
	For each input you would like to specify, change the bool from 'false' to 'true'.
	e.g. If you want to replace the default tempo with one of your choosing, first change the value of 'tempo_given' from 'false' to 'true'.

	The idea here is that if you want to quickly revert to default values,
	you can just change the boolean to 'false' instead of having to remember what the original values were.

	The 'input' key corresponds to the values you'd like to set for each field.

	The 'default' key corresponds to values that will be used if 'enabled' is set to 'false'.

	The intention is for the user to only mess with the 'input' values, though I suppose one could also treat this as
	a quick way to perform A-B tests, by editing both values and using the 'enabled' flag to switch between them.

*/


/*	Measures and Transformations
	The length of the array used (either input or defaul) determines the number of measures that will play.
	The array you use can be as long as you like or as short as 1 element long.
*/

	~measures = (enabled: false,
		input: [0, 0, 0, 0],
		default: [0, 1, 2, 3, 0, 2, 2, 1]
	);


	// Tempo in beats per minute
	~tempo = (enabled: true,
		input: 80,
		default: 120
	);

/*
	Each sample is given an array of size 16 corresponding to the 16th notes of each measure.
	For each point in time at which you would like a sample to trigger, replace the corresponding '0' with a '1'.
	e.g. if you would like the snare sample to trigger on the 3rd 1/4 note, AKA the 9th 1/8th note,
	replace the '0' at snare_pattern[8] with a '1'.
*/

	~kick = (
		enabled: false,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
	);
	~snare = (
		enabled: false,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]
	);
	~hat1 = (
		enabled: false,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0]
	);
	~hat2 = (
		enabled: false,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]
	);
	~rim = (
		enabled: false,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1]
	);

	// *** END OF USER INPUT SECTION ***
	// -----------------------------------------------------------------------------------------------------------------------

	// set tempo
	t = TempoClock.default; // the default clock
	if(~tempo[\enabled] == true) {
		~newTempo = ~tempo[\input] / 60; } {
		~newTempo = ~tempo[\default] / 60; };
	t.tempo = ~newTempo;

	// load files from subdirectory labeled "samples"
	b = [\kick, \sd, \hh1, \hh2, \rim].collect{|val| Buffer.read(s,("samples/"++val++".wav").resolveRelative) };


	// a very simple sample-playing instrument (as given in starter code)
	SynthDef(\playBuf,
		{ |buffer, start = 0, dur = 0.25, amp = 1|
			var sig = PlayBuf.ar(1,buffer,startPos: start, loop: 0);
			var env = EnvGen.kr(Env.linen(0.01,dur,0.01,level:amp),doneAction:2);
			Out.ar(0,(sig*env) !2);
		}
	).add;

	// create sequences of play and rests for each sample
	~sampleDicts = [~kick, ~snare, ~hat1, ~hat2, ~rim];
	~sampleDicts.do {
		|dict|
		var data;
		if(dict[\enabled] == true) {
			data = dict[\input] } {
			data = dict[\default] };
		dict.put(\sequence,
			data.collect { |step|
				if(step == 1) {0.25} {Rest(0.25)};
		});
	};

	// determine number of measures
	if(~measures[\enabled]) {
		~numMeasures = ~measures[\input]; } {
		~numMeasures = ~measures[\default]; };

	s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

	// create Pbinds for each sample
	~kickBind = Pbind(\instrument, \playBuf, \dur, Pseq(~kick[\sequence], 1), \buffer, b[0], \amp, 1.0);
	~snareBind = Pbind(\instrument, \playBuf, \dur, Pseq(~snare[\sequence], 1), \buffer, b[1], \amp, 1.0);
	~hat1Bind = Pbind(\instrument, \playBuf, \dur, Pseq(~hat1[\sequence], 1), \buffer, b[2], \amp, 0.55);
	~hat2Bind = Pbind(\instrument, \playBuf, \dur, Pseq(~hat2[\sequence], 1), \buffer, b[3], \amp, 0.20);
	~rimBind = Pbind(\instrument, \playBuf, \dur, Pseq(~rim[\sequence], 1), \buffer, b[4], \amp, 0.60);

	// play each Pbind in parallel
	Ppar([~kickBind, ~snareBind, ~hat1Bind, ~hat2Bind, ~rimBind], ~numMeasures).play;



	// 0.exit;

})