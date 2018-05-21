
  use strict;
  use warnings;
  use File::Basename qw(dirname);
  use Cwd  qw(abs_path);
  use lib dirname(dirname abs_path $0) . '/lib';

  use filesHandlerT;
  use textReaderT;
  use userHandlerT;

  # filesHandler::chkAllDirectories ();
  # filesHandler::runAllDirectories ();
  # textReader::searchTopic ("Topico_B");
  # userHandler::insertUser ("Bruno", "cash_master", "53479494650");
  # userHandler::deleteUser ("Bruno");
  # userHandler::validateLogin ("Bruno", "cash_master");
  # userHandler::createPost ("Diogo", "0", "Oi, tchau!", "Topico_B");