
(
var keys = [\C, \G, \D]; // Define the keys your machine will handle
var currentState = \C; // Initial state

// Define the processInput function separately
~processInput = { |machine, inputSymbol|
	"Received input symbol: ".post; inputSymbol.postln; // Diagnostic print
	switch(inputSymbol,
		\generate_c, {
			if (machine.state == \C) {
				"Generating progression in C".postln;
				machine.generateProgression.(machine.state);
			} {
				"Currently not in C, cannot generate progression in C".postln;
				// Optionally, you might want to modulate to C here before generating the progression
				// mealyMachine.modulate.(mealyMachine.state, \C);
				// mealyMachine.state = \C;
			};
		},
		\modulate_c, {
			if (machine.state != \C) {
				machine.modulate.(machine.state, \C);
				machine.state = \C; // Update state after modulation
			} {
				"Already in C, no modulation needed".postln;
			};
		},
		{
			"Invalid inputSymbol".postln; // Default case for invalid inputSymbol
		}
	);
};

// Define the mealyMachine
~mealyMachine = (
	state: currentState,
	generateProgression: { |key|
		"Generating progression in ".post; key.postln;
		// Placeholder for actual progression generation logic
	},
	modulate: { |fromKey, toKey|
		"Modulating from ".post; fromKey.post; " to ".post; toKey.postln;
		// Placeholder for actual modulation logic
	}
);

// Test the machine with different input symbols
~processInput.(~mealyMachine, \generate_c); // Should generate progression in C
//~processInput.(~mealyMachine, \modulate_c); // Should modulate to C, if not already in C
//~processInput.(~mealyMachine, \generate_d); // Invalid input, should print "Invalid input"
)