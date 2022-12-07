type FSItem =
    | Dir of path: string * items: FSItem list
    | File of path: string * size: uint

let get_path item =
    match item with
    | Dir(path, _) -> path
    | File(path, _) -> path

let is_dir item =
    match item with
    | Dir(_, _) -> true
    | _ -> false

let parse_dir_header current_path (commands: string list) =
    match commands with
    | cd :: _ :: rest ->
        let name =
            match cd.Split ' ' with
            | [| _; _; n |] -> n

        ((if name = "/" then name else $"{current_path}{name}/"), rest)

let parse_raw current_path entry =
    match entry with
    | [| "dir"; name |] -> Dir($"{current_path}{name}/", [])
    | [| raw_size; name |] -> File($"{current_path}{name}", uint raw_size)

let rec parse_dir commands current_path =
    let (path, with_entries) = commands |> parse_dir_header current_path

    let raw_entries =
        with_entries
        |> List.takeWhile (fun e -> not (e.StartsWith('$')))
        |> List.map (fun e -> e.Split(' '))
        |> List.map (parse_raw path)

    let mutable entries = raw_entries
    let mutable tail = with_entries |> List.skip raw_entries.Length

    let should_continue els =
        match els with
        | "$ cd .." :: _ -> false
        | [] -> false
        | _ -> true

    let is_different_dir dir item =
        match item with
        | Dir(path, _) -> not (path = get_path dir)
        | _ -> true

    while should_continue tail do
        let sub_dir, new_tail = parse_dir tail path
        let filtered = entries |> List.filter (is_different_dir sub_dir)
        entries <- sub_dir :: filtered
        tail <- new_tail

    Dir(path, entries), (if tail.Length = 0 then [] else tail.Tail)

let commands = System.IO.File.ReadLines("day7.txt") |> List.ofSeq
let fs, _ = parse_dir commands ""

let rec size item =
    match item with
    | Dir(_, items) -> items |> List.fold (fun acc i -> acc + size (i)) 0u
    | File(_, size) -> size

let rec flatten item =
    match item with
    | Dir(_, items) -> item :: (items |> List.collect flatten)
    | _ -> [ item ]

let rec print item indent =
    match item with
    | Dir(path, items) ->
        printfn "%s%s (dir)" indent path

        for item in items do
            print item $"{indent}  "
    | File(path, size) -> printfn "%s%s (file, size=%i)" indent path size

let sizes = fs |> flatten |> List.filter is_dir |> List.map size
printfn "Part 1: %i" (sizes |> List.filter ((>) 100000u) |> List.sum)

let total_space = 70000000u
let desired_unused = 30000000u
let current_unused = total_space - (size fs)
let need_to_free = desired_unused - current_unused
printfn "Part 2: %i" (sizes |> List.filter ((<) need_to_free) |> List.min)
