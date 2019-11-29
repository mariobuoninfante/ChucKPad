// main.ck  
// 
// ChucKPad
// --------
// ChucK Programming Language + Novation Launchpad
// 
// @author         Mario Buoninfante
// @copyright      2019 



chout <= "\nChucKPad\n--------\nChucK Programming Language + Novation Launchpad\n" <= IO.nl();

MidiLib     MidiLib;
LPX         LPX;
Square      S[4];
Euclidean   E;

LPX.connect();
LPX.programmer_mode(1);
LPX.clear();

for(0 => int c; c < S.size(); c++)
{
    S[c].link(LPX);
}
// draw the squares
S[0].create(0, 0, 4, 97);
S[1].create(4, 0, 4, 24);
S[2].create(0, 4, 4, 78);
S[3].create(4, 4, 4, 126);

// Euclidean rhythm
E.set(11, 3);
E.print();



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
            // LPX.clear();
            // LPX.set_led(LPX.msg_in.data2, LPX.msg_in.data3, 2);
            // LPX.set_leds([11,24,99,120,91,100,88,90]);
            // LPX.set_all(Math.random2(0, 127), 2);
            // LPX.set_led("solo", 120, 1);
            // LPX.set_column(3, 119, 2);
            // LPX.set_row(4, 120, 0);
            pad_press();
            print_status();
        }
        // LPX.msg_in.print();
    }
}


//------------------------
//-------FUNCTIONS--------
//------------------------
function void pad_press()
{
    /*
        call pad_press for all the Squares
    */

    for(0 => int c; c < S.size(); c++)
    {
        S[c].pad_press();
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

function void get(int nr)
{
    /*
        call get() for a specific Square
    */

    S[nr].get();
}