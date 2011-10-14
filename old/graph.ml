
exception Vertex_missing of int
exception Edge_missing of int*int

module S = Set.Make(struct 
  type t = int 
  let compare = Pervasives.compare end)

module G  = Map.Make(struct 
  type t = int 
  let compare = Pervasives.compare end)

type value  = { label : int; adj_list : S.t } 
type t = value G.t

let mem graph key = G.mem key graph

let addvertex graph key = 
  if mem graph key then
    graph
  else
    G.add key {label = 0 ; adj_list = S.empty} graph
      
let remove_vertex graph target = 
  let aux key value g =
    let v = { value with adj_list = (S.remove target value.adj_list) } in
    G.add key v g in
  let g2 = G.fold aux graph graph in
  G.remove target g2

let remove_edge graph src dst =
  let value = 
  try 
    find graph src 
  with Not_found -> raise Vertex_missing src 
  in
  G.add src {value with adj_list = S.remove dst value.adj_list}
      
let addedge graph src dst =
  let g = addvertex graph src in
  let g2 = addveretx g dst in
  let s = find g2 src in
  G.add src { label = s.label; adj_list =  S.add dst s.adj_list } g2
  
 
