

# An OCaml Module for Optimal Line Breaking 

This repository implements a module `Linebreak` that provides
breaking a list of words into a list of lines, each not exceeding 
a given width. 

The `Linebreak` module is accompanied by a small client application `demo`
for tests and experiments. Module `Linebreak` implements two algorithms,
_simple_ and _smart_. The simple algorithm implements the naive greedy
algorithm of appending a word to a line as long as enough space is
available. The smart algorithm distributes unused space at the end of lines
over all lines in a paragraph in an optimal way using a cost model: unused
space at the end of a line is attributed a cost that is the square of the
number of spaces not used. This cost is summed up over all lines and
minimized. Hence, the algorithm finds the line breaking that causes the
smallest cost.

Below are two paragraphs. The left one was formatted using the simple
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

Oege de Moor and Jeremy Gibbons from Oxford University discuss in _Bridging
the Algorithm Gap: A Linear-time Functional Program for Paragraph
Formatting_ the problem and present a linear algorithm for optimal line
breaking. As an introduction, a classical non-linear algorithm is presented
as well. The presentation is broken down into very small functions and
remarkable for that. I am not sure how their naive implementation compares
with my implementation here.

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

Copyright (c) 2012, 2013 Christian Lindig <lindig@gmail.com>
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


## Overview

We have interface and implementation of the `Linebreak` module 
and a command line client. Module `Linebreaking` implements two
algorithms which stay in separate sub modules.

The cost model assumes that words in a line are separated
by spaces of width one and that each character in a word is
likewise of width one.

<<don't modify>>=
(* This code is extracted from a literate program at 
   http://github.com/lindig/ocaml-linebreak. Please don't
   modify this code directly but the literate program instead.

   (c) Christian Lindig 2012, 2013 <lindig@gmail.com>
*)

<<linebreak.mli>>=
<<don't modify>>
type words  = string list 
type lines  = words list

val spacewidth: int (* 1 *)

module Simple: sig
    val break: int -> words -> lines
    (** [break n words] breaks words into lines of width w *)
end

module Smart: sig
    val break: int -> words -> lines
    (** [break n words] breaks words into lines of width w *)

    val debug: int -> words -> unit
    (** [debug n words] dumps the internal representation of 
    the paragraph to stdout. This can be helpful for debugging
    or understanding the algorithm. *)
end
@

<<linebreak.ml>>=
<<don't modify>>
<<global definitions>>
module Simple = struct
    <<Simple>>
end    
module Smart = struct
    <<Smart>>
end 
@

### Main

@ The main function resides in module `Demo`. It has no interface since it
is the top-level module that executes `main`.

<<demo.ml>>=
exception Error of string
let error fmt   = Printf.kprintf (fun msg -> raise (Error msg)) fmt

let length          = String.length
let square (x:int)  = x * x
let (@@) f x        = f x
let eprintf         = Printf.eprintf
let printf          = Printf.printf

<<Demo>>

let () = if !Sys.interactive then () else 
    try
        main (Array.to_list Sys.argv); exit 0
    with
    | Error(msg)         -> eprintf "error: %s\n" msg; exit 1
    | Sys_error(msg)     -> eprintf "error: %s\n" msg; exit 1
@

### Scanner

The demo client employs a scanner to break a text file into words. This
might be useful in the long run when we want to categorize words into
different categories or implement unbreakable spaces.

<<scanner.mll>>=
{
    <<prelude>>
}
<<rules>>

{
let words lexbuf = scan [] lexbuf
let lines lexbuf = lines [] [] lexbuf
}
@

## Linebreaking Implementation

<<global definitions>>=
let (@@) f x    = f x

@ The line breaking algorithm breaks `words` into lines represented as a 
list of words.

<<global definitions>>=
type words  = string list 
type lines  = words list

let length = String.length
let spacewidth = 1 (* width of a space *)
let square (x:int): int = x*x
@

## Demo Client

@ `finally f x cleanup` function provides resource cleanup in the presence
of exceptions: `f x` is computed as a result and `cleanup x` is guaranteed
to run afterwards. (In many cases `cleanup` will not use its argument `x`
but it can be convenient to have access to it.)

