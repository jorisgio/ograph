
module  Noeud = struct
  type t = int
  let compare = Pervasives.compare
  type label = int
  let empty = 0
end

module Graphe = Graph.MakeLabeledGraph (Noeud)
module Vertex = Graphe.Vertex  

let rec construit taille acc count = 
  match count with 
  | k when k = taille -> acc
  | n -> construit taille (Graphe.addVertex acc n ) (n+1)

let graphe = construit 200 ( Graphe.empty ) 0

let graphe2 = Graphe.setLabel graphe (100+1) 42

let label = Graphe.getLabel graphe2 101

let graphe3 = Graphe.mapVertex (fun x -> Vertex.addSucc x 1) graphe2


let () = Printf.printf "%d\n" label
