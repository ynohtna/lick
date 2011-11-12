/*

    LiCK  Library for ChucK.
    Copyright (c) 2007-2011 held jointly by the individual authors.

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

public class Arpeggiator extends Procedure
{
    ArrayList @ intervals;
    FloatProcedure procedure;
    200::ms => dur rate;
    440.0 => float root;

    fun void run()
    {
        reset() => int i;
        <<<"i reset",i>>>;
        while (hasNext(i))
        {
            <<<"i before",i>>>;
            intervals.get(i) $ Interval @=> Interval interval;
            procedure.run(interval.evaluate(root));
            next(i) => i;
            <<<"i after",i>>>;
            rate => now;
        }
    }

    fun int reset()
    {
        <<<"reset">>>;
        return 0;
    }

    fun int next(int index)
    {
        <<<"next",index>>>;
        return index + 1;
    }

    fun int hasNext(int index)
    {
        return (index < intervals.size());
    }
}
