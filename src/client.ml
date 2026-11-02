open Diagraml

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