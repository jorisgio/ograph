
module  Noeud = struct
  type t = int
  let compare = Pervasives.compare
  type label = int
  let empty = 0
end

module Couleur = struct
  type t = bool
  let empty = false
end

module Graphe = Builder.MakeLabeledGraph (Noeud)
module Vertex = Graphe.Vertex  
module Colore = Coloring.MakeColoredGraph(Graphe)(Couleur)

let rec construit taille acc count = 
  match count with 
  | k when k = taille -> acc
  | n -> construit taille (Graphe.addVertex acc n ) (n+1)

let graphe = construit 200 ( Graphe.empty ) 0

let graphe2 = Graphe.setLabel graphe (100+1) 42

let label = Graphe.getLabel graphe2 101

let graphe3 = Graphe.mapVertex (fun x -> Vertex.addSucc x 1) graphe2

let graphe3 = Colore.colorGraph graphe3 

let graphe3 = Colore.addVertex graphe3 202
let graphe3 = Colore.addEdge graphe3 202 42
let graphe3 = Colore.setColor graphe3 42 true
let couleur = Colore.getColor graphe3 42

let col = string_of_bool couleur

let () = Printf.printf "%d %s\n" (label) col
