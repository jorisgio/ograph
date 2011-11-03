(** Graphe coloré depuis l'implémentation de graphe  G *)
module MakeColoredGraph( Graph : Sig.G) (C : Sig.COLOR) = struct 
  include(Graph)
  (* il faut redefinir les fonctions add* et remove* *)
    
  (* on stocke les couleurs dans une table *)
  (** type de couleur *)
  type color = C.t
      
  (** type de la table des couleurs  *)
  type colortbl = (key, color) Hashtbl.t 

  (** type d'un graphe coloré *)
  type colored = { graph : t; colors : colortbl }
      
  (** Colorise un graphe  *)
  let colorGraph graph =
    let h = Hashtbl.create (Graph.size graph) in 
    Graph.iterVertex (fun k _ -> Hashtbl.add h k C.empty) graph;
    { graph = graph ; colors = h }
  
  (** Supprime les couleurs d'un graphe coloré
      @param graph Graphe
  *)
  let uncolorGraph g = g.graph
    
  (** Ajoute un noeud au graphe
      @param g Graphe coloré
      @param key index du noeud *)
  let addVertex g key =
    Hashtbl.add g.colors key C.empty;
    { g with graph = ( addVertex g.graph key ) }
    
   (** Enlève un noeud du graphe 
       @param g Graphe coloré
       @param key index du noeud *)
  let removeVertex g key =
    Hashtbl.remove g.colors key ;
    { g with graph = (removeVertex g.graph key) }

   (** Ajoute une branche au graphe 
       @param graph Graphe coloré
       @param src noeud source
       @param dst noeud destination
   *)
  let addEdge g src dst =
    if not (Hashtbl.mem g.colors src) then Hashtbl.add g.colors src C.empty ;
    if not (Hashtbl.mem g.colors dst) then Hashtbl.add g.colors dst C.empty ;
    { g with graph = (addEdge g.graph src dst) }


  (** Renvoit la couleur d'un noeud @raise Vertex_missing si le noeud n'existe pas
      @param g Graphe coloré
      @param key index du noeud
  *)
  let getColor g key =
    Hashtbl.find g.colors key
      

  (** Change la couleur d'un noeud, renvoit le graphe identique si inexistant
      @param g Graphe coloré
      @param key index du noeud 
      @param col Couleur à définir
  *)
  let setColor g key col =
    Hashtbl.replace g.colors key col;
    g

  let find g key = find g.graph key;

end
