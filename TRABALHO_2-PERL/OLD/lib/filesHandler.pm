  package filesHandler;
  
  use strict;
  use warnings;
  use File::Find;
  use English;
  use textReader;
  
  sub getFiles #Retorna todas as Pastas no diretório passado!
  {
    my $dir = $_[0];
    opendir (DIR, $dir);
    my @files = readdir (DIR);
    my @directories;
    my $i = 0;
    foreach (@files)
    {
      if (!($_ =~ /\./)){ #Se for um diretório
        $directories[$i] = $dir . $_;
        $i++;
      }
    }
    return @directories;
  }
  
  sub getFilesList #Retorna como array todos os arquivos txt dentro da pasta enviada como argumento
  {
    my $dir = $_[0];
    opendir (DIR, $dir);
    my @files = readdir (DIR);
    my @filesTxt; 
    my $i = 0;
    foreach (@files)
    {
      if (/.txt$/) # Se o nome do arquivo termina com .txt
      {
        $filesTxt[$i] = $dir . "\\" . $_;
        $i++;
      }
    }
    return @filesTxt;    
  }
  
  sub openTxtFiles #Printa o que está dentro de um arquivo '.txt'!
  {
    my $dir = $_[0];
    my @files = getFilesList ($dir);
    foreach (@files){
      open (my $fh, '<:encoding(UTF-8)', $_) or die "Could not open file '$_' $!";
      while (my $row = <$fh>){
        chomp $row;
        print "$row\n";
      }
    }
  }
  
  sub SPAM_Finder {
	### VOCE ESCOLHE O QUE VC QUER PEGAR COMO ARGUMENTO, SE E O ARQUIVO PARA VC LER O POST TODO DE UMA VEZ
	### OU SE E BASEADO NAQUELE "$row" QUE VAI LENDO DE LINHA EM LINHA
	### DE QQ FORMA, EU VOU ESCREVENDO A FUNCAO MSM ASSIM
	
	### DETECCAO DE TEXTO EM CAIXA ALTA
	my $found_SPAM = 0;
	my $str_post = $_[0];
	if (!($str_post cmp uc($str_post))){ $found_SPAM = 1; }
	return $found_SPAM;
	
	
}
  
  sub chkTxtFilesCurses #Checa se há "Curses" nos arquivos txt do diretório enviado como argumento
  {
    my $dir = $_[0];
    my $curse = $_[1];
    my @files = getFilesList ($dir);
    foreach (@files){
      open (my $fh, '<:encoding(UTF-8)', $_) or die "Could not open file '$_' $!";
      while (my $row = <$fh>){
        chomp $row;
        if (textReader::levenshtein ($curse, $row) <= 2)
        {
          print "Found curse";
        }
      }
    }
  }
  
  sub chkTxtFilesSPAM #Checa se há SPAM nos arquivos txt do diretório enviado argumento
  {
    my $dir = $_[0];
    my @files = getFilesList ($dir);
    my $totalRows = 0;
    my $foundRows = 0;
    foreach (@files){
      open (my $fh, '<:encoding(UTF-8)', $_) or die "Could not open file '$_' $!";
      while (my $row = <$fh>){
        chomp $row;
        $totalRows++;
        if (SPAM_Finder ($row))
        {
          $foundRows++;
        }
      }
      if ($totalRows == $foundRows)
      {
        print "Found SPAM\n";
      }
    }

  }
  
  sub runAllDirectories #Roda todos os diretórios dentro do Root do Programa!
  {
    my $dir = "..\\";
    my @directories = getFiles ($dir);
    foreach (@directories)
    {
      openTxtFiles ($_);
    }
  }
  
  sub getCurses #Retorna um array com todas as palavras de Curses no arquivo Curses.txt no diretório enviado como argumento
  {
    my $dir = $_[0];
    my $cursesPath = $dir . "Curses.txt";
    my @curses;
    my $i = 0;
    open (my $fh, '<:encoding(UTF-8)', $cursesPath) or die "Could not open file '$_' $!";
      while (my $row = <$fh>){
        chomp $row;
        $curses [$i] = $row;
        $i++;
      }
    return @curses;
  }
  
  sub chkAllDirectories #Roda todos os diretórios dentro do Root do Programa e checa por Curses e SPAM!
  {
    my $dir = "..\\";
    my @directories = getFiles ($dir);
    my $curse;
    my @curses = getCurses ($dir);
    foreach $curse (@curses)
    {
      foreach (@directories)
      {
        chkTxtFilesCurses ($_, $curse);
        print "\n";
      }
    }
    foreach (@directories)
    {
      chkTxtFilesSPAM ($_);
      print "\n";
    }
  }
   
  1;
