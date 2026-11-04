type rgb = { r : int; g : int; b : int }

type 'a atom = Atom : string -> 'a atom
type ('a, 'b) field = Field : string -> ('a, 'b) field

type dynamic_atom = DynamicAtom : 'a atom -> dynamic_atom
type dynamic_field = DynamicField : ('a, 'b) field -> dynamic_field

type _ selector =
| Atom : 'a atom -> 'a selector
| Edge : ('a, 'b) field -> ('a * 'b) selector
| Unary : 'a atom * 'a condition -> 'a selector
| Binary : 'a atom * 'b atom * ('a * 'b) condition -> ('a * 'b) selector
| Join : 'a selector * ('a * 'b) selector -> 'b selector
| Reverse : 'b selector * ('a * 'b) selector -> 'a selector
| Reach : 'a selector * ('a * 'a) selector -> 'a selector
| ReachId : 'a selector * ('a * 'a) selector -> 'a selector
| Union : 'a selector * 'a selector -> 'a selector
| Intersection : 'a selector * 'a selector -> 'a selector
| Difference : 'a selector * 'a selector -> 'a selector
| Cross : 'a selector * 'b selector -> ('a * 'b) selector
| List : ('a list) selector -> 'a selector
| Display : 'a selector -> string selector
and _ condition =
| EQ : 'a selector * 'a selector -> ('a * 'a) condition
| EQimm : 'a selector * 'a -> 'a condition
| IN : 'a selector * ('a list) selector -> ('a * 'a list) condition
| INimm : 'a selector * 'a list -> 'a condition
| LT : 'a selector * 'a selector -> ('a * 'a) condition
| LTimm : 'a selector * 'a -> 'a condition
| LEQ : 'a selector * 'a selector -> ('a * 'a) condition
| LEQimm : 'a selector * 'a -> 'a condition
| GT : 'a selector * 'a selector -> ('a * 'a) condition
| GTimm : 'a selector * 'a -> 'a condition
| GEQ : 'a selector * 'a selector -> ('a * 'a) condition
| GEQimm : 'a selector * 'a -> 'a condition
| SOME : 'a selector -> 'a condition
| NO : 'a selector -> 'a condition
| ONE : 'a selector -> 'a condition
| LONE : 'a selector -> 'a condition
| AND : 'a condition * 'a condition -> 'a condition
| OR : 'a condition * 'a condition -> 'a condition
| NOT : 'a condition -> 'a condition

type direction =
| Above
| Below
| Left
| Right
| DirectlyAbove
| DirectlyBelow
| DirectlyLeft
| DirectlyRight

type rotation =
| Clockwise
| Counterclockwise

type aligndir =
| Horizontal
| Vertical

type constrain =
| Orientation : ('a * 'b) selector * direction list -> constrain
| Cyclic : ('a * 'b) selector * rotation -> constrain
| Align : ('a * 'b) selector * aligndir -> constrain
| Group : 'a selector * string (* name *) -> constrain
| Groups : ('a * 'b) selector * string (* name *) * bool (* showedge *) -> constrain
| Size : 'a selector * Q.t (* width *) * Q.t (* height *) -> constrain
| HideAtom : 'a selector -> constrain

type directive =
| Icon : 'a selector * string (* filepath *) * bool -> directive
| AtomColor : 'a selector * rgb -> directive
| EdgeColor : 'a selector * ('a, 'b) field * rgb -> directive
| HideField : 'a selector * ('a, 'b) field -> directive
| InferredEdge : ('a * 'b) selector * string (* name *) * rgb -> directive
(* no need for Attribute *)

(* signature passed into diagramming function *)
module type DiagramNode = sig
  type t

  val type_of : t -> dynamic_atom
  val fields : (dynamic_field * (t -> t option)) list
  val attributes : (dynamic_field * (t -> string option)) list
  val constraints : constrain list
  val directives : directive list
end