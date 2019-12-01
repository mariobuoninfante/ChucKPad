//-------------------------
// playback an audio sample
//-------------------------


SndBuf sample => dac;

// audio file name (includes its location)
me.dir(1) + "/audio/kick.wav" => string filename;

<<< "LOADING: " + filename >>>;

// load audio file in SndBuf UGen
sample.read(filename);


// set playback rate to 0 so that SndBuf doesn't play by default
0 => float playback_rate;
sample.rate(playback_rate);



// arrays are objects and as such can be 
// initialized using the operator '@=>'
//------------------------------
// this array contains a list of
// playback rates used to create 
// a rhythmic pattern 
[1.,0.,0.,0.] @=> float pattern[];

// pattern rate
250::ms => dur patt_rate;


// equivalent of the 'tape head' on tape machines
// this is used to 'scan' the 'pattern' array
0 => int pointer;

while(true)
{
    // reset playback head to initial position
    sample.pos(0);
    sample.rate(pattern[pointer]);

    <<< "STEP: " + pointer + " || VALUE: " + pattern[pointer] >>>;
    patt_rate => now;

    // increase the read head by one and make sure
    // it wraps when reaching the end of the 'pattern' array 
    (pointer + 1) % pattern.size() => pointer;
}
