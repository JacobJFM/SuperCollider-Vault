/*_____________________________________________________

Introduction to SuperCollider Syntax and Functionality

Scott Petersen
version 092319


CONTENTS:

1. Shortcuts, getting help
2. Syntax Examples
     Literals
     Numbers, Operators
     Variables
     Collections
     Functions
     Control Structures
3. Tripups, gotchas, unexpected "perks"


_____________________________________________________*/



/*_____________________________________________________

Part 1: Most-used keyboard shortcuts

You can change these or learn more
_____________________________________________________*/

play { SinOsc.ar() * 0.5 }

/* BOOT SERVER

cmd (or ctl) + B

*/


/* CODE EVALUATION

cmd + return
*or*
ctl + enter

*/


{"this document is chock full of goodness!".postln }.value ;


// place between parens for easy evaluation

( // place cursor here -- all code below will be evaluated:

"hi!".postln;

{"this document is chock full of goodness!".postln }.value ;

)


/* STOP SOUND (everything)

cmd (or ctl) + period (.)

*/


/* GET HELP

select a class or message/method and press
cmd (or ctl) + D

-for classes, the help file will open.
-for messages, you will have to pick the class for which you want the method description

*/

Class

play

/* FIND CLASS FILE (implementation)

select object and press

cmd (or ctl) + I

*/

Task


/* CLEAR POST

shift + cmd (or ctl) + P

*/

/*

For more on getting help see the More on Getting Help tutorial file in the file browser, and the file

sc3-info-help-troubleshooting.scd

In the Files --> Week 3 Materials folder.

*/



/*_____________________________________________________

Part 2: Syntax Examples

_____________________________________________________*/


/*_____________________________________________________

Literals

A literal is â€œA notation for representing a fixed value.â€ / â€œA value written exactly as it's meant to be interpreted.â€ / â€œA value with direct syntactic representation.â€  In SC3, these are things that you get â€œfor free.â€  You donâ€™t define them, or have to tell the system what they are.  They exist and they do things, things you cannot change.

*/

/* Integers: */ 1; 7; 1006789;
/* Floats: */ 1.002998767;
/* Scale Degrees: */ 1s;
/* Symbols: */ â€˜i am a symbolâ€™; \soAmEye;
/* Strings: */ "I am a string";
/* Identifiers: */ var wonderBread;
/* Class names: */ Object;
/* Special Values: */ this, true, false, nil, inf;
/* Literal Arrays: */ #[1, 2, 'abc', "def", 4]



// Strings: awesome because strings are actually arrays of characters...

"Test Me!".at(5);  // M
"Test Me!".at(5).class;  //  Char = Ascii character.



/*_____________________________________________________

Numbers, unary and binary operators

For more, see the SimpleNumber helpfile
*/


// Integers (32): from -2147483648 to 2147483647

1;
17;
912874664;


// Unary Operators

1.neg;

-115.abs;

60.cpsmidi.round(1);


// Binary Operators: note the different syntactical representations

pow(4,5);

4 pow: 5;

4.pow(5);


// Mathematical symbols  +, -, *, /, %, ** (binary operators) must be written

	a + b;
	a - b;
	etc.


// Booleans: answer true or false

4 <= 5;

4 != 5;

// Also work on collections, right?

x = ["dog", 45, 234987, 0.00367] + 4; // yay!

x = ["dog", 45, 234987, 0.00367].pow(2);  // Oops!  pow(2) didn't work because class string doesnt support it.




/* BRACKETS: Brackets, curly brackets, and square brackets () {} []

The above are used in different ways.  We will go into those ways in depth below (or on separate handouts) but regarding numbers they are used as follows:

*/

4 + 7 - (10 + 11); // to determine precedence or order of operations

{| in | 4 + 7 - (10 + in ) }.value(11); // to define functions -- also brackets to supply arguments

[1, 6, 10, 7867]; // to define arrays

x = [17, 19, 33];  x[1];  // to index into an array

x.at(1) // brackets supply args for .at method

// Pipes mean different things in different contexts

{|i, in, dork| i.postln }.value(4,5,6)

// also

{arg i, in, dork; i.postln }.value(5)




/*_____________________________________________________

   VARIABLES

SuperCollider is a dynamically typed language which means that the types of objects you assign to variables do not have to be defined.  You simply assign whatever you want to the variable.

For more on variables, see:
     Assignment Statements: "Help/Reference/Assignment.html"
     Scoping and Closure: "Help/Reference/Scope.html"

*/


