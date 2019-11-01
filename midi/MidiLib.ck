public class MidiLib
{
    0x80 => static int NOTE_OFF;
    0x90 => static int NOTE_ON;
    0xA0 => static int POLY_PRESS;
    0xB0 => static int CTRL_CHANGE;
    0xC0 => static int PROG_CHANGE;
    0xD0 => static int CHAN_PRESS;
    0xE0 => static int PITCHBEND;
    0x7B => static int ALLNOTESOFF;
    0x00 => static int CHANNEL;    // device MIDI channel
    0xF8 => static int CLOCK;
    0xFA => static int START;
    0xFB => static int CONTINUE;
    0xFC => static int STOP;

    function static void print_midi_ports( MidiIn m_port )
    {
        string midi_port_name[0];
        0 => int _c;

        m_port.printerr(0);  // don't print error when trying to open port that doesn't exist
        m_port.open(_c);
        while( m_port.name() != "" )
        {
            midi_port_name.size( midi_port_name.size() + 1 );
            m_port.name() => midi_port_name[_c];
            <<< _c, midi_port_name[_c] >>>;
            _c++;
            m_port.open(_c);
        }
        m_port.printerr(1);  // now we can re-enable printerr
    }

    function static void print_midi_ports( MidiOut m_port )
    {
        string midi_port_name[0];
        0 => int _c;

        m_port.printerr(0);  // don't print error when trying to open port that doesn't exist
        m_port.open(_c);
        while( m_port.name() != "" )
        {
            midi_port_name.size( midi_port_name.size() + 1 );
            m_port.name() => midi_port_name[_c];
            <<< _c, midi_port_name[_c] >>>;
            _c++;
            m_port.open(_c);
        }
        m_port.printerr(1);  // now we can re-enable printerr
    }

    function void sysex_out(MidiOut out, MidiMsg msg_out, int sys_msg[])
    {
        for(0 => int c; c < sys_msg.size(); c++)
        {
            if(c % 3 == 0)
            {
                sys_msg[c] => msg_out.data1;
                if(c == sys_msg.size() - 1)
                {
                    out.send(msg_out);
                }
            }
            else if(c % 3 == 1)
            {
                sys_msg[c] => msg_out.data2;
                if(c == sys_msg.size() - 1)
                {
                    out.send(msg_out);
                }
            }
            else if(c % 3 == 2)
            {
                sys_msg[c] => msg_out.data3;
                out.send(msg_out);
            }
        }
    }
}
