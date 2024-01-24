/* USAGE:
Due to the particularities of working with MIDI devices and with different operating systems,
I found that dynamically adjusting to each situation was just out of my scope.
Here's how to make this system work for you:

WINDOWS:
I built this on Windows, so honestly this is the only one I'm very confident in.
1. download loopMIDI: https://www.tobias-erichsen.de/software/loopmidi.html
2. evaluate this (it does get run automatically if you evaluate this entire file, but probably easier to just do it first): (
 MIDIdef.freeAll;
 MIDIClient.init;
 MIDIClient.destinations;
 )
3. note whichever index in MIDI Destinations belongs to loopMIDI.
 set ~midiOutput equal to that index. Mine is set to 3.

MacOS:
I did not have time to test this on a mac system, so I am not sure of all the steps you would need to take to adjust this program, but much of my code was based on this video which should explain it fairly well (this link will put you at the proper timestamp): https://youtu.be/ih2uqOaqb4c?si=fI4ITdRmVf48U3KW&t=81

Linux:
The documentation suggests that Linux systems are a whole nother beast with this stuff, so if possible I would suggest just finding another machine to run this on :/

*/


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

	~midiOutput = 3;

	~arpEnabled = true;
	~arpMode = \upward;

	// current chord - can be set equal to the symbol for any of our available chords.
	~chordEnabled = true;
	~currentChord = \minor;

	// if chord mode is off, this keeps track of all pressed notes
	~heldNotes = List(16);

	~tempo = 50;

	~alter = {
		|arpEnabled, signal, val, chord, root, tempo|
		var notesArray;
		var updateNotes = {
			if(~chordEnabled) {
				notesArray = chord;
			} {
				notesArray = ~heldNotes;
			};
		};
		tempo = ~tempo;
		updateNotes.value;
		switch(arpEnabled)
		{ false } {
			if(~chordEnabled) { chord.do({ |note|
				if(signal == \on) {
					m.noteOn(0, note, val); } {
					m.noteOff(0, note); }})} {
				if(signal == \on) {
					m.noteOn(0, root, val); } {
					m.noteOff(0, root);
		} } }
		{ true } {
			var noteIndex = 0;
			var interval = 60/tempo;
			var direction = 1;

			// stop previous task if it's still running
			if (arpTask.notNil) {
				arpTask.stop();
				notesArray.do { |note| m.noteOff(0, note); };
			};

			arpTask = Task({
				loop {
					updateNotes.value;
					if (notesArray.size > 0 && signal == \on) {
						noteIndex = noteIndex % notesArray.size;

						m.noteOn(0, notesArray[noteIndex], val);
						interval.wait;
						m.noteOff(0, notesArray[noteIndex]);

						switch(~arpMode)
						{ \upward } {
							noteIndex = (noteIndex + 1) % notesArray.size; }
						{ \downward } {
							noteIndex = (noteIndex - 1);
							if (noteIndex < 0) { noteIndex = notesArray.size - 1; } }
						{ \random } {
							noteIndex = (notesArray.size).rand; }
						{ \randomWalk } {
							noteIndex = noteIndex + [-1, 1].choose;
							if (noteIndex < 0) { noteIndex = 0; };
							if (noteIndex >= notesArray.size) { noteIndex = notesArray.size - 1; }; }
						{ \pingPong } {
							if (noteIndex >= (notesArray.size -1)) {
								direction = -1;
							};
							if (noteIndex <= 0) {
								direction = 1;
							};
							noteIndex = (noteIndex + direction).clip(0, notesArray.size - 1); }
						{ "no arp mode specified".postln; };
					} {
						// if signal is off, stop the task
						notesArray.do { |note| m.noteOff(0, note); };
						thisThread.stop();
					};
				}
			}).play(); };
	};


	// MIDI setup

	MIDIdef.freeAll;
	MIDIClient.init;
	MIDIClient.destinations;
	m = MIDIOut.new(~midiOutput); // particular to my PC - will have to be adjusted
	MIDIIn.connect;

	(
		MIDIdef.noteOn(\noteOn, {
			|val, num|
			if(~chordEnabled.not) {
				~heldNotes.add(num);
			};
			~alter.value(~arpEnabled, \on, val,
				(if(~chordEnabled) {
					~currentChord.postln;
					chords[~currentChord].value(num)
				};),
				num
			);
		});

		MIDIdef.noteOff(\noteOff, {
			|val, num|
			if(~chordEnabled.not) {
				~heldNotes.remove(num);
			};
			~alter.value(~arpEnabled, \off, val,
				(if(~chordEnabled) {
					~currentChord.postln;
					chords[~currentChord].value(num);
				};),
				num
			);
		});

	);

}
)