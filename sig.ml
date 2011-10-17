(* ordre total sur t *)
module type ORDERED = sig
  type t
  val compare : t -> t -> int
end 

module type VERT =
sig
  type key
  type 'a value
  val compare : key -> key -> int 
  val empty : 'a -> 'a  value
  val setLabel : 'a value -> 'a -> 'a value
  val getLabel : 'a value -> 'a
  val addSucc : 'a value -> key -> 'a value
  val removeSucc : 'a value -> key -> 'a value
  val getSucc : 'a value -> key list
  val iterSucc : ( key -> unit ) -> 'a value -> unit 
  val foldSucc : ( key -> 'b -> 'b ) -> 'a value -> 'b -> 'b 
end

module type L =
sig
  type key 
  type 'a value 
  type 'a t
  exception Vertex_missing of key
  val empty : 'a t
  val mem : 'a t -> key ->  bool
  val addVertex : 'a t -> key -> 'a -> 'a t 
  val removeVertex : 'a t -> key -> 'a t
  val removeEdge : 'a t -> key -> key -> 'a t
  val addEdge : 'a t -> key -> key -> 'a-> 'a t
  val getLabel : 'a t -> key -> 'a
  val setLabel : 'a t -> key -> 'a -> 'a t
  val mapVertex : ( 'a value -> 'b value) -> 'a t -> 'b t
  val iterVertex : ( key -> 'a value -> unit) -> 'a t -> unit
  val foldVertex : ( key -> 'a value -> 'b -> 'b) -> 'a t -> 'b -> 'b
  val find : 'a t -> key -> 'a value
end
    
