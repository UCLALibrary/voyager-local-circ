#!/m1/shared/bin/perl -w
############################################################
# This script takes a filename and date in format MM/DD/YY
# as parameters and returns a 1 if the date is a University
# holiday and a 0 if it is not. The filename corresponds to 
# a file that lists University holidays.
#
# Last revised: 2008-05-23 chunt
############################################################

use strict;

# There should be exactly two arguments. If there are not,
# show usage and exit.
if ($#ARGV != 1)
{
        print "$#ARGV\n";
        show_usage();
}
# Otherwise continue.
else
{
        my($holidays_file) = shift(@ARGV);
        my($day) = shift(@ARGV);

	my(%holidays) = ();

	open(HOLIDAYS, $holidays_file) ||
		die "$ARGV[0] cannot open $holidays_file"; 

	while (my $line = <HOLIDAYS>)
	{
		chomp($line);
		$holidays{$line} = 1;
	}
	if (defined($holidays{$day}))
	{
		print 1;
	}
	else
	{
		print 0;
	}
}

sub show_usage
{
        print <<USAGE;
Usage:
        check_holiday.pl filename date

Where:
        filename is the name of the file that contains University holidays.
        date is the date (MM/DD/YY) that should be checked to see if it's a University holiday.
USAGE

        return;
}

