type 'a selector_one = 'a -> bool
type 'a selector_two = 'a -> 'a -> bool
type 'a partition = 'a -> int
type 'a field = 'a -> 'a option
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
| EdgeColor of 'a selector_one * 'a field * rgb
| Attribute of 'a selector_one * 'a field
| HideField of 'a selector_one * 'a field
| InferredEdge of 'a selector_two * string (* name *) * rgb

(* signature passed into diagramming function *)
module type DiagramNode = sig
  type t

  val fields : (string * t field) list
  val constraints : (t constrain) list
  val directives : (t directive) list
end

(*
type 'a tree = 
| Leaf of 'a
| InnerNode of 'a tree * 'a tree

module type Tree = sig
  type t

  
end

module DiagramTreeNode : DiagramNode with type t = int tree = struct
  type t = int tree

  let fields = [
    ("left", fun n -> n.left);
    ("right", fun n -> n.right)
  ]

  let constraints = []
  let directives = []
end
*)