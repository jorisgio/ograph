
module type Vertex = Sig.VERTEX
module type L = Sig.L

module MakeLabeledGraph ( V : Vertex) = 
  ( Concrete.LabeledGraph(V) : (L with type key = V.t and type label = V.label))

