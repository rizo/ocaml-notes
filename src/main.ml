
module Web = Opium.Std

module IO = Lwt_io
open Lwt.Infix

module J = Ezjsonm

type note = {
  title: string;
  content: string;
}

let note_to_json { title; content } =
  J.dict [
    "title", J.string title;
    "content", J.string content
  ]

let post_note notes =
  Web.get "/notes/:note" begin fun req ->
    let note = { title = "Untitled"; content = Web.param req "note" } in
    notes := note :: !notes;
    IO.printl ("note = " ^ note.content) >>= fun () ->
    Lwt.return (Web.respond (`String "OK"))
end

let get_notes notes =
  Web.get "/notes" begin fun req ->
    IO.printlf "requesting %d notes..." (List.length !notes) >>= fun () ->
    let json_note = J.list note_to_json !notes in
    Lwt.return (Web.respond (`Json json_note))
end

let notes: note list ref = ref []

let () =
  Web.App.empty
  |> get_notes notes
  |> post_note notes
  |> Web.App.run_command


