CXX = g++ -O2 -w -std=c++11
RUN = python3

all:	IGNViewer
python: descargar.py 
	@$(RUN) $^
lex.yy.c:	tiempo.lex
	@flex tiempo.lex

IGNViewer:	lex.yy.c
	@$(CXX) $^ -o $@ 

clean:
	@rm -f IGNViewer lex.yy.c IGN.html