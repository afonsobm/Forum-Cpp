  package textReader;

  use strict;
  use warnings;
  use File::Find;
  use English;
  use List::Util qw(min);
  use filesHandler;
  
    sub levenshtein #APAGAR COMENTARIO. levenshtein distance. Nao sei exatamente como funciona, mas calcula a diferença entre duas palavras.
    { 
      my ($str1, $str2) = @_;
      my @ar1 = split //, $str1;
      my @ar2 = split //, $str2;

      my @dist;
      $dist[$_][0] = $_ foreach (0 .. @ar1);
      $dist[0][$_] = $_ foreach (0 .. @ar2);

      foreach my $i (1 .. @ar1){
          foreach my $j (1 .. @ar2){
              my $cost = $ar1[$i - 1] eq $ar2[$j - 1] ? 0 : 1;
              $dist[$i][$j] = min(
                          $dist[$i - 1][$j] + 1, 
                          $dist[$i][$j - 1] + 1, 
                          $dist[$i - 1][$j - 1] + $cost );
          }
      }

      return $dist[@ar1][@ar2];
  }
  
  sub findString
   {
	my $bad_str = uc $_[1];
	my $curse_word = uc $_[0];
	
	### index localiza a substring "$curse_word" em "$bad_str" e devolve a localizacao dele na string
	my $loc = index($bad_str, $curse_word);
	if ($loc < 0)
	{
          return 0;
        }
        else
        {
          return 1;
        }
	
  }
  
  sub splitWords #limpa todos as pontuações e palavras recorrentes separa as palavras num array
  {
     my $splitString = $_[0];
     my @splitWords = split / |,|_|-|'|.\\/, $splitString; # elimina as pontuações dentro do '/  /' 
     my @newSplitWords;
     
     my %stop_hash;
     my @stop_words = qw/i in a to the it have haven't was but is be from a ou e pra para com como até ate esta ta este por pelo pela/; # hash com palavras recorrentes que não serão pesquisadas
     foreach (@stop_words)
     {
       $stop_hash{$_}++ ;
     }
    
     my $i = 0;
     foreach (@splitWords)
     {
       if ((! (exists $stop_hash {$_ })) && ($_ cmp "")) #limpa todas as palavras dentro do hash do array
       {
         $newSplitWords[$i] = $_;
         $i++;
       }
     }
     
     return @newSplitWords;
  }
  
  sub calculateDistance # verifica a proximidade entre duas strings para a pesquisa
  {
    my $i;
    
    my $searchString = uc $_[0];
    my $topicName = uc $_[1];
    
    chomp $searchString;
    chomp $topicName;
    
    my @newSearchWords = splitWords ($searchString);
    my @newTopicWords = splitWords ($topicName);    
    
    my $sWord;
    my $tWord;
    
    
    my @distances;
    $i = 0;

    foreach $sWord (@newSearchWords)
    {
      foreach $tWord (@newTopicWords)
      {
        $distances[$i] = 0;
        if ((levenshtein($sWord, $tWord) < 3 && length $sWord >2) || !($sWord cmp $tWord))
        {
          $distances[$i] = 1;
        }
        $i++;
      }
    }

    $i = 0;
    my $maximumDistance = 5;
    my $totalPoints = 0;
    
    foreach (@distances)
    {
      if ($_)
      {
        my $actualDistance = 0;
        my $tempPoints = 1;
        for (my $j = $i+1; $j< scalar @distances; $j++)
        {
          $actualDistance++;
          if ($distances[$j])
          {
            $tempPoints++;
            $actualDistance = 0;
          }
          if ($actualDistance == $maximumDistance)
          {
            last; # BREAK;
          }
        }
        if ($tempPoints > $totalPoints)
        {
          $totalPoints = $tempPoints;
        }
      }
      $i++;
    }
    
    
    if (scalar @newTopicWords * scalar @newSearchWords < 5)
    {
      $totalPoints *=2;
    }

    return $totalPoints;
    
  }
  
  sub searchTopic #Procura por Tópicos (pastas) que contenham a String enviada como argumento
  {
    my $searchString = $_[0];
    my @distances;
    my $dir = "..\\";
    my @directories = filesHandler::getFiles ($dir);
    
    my @foundDirectories;
    my $directory;
    my $i = 0;
    foreach $directory (@directories)
    {
      if (calculateDistance($searchString,$directory) >= 2)
      {
        $foundDirectories[$i] = $_;
        print $directory,"\n";
        print "points: ", calculateDistance($searchString, $directory),"\n";
      }
    }
    return @foundDirectories;
  }
  
  sub validateCPF #Verifica a validade do CPF enviado como argumento
  {
    my $numbersCPF = $_[0];
    
    my @arrayCPF;
    
    for (my $i = 0; $i<11; $i++)
    {
      $arrayCPF[$i] = 0;
    }
    
    my $i = 10;
    while ($numbersCPF > 0)
    {
      $arrayCPF[$i] = $numbersCPF %10;
      $numbersCPF = int ($numbersCPF/10);
      $i--;
    }
    
    if ($i > 1)
    {
      return 0;
    }
    
    my $sum = 0;
    
    for (my $i = 0; $i<9; $i++)
    {
        $sum+= (10 - $i) * $arrayCPF[$i];
    }
    
    
    if (!(11- $sum%11== $arrayCPF[9]) && !($sum%11<2 && $arrayCPF[9] == 0))
    {
      return 0;
    }
    
    $sum = 0;
    for (my $i = 0; $i<10; $i++)
    {
        $sum+= (11-$i) * $arrayCPF[$i];
    }
    
    if (!(11- $sum%11== $arrayCPF[10]) && !($sum%11<2 && $arrayCPF[10] == 0))
    {
      return 0;
    }
    
    return 1;
    
  }
  
  sub CryptPass 
  {
	my $pwd = $_[0];
	my $rand_nbr = int(rand(5));
	my $salt = "rnd";
	
	if ($rand_nbr == 0) { $salt = "meta_security"; }
	elsif ($rand_nbr == 1) { $salt = "blowfish_killer"; }
	elsif ($rand_nbr == 2) { $salt = "L337_Skillz"; }
	elsif ($rand_nbr == 3) { $salt = "FBD_JBA_PLAN"; }
	elsif ($rand_nbr == 4) { $salt = "NTPN_NTPN_NTPN"; }
	
	my $crypt_msg = crypt($pwd, $salt);
	return $crypt_msg;
}

  sub chkName #Verifica se há Nome igual ao enviado como argumento entre os usuários cadastrados na pasta enviada como argumento
  {
    my $dir =  $_[0];
    my $name = $_[1];
    my $userName = "";
    my $userIndex = 1; 
    my @users = filesHandler::getFilesList ($dir);
    foreach (@users)
    {
       my $i = 0;
       open (my $fh, '<:encoding(UTF-8)', $_) or die "Could not open file '$_' $!";
       while (my $row = <$fh>){
        chomp $row;
        if ($i == 1) #1 é o número da linha em que o Nome se encontra no .txt
        {
          $userName = $row;
          last; #BREAK
        }
        $i++;
      }
      if (!($name cmp $userName))
      {
        return $userIndex;
      }
      $userIndex++;
    }
    return 0;
  }
  
  sub chkCPF #Verifica se há CPF igual ao enviado como argumento entre os usuários cadastrados na pasta enviada como argumento
  {
    my $dir =  $_[0];
    my $CPF = $_[1];
    my $userCPF = "";
    my $userIndex = 1;
    my @users = filesHandler::getFilesList ($dir);
    foreach (@users)
    {
       my $i = 0;
       open (my $fh, '<:encoding(UTF-8)', $_) or die "Could not open file '$_' $!";
       while (my $row = <$fh>){
        chomp $row;
        if ($i == 3) # 3 é o número da linha em que o CPF se encontra no .txt
        {
          $userCPF = $row;
          last; #BREAK
        }
        $i++;
      }
      if (!($CPF cmp $userCPF))
      {
        return $userIndex;
      }
      $userIndex++;
    }
    return 0;
  }
  
  1;