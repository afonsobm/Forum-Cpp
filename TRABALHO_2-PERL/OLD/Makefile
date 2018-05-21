PERL=perl

INSTALL_DIR=~/Trab_LingProg_2016-2_Bruno-e-Diogo_Perl

all: install
	
install:
	if ! [ -d $(INSTALL_DIR) ]; then \
		mkdir $(INSTALL_DIR); \
		mkdir $(INSTALL_DIR)/bin; \
		mkdir $(INSTALL_DIR)/lib; \
	fi
	cp Curses.txt $(INSTALL_DIR)
	cp bin/* $(INSTALL_DIR)/bin
	cp lib/* $(INSTALL_DIR)/lib

clean:
	rm -rf $(INSTALL_DIR)