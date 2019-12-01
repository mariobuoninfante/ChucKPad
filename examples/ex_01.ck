//--------------------------------------
// create a sine osc, connect it to the 
// computer output set its frequency and 
// amplitude the play it for 2 seconds
//--------------------------------------


// connect a sine oscillator UGen to the computer output
// UGen: Unit Generator - class of objects that produces audio signals
// to connect different UGens to each other the chuck operator is used (=>)
SinOsc sine => dac;


// variables
// to assign variables the chuck operator is used (=>)
400 => float frequency;
0.2 => float amp;

// pass parameters to SinOsc object
// this is the same as:
// frequency    => sin.freq;
// amp          => sin.amp;
sine.freq(frequency);
sine.gain(amp);

// print msg to the console
<<< "making sound" >>>;

// wait 2 seconds then procede
// 'now' is a keyword used to manage time in ChucK
2::second => now;

// another msg to the console before exiting the program
<<< "Bye bye" >>>;

