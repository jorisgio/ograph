
module  Noeud = struct
  type t = int
  let compare = Pervasives.compare
end

module Graphe = Graph.MakeLabeled (Noeud)
  
let rec construit taille acc count = 
  match count with 
  | k when k = taille -> acc
  | n -> construit taille (Graphe.addVertex acc n 0) (n+1)

let graphe = construit 200 ( Graphe.empty ) 0

let graphe2 = Graphe.setLabel graphe (100+1) 42

let label = Graphe.getLabel graphe2 101

let () = Printf.printf "%d\n" label