// GLOBAL or INTERPRETER VARIABLES (a..z) available everywhere

a = (2..40);

b = Array.fill(a.size, {|i| a[i]});

//note s defaults to the default server

s; //localhost

// See all the variables currently in use
this.inspect


// ENVIRONMENTAL VARIABLES

~iAmAnEnvironmentalVariable = "I am an Environmental Variable!  I am available EVERYWHERE!..";

// all are accessible in the following function
(
{
(a * 2).postln;
b.isArray.postln;
~iAmAnEnvironmentalVariable.isString;
}.value
)

// LOCAL VARIABLES are available only in the function in which they are defined or child functions (within the defining function or context (  )s.

(
{
var variable;
variable = 7;
variable.postln;
}.value
)

// but lets try it here now...

(
{
var variable;
variable = 7;
variable.postln;
}.value;
variable.postln;
)


/*
Some dangers exist in using Interpreter variables when prototyping.  Most often they revolve around the reuse of variables and overwriting values.  In simple code this is easy to avoid, but in longer code it's harder to keep track. NEVER use interpreter variables in your classes...

Use environmental variables (~thisKind) to prototype and then switch to local variables (var ...) whose scope is limited in your final code.

*/


/*_____________________________________________________

   COLLECTIONS

   Further reading: ArrayedCollection, Collections, Collection, SequenceableCollection


// Add section on iteration.

*/

// Here's an array
x = [1,7];
x.isArray;


// Here's an array
x = Array.fill(7, { rrand(0,10) });
x.postln;


// Accessing what's in the array -- Indexing starts at 0 <-- muy importante!
x[4] + x[3]; // ??


// #[] is a literal array. note i do not define seven...
x = #[seven, 7];

// seven is not seven...
x[0].class;

// literal arrays are "immutable" and cannot be altered.
x.add(4); // error


// arrays have a fixed size and can only grow so much.

x = [];
x.isArray;
x.add(1);  // Uh huh.
x.add(2);  // So far, so good!..
x.add(3);  // AAAAAAH!!!
x = x.add(2); // Try again?..
x = x.add(3); // so much x...

// Lists on the other hand can be expanded ad infinitum

// an empty list
x = List[];

// add a number
x.add(5);

// add a random number
x.add({rrand(0,10)}.value);

// add a function
x.add({|in| in + 7});

// return values from the function
x[0] + x.last.value(10);

// note: this is not an array
x.isArray

//but we can make it one...
x = x.asArray;

// and viole
x.isArray


// ADVANCED ARRAY SECRETS __________________________


// Arrays can be unpacked into functions and assigned to args using the * operator

(
x = [7,47,41,123,9];

{|first, second, third, fourth, whatever|
	first.postln;
	second.postln;
	third.postln;
	fourth.postln;
	whatever.postln;
}.(*x)
)

// One array "gotcha" if you are coming from another language

// what does this result in?
[1,2] + [3,4];

// how about this?
[1,2] + [3,4,5]


/*

The key to choosing the right collection for your purpose and using it effectively relies in large part on how you want to access the data stored in the collection.  If the data needs to be ordered, associated with another value or object, or a specific data type, then you might choose List, Dictionary, and FloatArray respectively.  For manipulating audio buffer data, for example, the triad of Signal, FloatArray and Buffer (not a Collection, but donâ€™t worry about it) are commonly used.


*/




/*_____________________________________________________

  FUNCTIONS

Functions are defined by curly brackets {}.  You can find functions all over -- in Control Structures, SynthDefs, Routines, etc.

Functions are coded as follows:  { | args | vars; expressions; return; }

Where the arguments allows access to the function from outside, the vars are valid only within the function, and the last expression is returned when you send the .value message to the function.  Thus, the following code: */

{ | in | var value = 27; value + in }.value(10);

// will return 37.  Here's another view:

{ /*arguments: named whatever you want*/
	arg in;

	/*variables declared with var = */
	var value = 27;

	/*Statements: math, whatever you want the function to do*/
	value + in

	/* in this case, the only statement is also the return, because it's last in the function */

}.value(10);


/* Arguments can be given default values so that if they do not have to be supplied by the .value message.

The return is a typical point of difficulty for newbies.  Be aware that a function can perform all necessary functions to compute a problem (x) but still return something else provided that x is not the last expression in the function.


  Further Reading: AbstractFunction, Function, Functions
*/


