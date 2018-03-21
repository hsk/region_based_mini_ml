#!/Usr/bin/make -f

COMPONENT= target.ml main.ml srcParser.mli srcParser.ml srcLexer.ml
TARGET=region_ml

all: $(TARGET) run

$(TARGET): $(COMPONENT)
	ocamlfind ocamlmktop -annot -o $(TARGET) $(COMPONENT)
	make clean1
srcParser.mli: srcParser.mly
	ocamlyacc srcParser.mly
srcLexer.ml: srcLexer.mll
	ocamllex srcLexer.mll
run:
	./region_ml
clean1:
	/bin/rm -f *.cmi *.cmo *.mli
	/bin/rm -f *.annot
	/bin/rm -f srcParser.ml srcLexer.ml srcParser.mli
clean: clean1
		/bin/rm -f $(TARGET)