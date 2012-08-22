
# An OCaml Module for Optimal Line Breaking 

This repository implements a module `Linebreak` that provides
breaking a list of words in a list of lines, each not exceeding 
a given width. See file `format.lp` for interface and implementation.

The `Linebreak` module is accompanied by a small client application `demo`
for tests and experiments. Module `Linebreak` implements two algorithms,
simple and smart. The simple algorithm implements the naive greedy
algorithm of appending a word to a line as long as enough space is
available. The smart algorithm distributes unused space at the end of lines
over all lines in a paragraph in an optimal way using a cost model: unused
space at the end of a line is attributed a cost that is the square of the
number of spaces not used. This cost is summed up over all lines and
minimized. Hence, the algorithm finds the line breaking that causes the
smallest cost.

Below are two paragraphs. The left was formatted using the simple
algorithm and the right one the smart algorithm. The cost indicates
that the smart formatting distributes the unused space more evenly.

    |Lorem ipsum dolor sit____| |Lorem ipsum dolor________|
    |amet, consetetur_________| |sit amet, consetetur_____|
    |sadipscing elitr, sed____| |sadipscing elitr, sed____|
    |diam nonumy eirmod tempor| |diam nonumy eirmod tempor|
    |invidunt ut labore et____| |invidunt ut labore et____|
    |dolore magna aliquyam____| |dolore magna aliquyam____|
    |erat, sed diam voluptua._| |erat, sed diam voluptua._|
    |At vero eos et accusam et| |At vero eos et accusam___|
    |justo duo dolores et ea__| |et justo duo dolores et__|
    |rebum. Stet clita kasd___| |ea rebum. Stet clita_____|
    |gubergren, no sea________| |kasd gubergren, no sea___|
    |takimata sanctus est_____| |takimata sanctus est_____|
    |Lorem ipsum dolor sit____| |Lorem ipsum dolor sit____|
    |amet. Lorem ipsum dolor__| |amet. Lorem ipsum dolor__|
    |sit amet, consetetur_____| |sit amet, consetetur_____|
    |sadipscing elitr, sed____| |sadipscing elitr, sed____|
    |diam nonumy eirmod tempor| |diam nonumy eirmod tempor|
    |invidunt ut labore et____| |invidunt ut labore et____|
    |dolore magna aliquyam____| |dolore magna aliquyam____|
    |erat, sed diam voluptua._| |erat, sed diam voluptua._|
    cost: 342                   cost: 304 

The demo client can be used to compare the two algorithms by
taking a line from a file and formatting it for a short line width:

     $ ./demo.native -x 15 test.txt 
     89|sed diam nonumy|eirmod tempor__|invidunt_______|ut labore______|
    101|sed diam nonumy|eirmod tempor__|invidunt ut____|labore_________|
    ---+
     74|et dolore______|magna aliquyam_|erat, sed diam_|voluptua.______|
     86|et dolore magna|aliquyam erat,_|sed diam_______|voluptua.______|
    ---+
    106|At vero eos____|et accusam_____|et justo_______|duo dolores____|
    126|At vero eos et_|accusam et_____|justo duo______|dolores________|
    ---+
    115|et ea rebum.___|Stet clita kasd|gubergren,_____|no sea_________|
    157|et ea rebum.___|Stet clita kasd|gubergren, no__|sea____________|
    ---+

## Building

The source code is a literate program. You need Lipsum
(https://github.com/lindig/lipsum.git) to extract the source code. (Lipsum
is implemented in Objective Caml and should be no problem to build.)

With Lipsum installed, just call Make, which in turn relies on OCamlBuild.

    $ make

For use in your own project, you either can use `linebreak.{ml,mli}`
directly or take `format.lp` and use Lipsum to extract `linebreak.{ml,mli}`
when you need it.

## Running

You can run the demo client for some help. A _width_ needs to be a positive
integer denoting the desired line width in characters.


    ./demo.native( -copyright | -help | <alg> [options] )

    -copyright       prints the copyright notice
    -help            prints this help

    <alg> is one of:
     -g width        simple line breaking
     -s width        smart line breaking
     -x width        compare simple and smart
     -d width        emit debug information
    <option> is one of:
     -f file         read input from file instead of stdin
     -atomic         treat input as one paragraph instead of each line

## References

Breaking words into lines as it is implemented in TeX is discussed in _The
TeXbook_ by Donald Knuth in Chapter 14 _How TEX Breaks Paragraphs into
Lines_. 

The algorithm implemented in `Linebreak` is considerably simpler than the
TeX algorithm but works on the same principles. In particular, `Linebreak`
computes the cost between any two adjacent points while the algorithm in
TeX is optimized for longer lines and checks only likely breakpoints.

## Future Work

The `Linebreak` module could be generalized to permit any value to be
assembled into lines. This would require to turn it into a functor. 
For now I don't need this.

A more likely addition is to make the last line in a paragraph special in
that unused space here does not count towards the total cost. I haven't yet
thought about how to implement this.

## Contributors

1. Kevin Streit <kevin.streit@googlemail.com>

## Copyright

Copyright (c) 2012, Christian Lindig <lindig@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.





















