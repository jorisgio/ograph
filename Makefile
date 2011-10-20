CC=ocamlc -c
LINK=ocamlc -pack
LIB=graph.cma
CMI=sig.cmi
CMO=concrete.cmo builder.cmo
DOC=sig.mli builder.ml concrete.ml
FLAGS=

all: $(CMI) $(CMO)	
	$(LINK) $(FLAGS) -o $(LIB) $(CMI) $(CMO)

%cmi: %mli
	$(CC) $(FLAGS)  $<

%cmo: %ml
	$(CC) $(FLAGS)  $<
clean:
	rm -f *.cm[io] *.o *~ $(LIB)
	rm -rf doc/

doc:	
	mkdir  -p doc
	rm -rf  doc/*
	ocamldoc -d doc -html $(DOC)
	sed -i "s/iso-8859-1/UTF-8/g" doc/*

