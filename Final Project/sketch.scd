// I got a lot of help from Eli Fieldsteel's YouTube chanel: https://www.youtube.com/watch?v=Oz4KYZ9KLc0
(
Server.killAll;
s.waitForBoot {

	// dict of available chords
	var chords = Dictionary.newFrom([
		\major, { |root|
			[root, root + 4, root + 7] },
		\minor, { |root|
			[root, root + 3, root + 7] },
		\diminished, { |root|
			[root, root + 3, root + 6] },
		\maj7, { |root|
			[root, root + 4, root + 7, root + 11] },
		\min7, { |root|
			[root, root + 3, root + 7, root + 10] },
		\7, { |root|
			[root, root + 4, root + 7, root + 10] },
		\sus2, { |root|
			[root, root + 2, root + 7] },
		\sus4, { |root|
			[root, root + 5, root + 7] },
		\aug, { |root|
			[root, root + 4, root + 8] },
	]);

	var arpTask;
	~currentMode = \arpeggiate;
	~arpMode = \upward;

	// current chord - can be set equal to the symbol for any of our available chords.
	~currentChord = \min7;
	~alter = {
		|mode, signal, val, chord, tempo = 170|
		switch(mode)
		{ \normal } {
			chord.do({
				|note|
				if(signal == \on)
				{ m.noteOn(0, note, val); }
				{ m.noteOff(0, note); }
		}) }
		{ \arpeggiate } {
			var noteIndex = 0;
			var interval = 60/tempo;
			var direction = 1;

			// stop previous task if it's still running
			if (arpTask.notNil) {
				arpTask.stop();
				chord.do { |note| m.noteOff(0, note); };
			};

			arpTask = Task({
				loop {
					if (signal == \on) {
						if (noteIndex > 0) {
							m.noteOff(0, chord[noteIndex - 1]);};
						m.noteOn(0, chord[noteIndex], val);
						switch(~arpMode)
						{ \upward } {
							noteIndex = (noteIndex + 1) % chord.size; }
						{ \downward } {
							noteIndex = (noteIndex - 1);
							if (noteIndex < 0) { noteIndex = chord.size - 1; } }
						{ \random } {
							noteIndex = (chord.size).rand; }
						{ \randomWalk } {
							noteIndex = noteIndex + [-1, 1].choose;
							if (noteIndex < 0) { noteIndex = 0; };
							if (noteIndex >= chord.size) { noteIndex = chord.size - 1; }; }
						{ \pingPong } {
							if (noteIndex >= (chord.size -1)) {
								direction = -1;
							};
							if (noteIndex <= 0) {
								direction = 1;
							};
							noteIndex = (noteIndex + direction).clip(0, chord.size - 1); }
						{ "no arp mode specified".postln; };
					} {
						// if signal == /off
						chord.do({ |note| m.noteOff(0, note); });
						arpTask.stop();
					};
					interval.wait; }
			});
			arpTask.play(); }
		{ "no mode selected???".postln; };
	};


	// MIDI setup

	MIDIdef.freeAll;
	MIDIClient.init;
	MIDIClient.destinations;
	m = MIDIOut.new(3); // particular to my PC - will have to be adjusted
	MIDIIn.connect;

	(

		MIDIdef.noteOn(\noteOn, {
			|val, num|
			~currentChord.postln;
			~alter.value(~currentMode, \on, val, chords[~currentChord].value(num));
		});

		MIDIdef.noteOff(\noteOff, {
			|val, num|
			~currentChord.postln;
			~alter.value(~currentMode, \off, val, chords[~currentChord].value(num));
		});

	);
}
)