{4 + 4}.value // 8

x = {4 + 4};  // registers the function

10 + x.value;  // calling value here gives the return

10 + x.value;  // the return can be used in further operations

x = {|y| 4 + y; "YEAH!".postln;}; // the argument is left undefined -- to be supplied later...

y = 10 + x.value(10);  // here we are supplying 10 for the internal y argument

y.class;

// Additionally, functions can be used to accomplish any number of tasks and the return ignored.

x = List[3,7,9];
y = List[1,2,4];

z = { var array = x ++ y; array.scramble; x.add(array.remove(rrand(0,4))); y.add(array.remove(x.choose;))}.value

x.postln;
y.postln;


// The purpose of the above is not to return y, but to alter the contents of both x and y based on some (inane) process.  Keep an eye on how functions are used in the control structures below.


// ** ADVANCED FUNCTION SECRETS ___________________

// 1. unspecified number of input arguments

{| ... a | a.postln; }.value(7,5,2,3,1)


// 2. changing order, supplying partial args

(
{| input_1, input_2 |

	if ( input_1.notNil) { input_1.postln }; // this function only happens if arg 1 is supplied
	if ( input_2.notNil) { input_2.postln }; // this function only happens if arg 2 is supplied

}.value(input_2: 70);
)


// 3. Specifying arg values out of order: run with defaults for a and c, but change b.
{|a=50, b=60, c=70| a.postln; b.postln; c.postln;  }.value(b: 40)

// note that the seemingly "global" interpreter variables here are locally defined args and do not change the actual interpreter.


// 4. Functions can be passed to functions

f = {|i| i + 4}; // f = function

g = {|f, i| f.(i) }; //   g = evaluator, higher order function

g.(f, 10) // passes function and arg to that func



/*_____________________________________________________

  Control Structures

  Control Structures are one of the building blocks of any programming language.
  They are used to build   logical structures that process, sort, and alter incoming data in any number of ways.
  Control structures are interchangeable and can accomplish the same goals but with varying degrees of efficiency.

*/


// DO

5.do({|i| i.postln;});


// often used to 'do' something a certain amount of times, like iterate over an array

x = [60, 61, 64, 65];
x.size.do {|i| i.postln } ;

// the above simply uses the size to pass integers into the function as the argument
// the same as doing 4.do { ...

x.do {|i, j| i.postln; j.postln} ;

// without '.size' the array elements themselves are passed as the arguments

x.do {|i| i.postln; (i + 10).postln;} ;


// _____________________________________________________

// IF

// if - test case - true - false
{ if( 5 < 7, { "True! :D"}, {"False! >:("})}.value;

{ if( 5 >= 7, { "True! :D"}, {"False! >:("})}.value;

// doesn't required a false function

if( 5 < 7, { "True! :D"})
if( 5 >= 7, { "True! :D"})

// note the false statement returns nothing - in the form of nil

// You can also have && and || statements of course

if ( 5 < 7 && 30 > 40) {"really?".postln;} { "No! >:(".postln};

// Same thing:

if ( 5 < 7 and: 30 > 40) {"yay!".postln;} { "No! >:(".postln};

// please note: OK

if ( 5 > 7 || 30 < 40) {"yay!".postln;} { "No! >:(".postln};

// please note: Not OK

if ( 5 < 7 || 30 < 40) {"yay!".postln;} { "No! >:(".postln};

// Now it's OK

if ( 5 < 7 || (30 < 40)) {"yay!".postln;} { "No! >:(".postln};

// or .or...
if ( (5 > 7).or(30 < 4)) {"yay!".postln;} { "No! >:(".postln};


// test with booleans to see why this makes sense:

true or: {"why/!???"};

false or: {"why/!???"};


//_____________________________________________________

/* WHILE

Use the while statement if you don't know when the test func will return false (but are sure it eventually will...) -- IOW -- if you don't know how many test cases it will take.  Otherwise you can type less and use .do (though 'while' is more efficient)

*/

(
i = 0;
while ( { i < 5 }, { i = i + 1; "boing".postln });
)

//_____________________________________________________

// CASE

(
case
{ 1 < 0 } { "OMG" }
{10 > 100 }{ "WHAT?!?"}
{100 > -17000}{ "FINALLY!"};
)

