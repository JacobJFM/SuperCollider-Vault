/* This document contains supplementary thoughts concerning implementation strategies for homework 3.

-- Overall structure and nature of input --

The overall form of the project is open ended. You decide what form the input takes, string, array with symbols, array with strings, whether the size is fixed and presented that way, or whether the size is up to the user and they must specify rhythm separately in another array. How you present those options to the user is also up to you. Probably text comments with examples in the comments would be clearest. A stretch might be using a GUI. For those doing group projects, you might consider how a GUI could make your program more user friendly.

-- Two implementations of the beat --

You will probably have to decide eary on whether or not the user can change the size of the input pattern and/or what happens when they do.

-- 1 --

If the user can specify an array of symbols, for example, that can be any size, four, five, six, etc, how does your system interpret the rhythm or duration of the events? Your system could merely spread them evenly accross the measure or bar, but tuples may not be what your user is really looking for. This probably necessitates the specification of a durations array or rhythmic array separate from the pattern specification.

Ex.

~p = [\k, \h, \s, \s, \s, \s]
~d = [1, 1, 0.5, 0.5, 0.5, 0.5]

Where ~p is used to pull samples from a dictionary and supplied to your SynthDef and ~d us used directly in the Pbind to supply the time to next event (... \dur, Pseq(~d)...)

-- 2 --

Alternately, you might have a fixed-length array whose size or number of indices represent the divisions of the measure in fractions of a beat.

Ex.

~p = [\k, Rest(), \h, Rest(), \s, Rest(), \h, Rest()];

You must indicate to the user that all slots must contain an appropriate symbol, string, or number, or a Rest() object and that no further division of the measure is possible. (or that changing the length will have unintended consequences.)

*/

~p = [0,1,2,Rest(),3,4,5,Rest()];

Pbind(\degree, Pseq(~p), \dur, 0.5).play

/*

-- Clarification of "beat", "pattern" and "measure" --

For many of you, the above words all refer to the same thing, an input specification for a beat pattern that lasts one measure.

Ex. [\k, \h, \s, \h];

This is relative to a constant, though, and requires that constant value be specified in the Pbind using the \dur key. If the value for \dur is 1, then the above four symbol array will indeed be one measure as counted by TempoClock. If the value for \dur is 0.5, it will only be half a measure. Etc.

Play the below code to compare what happens when patterns of different lengths are used with a pattern where the read speed (\dur) is a constant value (0.5)

Also, read the TempoClock help file!
*/

(
~p = [0,1,2,3];
~q = [0,1,2,3,4,5,6,7] + 2;
~r = [0,1,2,3,4,5,6,7,8,9,10] + 4;

~pp = Pbind(\degree, Pseq(~p), \dur, 0.5);
~qp = Pbind(\degree, Pseq(~q), \dur, 0.5);
~rp = Pbind(\degree, Pseq(~r), \dur, 0.5);

Ppar([~pp, ~qp, ~rp]).play;
)