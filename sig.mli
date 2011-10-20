(** Sigantures utilisées par la bibliothèques *)

(** ordre total sur t, utilisé pour indexer le graphe *)
module type ORDERED = sig
  type t
    
  (** compare deux valeurs {b e1} et {b e2}, renvoit un entier < 0 si {b e1} < {b e2}, nul si égalité et > 0 si {b e1} > {b e2} *)
  val compare : t -> t -> int
end 

(** Signature d'un noeud étiqueté *)
module type VERT =
sig
  (** Type de l'index du noeud dans le graphe *)
  type key

  (** type de la valeur d'un noeud, {b 'a} est le type de l'étiquette *)
  type 'a value
  val compare : key -> key -> int 

  (** Prend une étiquette et renvoit un noeud vide pour cette étiquette *)
  val empty : 'a -> 'a  value
    
  (** définit l'étiquette d'un noeud *)
  val setLabel : 'a value -> 'a -> 'a value 

  (** renvoit l'étiquette d'un noeud *)
  val getLabel : 'a value -> 'a

  (** Ajoute un successeur au noeud *)
  val addSucc : 'a value -> key -> 'a value

  (** Enlève le successeur au noeud *)
  val removeSucc : 'a value -> key -> 'a value

  (** renvoit la liste des successeurs du noeud *)
  val getSucc : 'a value -> key list

  (** Prend une fonction {b f k: (key -> unit)}, un noeud et applique {b f s1; f s2; ... f sn ;} ou {b s1...sn} sont les successeurs du noeud donné *) 
  val iterSucc : ( key -> unit ) -> 'a value -> unit 

  (** Prend une fonction {b f k d : ( key -> 'b -> 'b )}, un noeud, un élément {b d} de type {b 'b} et renvoit  (f kN ... (f k1 d) ...) ou {b k1...kN} sont les clés des successeurs du noeud *)
  val foldSucc : ( key -> 'b -> 'b ) -> 'a value -> 'b -> 'b 
end

(** Sigature d'un graphe étiquetté *)
module type L =
sig
  (** Type des clés indexant les noeuds *)
  type key
  (** Type d'un noeud
      @param 'a type de l'étiquette *)
  type 'a value
  (** type abstrait d'un graphe
      @param 'a type de l'étiqyette *)
  type 'a t
  (** Réunit les primitives sur les noeuds *)
  module Vertex : (VERT with type key = key and type  'a value = 'a  value)
  (** Renvoyée quand le noeud recherché est manquant *)
  exception Vertex_missing of key
      
  (** le graphe vide *)
  val empty : 'a t

  (**  cherche un noeud  dans le graphe, renvoit True si existant *) 
  val mem : 'a t -> key ->  bool

  (** Un noeud au graphe *
      @param g graphe
      @param key index du noeud
      @param label étiquette du noeud *)
  val addVertex : 'a t -> key -> 'a -> 'a t 

    (** Supprime un noeud d'un graphe 
	@param g graphe
	@param  key index du noeud *)
  val removeVertex : 'a t -> key -> 'a t

  (** Supprime une Branche du graphe, @raise Vertex_missing si src n'existe pas
      @param g graphe
      @param src noeud source
      @param dst noeud destination
  *)
  val removeEdge : 'a t -> key -> key -> 'a t

  (** Ajoute une branche au graphe. Si un noeud n'existe pas, il est créé 
      @param g graphe
      @param src neoud source
      @param dst noeud destination
      @param label étiquette d'un noeud éventuellement crée*)
  val addEdge : 'a t -> key -> key -> 'a-> 'a t

  (** Renvoit l'étiquette d'un noeud 
      @param g graphe
      @param key noeud *)
  val getLabel : 'a t -> key -> 'a

  (** Définit l'étiquette d'un noeud 
      @param g graphe
      @param key noeud 
      @param label étiquette*)
  val setLabel : 'a t -> key -> 'a -> 'a t

  (** Map sur les noeuds *)
  val mapVertex : ( 'a value -> 'b value) -> 'a t -> 'b t
  val iterVertex : ( key -> 'a value -> unit) -> 'a t -> unit
  val foldVertex : ( key -> 'a value -> 'b -> 'b) -> 'a t -> 'b -> 'b
    
  (** Renvoit la valeur du noeud key, @raise Missing_vertex si non existant 
      @param g graphe
      @param key noeud *)
  val find : 'a t -> key -> 'a value
end
    
