  package userHandler;

  use strict;
  use warnings;
  use File::Find;
  use English;
  use List::Util qw(min);
  use filesHandler;
  use textReader;
  
  
  sub insertUser #insere e valida um usuário na pasta Users do Root utilizando os valores passados como argumento
  {
    my $dir =  "..\\Users\\";
    my $root = "..\\";
    my $userName = $_[0];
    my $unCryptPassword = $_[1];
    my $cryptPassword = textReader::CryptPass ($unCryptPassword);
    my $CPF = $_[2];
    $CPF =~ s/\D//g; # TIRA CARACTERES NAO NUMERICOS DA STRING
    
    if (textReader::chkCPF ($dir, $CPF))
    {
      print "Repeated CPF\n";
      return 0;
    }
    
    if (textReader::chkName ($dir, $userName))
    {
      print "Repeated Name\n";
      return 0;
    }
    
    if(!textReader::validateCPF ($CPF + 0))
    {
      print "Invalid CPF\n";
      return 0;
    }
    
    my @curses = filesHandler::getCurses ($root);
    foreach (@curses)
    {
      if (textReader::findString ($_, $userName) || textReader::findString ($_, $unCryptPassword) || textReader::findString ($_, $CPF))
      {
        print "Improper Name\n";
        return 0;
      }
    }
    
    my @users = filesHandler::getFilesList ($dir);
    my $i = 1; #número do primeiro user na lista!!
    foreach(@users)
    {
      $i++;
    }
    my $userFileName = $dir . $i . ".txt";
    open(my $fh, '>', $userFileName) or die "Could not open file '$userFileName' $!";
    print $fh $i,"\n";
    print $fh $userName,"\n";
    print $fh $cryptPassword,"\n";
    print $fh $CPF,"\n";
    close $fh;    
    
    return 1;        
    
  }  
  
  sub deleteUser #deleta o usuario com o nome informado
  {
    my $dir = "..\\Users\\";
    my $userName = $_[0];
    my $userIndex;
    if (!($userIndex = textReader::chkName($dir, $userName)))
    {
      print "User not found!\n";
      return 0;
    }

    my $userFileName = $dir . $userIndex . ".txt";
    unlink $userFileName;
    
    return 1;
  }
  
  sub chkPass # retorna uma lista com a senha encriptada em com todos os salts possiveis
  {
    my $pwd = $_[0];
    my $salt = "";
    my @passwords;
    
    for (my $nbr =0; $nbr < 5; $nbr++)
    {
      if ($nbr == 0) { $salt = "meta_security"; }
      elsif ($nbr == 1) { $salt = "blowfish_killer"; }
      elsif ($nbr == 2) { $salt = "L337_Skillz"; }
      elsif ($nbr == 3) { $salt = "FBD_JBA_PLAN"; }
      elsif ($nbr == 4) { $salt = "NTPN_NTPN_NTPN"; }
          
      $passwords[$nbr] = crypt($pwd, $salt);
    }
    
    return @passwords;
  }
  
  sub validateLogin #valida do login de um usuário. Recebe como argumento o nome do usuário e a senha
  {
    my $dir = "..\\Users\\";
    my $userName = $_[0];
    my $userPassword = $_[1];
    my $userActualPassword;
    my $userIndex;
    if (!($userIndex = textReader::chkName ($dir, $userName)))
    {
      print "User not found!\n";
      return 0;
    }
    my @passwords = chkPass($userPassword);
    
    my $userFileName = $dir . $userIndex . ".txt";
    
    my $i = 0;
    open (my $fh, '<:encoding(UTF-8)', $userFileName) or die "Could not open file '$userFileName' $!";
    while (my $row = <$fh>)
    {
      chomp $row;
      if ($i == 2) # 3 é o número da linha em que o CPF se encontra no .txt
      {
        $userActualPassword = $row;
        last; #BREAK
      }
      $i++;
    }
    
    foreach (@passwords)
    {
      if ( $_ eq $userActualPassword)
      {
        print "Login Succefull!\n";
        return 0;
      }
    }
    
    print "Wrong Password!\n";
    return 1;
    
  }
  
  sub createPost #Cria um post. Recebe como argumento o Autor do post, qual post foi respondido (0 quer dizer que não foi resposta), A mensagem do post e o topico no qual o post será feito
  {
    my $dir = "..\\";
    my $author = $_[0];
    my $response = $_[1];
    my $message = $_[2];
    my $topic = $_[3];
    my @files = filesHandler::getFiles ($dir);
    my $topicPath = "";
    
    foreach (@files)
    {
      $_ =~ s/[\.\\\/]+//g;
      if ($topic eq $_)
      {
        $topicPath = $_;
      }
    }
    
    if ($topicPath eq "")
    {
      print "No Topic Found!\n";
      return 0;
    }
    
    $topicPath = $dir . "\\" . $topicPath;
    my @txts = filesHandler::getFilesList ($topicPath);
    
    my $i = 1;
    foreach (@txts)
    {
      $i++;
    }
    
    my $topicFileName = $topicPath . "\\" . $i . ".txt";
    
    open(my $fh, '>', $topicFileName) or die "Could not open file '$topicFileName' $!";
    print $fh $author,"\n";
    print $fh $response,"\n";
    print $fh $message,"\n";
    close $fh;    
    
    return 1;    
    
  } 
   
  1;