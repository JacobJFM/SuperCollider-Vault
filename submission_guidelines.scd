/* Code Submission Format: Projects

All code submitted for projects should be submitted in the following format. This format ensures 1) one-click evaluation and 2) that your code can be run in command-line mode:

$ sclang yourFile.scd

*/

(
s.waitForBoot( {

// Variables here:

// SynthDefs here:

s.sync; // waits for asynchronous client-->server communications to complete

// Your valide code here: Routines, Patterns, etc.

})

)


/* Code Submission Format: Psets

All code submitted for Psets should be submitted in the following format:

*/

(

// All of your valid code here. You can assume my server.local is booted. If you require a different server be booted you must ensure so in your code.

)

/* For command-line execution be sure your code follows the above outline (assuming it makes sound...) and then append 0.exit to the end of your last language-based routine or pattern. That will ensure that sclang quits cleanly upon completion. */

(
s.waitForBoot( {

// Variables here:

// SynthDefs here:

s.sync; // waits for asynchronous client-->server communications to complete


fork {

	// Your valide code here: Routines, Patterns, etc.

	totalTimetoComplete.wait;

		0.exit;

	}

})

)


// s.options.numInputBusChannels = 0;
