# avv

avv is a commandline client for the http://fahrplan.avv.de/ interface. It requests bus connections inside the AVV area.

## Basic usage

Find a connection from point A to point B:

    avv [from-city] from-stop [to-city] to-stop

When no city is specified, Aachen is assumed (as I live there now).

Example output:

    $ avv Aachen "Am Hügel" "Königstraße"
    Von Aachen Am Hügel nach Aachen Königstraße
    -------------------------------------------
    Linie	ab	Um.	an
    -----------------------------
    23	20:46	0	20:49
    23	21:16	0	21:19
    23	21:46	0	21:49

Show departures from a given stop in Aachen:

    avv from-stop

Do not want to start immediately? Just pass a time:

    avv from-stop -t 14:00

Example output:

    $ avv "Am Hügel" -t 8:00
    Abfahrt Aachen, Am Hügel
    ------------------------
    08:08	22	Stolberg (Rheinland), Mühlener Bahnhof (Bus)
    08:13	12	Aachen, Campus Melaten
    08:23	12	Stolberg (Rheinland), Münsterbusch Buschmühle Friedhof

## Install

First you need [mechanize](http://mechanize.rubyforge.org/):

    gem install mechanize

Then copy the `avv.rb` file to a folder of your `$PATH` and you're ready to use it.

## License

Copyright (c) 2011 Jan-Erik Rediger <http://fnordig.de/about/>

Permission  is  hereby granted, free of charge, to any person ob-
taining a copy of  this  software  and  associated  documentation
files  (the "Software"), to deal in the Software without restric-
tion, including without limitation the rights to use, copy, modi-
fy, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is  fur-
nished to do so, subject to the following conditions:

The  above  copyright  notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,
EXPRESS  OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE  AND  NONIN-
FRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER  IN  AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
SOFTWARE.
