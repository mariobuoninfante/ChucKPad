/*
    ChucKPad
    --------
    ChucK Programming Language + Novation Launchpad
*/

chout <= "\nChucKPad\n--------\nChucK Programming Language + Novation Launchpad\n" <= IO.nl();

MidiLib MidiLib;
LPX LPX;

LPX.connect();
LPX.programmer_mode(1);
LPX.clear();

// MAIN
while(true)
{
    LPX.from_LP => now;
    while(LPX.from_LP.recv(LPX.msg_in))
    {
        if(LPX.msg_in.type() == "NOTE_ON" && LPX.msg_in.data3 != 0)
        {
            // LPX.set_led(LPX.msg_in.data2, LPX.msg_in.data3, 2);
            // LPX.set_leds([11,24,99,120,91,100,88,90]);
            LPX.set_all(Math.random2(0, 127), 2);
            // LPX.set_led("solo", 120, 1);
            // LPX.clear();
        }
        LPX.msg_in.print();
    }
}