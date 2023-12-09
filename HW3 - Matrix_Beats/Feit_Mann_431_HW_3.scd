/*

JACOB'S BEAT SEQUENCER

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
	// -----------------------------------------------------------------------------------------------------------------------
	/*
	*** USER INPUT SECTION ***

	Basic Instructions:

	For each input section, the first key, 'enabled', corresponds to a boolean that determines whether to read values inputted by the user or to use the default values.
	For each input you would like to specify, change the bool from 'False' to 'True'.
	e.g. If you want to replace the default tempo with one of your choosing, first change the value of 'tempo_given' from 'False' to 'True'.

	The idea here is that if you want to quickly revert to default values,
	you can just change the boolean to 'False' instead of having to remember what the original values were.

	The 'input' key corresponds to the values you'd like to set for each field.

	The 'default' key corresponds to values that will be used if 'enabled' is set to 'False'.
	The intention is for the user to only mess with the 'input' values, though I suppose one could also treat this as
	a quick way to perform A-B tests, by editing both values and using the 'enabled' flag to switch between them.

	*/


	// Tempo in beats per minute
	var tempo = IdentityDictionary(enabled: False, input: 120, default: 120);

	/*
	Each sample is given an array of size 16 corresponding to the 16th notes of each measure.
	For each point in time at which you would like a sample to trigger, replace the corresponding '0' with a '1'.
	e.g. if you would like the snare sample to trigger on the 3rd 1/4 note, AKA the 9th 1/8th note,
	replace the '0' at snare_pattern[8] with a '1'.
	*/
	var kick = IdentityDictionary(
		enabled: False,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]
	);
	var snare = IdentityDictionary(
		enabled: False,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0]
	);
	var hat1 = IdentityDictionary(
		enabled: False,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	);
	var hat2 = IdentityDictionary(
		enabled: False,
		input: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		default: [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
	);

	// *** END OF USER INPUT SECTION ***
	// -----------------------------------------------------------------------------------------------------------------------

	// set tempo
	t = TempoClock.default; // the default clock
	if(tempo[\enabled]) {
		t.tempo = tempo[\input]/60; } {
		t.tempo = tempo[\default]/60; }

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

	// create sequences of play and rests for each sample
	~sampleDicts = [kick, snare, hat1, hat2];
	~sampleDicts.do {
		|dict|
		var data = dict[\enabled] ? dict[\input] : dict[\default];
		dict.put(\sequence,
			data.collect { |step|
				step == 1 ? 0.25 : Rest(0.25);
		});
	}


	s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

	// create Pbinds for each sample
	~kickBind = Pbind(\instrument, \playBuf, \dur, Pseq(kick[\sequence], inf), \buffer, b[0], \amp, 1.0);
	~snareBind = Pbind(\instrument, \playBuf, \dur, Pseq(snare[\sequence], inf), \buffer, b[1], \amp, 1.0);
	~hat1Bind = Pbind(\instrument, \playBuf, \dur, Pseq(hat1[\sequence], inf), \buffer, b[2], \amp, 0.55);
	~hat2Bind = Pbind(\instrument, \playBuf, \dur, Pseq(hat2[\sequence], inf), \buffer, b[3], \amp, 0.35);

	// play each Pbind in parallel
	Ppar([~kickBind, ~snareBind, ~hat1Bind, ~hat2Bind], inf).play;

	0.exit;

})