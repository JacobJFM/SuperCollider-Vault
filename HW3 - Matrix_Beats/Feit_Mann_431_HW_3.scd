
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

//

~k = Array.newClear(16); // array for the kick drum
~s = Array.newClear(16); // array for the snare drum
~h = Array.newClear(16); // array for the hi-hat
~hH = Array.newClear(16); // array for the other hi-hat
~guit = Array.newClear(16);


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



(
w = Window("Experiment", Rect(200,200,600,300));
~butt_kick = View(w, Rect(0, 0, ))

b = Button(w, Rect(20, 20, 20, 20)).states_([
	["", Color.red, Color.white],
	["", Color.red, Color.blue]
])
.action_({ arg butt;
	butt.value.postln;
});

w.front;
)