// There's an undocumented default functionality (Thanks Brian!)

(
case
{ 1 < 0 } { "OMG" }
{10 > 100 }{ "WHAT?!?"}
{100 > 17000}{ "FINALLY!"}
{"None of those are true, so post me instead! :D".postln};
)


//_____________________________________________________

// FOR :: Iterates over an integer series and passes the values to the function


for (3, 7, { arg i; i.postln }); // prints values 3 through 7

// same as...

(3..7).do {arg i; i.postln };

// but for is more efficient

// forBy does the same thing but you can change the step size



/*_____________________________________________________

  A Quick Note on Benchmarking
  Want to know if something is faster (read: better) than something else?
*/


y = List[];

10.do { y.add({ 1000000.do { 2 == 2 && (3 >= 2) } }.bench);};
y.mean

x = List[];
10.do { x.add({ 1000000.do { 2 == 2 and: {3 >= 2} } }.bench);};
x.mean;

y.mean; // wow...
x.mean


// For fun, let's look at the bytecodes to see if there's a reason for this...

{ 2 == 2 && {3 >= 2} }.def.dumpByteCodes
{ 2 == 2 and: {3 >= 2} }.def.dumpByteCodes

// Note the line: 3   FA 00 05 JumpIfFalsePushFalse 5  (11)
// This "short circuit" makes and: with a function much faster.
// See the Symbolic Notations help document for more info.


/*_____________________________________________________

Part 3: Tripups, gotchas, unexpected "perks"

_____________________________________________________*/


/*_____________________________________________________

PART 1. PRESEDENCE

SuperCollder does everything left-to-right.  Because left-to-right is better... D';

*/

// these are not the same

20 + 5 * 5 // 125
5 * 5 + 20 // 45

// these are the same

20 + (5 * 5) // 45
5 * 5 + 20 // 45


// bad with booleans too...

// or:
if ( 6 > 5 or: 5 > 6 ) {"crap!".postln; } ;

// vs

if ( 6 > 5 or: ( 5 > 6 ) ) {"true".postln; } ;

// and:

if ( 5 > 6 and:  5 > 4   ) {"crap!".postln; } {"no"};

// vs

if ( 5 > 6 and: ( 5 > 4 ) ) {"crap!".postln; } {"no"};



/*_____________________________________________________

PART 2. BEWARE SYNTACTIC SUGAR

Over the next semester/year, you will continually run across code that you donâ€™t understand because the programmer is using syntactic sugar you have never seen.  This syntactic shortcut nonsense is both a blessing and a curse as you will find out.  The help file â€œSyntax Shortcutsâ€ shows many, but not all, examples of these shorthand notations.  Another helpful document is the glossary of terms at the end of the SuperCollider Book.  I have scanned and uploaded this to the Canvas files area.

Further reading: Syntax Shortcuts
*/


{ 4 + 4 }.value

value { 4 + 4 }

{ 4 + 4 }.( ) // ...

{ SinOsc.ar() }.play

play { SinOsc.ar() }

(\amp: 1).play  // This should make you seriously nervous...


//

if ( 4 > 3, { "true!".postln }, { "false!".postln } ) ;

if ( 4 > 3 ) { "true!".postln } { "false!".postln } ;

//  etc.


// 3. A variable is a variable, well, not really, it's Nil until it's assigned something, then it is that thing.  Unless you use Ref, then it's always a Ref...

(
var a = 10;
var b = 20;
var c = a;
var d = Ref.new;

a = d;
b = c;
d.value = 60;
c = a;
("a =" + a.value).postln;
("b =" + b.value).postln;
("c =" + c.value).postln;
a.class;
b.class;
c.class;
(c + 40).postln;
(c.value + 40).postln;
)


/*_____________________________________________________

PART 3: EQUALITY VS EQUIVALENCE (Identity)

Sometimes you need to know "what" something is rather than whether or not it returns the same value as something else. We can test identity using === .

*/

a = (2..40);
b = Array.fill(a.size, {|i| a[i]});

// a equals b?  yes. both return the same array
a == b;

// but is a the same object as b?

a === b;

// nope. they are different objects

// Also salient for strings/symbols

~this = "this";

{|in| ~this == "this" }.(~this);

{|in| ~this === "this" }.(~this);

~that = \that;

{|in| ~that == \that }.(~that);

{|in| ~that === \that }.(~that);