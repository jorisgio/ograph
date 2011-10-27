(** signature d'un Noeud passé par l'utilisateur *)
module type Vertex = Sig.VERTEX
(** signature d'un graphe étiquetté *)
module type L = Sig.L

(** Créer un module implémentant un graphe étiquetté 
    @param V Module de signature {b Vertex} *)
module MakeLabeledGraph ( V : Vertex) = 
  ( Concrete.LabeledGraph(V) : (L with type key = V.t and type label = V.label))

