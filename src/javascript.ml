open Js_of_ocaml

let create_button text onclick =
  let doc = Dom_html.document in
  let button = Dom_html.createButton doc in
  
  (* content *)
  button##.textContent := Js.some (Js.string text);
  button##.onclick := Dom_html.handler (fun _ ->
    onclick ();
    Js._true);

  (* style *)
  button##.style##.fontSize := Js.string "24px";
  button##.style##.margin := Js.string "10px";

  button

let () =
  let doc = Dom_html.document in
  let body = doc##.body in

  (* Create a counter display *)
  let counter = ref 0 in
  let display = Dom_html.createDiv doc in
  let update_display () =
    display##.textContent := Js.some (Js.string (string_of_int !counter))
  in
  update_display ();

  (* Create buttons *)
  let incr_btn = create_button "+" (fun () ->
    incr counter;
    update_display ()
  ) in
  let decr_btn = create_button "-" (fun () ->
    decr counter;
    update_display ()
  ) in

  (* Add to page *)
  Dom.appendChild body decr_btn;
  Dom.appendChild body display;
  Dom.appendChild body incr_btn