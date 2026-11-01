type 'a selector_one = 'a -> bool
type 'a selector_two = 'a -> 'a -> bool
type 'a partition = 'a -> int
type 'a edge = 'a -> 'a option
type 'a attribute = 'a -> string option
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

type 'a tree = 
| Leaf
| InnerNode of 'a tree * 'a * 'a tree

module TreeDiagramNode : DiagramNode with type t = int tree = struct
  type t = int tree

  let edges = [
    ("left", fun n -> 
      match n with
      | Leaf -> None
      | InnerNode (left, _, _) -> Some left
    );
    ("right", fun n ->
      match n with
      | Leaf -> None
      | InnerNode (_, _, right) -> Some right
    );
  ]

  let attributes = [
    ("value", fun n ->
      match n with
      | Leaf -> None
      | InnerNode (_, value, _) -> Some (string_of_int value)
    )
  ]
  
  let constraints = []
  let directives = []
end

let my_tree = InnerNode (Leaf, 1, InnerNode (Leaf, 2, Leaf))

let get_right = List.assoc "right" TreeDiagramNode.edges
let get_value = List.assoc "value" TreeDiagramNode.attributes
let value = Option.get (get_value (Option.get (get_right my_tree)))