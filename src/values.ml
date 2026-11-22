(* primitive type *)
let int_primitive = 1
let float_primitive = 1.0
let bool_primitive = true
let string_primitive = "Cynthia Chinasaokwu Onyedinmanasu Owezuke "
 ^ "Amarachukwu Echimino Erivo"
let char_primitive = 'A'
let unit_primitive = ()


(* simple variant type *)
type vehicle = 
| Bike
| Motorbike of int (* engine size in CCs *)
| Car of bool (* true if a Reliant Robin *)
| Lorry of int (* number of wheels *)

let bike_vehicle = Bike
let motorbike_vehicle = Motorbike 300
let car_vehicle = Car false

type shape =
| Dot
| Circle of float (* radius *)
| Rectangle of float (* width *) * float (* height *)
| Cuboid of float (* width *) * float (* height *) * float (* depth *)

let dot_shape = Dot
let circle_shape = Circle 2.
let rectangle_shape = Rectangle (2., 1.)
let cuboid_shape = Cuboid (1., 2., 3.)


(* lists of simple variant type *)
type vehicle_list = 
| Nil
| Cons of vehicle * vehicle_list

let short_list = Cons (
  bike_vehicle, 
  Cons (
    motorbike_vehicle, 
    Cons (
      car_vehicle, 
      Nil
    )
  )
)
let long_list = List.init 50 (fun n ->
  match n mod 3 with
  | 0 -> bike_vehicle
  | 1 -> motorbike_vehicle
  | _ -> car_vehicle
)


(* non-polymorphic recursive type *)
type int_tree = 
| Leaf
| Node of int_tree * int * int_tree

let int_tree : int_tree = Node (
  Leaf,
  1,
  Node (
    Node (
      Leaf,
      3,
      Leaf
    ),
    2,
    Leaf
  )
)


(* polymorphic recursive type *)
type 'a tree =
| Leaf
| Node of 'a tree * 'a * 'a tree

let int_poly_tree : int tree = Node (
  Leaf,
  1,
  Node (
    Node (
      Leaf,
      3,
      Leaf
    ),
    2,
    Leaf
  )
)
let vehicle_poly_tree = Node (
  Leaf,
  bike_vehicle,
  Node (
    Node (
      Leaf,
      car_vehicle,
      Leaf
    ),
    motorbike_vehicle,
    Leaf
  )
)


(* functors *)
module Vehicle = struct
  type t = vehicle

  let compare v1 v2 =
    match v1, v2 with
    | Bike, Bike -> 0
    | Bike, _ -> -1
    | Motorbike _, Bike -> 1
    | Motorbike n1, Motorbike n2 -> Int.compare n1 n2
    | Motorbike _, _ -> -1
    | Car _, Bike -> 1
    | Car _, Motorbike _ -> 1
    | Car b1, Car b2 -> Int.compare (Bool.to_int b1) (Bool.to_int b2)
    | Car _, _ -> -1
    | Lorry n1, Lorry n2 -> Int.compare n1 n2
    | Lorry _, _ -> 1
end
module VehicleSet = Set.Make(Vehicle)
module IntSet = Set.Make(Int)
module VehicleMap = Map.Make(Vehicle)
module IntMap = Map.Make(Int)

let int_set = IntSet.(
  empty
  |> add 1
  |> add (-3)
  |> add 17
  |> add 5
)
let vehicle_set = VehicleSet.(
  empty
  |> add Bike
  |> add (Lorry 18)
  |> add (Lorry 20)
  |> add (Car false)
  |> add (Motorbike 300)
  |> add (Motorbike 500)
  |> add (Motorbike 1000)
)
let int_vehicle_map = IntMap.(
  empty
  |> add 0 Bike
  |> add 10 (Lorry 18)
  |> add 11 (Lorry 20)
  |> add 20 (Car false)
  |> add 31 (Motorbike 300)
  |> add 32 (Motorbike 500)
  |> add 33 (Motorbike 1000)
)
let vehicle_string_map = VehicleMap.(
  empty
  |> add Bike "bike"
  |> add (Lorry 18) "small lorry"
  |> add (Lorry 20) "big lorry"
  |> add (Car false) "car"
  |> add (Motorbike 300) "small motorbike"
  |> add (Motorbike 500) "medium motorbike"
  |> add (Motorbike 1000) "large motorbike"
)


(* GADTs *)
type _ expr =
| Int : int -> int expr
| Bool : bool -> bool expr
| Eq : int expr * int expr -> bool expr
| Plus : int expr * int expr -> int expr
| If : bool expr * 'a expr * 'a expr -> 'a expr

let expr = If (
  Eq (
    Plus (Int (-1), Int (2)),
    Int (1)
  ),
  Bool false,
  Bool true
)