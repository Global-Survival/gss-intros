#!/usr/bin/perl -wT
use strict;

use IO::File;
use Fcntl ":flock";

# Learning Perl... 
# The following declarations are all implied 
# by the final *FH1 (typeglob) assignment: 
#
#sub FH1 {
#  new_tmpfile IO::File or die "Cannot open temp file: $!\n";
#}  
#my $FH1 = FH1;
#my @FH1 = FH1;
#my %FH1 = (FH1,FH1);
#
*FH1 = new_tmpfile IO::File or die "Cannot open temp file: $!\n";
print "\n";

eval { flock FH1, LOCK_SH };
$@ and die "Your system does not support flock: $@\n";

open FH2, ">> &FH1" or die "Cannot duplicate filehandle: $!\n";

if ( flock FH2, LOCK_SH | LOCK_NB ) {
  print "Your system supports shared file locks!\n";
  close FH1;
  close FH2;
  unlink "&FH1";
} else {
  print "Your system only supports exclusive file locks\n";
  close FH1;
  unlink "&FH1";
}
print "\n";

