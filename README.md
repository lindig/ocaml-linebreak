
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

## Copyright

Copyright (c) 2012, Christian Lindig <lindig@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

(1) Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
(2) Redistributions in binary form must reproduce the above copyright
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





















