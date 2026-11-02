type 'a selector_one = 'a -> bool
type 'a selector_two = 'a -> 'a -> bool
type 'a partition = 'a -> int
type 'a edge = 'a -> 'a option
type 'a attribute = 'a -> string option
type rgb = { r : int; g : int; b : int }

type 'a atom = Atom of 'a

type _ selector =
| Atom : 'a atom -> 'a selector
| Edge : 'a edge -> ('a * 'a) selector
| Unary : 'a atom * ('a -> bool) -> 'a selector
| Binary : 'a atom * 'a atom * ('a * 'a -> bool) -> ('a * 'a) selector
| Follow : 'a atom * 'a edge -> ('a * 'a) selector
| Reverse : 'a atom * 'a edge -> ('a * 'a) selector
| Reach : 'a atom * 'a edge -> ('a * 'a) selector
| ReachId : 'a atom * 'a edge -> ('a * 'a) selector
| Union : 'a selector * 'a selector -> 'a selector
| Intersection : 'a selector * 'a selector -> 'a selector
| Difference : 'a selector * 'a selector -> 'a selector
| Cross : 'a selector * 'b selector -> ('a * 'b) selector
| List : ('a list) selector -> 'a selector

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

type 'a constrain =
| Orientation of 'a selector_one * direction list
| Cyclic of 'a selector_two * rotation
| Align of 'a selector_two * aligndir
| Group of 'a selector_one * string (* name *)
| Groups of 'a selector_one * 'a partition * string (* name *) * bool (* showedge *)
| Size of 'a selector_one * Q.t (* width *) * Q.t (* height *)
| HideAtom of 'a selector_one

type 'a directive =
| Icon of 'a selector_one * string (* filepath *) * bool
| AtomColor of 'a selector_one * rgb
| EdgeColor of 'a selector_one * 'a edge * rgb
| Attribute of 'a selector_one * 'a attribute
| HideField of 'a selector_one * 'a edge
| InferredEdge of 'a selector_two * string (* name *) * rgb

(* signature passed into diagramming function *)
module type DiagramNode = sig
  type t

  val edges : (string * t edge) list
  val attributes : (string * t attribute) list
  val constraints : (t constrain) list
  val directives : (t directive) list
end