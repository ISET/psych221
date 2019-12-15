#!/usr/bin/perl
use strict; 

# Documentation near the end.

# We could also use glob("*.m") to automatically find any
# .m files in the directory.
my $filelist = <<EOLIST;
ColorMatching.m
Halftone.m
ImageFormation.m
JPEG_bw.m
JPEG_color.m
Metrics.m
Rendering.m
SensorEstimation.m
Spectrum.m
EOLIST

my $qdir = "questions";

########################################

my @files = split(/\r?\n/, $filelist);
my ($filename, $fn1);


mkdir $qdir unless (-d $qdir); # Make the dir if it doesn't exist.

foreach $filename (@files) {
	print "Reading $filename...\n";
	my $questions = read_tutorial($filename);
	if (!$questions) {
		print "\tCouldn't find any questions.\n";
	} else {
		$fn1 = $filename;
		$fn1 =~ s/\.m$/\.html/i;
		writehtml("$qdir/$fn1", $questions);
		print "\tWrote questions to $qdir/$fn1\n";
	}
}

exit(0);

=pod

=head1 NAME

makequestions.pl - Extract the questions from the .m files in the tutorials.

=head1 AUTHOR

Gregory Ng

=head1 DATE

9 Jan 2006

=head1 DESCRIPTION

This script parses the .m files and looks for a beginning marker:

	%%% BEGIN TUTORIAL QUESTIONS

And then reads until it finds:

	%%% END TUTORIAL QUESTIONS

It then takes this text, and dumps it into an HTML file
(which really ends up just being preformatted text).

=cut


sub writehtml {
	my ($filename, $questions) = @_;
	open (FH, ">$filename") or die "Can't write to $qdir/$fn1: $!";
	$filename =~ s/\.html$//;
	print FH "<html><title>$filename</title><body>\n";
	print FH "<pre>";
	print FH unHTML($questions);
	print FH "</pre>\n</body></html>\n";
	close FH;
}

# Read the tutorial and extract the questions section.

sub read_tutorial {
	my ($flag_save, $text) = (0,'');
	open (FH, "<$_[0]") or die "Can't open $_[0]: $!";
	while (<FH>) {
		if ($flag_save && m/^\%\%\%\s+END TUTORIAL QUESTIONS/i) {
			$flag_save = 0;
		} elsif ($flag_save) {
			s/^\% ?//;
			$text .= $_;
		} elsif (m/^\%\%\%\s+BEGIN TUTORIAL QUESTIONS/i) {
			$flag_save = 1;
		}
	}
	close FH;
	return $text;
}

sub unHTML {
	my ($text) = @_;
	$text =~ s/&/&amp;/g;
	$text =~ s/</&lt;/g;
	$text =~ s/>/&gt;/g;
	return $text;
}
