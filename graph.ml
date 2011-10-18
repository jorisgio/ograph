module ConcreteLabeled (O :Sig.ORDERED) = 
struct
  module Vertex = Concrete.LabeledVertex (O) 
  include Concrete.Graph (Vertex)
  let addVertex = __addVertex
  let addEdge = __addEdge
end

module type Ordered = Sig.ORDERED
module type L = Sig.L

module MakeLabeledGraph ( O : Ordered) = 
  ( ConcreteLabeled(O) : (L with type key = O.t))

