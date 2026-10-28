type 'a selector_one = ('a -> bool) list
type 'a selector_two = ('a -> 'a -> bool) list
type 'a partition = 'a -> int
type rgb = { r : int; g : int; b : int }

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
| EdgeColor of 'a selector_one * string (* field *) * rgb
| Attribute of 'a selector_one * string (* field *)
| HideField of 'a selector_one * string (* field *)
| InferredEdge of 'a selector_two * string (* name *) * rgb

module type diagram_node = sig
  type t

  val constraints : (t constrain) list
  val directives : (t directive) list
end