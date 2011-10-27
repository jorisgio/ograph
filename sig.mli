(** Sigantures utilisées par la bibliothèques *)

(** ordre total sur t, utilisé pour indexer le graphe et type d'étiquettes *)
module type VERTEX = sig
  type t
    
  (** compare deux valeurs {b e1} et {b e2}, renvoit un entier < 0 si {b e1} < {b e2}, nul si égalité et > 0 si {b e1} > {b e2} *)
  val compare : t -> t -> int
  type label 
  val empty : label
end 

(** Signature d'un noeud étiqueté *)
module type VERT =
sig
  (** Type de l'index du noeud dans le graphe *)
  type key

  (** type de la valeur d'un noeud, *)
  type value

  (** type d'étiquette *)
  type label

  val compare : key -> key -> int 

  (** Prend une étiquette et renvoit un noeud vide pour cette étiquette *)
  val empty :  value
    
  (** définit l'étiquette d'un noeud *)
  val setLabel : value -> label -> value 

  (** renvoit l'étiquette d'un noeud *)
  val getLabel :  value -> label

  (** Ajoute un successeur au noeud *)
  val addSucc :  value -> key -> value

  (** Enlève le successeur au noeud *)
  val removeSucc : value -> key -> value

  (** renvoit la liste des successeurs du noeud *)
  val getSucc : value -> key list

  (** Prend une fonction {b f k: (key -> unit)}, un noeud et applique {b f s1; f s2; ... f sn ;} ou {b s1...sn} sont les successeurs du noeud donné *) 
  val iterSucc : ( key -> unit ) -> value -> unit 

  (** Prend une fonction {b f k d : ( key -> 'b -> 'b )}, un noeud, un élément {b d} de type {b 'b} et renvoit  (f kN ... (f k1 d) ...) ou {b k1...kN} sont les clés des successeurs du noeud *)
  val foldSucc : ( key -> 'b -> 'b ) -> value -> 'b -> 'b 
end

(** Sigature d'un graphe étiquetté *)
module type L =
sig
  (** Type des clés indexant les noeuds *)
  type key
  (** Type d'un noeud *)
  type value
  (** type d'étiquette du graphe *)
  type label 
  (** type abstrait d'un graphe *)
  type t
  (** Réunit les primitives sur les noeuds *)
  module Vertex : (VERT with type key = key and type  value = value and type label = label)
  (** Renvoyée quand le noeud recherché est manquant *)
  exception Vertex_missing of key
      
  (** le graphe vide *)
  val empty : t

  (**  cherche un noeud  dans le graphe, renvoit True si existant *) 
  val mem : t -> key ->  bool

  (** Un noeud au graphe *
      @param g graphe
      @param key index du noeud *)
  val addVertex : t -> key -> t 

    (** Supprime un noeud d'un graphe 
	@param g graphe
	@param  key index du noeud *)
  val removeVertex : t -> key -> t

  (** Supprime une Branche du graphe, @raise Vertex_missing si src n'existe pas
      @param g graphe
      @param src noeud source
      @param dst noeud destination
  *)
  val removeEdge : t -> key -> key -> t

  (** Ajoute une branche au graphe. Si un noeud n'existe pas, il est créé 
      @param g graphe
      @param src neoud source
      @param dst noeud destination
      @param label étiquette d'un noeud éventuellement crée*)
  val addEdge : t -> key -> key -> t

  (** Renvoit l'étiquette d'un noeud 
      @param g graphe
      @param key noeud *)
  val getLabel : t -> key -> label

  (** Définit l'étiquette d'un noeud 
      @param g graphe
      @param key noeud 
      @param label étiquette*)
  val setLabel : t -> key -> label -> t

  (** Map sur les noeuds *)
  val mapVertex : ( value -> value) -> t ->  t
  val iterVertex : ( key -> value -> unit) ->  t -> unit
  val foldVertex : ( key -> value -> 'b -> 'b) -> t -> 'b -> 'b
    
  (** Renvoit la valeur du noeud key, @raise Missing_vertex si non existant 
      @param g graphe
      @param key noeud *)
  val find :  t -> key -> value
end
    