<<Demo>>=
type 'a result = Success of 'a | Failed of exn
let finally f x cleanup = 
    let result = try Success (f x) with exn -> Failed exn
    in
        cleanup x; 
        match result with
        | Success y  -> y 
        | Failed exn -> raise exn

@ `process f path` opens file `path` or `stdin` when no path is provided
and creates a `lexbuf` from it, which is passed to `f`. `process` takes
care of opening and closing the file such that `f` does not need to do it.

<<Demo>>=
let process f = function
    | Some path -> 
        let io = open_in path in
        let lexbuf = Lexing.from_channel io in
            finally f lexbuf (fun _ -> close_in io)
    | None      -> 
        let lexbuf = Lexing.from_channel stdin in
            f lexbuf


@ `a2i` converts a string of a non-negative integer into an integer value.
<<Demo>>=
let a2i str =
    try 
        let n = int_of_string str in
            if n >= 0 
            then n 
            else error "\"%s\" must be a positive number" str
    with 
        Failure _ -> error "\"%s\" must be positive number" str

<<Demo>>=
let badness (width:int) (lines:Linebreak.lines): int =
    let sum f = List.fold_left (fun sum x -> sum + f x) 0 in
    let cost (words:string list): int =
        let spaces = max 0 (List.length words - 1) in
        let chars  = sum length words in
        let total  = chars + spaces in
            square (width - total)
    in
        sum cost lines

@ `padright w str` returns string `str` padded with spaces on the right
such that is has length `w`. It returns `str` as is if it is longer than
`w` already.

<<Demo>>=
let padright width string =
    let n = String.length string in
    if n < width then
        string ^ String.make (width - n) '_'
    else
        string

<<Demo>>=
let print (width:int) (lines:Linebreak.lines): unit =
     ( List.iter  (fun s -> Printf.printf "|%s|\n" (padright width s))
        @@ List.map (String.concat " ") lines
     ; Printf.printf "cost: %d\n" (badness width lines)
     )

<<Demo>>=
let print' width (lines:Linebreak.lines): unit =
    Printf.printf "%3d|%s|\n" 
        (badness width lines) 
            (String.concat "|" 
            @@ List.map (padright width)
            @@ List.map (String.concat " ") lines)
@

The `main` function parses the command line. Exceptions are caught and
reported one level up.

<<Demo>>=
let copyright () =
    List.iter print_endline
    [ "https://github.com/lindig/ocaml-linebreak"
    ; ""
    ; "Copyright (c) 2012, 2013 Christian Lindig <lindig@gmail.com>"
    ; "All rights reserved."
    ; ""
    ; "Redistribution and use in source and binary forms, with or"
    ; "without modification, are permitted provided that the following"
    ; "conditions are met:"
    ; ""
    ; "(1) Redistributions of source code must retain the above copyright"
    ; "    notice, this list of conditions and the following disclaimer."
    ; "(2) Redistributions in binary form must reproduce the above copyright"
    ; "    notice, this list of conditions and the following disclaimer in"
    ; "    the documentation and/or other materials provided with the"
    ; "    distribution."
    ; ""
    ; "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND"
    ; "CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES,"
    ; "INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF"
    ; "MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"
    ; "DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR"
    ; "CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,"
    ; "SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT"
    ; "LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF"
    ; "USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED"
    ; "AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT"
    ; "LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN"
    ; "ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE"
    ; "POSSIBILITY OF SUCH DAMAGE."
    ]

let simple width words = print width @@ Linebreak.Simple.break width words
let smart  width words = print width @@ Linebreak.Smart.break width words
let debug  width words = Linebreak.Smart.debug width words
let both width words =
          print' width @@ Linebreak.Smart.break width words
        ; print' width @@ Linebreak.Simple.break width words

let break_lines linealg = List.iter (fun words -> 
        linealg words
        ; Printf.printf "---+\n"
        ) (* lines *)

let usage prg msg =
    List.iter prerr_endline
    [ msg
    ; prg ^ "( -copyright | -help | <alg> [options] )"
    ; ""
    ; "-copyright       prints the copyright notice"
    ; "-help            prints this help"
    ; ""
    ; "<alg> is one of:"
    ; " -g width        simple line breaking"
    ; " -s width        smart line breaking"
    ; " -x width        compare simple and smart"
    ; " -d width        emit debug information"
    ; "<option> is one of:"
    ; " -f file         read input from file instead of stdin"
    ; " -atomic         treat input as one paragraph instead of each line"
    ]

