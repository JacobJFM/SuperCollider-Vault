
     .-./`)   ________ ,---.    ,---.         _______       .-''-.     ____   ,---------.            .-'''-.     .-''-.      ,-----.      ___    _     .-''-.  ,---.   .--.    _______      .-''-.  .-------.
     \ '_ .')|        ||    \  /    |        \  ____  \   .'_ _   \  .'  __ `.\          \          / _     \  .'_ _   \   .'  .-,  '.  .'   |  | |  .'_ _   \ |    \  |  |   /   __  \   .'_ _   \ |  _ _   \
    (_ (_) _)|   .----'|  ,  \/  ,  |        | |    \ |  / ( ` )   '/   '  \  \`--.  ,---'         (`' )/`--' / ( ` )   ' / ,-.|  \ _ \ |   .'  | | / ( ` )   '|  ,  \ |  |  | ,_/  \__) / ( ` )   '| ( ' )  |
      / .  \ |  _|____ |  |\_   /|  |        | |____/ / . (_ o _)  ||___|  /  |   |   \           (_ o _).   . (_ o _)  |;  \  '_ /  | :.'  '_  | |. (_ o _)  ||  |\_ \|  |,-./  )      . (_ o _)  ||(_ o _) /
 ___  |-'`|  |_( )_   ||  _( )_/ |  |        |   _ _ '. |  (_,_)___|   _.-`   |   :_ _:            (_,_). '. |  (_,_)___||  _`,/ \ _/  |'   ( \.-.||  (_,_)___||  _( )_\  |\  '_ '`)    |  (_,_)___|| (_,_).' __
|   | |   '  (_ o._)__|| (_ o _) |  |        |  ( ' )  \'  \   .---..'   _    |   (_I_)           .---.  \  :'  \   .---.: (  '\_/ \   ;' (`. _` /|'  \   .---.| (_ o _)  | > (_)  )  __'  \   .---.|  |\ \  |  |
|   `-'  /   |(_,_)    |  (_,_)  |  |        | (_{;}_) | \  `-'    /|  _( )_  |  (_(=)_)          \    `-'  | \  `-'    / \ `"/  \  )  \| (_ (_) _) \  `-'    /|  (_,_)\  |(  .  .-'_/  )\  `-'    /|  | \ `'   /
 \      /    |   |     |  |      |  |        |  (_,_)  /  \       / \ (_ o _) /   (_I_)            \       /   \       /   '. \_/``"/)  )\ /  . \ /  \       / |  |    |  | `-'`-'     /  \       / |  |  \    /
  `-..-'     '---'     '--'      '--'        /_______.'    `'-..-'   '.(_,_).'    '---'             `-...-'     `'-..-'      '-----' `-'  ``-'`-''    `'-..-'  '--'    '--'   `._____.'    `'-..-'  ''-'   `'-'





*/
(

s.waitForBoot {

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


	// Synth(\playBuf, [\buffer, b[2]]); // uncomment and use this line to hear indiviual sounds stored in buffers.

	// ~p = [\k, \r, \h, \r, \s, \r, \h, \r]; // 1D drum pattern
	// ~p = [\k, \h, \r, \h, \s, \r, \h, \h]; // 1D drum pattern
	// ~p = [\k, \h, \hH, \h, \s, \h, \hH, \h]; // 1D drum pattern
	~p = [\h, Rest(), Rest(), \h, Rest(), Rest(), \h, Rest()]; //drill pattern
	// ~p = [\guitar];
	// ~p = ~p.reverse;



	/* WHAT I NEED INSTEAD OF ABOVE
	The code is structured to take the arrays above, which each have the specification of the patter, and for each index of the pattern above, add something to the corresponding list below. What I need to do is have multiple pattern arrays, one for each sample. Go from there.


	*/
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
~guit = List[];

// create separate "parts" for each drum. Fills the array with short values where the symbol is present in the original beat, and with Rests where there are no symbols.
~p.size.do {|i|
	if (~p[i] == \k, {~k.add(0.25)}, {~k.add(Rest(0.25))});
	if (~p[i] == \s, {~s.add(0.25)}, {~s.add(Rest(0.25))});
	if (~p[i] == \h, {~h.add(0.25)}, {~h.add(Rest(0.25))});
	if (~p[i] == \hH, {~hH.add(0.25)}, {~hH.add(Rest(0.25))});
	if (~p[i] == \guitar, {~guit.add(0.25)}, {~guit.add(Rest(0.25))});
};










	// testing testing 123


// see them all
~k.postln; // the kick line -- feed to \kick
~s.postln;
~h.postln;
~hH.postln;
~guit.postln;

s.sync; // the sync statement causes the below to wait until all asynchronous stuff above has completed.

	~kick = Pbind(\instrument, \playBuf, \dur, Pseq(~k, inf), \buffer, b[0], \amp, 1.0);
	~snare = Pbind(\instrument, \playBuf, \dur, Pseq(~s, inf), \buffer, b[1], \amp, 1.0);
	~hat = Pbind(\instrument, \playBuf, \dur, Pseq(~h, inf), \buffer, b[2], \amp, 0.55);
	~hatOpen = Pbind(\instrument, \playBuf, \dur, Pseq(~hH, inf), \buffer, b[3], \amp, 0.35);
	~guitar = Pbind(\instrument, \playBuf, \dur, Pseq(~guit, inf), \buffer, b[4], \amp, 1.0);

// Here your simple, yet lit beat

	Ppar([~kick, ~snare, ~hat, ~hatOpen, ~guitar], inf).play;



	// 0.exit;

}
)