module CS = Set.Make(Char)

let read_file filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines ;;

type rucksack = {compartment1 : CS.t; compartment2 : CS.t}

let file = read_file "day3.txt" ;;
let rucksacks =
  let str_to_set s = Seq.fold_left (Fun.flip CS.add) CS.empty (String.to_seq s) in
    let str_to_rucksack s = {
      compartment1 = str_to_set (String.sub s 0 ((String.length s) / 2));
      compartment2 = str_to_set (String.sub s ((String.length s) / 2) ((String.length s) / 2))
    } in
      List.map str_to_rucksack file ;;

let prioritize_char c = (Char.code c) - (if Char.lowercase_ascii c == c then 97 else 65 - 26) + 1;;

let intersected_individual =
  let intersect_rucksack r = prioritize_char (CS.choose (CS.inter r.compartment1 r.compartment2)) in
    List.map intersect_rucksack rucksacks ;;

print_string "Part 1: ";;
print_int (List.fold_left (+) 0 intersected_individual);;
print_endline "";;

let rec windowed list window_size =
  let rec extract_window i window xs =
    match xs with
    | [] -> (List.rev window, xs)
    | _ when i == window_size -> (List.rev window, xs)
    | hd :: tl -> extract_window (i + 1) (hd :: window) tl
  in
    match list with
    | [] -> []
    | _ -> let (window, rest) = extract_window 0 [] list in
      window :: (windowed rest window_size) ;;

let joined =
  let join r = CS.union r.compartment1 r.compartment2 in
    List.map join rucksacks ;;
let grouped = windowed joined 3
let badge_priorities =
  let badge_priority (hd :: tl) = prioritize_char (CS.choose (List.fold_left CS.inter hd tl)) in
    List.map badge_priority grouped;;

print_string "Part 2: ";;
print_int (List.fold_left (+) 0 badge_priorities);;
print_endline "";;
