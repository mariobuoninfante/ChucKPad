// main.ck  
// 
// ChucKPad
// --------
// ChucK Programming Language + Novation Launchpad
// 
// @author         Mario Buoninfante
// @copyright      2019 



chout <= "\nChucKPad\n--------\nChucK Programming Language + Novation Launchpad\n" <= IO.nl();

4           => int nr_of_tracks;

MidiLib     MidiLib;
LPX         LPX;
Square      S[nr_of_tracks];
Button      Play;
Sequencer   Seq;

LPX.connect();
LPX.programmer_mode(1);
LPX.clear();

for(0 => int c; c < S.size(); c++)
{
    S[c].link(LPX);
}
// draw the squares
S[0].create(0, 0, 4, 97);   // yellow square 
S[1].create(4, 0, 4, 29);   // green square
S[2].create(0, 4, 4, 78);   // azure square
S[3].create(4, 4, 4, 126);  // orange square

// initialize the PLAY button
Play.link(LPX);
Play.create(19, 21, 1);     // pad_id: 19, ON_color: 21, button_type: 1 (toggle)

// set tracks
Seq.track_nr(nr_of_tracks);

// expecting to find these files in the 'audio' folder
Seq.loadsample(0, me.dir() + "/audio/kick.wav");
Seq.loadsample(1, me.dir() + "/audio/snare.wav");
Seq.loadsample(2, me.dir() + "/audio/hh.wav");
Seq.loadsample(3, me.dir() + "/audio/tom.wav");

Seq.set_track(0, 16, 0, 0);     // track nr, length, ones, offset
Seq.smart_offset(1,1);
Seq.set_track(1, 16, 0, 2);
Seq.set_track(2, 16, 0, 0);
Seq.set_track(3, 16, 0, 0);




//------------------------
//----------MAIN----------
//------------------------

while(true)
{
    // receive msg from LP X
    LPX.from_LP => now;
    while(LPX.from_LP.recv(LPX.msg_in))
    {
        if(LPX.msg_in.type() == "NOTE_ON" && LPX.msg_in.data3 != 0)
        {
            pad_press();
            chout <= "------------------------------------------------" <= IO.nl();
            chout <= "------------------------------------------------" <= IO.nl();
            seq_update();
        }
        else if((LPX.msg_in.type() == "NOTE_ON" && LPX.msg_in.data3 == 0) || LPX.msg_in.type() == "CC")
        {
            if(Play.press())
                Play.get() => Seq.play;
        }
    }
}



//------------------------
//-------FUNCTIONS--------
//------------------------

function void pad_press()
{
    /*
        call press for all the Squares
    */

    for(0 => int c; c < S.size(); c++)
    {
        S[c].press();
    }
}

function void print_status()
{
    /*
        print status of all the Squares
    */
    
    chout <= "STATUS: ";

    for(0 => int c; c < S.size(); c++)
        chout <= S[c].get() <= " ";
    
    chout <= IO.nl();
}

function void seq_update()
{
    /*
        update euclidean sequencer in accord with Square value
    */

    for(0 => int c; c < S.size(); c++)
    {
        S[c].get() => int ones;
        Seq.set_track(c, 16, ones, -1);     // -1 to use the current offset - ie no changes
    }
}

function void get(int nr)
{
    /*
        call get() for a specific Square
    */

    S[nr].get();
}