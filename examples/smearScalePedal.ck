/*

    LiCK  Library for ChucK.
    Copyright (c) 2007-2012 held jointly by the individual authors.

    This file is part of LiCK.

    LiCK is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    LiCK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with LiCK.  If not, see <http://www.gnu.org/licenses/>.

*/

0 => int interval;
440.0 => float root;
Scales.majorBlues(root) @=> Scale scale;

16 => int z;
0.8 => float m;
0.005 => float inverseFeedback;  // use inverse so feedback limit approaches 1.0 instead of 0.0
Smear.create(z, m, root, 1.0 - inverseFeedback) @=> Smear smear;

adc => smear.input;
0.4 => smear.dry.gain;
0.6 => smear.wet.gain;
smear.dry => dac;
smear.wet => dac;

smear.stop();

class Toggle extends Procedure
{
    fun void run()
    {
        smear.toggle();
        <<<"running",smear.running>>>;
    }
}

class FreqUp extends Procedure
{
    fun void run()
    {
        constrain(interval + 1, 0, scale.intervals.size() - 1) => interval;
        scale.intervals.get(interval) $ Interval @=> Interval i;
        <<<"freq up", interval, smear.freq(i.evaluate(root))>>>;
    }
}

class FreqDown extends Procedure
{
    fun void run()
    {
        constrain(interval - 1, 0, scale.intervals.size() - 1) => interval;
        scale.intervals.get(interval) $ Interval @=> Interval i;
        <<<"freq down", interval, smear.freq(i.evaluate(root))>>>;
    }
}

class FeedbackUp extends Procedure
{
    fun void run()
    {
        constrainf(inverseFeedback - (inverseFeedback / 10.0), 0.0, 1.0) => inverseFeedback;
        <<<"feedback up", smear.feedback(1.0 - inverseFeedback)>>>;
    }
}

class FeedbackDown extends Procedure
{
    fun void run()
    {
        constrainf(inverseFeedback + (inverseFeedback / 10.0), 0.0, 1.0) => inverseFeedback;
        <<<"feedback down", smear.feedback(1.0 - inverseFeedback)>>>;
    }
}

fun int constrain(int value, int min, int max)
{
    if (value < min)
    {
        return min;
    }
    if (value > max)
    {
        return max;
    }
    return value;
}

fun float constrainf(float value, float min, float max)
{
    if (value < min)
    {
        return min;
    }
    if (value > max)
    {
        return max;
    }
    return value;
}

Toggle toggle;
FreqUp freqUp;
FreqDown freqDown;
FeedbackUp feedbackUp;
FeedbackDown feedbackDown;
StompKeyboard stomp;
toggle @=> stomp.button0Down;
freqUp @=> stomp.button1Down;
freqDown @=> stomp.button2Down;
feedbackUp @=> stomp.button3Down;
feedbackDown @=> stomp.button4Down;

stomp.open(0);