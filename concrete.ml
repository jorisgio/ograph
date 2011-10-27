(** Implémentation minimale des graphes *)
module Graph (Vertex : Sig.VERT)  =
struct
  module O = struct
    type t = Vertex.key
    let compare = Vertex.compare
  end
  (* Module implémentant une Map sur les clés pour stocker les listes d'adjacence du graphe et les méta données *)    
  module G = ( Map.Make(O) )
  (** type abstrait des graphes *)
  type t = Vertex.value G.t
  (* Type d'une clée de la map c'est aussi les index qui identifient les noeuds extèrieurement *)
  (** Type des clés indexant les noeuds *)
  type key = Vertex.key

  (** Levée quand un noeud n'est pas présent dans le graphe *)
  exception Vertex_missing of key

  (** Le graphe vide *)
  let empty = G.empty
    
  (** Cherche le noeud key dans le graphe 
    @param graph Un graphe
    @param key le noeud recherché *)
  let mem  graph key = G.mem key graph
  
  (* renvoit la valeur associée au noeud et key et raise Vertex_missing sinon *)
  (** Renvoit la valeur du noeud associè à {b key}, @raise Vertex_missing s'il n'existe pas. 
    @param graph Le graphe
    @param key la clé du noeud recherché *)
  let find graph key =
    try
      G.find key graph 
    with Not_found -> raise (Vertex_missing key) 

  (** Ajoute un noeud au graphe 
    @param graph le graphe
    @param key index du noeud ajouté *)
  let addVertex graph key =
    if mem graph key then
      graph
    else
      G.add key (Vertex.empty) graph
	
  (* Ajoute une branche entre src et dst *)
(** Ajoute une branche au graphe 
    @param graph le graphe
    @param src le noeud source
    @param dst le noeud destination *)
  let addEdge graph  src dst =
    let g = addVertex graph src in
    let g2 = addVertex g dst in
    let value = find g2 src in
    G.add src (Vertex.addSucc value dst) g2    

  (*supprime le noeud indexé par "key"*)
  (** Supprime un noeud. Si le noeud n'existe pas, renvoit le graphe
    @param graph le graphe
    @param key la clé du noeud à supprimer*)
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
  (** Supprime la branche entre {b src} et {b dst}, @raise Vertex_missing si {b src} n'existe pas.
    @param graph le graphe
    @param src le noeud source de la branche
    @param dst le noeud destination de la branche *)
  let removeEdge graph src dst =
    let value = find graph src in
    G.add src (Vertex.removeSucc value dst) graph
      
  (* map sur le graphe *)
  (** Map sur les noeuds. Renvoit le graphe dont les noeuds {b v1 ... vn} on été remplacés par {b (f v1) ... (f vn)}
      @param f Une fonction {b f : value -> value }
      @param graph le graphe *)
  let mapVertex f graph =
    G.map f graph
      
  (* folder *)
  (** Fold sur les noeuds. Si {b k1 ... kn, v1 ... vn } sont les clés/valeurs du graphe, renvoit {b f ( kn vn ... ( f ( k1 v1 x )...) } 
      @param f Une fonction {b f : key -> value -> 'b -> 'b}
      @param graph le graphe
      @param x un élément *)
  let foldVertex f graph x=
    G.fold f graph x
      
  (* iter vertex *)
  (** Iter sur les noeuds. Applique {b f} à tout les noeuds 
      @param f Une fonction {b f : key -> value -> unit}
      @param graph le graphe *)
  let iterVertex f graph =
    G.iter f graph

end

(* implémentation de VERT pour un graphe étiqueté *)
(** Implémention d'un noeud étiquetté 
    @param V module simple d'un noeud f*)
module LabeledVertex = functor (V : Sig.VERTEX) ->
struct
  (** Type de la clé identifiant le noeud *)
  type key = V.t
  (** type de l'étiquette du noeud *)
  type label = V.label
  (* Module d'ensemble de clé, pour la liste d'adjacence *)
  module S = Set.Make(V)
  (** type des métadonnées du noeud *)
  type value =  { label : label ; adjList : S.t }
  (** Le noeud vide *)    
  let empty = {label = V.empty; adjList = S.empty }

  let compare = V.compare
  (** Change l'étiquette du noeud et le renvoit
      @param value Noeud
      @param lab étiquette*)
  let setLabel value lab = {value with label = lab }
  (** renvoit l'étiquette du noeud
      @param value Noeud*)
  let getLabel value = value.label

  (** Ajoute le successeur dst au noeud 
      @param value Noeud
      @param dst le successeur à ajouter *)
  let addSucc value dst = 
    let s = value.adjList in
    {value with adjList = (S.add dst s)}

  (** Supprime le successeur 
      @param value Noeud
      @param dst successeur à supprimer *)
  let removeSucc value dst =
    let s = value.adjList in
    {value with adjList = (S.remove dst s)}

  (* renvoit la liste des successeurs *)
  (** Renvoit la liste des successeurs du noeud 
    @param value Noeud *)
  let getSucc value = S.elements value.adjList

  (* itère sur les clés des successeurs *)
  (** Iter sur les clés successeurs du noeud. Applique {b f s1; f s2; ... f sn ;} ou {b s1...sn} sont les successeurs du noeud
      @param f Une fonction {b  f : key -> unit }
      @param value Noeud *)
  let iterSucc f value = S.iter f value.adjList

  (* fold sur les clés des successeurs, dans l'ordre croissant *)
  (** fold sur les clés des successeurs, dans l'ordre croissant. Renvoit  (f kN ... (f k1 foo) ...) ou {b k1...kN} sont les clés des successeurs du noeud 
      @param f Une fonction {b f :  key -> 'b -> 'b}
      @param value Noeud
      @param foo Un élément de type {b 'b} *)
  let foldSucc f value foo = S.fold f value.adjList foo

end

(** Implémentation d'un graphe étiquetté 
    @param V Un vertex simple *)
module LabeledGraph (V :Sig.VERTEX) =
struct
  (** module implémentant les primitives sur les noeuds *)
  module Vertex = LabeledVertex (V)
  (** type des métadonnées dur les noeuds *)
  type   value =  Vertex.value
  (** type d'étiquette des noeuds *)
  type label = Vertex.label
  include Graph (Vertex)

 (*renvoit l'étiquette de key *)
  (** Renvoit l'étiquette du noeud indexé par {b key} 
      @param graph le graphe
      @param key l'indexe du noeud *)
  let getLabel graph key =
    let v = find graph key in
    Vertex.getLabel v
      
  (*définie l'étiquette de key, éventuellement de type (fun : t -> key -> Vertex.label -> unit)  *)
  (** Change l'étiquette du noeud et renvoit le nouveau graphe 
      @param graph le graphe
      @param key l'index du noeud
      @param label la nouvelle étiquette*)
  let setLabel graph key label =
    let v = find graph key in
    G.add key (Vertex.setLabel v label) graph

end

(* Code Outdated
module UnlabeledVertex ( O : Sig.ORDERED) = 
struct
  type key = O.t
  module S = Set.Make(O)
  type 'a value = S.t
      
  let compare = O.compare
  let empty _ = S.empty
    
  let setLabel _ _ = ()
  let getLabel _ = ()
    
  let addSucc vert succ =  S.add succ vert
  let removeSucc vert succ = S.remove succ vert

  let getSucc vert = S.elements vert

  let iterSucc  = S.iter
  let foldSucc = S.fold 
end

*)
