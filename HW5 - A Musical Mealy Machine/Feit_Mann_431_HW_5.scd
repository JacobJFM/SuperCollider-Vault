(
s.waitForBoot{

	var keys = [\C, \G, \D];
	var currentState = \C;
	var pathways = (
		C: (
			G: [[60, 64, 67], [57, 60, 64], [62, 66, 69, 72], [55, 59, 62]], // C,Am,D7,G
			D: [[60, 64, 67], [55, 59, 62], [57, 61, 64, 67], [62, 66, 69]] // C,G,A7,D
		),
		G: (
			C:  [[55, 59, 62], [62, 65, 69], [55, 59, 62, 65], [60, 64, 67]], // G,Dm,G7,C
			D: [[55, 59, 62], [52, 55, 59], [57, 61, 64, 67], [62, 66, 69]] // G,Em,A7,D
		),
		D: (
			C: [[62, 66, 69], [57, 61, 64, 67], [57, 60, 64], [55, 59, 62], [60, 64, 67]], // D,A7,Am,G,C
			G: [[62, 66, 69], [59, 62, 66], [52, 55, 59], [57, 61, 64, 67], [62, 66, 69], [55, 59, 62]] // D,Bm,Em,A7,D,G
		)
	);
	var progressions = (
		C: [
			[[60, 64, 67], [65, 69, 72], [67, 71, 74], [60, 64, 67]], // I-IV-V-I / C,F,G,C
			[[60, 64, 67], [69, 72, 76], [62, 65, 69], [67, 71, 74]]], // I-vi-ii-V / C,Am,Dm,G
		G: [
			[[67, 71, 74], [62, 66, 69], [64, 67, 71], [60, 64, 67]], // I-V-vi-IV / G,D,Em,C
			[[67, 71, 74], [69, 72, 76], [62, 66, 69], [67, 71, 74]]],  // I-ii-V-I / G,Am,D,G
		D: [
			[[62, 66, 69], [69, 73, 76], [71, 74, 78], [67, 71, 74]], // I-V-vi-IV / D,A,Bm,G
			[[62, 66, 69], [66, 69, 73], [71, 74, 78], [64, 67, 71]]]  //  I-iii-VI-II / D,F#m,Bm,Em
	);
	var chordsList = List.new();


	var mealy = (
		generate: {
			|key|
			if(key == currentState) {
				chordsList.addAll(progressions[key].choose).postln; // select one of the progressions for the current key at random
			} {
				"Can only generate progressions for current key!".postln; };
		},
		modulate: {
			|key|
			if(key != currentState) {
				chordsList.addAll(pathways[currentState][key]).postln; // select the pathway from the current key to the new key
				currentState = key; // switch state
				"new key: ".post;
				currentState.postln;
			} {
				"Can't modulate to current key!".postln; };
		}
	);


	// A synthdef by Nathan Ho aka Snappizz (http://sccode.org/1-522) modified to take MIDI information directly instead of scale degrees
	SynthDef(\Piano_rhodeySC, {
		| out = 0, midiNote = 60, gate = 1, pan = 0, amp = 0.1, vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1 |
		var env1, env2, env3, env4;
		var osc1, osc2, osc3, osc4, snd, freq;

		lfoSpeed = lfoSpeed * 12;

		// Convert MIDI note to frequency
		freq = midiNote.midicps;  // Converts MIDI note number to cycles per second/Hz

		env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
		env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
		env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
		env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

		osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
		osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
		osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
		osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
		snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
		snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

		// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
		snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
		snd = Pan2.ar(snd, pan, amp);

		Out.ar(out, snd);
	}).add;


/*   __ __  __   ____ ____     __ __  __ ____  __ __ ______    __  __  ____ ____   ____ __
   || || (( \ ||    || \\    || ||\ || || \\ || || | || |    ||  || ||    || \\ ||    ||
   || ||  \\  ||==  ||_//    || ||\\|| ||_// || ||   ||      ||==|| ||==  ||_// ||==  ||
   \\_// \_)) ||___ || \\    || || \|| ||    \\_//   ||      ||  || ||___ || \\ ||___ ..

	Populate the array below with the functions you'd like to perform, formatted as:
	(mealy[<\method name>].value(<\key))

	For example, to generate a progression for D, you would write:
	(mealy[/generate].value(\D))
	Or, to modulate to G, you would write:
	(mealy[/modulate].value(\G))

	The array has been prepopulated with a default list of functions to perform.
*/

	([
		(mealy[\generate].value(\C)), (mealy[\modulate].value(\G))
	]).do(_.value);

	Pbind(
		\instrument, \Piano_rhodeySC,
		\legato, Pseq([0.9, 0.5, 0.5, 0.9, 0.9, 0.9, 0.9, 0.5, 1, 0.5, 1, 0.6, 0.3], inf),
		\dur, Pseq([1/3], inf),
		\midiNote, Pseq(chordsList, inf),
		\mix, 0.2,
		\modIndex, 0.2,
		\lfoSpeed, 0.5,
		\lfoDepth, 0.4,
		\vel, Pgauss(0.8, 0.1, inf),
		\amp, 0.3
	).play(TempoClock(1.0));

}
)