// I got a lot of help from Eli Fieldsteel's YouTube chanel: https://www.youtube.com/watch?v=Oz4KYZ9KLc0
(
Server.killAll;
s.waitForBoot {

	var chords = [
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
	];

	// d is our dict of available chords
	d = Dictionary.newFrom(chords);

	// c is our current mode. It can be set equal to the symbol for any of our available modes.
	c = \sus2;


	// MIDI setup

	MIDIdef.freeAll;
	MIDIClient.init;
	MIDIClient.destinations;
	m = MIDIOut.new(3); // particular to my PC - will have to be adjusted
	MIDIIn.connect;

	(
		MIDIdef.noteOn(\noteOn, {
			|val, num|
			c.postln;
			d[c].value(num).do({ // perform noteOn for each note in the chord
				|noteNum|
				noteNum.postln;
				m.noteOn(0, noteNum, val);
			});
		});

		MIDIdef.noteOff(\noteOff, {
			|val, num|
			d[c].value(num).do({ // perform noteOff for each note in the chord
				|noteNum|
				m.noteOff(0, noteNum);
			});
		});

	);

}
)