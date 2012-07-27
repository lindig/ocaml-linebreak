
# A tool to experiment with line-breaking algorithms

<<frmt.ml>>= 
exception Error of string
let error fmt = Printf.kprintf (fun msg -> raise (Error msg)) fmt
let eprintf   = Printf.eprintf
let printf    = Printf.printf

let (@@) f x = f x 

@ The `finally` function provides resource cleanup in the presence of 
exceptions: `f x` is computed as a result and `cleanup x` is guaranteed to 
run afterwards.

<<frmt.ml>>=
type 'a result = Success of 'a | Failed of exn

let finally f x cleanup = 
    let result =
        try Success (f x) with exn -> Failed exn
    in
        cleanup x; 
        match result with
        | Success y  -> y 
        | Failed exn -> raise exn

let process f = function
    | Some path -> 
        let io = open_in path in
        let lexbuf = Lexing.from_channel io in
            finally f lexbuf (fun _ -> close_in io)
    | None      -> 
        let lexbuf = Lexing.from_channel stdin in
            f lexbuf



let break width lexbuf = 
    let words = Scanner.words lexbuf in
        List.iter print_endline words

let print width doc =
    List.iter 
        (fun s -> Printf.printf "%+3d: %s\n" (String.length s - width) s)
        @@ List.map (String.concat " ") doc

let greedy width words =
    let len   = String.length in
    let rec loop w lines words = match lines, words with
        | line::lines, word::words when len word < w -> 
            loop (w - len word - 1) ((word::line)::lines) words
        | line::lines,word::words  -> 
            loop (width-len word) ([word] :: List.rev line :: lines) words
        | lines,[]  -> List.rev lines
        | [], words -> loop w [[]] words
    in
        loop width [] words
            
let a2i str =
    try 
        let i = int_of_string str
        in if i >= 0 then i else error "%s must be positive" str
    with Failure _ -> error "\"%s\" must be positive number" str
                            
let main argv =
    let args  = List.tl argv in
    let words = Scanner.words in
    let format width doc = print width @@ greedy width doc in
    match args with
        | "-w" :: w :: []           -> process (fun lb -> format (a2i w) (words lb)) None
        | "-w" :: w :: path :: []   -> process (fun lb -> format (a2i w) (words lb)) (Some path)
        | _                         -> error "unknown command line format"
        
let () = if !Sys.interactive then () else 
    try
        main (Array.to_list Sys.argv); exit 0
    with
    | Error(msg)         -> eprintf "error: %s\n" msg; exit 1
    | Sys_error(msg)     -> eprintf "error: %s\n" msg; exit 1
@

## Scanner

We employ a scanner to break a text file into words. This might be useful in 
the long run when we want to categorize words into different categories.

<<scanner.mll>>=
{
<<prelude>>
}
<<rules>>
{
let words lexbuf = scan [] lexbuf
}

@ The prelude contains definitions that we can use in the semantic action 
of a rule.

<<prelude>>=
exception Error of string
let error fmt = Printf.kprintf (fun msg -> raise (Error msg)) fmt

let (@@) f x = f x
let get         = Lexing.lexeme (* matched string *)



@ So far we only have one rules that splits the input into words by
capturing sequences of non-whitespace charaters. Such words are collected in 
a list. This list must be reversed before it is returned. We do this when the 
end of the file is recognized.

<<rules>>=
rule scan words = parse
     eof                        { List.rev words }
  |  [^ ' ' '\n' '\r' '\t']+    { scan (get lexbuf :: words) lexbuf }
  |  _                          { scan words lexbuf }     


