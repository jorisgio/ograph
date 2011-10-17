module ConcreteLabeled (O :Sig.ORDERED) = 
struct
  include Concrete.Graph ( Concrete.LabeledVertex (O) )
  let addVertex = __addVertex
  let addEdge = __addEdge
end

module type Ordered = Sig.ORDERED
module type L = Sig.L

module MakeLabeledGraph ( O : Ordered) = 
  ( ConcreteLabeled(O) : (L with type key = O.t))

module MakeLabeledVertex ( O : Ordered) =
  (Concrete.LabeledVertex (O) : ( Sig.VERT with type key = O.t))