type options =
    { algorithm:    (Linebreak.words -> unit) option
    ; input:        string option
    ; compare:      bool
    }

let options =
    { algorithm     = None
    ; input         = None
    ; compare       = false
    }

let some = function
    | None   -> error "this should not happen"
    | Some x -> x

let rec main' prg argv options =
    match argv with
    | [] when options.algorithm = None -> 
        error "missing specificaton of an algorithm"
    | [] when options.compare -> process (fun lb -> 
        some options.algorithm @@ (Scanner.words lb)) options.input
    | [] -> process (fun lb -> 
        break_lines (some options.algorithm) 
            (Scanner.lines lb)) options.input
    | "-copyright" :: _     -> copyright ()
    | "copyright"  :: _     -> copyright ()
    | "-help" :: _          -> usage prg "Usage:"
    | "help"  :: _          -> usage prg "Usage:"
    | "-atomic" :: xs -> 
        main' prg xs {options with compare = true } 
    | "-f" :: path :: xs -> 
        main' prg xs {options with input = Some path }
    | "-g" :: w :: xs -> 
        main' prg xs {options with algorithm = Some (simple @@ a2i w)}
    | "-s" :: w :: xs -> 
        main' prg xs {options with algorithm = Some (smart @@ a2i w)}
    | "-x" :: w :: xs -> 
        main' prg xs {options with algorithm = Some (both @@ a2i w)}
    | "-d" :: w :: xs -> 
        main' prg xs {options with algorithm = Some (debug @@ a2i w)}
    | _ -> usage prg "Illegal parameter usage!"

let main argv = main' (List.hd argv) (List.tl argv) options
@

## Smart Line Breaking

Optimal line breaking takes a list of words and breaks it into lines by
minimizing the amount of unused space at the end of each line. The solution
is optimal in the sense that no better line breaking exists given the
chosen cost model: for each line, the number of unused spaces at the end of
the line is taken and this number is squared and summed up for the
resulting paragraph.  Squaring the unused spaces penalizes lines with many
unused spaces more than those with fewer and leads to a distribution of the
unused space across all lines.

The line breaking algorithm maintains for each possible break point
(between two adjacent lines) three information:

1. The word before the break point.
2. The optimal cost for breaking up the paragraph provided it
   ends after the word.
3. The number of words that also belong to the current line.

The number of words that in addition to the current word belong to the
current line provides a way to construct all break points backwards from
last word of a paragraph.

The line breaking algorithm maintains a paragraph `par` as a list of
triples.  It represents all words in a paragraph together with the
associated costs. The list is maintained such that words later in
a paragraph appear at the beginning of the list.

<<Smart>>=
type cost       =   int
type break      =   string * cost * int
type par        =   break list

<<Smart>>=
let dump (par:par):unit =
    let break (word, cost, skip) = 
        Printf.printf "%4d %+2d %2d %s\n" cost skip (length word) word
    in
        List.iter break @@ List.rev par

@ `minimal par` provides the best cost for paragraph `par`. 
(This is mostly needed for the special case where `par` is empty.)

<<Smart>>=
let minimum: par -> cost = function
    | []            -> 0
    | (_,cost,_)::_ -> cost

@ `add'` is an internal function. It adds `word` to paragraph `par` 
and returns a `par` value with `word` added (and the resulting cost). This 
function scans `par` to determine how many words should be on the same
line as `word` to minimize the cost should the paragraph end with `word`.

The `add'` function knows that
1. `avail` space is available and
2. the best solution so far results in cost `cost` and would keep
   `skip` words on the same line as `word`. 

Searching for a better solution stops when the available space is too small
for the next word that we could add. At this point we return the best
solution found so far. We also stop at the beginning of the paragraph when
no words to try remain.

