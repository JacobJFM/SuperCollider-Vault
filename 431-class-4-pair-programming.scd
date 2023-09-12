/* 431 Pair Programming: 09122022

Today we will pair up and tackle a few (3) questions designed to get you using SC3. The primary goals are:

1. Familiarity with OOP in SC3
2. Familiarity with functions in SC3
3. Familiarity with many of SC3's literals
4. Implement musical tasks in a programming language
5. Familiarity with the extensive language features (methods) available in SC3
6. Familiarity with changing data collections and types


Please complete the questions as best you can. **When sharing code, please do so with screen shares and discussion rather than copying code into the chat window. Copying and pasting code doesn't assist learning.**

After class, please submit your pair programming code to the following shared Google Drive folder:

https://drive.google.com/drive/folders/19qbGEaijRdLWiaVTLBclV4jSM-gQcw20?usp=sharing

Submissions should be named according to the course naming convention found in the handbook/guidelines.

To incentivise you, each correct answer will be awarded one (1) 431 Bonus Bux® point. This is a free point to be added to your final grade. Just one point could mean the difference between a B+ and an A- (or an F and a D-). I'm just sayin'...

*/

/*  1.a

Write a function that takes a triad (ex. "c major" as a string input and matches it against a collection of triad names. The function should alert the user (and thus the program) that the chord is found or not. If found, the function should return the index of the chord in the collection. The total number of chords and the collection type are up to you. The collection could be contained within the function or exist outside of it. (Is one implementation better than the other?)

*/

/* List your code componenets here: (this one is mostly gratis). The below "method*"s must be found using the built-in search functionality of the IDE.

A function: { }
An Array: []
Strings with names for all chords in the array: "c major", "d minor", "e minor", etc
A method* to check whether the array includes the string:
A method* to return the index of the string:
A logical structure in which to embed inclusion code from above with different returns for true and false: if

*/


( // your code here
var chords;
chords = ["c major", "d minor", "e major", "f minor", "g major", "a minor", "b diminished"];

~checkChordInArray = { |array, chordToCheck|
	var index;
	index = array.indexOfEqual(chordToCheck);
	if (index.isNil) {
		"Chord not found!".postln
	} {
		index.postln;
	}
};

~checkChordInArray.value(chords, "c major");


)


/* Output may look like:

for valid input:
-> Key is recognized. Index is 1

for invalid input:
-> I'm sorry, your key is not recognized.

*/


/* 1.b

Add an error notification alerting the user to the correct input type if input is not a string. Test using a different class. (See Literals section of syntax doc for ideas.

*/

/* List your code components here:
Ï
A function: { }
An Array: []
Strings with names for all chords in the array: "c major", "d minor", "e minor", etc
A method* to check whether the array includes the string:
A method* to return the index of the string:
A logical structure in which to embed inclusion code from above with different returns for true and false: if
An if statement to check whether the input to the method is a string, which otherwise outputs an error message

*/

( // your code here
var chords;
chords = ["c major", "d minor", "e major", "f minor", "g major", "a minor", "b diminished"];

~checkChordInArray = { |array, chordToCheck|
	var index;
	index = array.indexOfEqual(chordToCheck);
	if (chordToCheck.isString) {
		if (index.isNil) {
			"Chord not found!".postln
		} {
			index.postln;
		}
	} {
		"ERROR: Input type must be string".postln
	}
};

~checkChordInArray.value(chords, "c major");


)

/* Output may look like this for invalid input:

ERROR: Your input to the function must be type String in the following format:
Triad root (ex. C, F) followed by triad type (ex. major, minor): ex. "C Major"

*/

/* 1.c

Post and *return* the input triad (if found) by associating it with your chord names using a dictionary this time. (You're really going to hate this one...) Again, the dictionary and collection can exist within or outside of your function. The triad should be of the form [pitch1, pitch2, pitch3] where the pitches are actual pitches represented by MIDI numbers of type Integer. Ex. "c major" might return [60, 64, 67].

*The return is a real thing, different from "post". Learn about the "return" in the Function help file.

*/

/* List your code components here:
Ï
A function: { }
Strings with names for all chords in the array: "c major", "d minor", "e minor", etc
An Array[] of said strings
Integer arrays of triads corresponding to the chords listed as strings, stored as their MIDI note equivalent
An Array[] of said integer arrays
A Dictionary of key-value pairs where each key is a chord string, and each value is the chord's corresponding triad-integer-array
A method* to check whether the array includes the string:
A method* to return the index of the string:
A logical structure in which to embed inclusion code from above with different returns for true and false: if
An if statement to check whether the input to the method is a string, which otherwise outputs an error message

*/


( // your code here
var chords = ["c major", "d minor", "e minor", "f major", "g major", "a minor", "b diminished"];
var triads = [[60, 64, 67], [62, 65, 69], [64, 67, 71], [65, 69, 72], [67, 71, 74], [69, 72, 76], [71, 74, 77]];
var i = 0;
d = Dictionary.new;


while {i < chords.size}
{
	d.put(chords[i], triads[i]);
	i = i + 1;

};

~checkChordInArray = { |chordToCheck|
	var triad;
	triad = d[chordToCheck];
	if (chordToCheck.isString) {
		if (triad.isNil) {
			"Chord not found!".postln
		} {
			triad.postln;
		}
	} {
		"ERROR: Input type must be string".postln
	}
};

~checkChordInArray.value("c major");

)


/* Output may look like:

for valid input:

Key is recognized. Index is 1. Your triad is [ 65, 69, 72 ].
-> [ 65, 69, 72 ]
*/


/* 1.d STRETCH GOAL

Add an octave argument (0-8) to your function and return the requested triad in that octave.

*/

/* List your code components here:


*/

( // your code here
var chords = ["c major", "d minor", "e minor", "f major", "g major", "a minor", "b diminished"];
var triads = [[60, 64, 67], [62, 65, 69], [64, 67, 71], [65, 69, 72], [67, 71, 74], [69, 72, 76], [71, 74, 77]];
var i = 0;
d = Dictionary.new;


while {i < chords.size}
{
	d.put(chords[i], triads[i]);
	i = i + 1;

};

~checkChordInArray = { |chordToCheck|
	var triad;
	triad = d[chordToCheck];
	if (chordToCheck.isString) {
		if (triad.isNil) {
			"Chord not found!".postln
		} {
			triad.postln;
		}
	} {
		"ERROR: Input type must be string".postln
	}
};

~checkChordInArray.value("c major");

)


// Running the following code (here we use an Environmental variable for our function):
~keyMatcher.("G Maj", 5);

/* Output may look like:

Key is recognized. Index is 2
Your triad (in octave 5 ) is [ 79, 83, 86 ]
-> [ 79, 83, 86 ]

*/
