#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use File::Basename;

#basic config
my $basepath = "./";
my $ext = "shp";
my $sharp_bin = "sharpe/sharpe";

#here you can define the files, which should be skipped
my @blacklist = ("simple_availability.shp", "redundant_availability.shp");


my @files = glob($basepath . "*." . $ext);

foreach my $file (@files) {
    if(grep $basepath . $_ eq $file, @blacklist) {
        print "skipping: " . $file . "\n";
    } else {
        print "calling: " . $sharp_bin . " " . $file . "\n";
        my $output = `$basepath$sharp_bin $file`;
        my @lines = split /\n/, $output;

        my($filename, $directories, $suffix) = fileparse($file, ".".$ext);
        open (FILE, ">$directories/$filename.dat");

        foreach my $line (@lines) {
            if($line =~ /\ (\d{1}\.\d{4})\ (e[\+\-]\d{2})\ \ (\d{1}\.\d{4})\ (e[\+\-]\d{2})/) {
                print FILE $1 . $2 . " ". $3 . $4 . "\n";
            }
        }

        print "successfully written to: $directories/$filename.dat\n";
        close (FILE);
    }
}