<<Smart>>=
let rec add' (word:string) (avail:int) (n:int) cost skip par =
    (* let spacewidth = 1 in  debug *)
    let need w = length w + spacewidth in (* need room for word + space *)
    match par with
    | []                             -> word, cost, skip (* best so far *)
    | (w,c,s)::par when need w > avail -> word, cost, skip (* best so far *)
    | (w,c,s)::par ->
        let cost'   = square (avail - need w) + minimum par in
        let skip'   = n+1 in
        let avail'  = avail - need w in
            if cost' < cost (* better breakpoint found? *)
            then add' word avail' skip' cost' skip' par 
            else add' word avail' skip' cost  skip  par 

@ `add_word` adds another word to a paragraph `par`. For the initial best
cost we assume that the word sits on a line by itself, the rest of the line
is unused and we use the breakpoint preceding `word`. The cost for this
breakpoint is `minumum par`. From this situation we try to find a better
solution by adding more (existing) words to the line. Searching for this
better solution is done by `add'`.

<<Smart>>=
let add_word (word:string) (linewidth:int) (par:par): break = 
    let avail   = linewidth - length word in
    let cost    = square avail + minimum par in
        add' word avail 0 cost 0 par 

@ `doc` converts a paragraph value into a `lines` value. It walks through
the paragraph and collects words into lines starting from the last word in 
the paragraph. Since this includes the number of words that belong to the
same line, function `doc` can take it from there.

<<Smart>>=
let doc (par:par): lines =
    let rec loop n par words lines = match n, par with
        | _, []         -> words::lines
        | 0, (w,c,n)::p -> loop n p [w] (words::lines)
        | n, (w,c,_)::p -> loop (n-1) p (w::words) lines
    in match par with
    | []         -> []
    | (w,c,n)::p -> loop n p [w] []
@   


@ `break'` takes a list of words and adds them one by one to create
a paragraph of type `par`.

<<Smart>>=
let break' (linewidth:int) (words:words): par = 
    let rec loop paragraph = function
    | []            -> paragraph
    | word :: words -> 
        loop (add_word word linewidth paragraph :: paragraph) words
    in
        loop [] words

<<Smart>>=
let break linewidth words = doc @@ break' linewidth words
let debug linewidth words = dump @@ break' linewidth words
@

## Simple line breaking

`break` implements a simple line breaking algorithm that takes a list of
words and breaks it into lines (each represented as a list words) no longer
than `width` characters. The algorithm fills a line with words until the
next word no longer fits into the given `width`. A word longer than `width`
characters ends up on a line by its own.

After a word is added to a line, the remaining space equals the available
space `w` minus the length of the word that was added and minus one space
since the next word (if any) would need that space as a separator.

<<Simple>>=
let break (width:int) (words:words): lines =
    let len   = String.length in
    let rev   = List.rev in
    let rec loop w lines words = match lines, words with
        | line::lines, word::words when len word <= w -> 
            loop (w - len word - spacewidth) ((word::line)::lines) words
        | line::lines, word::words  -> 
            loop (width - len word - spacewidth) 
                    ([word] :: rev line :: lines) words
        | line::lines,[]  -> rev (rev line :: lines)
        | [], words -> loop w [[]] words
    in
        loop width [] words
@


## Scanner

@ The prelude contains definitions that we can use in the semantic action 
of a rule.

<<prelude>>=
exception Error of string
let error fmt = Printf.kprintf (fun msg -> raise (Error msg)) fmt

let (@@) f x    = f x
let get         = Lexing.lexeme (* matched string *)


@ Rule `words`  splits the input into words by capturing
sequences of non-whitespace characters. Such words are collected into
a list.  This list must be reversed before it is returned. 

<<rules>>=
rule scan words = parse
     eof                        { List.rev words }
  |  [^ ' ' '\n' '\r' '\t']+    { scan (get lexbuf :: words) lexbuf }
  |  _                          { scan words lexbuf }  (* skip *)   

@ Rule `lines` scans a file line by line and splits each line into a list
of words. The resulting value has type `(string list) list`.

<<rules>>=
and lines words ls = parse
      eof                       { List.rev (List.rev words :: ls) }
  |  [^ ' ' '\n' '\r' '\t']+    { lines (get lexbuf :: words) ls  lexbuf}
  |  '\r'* '\n'                 { lines [] (List.rev words :: ls) lexbuf}
  |  _                          { lines words ls lexbuf } (* skip *)
@
