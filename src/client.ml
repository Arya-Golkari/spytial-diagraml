open Diagraml

type 'a tree = 
| Leaf
| InnerNode of 'a tree * 'a * 'a tree

(* atoms *)
type leaf
type inner_node
type node

let leaf_atom : leaf atom = Atom "Leaf"
let inner_node_atom : inner_node atom = Atom "InnerNode"
let node_atom : node atom = Atom "Node"

(* fields *)
type left
type right
type value

let left_field : (inner_node, node) field = Field "left"
let right_field : (inner_node, node) field = Field "right"
let value_field : (inner_node, string) field = Field "value"

module TreeDiagramNode : DiagramNode with type t = int tree = struct
  type t = int tree

  (* dynamic typing *)
  let type_of : t -> dynamic_atom list = function
  | Leaf -> [DynamicAtom leaf_atom; DynamicAtom node_atom]
  | InnerNode _ -> [DynamicAtom inner_node_atom; DynamicAtom node_atom]

  let fields = [
    (DynamicField left_field, fun n -> 
      match n with
      | Leaf -> None
      | InnerNode (left, _, _) -> Some left
    );
    (DynamicField right_field, fun n ->
      match n with
      | Leaf -> None
      | InnerNode (_, _, right) -> Some right
    );
  ]

  let attributes = [
    (DynamicField value_field, fun n ->
      match n with
      | Leaf -> None
      | InnerNode (_, value, _) -> Some (string_of_int value)
    )
  ]
  
  let constraints = []
  let directives = [
    AtomColor (
      (let x = Var (Atom inner_node_atom, "x") in
      Unary (
        x,
        SOME (
          Type (
            Join (
              x,
              Edge left_field
            ),
            inner_node_atom
          )
        )
      )),
      { r=255; g=0; b=0 }
    )
  ]
end


let my_tree = InnerNode (Leaf, 1, InnerNode (Leaf, 2, Leaf))

let get_right = List.assoc (DynamicField right_field) TreeDiagramNode.fields
let get_value = List.assoc (DynamicField value_field) TreeDiagramNode.attributes
let value = Option.get (get_value (Option.get (get_right my_tree)))