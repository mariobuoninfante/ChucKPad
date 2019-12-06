//--------------------------------------
// triangle oscillator + AR envelope 
// set random freq and amp
// use 'while' loop - endless loop
//--------------------------------------

// connect an triangular oscillator to the computer output
TriOsc sine => Envelope env => dac;

// variables
float frequency;
float amp;

// duration type
200::ms => dur env_time;


// set envelope raise/release time
env.duration(env_time);


// endless loop
while(true)
{
    // set random amplitude and frequency values
    // generated using 'Math' library
    Math.random2f(0.01, 0.5)    => amp;
    Math.random2f(300, 750)     => frequency;
    frequency   => sine.freq;
    amp         => sine.gain;

    // trigger the envelope - amp from 0 to 1
    env.keyOn(1);

    // print info to the console
    <<< "--------------------" >>>;
    <<< "FREQ: " + frequency + " || AMP: " + amp >>>;
    <<< "ENVELOPE: attack" >>>;


    // wait 500 msec before proceeding
    500::ms => now;     // the same as: 0.5::second => now;

    // release the envelope - amp from 1 to 0
    env.keyOff(1);
    <<< "ENVELOPE: release" >>>;

    // wait 500 msec before looping
    500::ms => now;
}