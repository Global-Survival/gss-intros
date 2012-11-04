#!/usr/bin/perl -wT

#Required Perl modules:
use Fcntl qw(:flock SEEK_END);
use MIME::Base64::URLSafe;

#subroutine for using flock on data files
sub lock {
  my ($fh) = @_;
  flock($fh, LOCK_EX) or die "Cannot lock data file - $!\n";
}
sub unlock {
  my ($fh) = @_;
  flock($fh, LOCK_UN) or die "Cannot unlock data file - $!\n";
}

#Create file handle and open/lock the input file
my $inputf;
my $file = $ARGV[0] or die "Invalid input filename";
open $inputf, '<', $file or die "Can't open $file: $!\n";
#Set binary mode if binary file
if (-B $inputf) {
  print "Input file is binary\n";
  binmode $inputf;
}
lock($inputf);

#Encode the first line of the file in base64 and print
$encoded = urlsafe_b64encode(<$inputf>);
# $decoded = urlsafe_b64decode($encoded);
print $encoded;
print "\n";

