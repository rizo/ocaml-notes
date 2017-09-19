
module Web = Opium.Std

module J = Ezjsonm


let demo_json =
  J.dict [
    "name", J.string "Bob";
    "age", J.int 42
  ]

let say_hello =
  Web.get "/hello" (fun req -> Web.respond' (`Json demo_json))

let () =
  Web.App.empty
  |> say_hello
  |> Web.App.run_command


