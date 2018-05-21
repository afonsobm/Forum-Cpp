
  use strict;
  use warnings;
  use File::Find;
  use English;
  use List::Util qw(min);
  
  use File::Basename qw(dirname);
  use Cwd  qw(abs_path);
  use lib dirname(dirname abs_path $0) . '/lib';
  
  use filesHandler;
  use textReader;
  use userHandler;

  # filesHandler::chkAllDirectories ();
  # filesHandler::runAllDirectories ();
  textReader::searchTopic ("TOPI B Z X Y C D E F G H A");
  # userHandler::insertUser ("Bruno", "Lanzanha", "00000000000");
  # userHandler::deleteUser ("Bruno");
  # userHandler::validateLogin ("Bruno", "Lanzanhaaa");
  # userHandler::createPost ("Diogo", "0", "Oi, tchau\naté", "Topico_A");