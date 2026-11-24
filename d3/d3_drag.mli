open Js_of_ocaml

(* implementation of the d3-drag API *)

type d3

(* https://d3js.org/d3-selection *)
type selection

(* https://d3js.org/d3-drag#drag *)
type behaviour

(* https://d3js.org/d3-drag#drag-events *)
type identifier (* string or int identifier of input mode *)
type source_event (* underlying input event *)

(* https://d3js.org/d3-drag#drag_subject *)
type subject (* an object exposing x and y properties *)

(* https://ocsigen.org/js_of_ocaml/latest/js_of_ocaml/Js_of_ocaml/Dom/class-type-element/index.html *)
type dom_element = Dom.element Js.t
[@@js.custom{
  of_js = (Obj.magic : Ojs.t -> Dom.element Js.t);
  to_js = (Obj.magic : Dom.element Js.t -> Ojs.t)
}]

(* https://d3js.org/d3-drag#drag-events *)
type event = {
    target : behaviour;
    type_ : string;
    subject : subject; (* arbitrary data *)
    x : float;
    y : float;
    dx : float;
    dy : float;
    identifier : identifier;
    active : int;
    source_event : source_event
}

val d3 : d3 [@@js.global "d3"]

(* https://d3js.org/d3-drag#drag *)
val drag : d3 -> behaviour [@@js.call "drag"]

(* https://d3js.org/d3-drag#_drag *)
val drag_selection : d3 -> selection -> unit [@@js.call "drag"]

(* https://d3js.org/d3-drag#drag_container *)
val get_container : behaviour -> (unit -> dom_element) [@@js.call "container"]
val set_container : behaviour -> (unit -> dom_element) -> 
    behaviour [@@js.call "container"]

(* https://d3js.org/d3-drag#drag_filter *)
val get_filter : behaviour -> (event -> bool) [@@js.call "filter"]
val set_filter : behaviour -> (event -> bool) -> behaviour [@@js.call "filter"]

(* https://d3js.org/d3-drag#drag_touchable *)
val get_touchable : behaviour -> (unit -> bool) [@@js.call "touchable"]
val set_touchable : behaviour -> (unit -> bool) -> 
    behaviour [@@js.call "touchable"]

(* https://d3js.org/d3-drag#drag_subject *)
val get_subject : behaviour -> 
    (event -> subject -> subject) [@@js.call "subject"]
val set_subject : behaviour -> (event -> subject -> subject) ->
    behaviour [@@js.call "subject"]