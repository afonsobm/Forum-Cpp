PERL=perl

INSTALL_DIR=~/Trab_LingProg_2016-2_Bruno-e-Diogo_Perl

all: install
	
install:
	if ! [ -d $(INSTALL_DIR) ]; then \
		mkdir $(INSTALL_DIR); \
		mkdir $(INSTALL_DIR)/bin; \
		mkdir $(INSTALL_DIR)/Users; \
		mkdir $(INSTALL_DIR)/Topico_A; \
		mkdir $(INSTALL_DIR)/Topico_B; \
		mkdir $(INSTALL_DIR)/lib; \
	fi
	cp INSTALL_FILES/Curses.txt $(INSTALL_DIR)
	cp INSTALL_FILES/Topico_B/* $(INSTALL_DIR)/Topico_B
	cp INSTALL_FILES/bin/* $(INSTALL_DIR)/bin
	cp INSTALL_FILES/lib/* $(INSTALL_DIR)/lib

clean:
	rm -rf $(INSTALL_DIR)