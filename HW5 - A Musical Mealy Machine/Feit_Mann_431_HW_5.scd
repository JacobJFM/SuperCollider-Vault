(
s.waitForBoot{

	var keys = [\C, \G, \D];
	var currentState = \C;
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
	var tonicizations = (
		C: (
			G: [[60, 64, 67], [62, 65, 69], [67, 71, 74]], // C,Dm,G
			D: [[60, 64, 67], [66, 69, 73], [62, 66, 69]]  // C,F#dim,D
		),
		G: (
			C: [[67, 71, 74], [65, 69, 72], [60, 64, 67]], // G,F,C
			D: [[67, 71, 74], [62, 65, 69], [62, 66, 69]]  // G,Dm,D
		),
		D: (
			C: [[62, 66, 69], [59, 62, 65], [60, 64, 67]], // D,Bm,C
			G: [[62, 66, 69], [69, 73, 76], [67, 71, 74]]  // D,A7,G
		)
	);
	var modulations = (
		C: (
			G: [[60, 64, 67], [69, 72, 76], [62, 66, 69, 72], [67, 71, 74]], // C,Am,D7,G
			D: [[60, 64, 67], [67, 71, 74], [57, 61, 64, 67], [62, 66, 69]] // C,G,A7,D
		),
		G: (
			C:  [[67, 71, 74], [62, 65, 69], [67, 71, 74, 77], [60, 64, 67]], // G,Dm,G7,C
			D: [[67, 71, 74], [64, 67, 71], [57, 61, 64, 67], [62, 66, 69]] // G,Em,A7,D
		),
		D: (
			C: [[62, 66, 69], [57, 61, 64, 67], [57, 60, 64], [55, 59, 62], [60, 64, 67]], // D,A7,Am,G,C
			G: [[62, 66, 69], [59, 62, 66], [64, 67, 71], [57, 61, 64, 67], [62, 66, 69], [67, 71, 74]] // D,Bm,Em,A7,D,G
		)
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
		tonicize: {
			|key|
			if(key != currentState) {
				chordsList.addAll(tonicizations[currentState][key]).postln; // select the key to tonicize
			} {
				"Can't tonicize to current key!".postln; };
		},
		modulate: {
			|key|
			if(key != currentState) {
				chordsList.addAll(modulations[currentState][key]).postln; // select the pathway from the current key to the new key
			} {
				"Can't modulate to current key!".postln; };
		}
	);

	var isPlaying = false;

	// initialize list to avoid empty list error in Pseq later on
	chordsList.add(Rest());

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



	{
		var window, keyButtons, addButton, actionsList, currentStateDisplay, overlay, disableOverlay, overlayMessage, initKeyButtons;
		var lastAction, lastKey, addActionToList, actionButtons, playButton;
		var left, top, width, height;
		var indigo, orange, green;

		left = (Window.screenBounds.width / 2) - 200;
		top = (Window.screenBounds.height / 2) - 200;
		width = 400;
		height = 350;

		actionsList = List.new;
		lastAction = nil;
		lastKey = nil;

		Font.default = Font("Eurostile Extd", 14, true);
		indigo = Color.new255(29, 23, 207);
		orange = Color.new255(255, 153, 102, 230);
		green = Color.new255(91, 171, 119);

		window = Window.new("A Musical Mealy Machine", Rect(left, top, width, height), false)
		.alwaysOnTop_(true)
		.background_(indigo);


		// action buttons
		actionButtons = ["Generate", "Tonicize", "Modulate"].collect { |action, i|
			Button(window, Rect(30, 30 + (i * 50), (width/2) - 40, height/8))
			.states_([
				[action, Color.black, Color.white],
				[action, Color.white, orange]])
			.action_({
				|button|
				actionButtons.do(~resetButtonStates);
				lastAction = action;
				button.value = 1;
			});
		};

		// key buttons
		keyButtons = [\C, \G, \D].collect { |key, i|
			Button(window, Rect((width/2) + 10, 30 + (i * 50), (width/2) - 40, height/8))
			.states_([
				[key, Color.black, Color.white],
				[key, Color.white, orange]])
			.action_({
				|button|
				keyButtons.do(~resetButtonStates);
				lastKey = key;
				button.value = 1;
			});
		};

		// function to reset button states
		~resetButtonStates = {
			|button|
			button.value = 0;
		};

		// display current state
		currentStateDisplay = StaticText(window, Rect(30, height - 30, 380, 20))
		.stringColor_(Color.white)
		.string_("Current State: " ++ currentState);
		~updateCurrentState = { |newState|
			currentState = newState;
			currentStateDisplay.string = "Current State: " ++ currentState.asString;
		};


		// add button
		addButton = Button(window, Rect(30, 200, width - 60, 40))
		.states_([["Add"]])
		.action_(
			{
				("lastAction:" + lastAction).postln;
				("lastKey:" + lastKey).postln;
				if(lastAction.notNil && lastKey.notNil) {
					switch(lastAction)
					{ "Generate" } { mealy[\generate].value(lastKey) }
					{ "Tonicize" } { mealy[\tonicize].value(lastKey) }
					{ "Modulate" } { mealy[\modulate].value(lastKey); ~updateCurrentState.value(lastKey) }
					{ "something went wrong...".postln };
				};

				// refresh action and key
				lastAction = nil;
				lastKey = nil;
				keyButtons.do(~resetButtonStates);
				actionButtons.do(~resetButtonStates);
			}
		);


		// play button
		playButton = Button(window, Rect(30, 250, width - 60, 40))
		.states_([
			["Play", Color.white, green] ])
		.action_({
			if(isPlaying)
			{ s.defaultGroup.freeAll;
				isPlaying = false;
				Routine({
					0.1.wait;
					~bigProg.play;
					isPlaying = true;
			}).play; }
			{ ~bigProg.play;
				isPlaying = true; };
		});

		overlay = UserView(window, Rect(0, 0, width, height))
		.background_(orange);

		overlayMessage = StaticText(overlay, Rect(100, 100, 200, 20))
		.stringColor_(indigo)
		.string_("Choose a key to start")
		.align_(\center);

		disableOverlay = {
			overlay.visible = false;
			overlay.enabled = false;
		};

		initKeyButtons = [\C, \G, \D].collect { |key, i|
			Button(overlay, Rect(150, 130 + (i * 30), 100, 20))
			.states_([[key]])
			.action_({
				currentState = key;
				~updateCurrentState.value(key);
				chordsList.pop;
				disableOverlay.value;
			});
		};

		window.front;
	}.value;


	~bigProg = Pbind(
		\instrument, \Piano_rhodeySC,
		\legato, Pseq([0.9, 0.5, 0.5, 0.9, 0.9, 0.9, 0.9, 0.5, 1, 0.5, 1, 0.6, 0.3], inf),
		\dur, Pseq([1/2], inf),
		\midiNote, Pseq(chordsList),
		\mix, 0.2,
		\modIndex, 0.2,
		\lfoSpeed, 0.5,
		\lfoDepth, 0.4,
		\vel, Pgauss(0.8, 0.1, inf),
		\amp, 0.3
	);

}
)