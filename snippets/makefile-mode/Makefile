# -*- mode: snippet -*-
#name : Makefile
# contributor: Darlan Cavalcante Moreira
# --
HEADERS := $(wildcard *.h)
CPPSOURCES := $(wildcard *.cpp)

CPPSOURCESFORLIB := $(CPPSOURCES:main.cpp=)


DEBUGFLAGS := -O0 -g3 -Wall
OPTFLAGS := -O2 -g0
PROFILERFLAG := -pg # Include this in CPPEXTRAFLAGS if you want to use
                    # gproof for profiling

CPPEXTRAFLAGS = $(DEBUGFLAGS) # Change to $(OPTFLAGS) for the optimized
                              # version or $(DEBUGFLAGS) for the debug
                              # version. Also, add $(PROFILERFLAG) for
                              # profiling


# The option -fPIC in the compilation is necessary to create shared libraries on
# 64bit platforms
CPP := ${1:g++}
LIBS=${2:Libraries (including -l in the name)}
CPPFLAGS= ${3:Compiler flags}
LDFLAGS= ${4:More linker flags} $(LIBS) # Add -static to link statically



EXEFILENAME := ${5:program_file_name}
LIBFILENAME := lib$5.a

EXEFILENAMESHARED := $5_shared
LIBFILENAMESHARED := lib$5.so

all: $(EXEFILENAME)
#	@echo target all
#	@echo $(CPPSOURCES)

run: $(EXEFILENAME)
	./$(EXEFILENAME)

$(EXEFILENAME): $(CPPSOURCES:.cpp=.o)
#	@echo Creating executable file: $@
	$(CPP) -o $@ $^ $(CPPEXTRAFLAGS) $(LDFLAGS)

$(EXEFILENAMESHARED): $(CPPSOURCES:.cpp=.o)
#	@echo Creating executable file: $@
	$(CPP) -o $@ llcross.cpp $(CPPEXTRAFLAGS) $(LDFLAGS) -L./ -l$(LIBFILENAMESHARED:.so=)

lib: $(LIBFILENAME)

sharedlib: $(LIBFILENAMESHARED)

# Create a static version of the library
# For that we use the "ar" program to create the archive and then the ranlib program to add an index to the archive
$(LIBFILENAME): $(CPPSOURCESFORLIB:.cpp=.o)
	@echo Creating static library
	@rm -f $(LIBFILENAME)
	@ar -qc $@ $^
	@ranlib $(LIBFILENAME)
	@echo Library Created

# Create a shared version of the library
# For that we just need to run gcc in the .o files with the -shared option
$(LIBFILENAMESHARED): $(CPPSOURCESFORLIB:.cpp=.o)
	@rm -f $(LIBFILENAMESHARED)
	@echo Creating shared library
	@$(CPP) -shared -o $@ $^
	@echo Shared Library Created

%.o: %.cpp
#	@echo Compiling object file: $@
	$(CPP) -c $< $(CPPFLAGS) $(CPPEXTRAFLAGS) -o $@

veryclean: clean cleantests cleanapps cleanplot
	-rm -f $(EXEFILENAME) $(LIBFILENAME) $(EXEFILENAMESHARED) $(LIBFILENAMESHARED)

clean:
#	@echo Cleaning...
	-rm -f *.o *~ *.d
# The signal '-' in the beginning of the line tell make not to stop even if the command returns errors

unittests: $(CPPSOURCES:.cpp=.o)
	cd tests && $(MAKE) run

cleantests:
	cd tests && $(MAKE) clean

cleanapps:
	cd apps && $(MAKE) clean

cleanplot:
	cd plot && $(MAKE) clean

remade:
	$(MAKE) clean
	$(MAKE)

# %.d: %.cpp
# 	@$(SHELL) -ec '$(CPP) -MM $(CPPFLAGS) $< \
#                       | sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
#                       [ -s $@ ] || rm -f $@'
# #	@echo Dependence file $@ regenerated

# %.d: %.cpp
# 	@$(CPP) $< -MM -MD $(CPPFLAGS)

-include $(CPPSOURCES:.cpp=.d) # The "-" tells make to ignore non-existent files


%.d: %.cpp
	@$(CPP) $< -MM -MT '$*.o $*.d ' -MD $(CPPFLAGS)
# A opção -MM diz para o g++ retornar as dependências do arquivo .cpp sem incluir as do sistema (para incluir use -M)
# O que o g++ gera é da forma -> arquivo.o : dependências
# A opção -MT permite que eu mude o target. No caso eu quero que ao invés de 'arquivo.o' seja 'arquivo.o arquivo.d '
# A opção -MD faz com que isso seja gravado no arquivo 'arquivo.d' ao invés de impresso na tela

tags: # Generates the TAGS file for use with Emacs
# 	etags --language-force=C++ *.h *.cpp
	etags *.h *.cpp

browse: # Generates the BROWSE file for use with Emacs
	ebrowse *.h *.cpp

# Generates documentation including plot classes and test classes
docs:
	cd ../ && doxygen

# Generates documentation without including test classes and plot classes
simpledocs: docs_no_tests_no_plots

# Generates documentation without including test classes
docs_no_tests:
	cd ../ && sed -f no_tests.sed Doxyfile > Doxyfile_no_tests && doxygen Doxyfile_no_tests

# Generates documentation without including test classes and plot classes
docs_no_tests_no_plots:
	cd ../ && sed -f no_tests_no_plots.sed Doxyfile > Doxyfile_no_tests_no_plots && doxygen Doxyfile_no_tests_no_plots

# Clean documentation
cleandocs:
	cd ../docs && rm -rf *

# Lembretes
#
# Em uma regra tipo
# %.d: %.cpp
# $< Lhe da a primeira referência que no caso será o arquivo.cpp
# $+ Da o nome de todas as dependencias incluindo repeticões
# $^ Da o nome de todas as referências sem incluir repeticões
# $* Lhe da o que corresponde ao %, que no caso é o nome do arquivo sem a extensâo
# $@ Lhe da o nome do target, que no caso será arquivo.o
