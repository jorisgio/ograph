module Graph (Vertex : Sig.VERT)  =
struct
  module O = struct
    type t = Vertex.key
    let compare = Vertex.compare
  end
  (* Module implémentant une Map sur les clés pour stocker les listes d'adjacence du graphe et les méta données *)    
  module G = ( Map.Make(O) )
  (* type d'une valeur dans la map *)
  type 'a value = 'a Vertex.value

  (*type d'une clée de la map c'est aussi les index qui identifient les noeuds extèrieurement *)
  type key = Vertex.key
      
  exception Vertex_missing of key
  (* type pout un graphe *)
  type ('a) t = ( ('a) value) G.t

  let empty = G.empty
  let mem  graph key = G.mem key graph
  
  (* renvoit la valeur associée au noeud et key et raise Vertex_missing sinon *)
  let find graph key =
    try
      G.find key graph 
    with Not_found -> raise (Vertex_missing key) 
    
  (*ajoute le noeud indexé par "key" de meta-données vides au graph*)
  let __addVertex graph key label =
    if mem graph key then
      graph
    else
      G.add key (Vertex.empty label ) graph

  (*supprime le noeud indexé par "key"*)
  let removeVertex graph key =
    let aux target value g =
      (* On enlève target de la liste d'adjacence de l'élément target *)   
      let v = Vertex.removeSucc value target in
      (* on réajoute target avec la liste d'adjacence modifiée *)
      G.add target v g in
    (* On applique sur tout les noeuds du graphe, pour supprimer toutes les branches pointant vers le noeud supprimé *)
    let g2 = G.fold aux graph graph in
    G.remove key g2

  (* Supprime la branche entre src et dst et raise Vertex_missing si src n'existe pas *)
  let removeEdge graph src dst =
    let value =find graph src in
    G.add src (Vertex.removeSucc value dst) graph
      
  (* Ajoute une branche entre src et dst *)
  let __addEdge graph  src dst label =
    let g = __addVertex graph src label in
    let g2 = __addVertex g dst label in
    let value = find g2 src in
    G.add src (Vertex.addSucc value dst) g2

  (*renvoit l'étiquette de key, éventuellement () *)
  let getLabel graph key =
    let v = find graph key in
    Vertex.getLabel v 

  (*définie l'étiquette de key, éventuellement de type (fun : t -> key -> Vertex.label -> unit)  *)
  let setLabel graph key label =
    let v = find graph key in
    G.add key (Vertex.setLabel v label) graph

  (* map sur le graphe *)
  let mapVertex f graph =
    G.map f graph
      
  (* folder *)
  let foldVertex f graph =
    G.fold f graph
      
  (* iter vertex *)
  let iterVertex f graph =
    G.iter f graph

end

(* implémentation de VERT pour un graphe étiqueté *)
module LabeledVertex = functor (O : Sig.ORDERED) ->
struct
  type key = O.t
  (* Module d'ensemble de clé, pour la liste d'adjacence *)
  module S = Set.Make(O)

  type ('a) value =  { color : bool ; label : 'a ; adjList : S.t }
      
  let empty lab = {color = false; label = lab ; adjList = S.empty }

  let compare = O.compare
  let setLabel value lab = {value with label = lab }
  let getLabel value = value.label

  let addSucc value dst = 
    let s = value.adjList in
    {value with adjList = (S.add dst s)}

  let removeSucc value dst =
    let s = value.adjList in
    {value with adjList = (S.remove dst s)}

  (* renvoit la liste des successeurs *)
  let getSucc value = S.elements value.adjList

  (* itère sur les clés des successeurs *)
  let iterSucc f value = S.iter f value.adjList

  (* fold sur les clés des successeurs, dans l'ordre croissant *)
  let foldSucc f value foo = S.fold f value.adjList foo

end

