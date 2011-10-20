
module type Ordered = Sig.ORDERED
module type L = Sig.L

module MakeLabeledGraph ( O : Ordered) = 
  ( Concrete.LabeledGraph(O) : (L with type key = O.t))
