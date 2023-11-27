// GUI stuff (skipping)
//
// (
// var num_tracks = 5; // how many samples I am using
// var window_width = 600;
// var window_height = (num_tracks * 100) + 100;
// w = Window("Experiment", Rect(200,200, window_width, window_height));
//
// // Create a track for each sample. Each track has 16 beats to sequence.
// num_tracks.do {
// 	// create track
// 	var curr_track = {
// 		View(bounds: Rect(width: window_width - 30, height: 100))
// 	};
// 	// create buttons
// 	16.do {
// 		var new_button = Button(parent: curr_track, bounds: Rect(width: 20, height: 20)).states_([
// 			["", Color.red, Color.white],
// 			["", Color.red, Color.blue]
// 		]).action_({ arg butt;
// 			butt.value.postln;
// 		});
// 	}
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // button template
// b = Button(~butt_kick, Rect(20, 20, 20, 20)).states_([
// 	["", Color.red, Color.white],
// 	["", Color.red, Color.blue]
// ]).action_({ arg butt;
// 	butt.value.postln;
// });
//
//
// // GridLayout of all tracks
// ~tracks_grid = View().layout_(
// 	GridLayout.rows(
// 	n, n, n, n)
// ))