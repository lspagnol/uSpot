#!/usr/bin/perl

$now = time();
use Time::Local;

open(LEASE, "/var/lib/dhcp/dhcpd.leases");
foreach $line (<LEASE>) {
        chomp($line);
        $data = 1 if $line =~ /^lease /;
        $data = 0 if $line =~ /^}/;

        if ($data) {
                if ($line =~ /^lease/) {
                        $ip = (split(" ", $line))[1];
                } elsif ($line =~ /^  starts/) {
                        $start = (split(" ", $line))[2];
                } elsif ($line =~ /^  ends/) {
                        $stop = (split(" ", $line))[2];
                } elsif ($line =~ /^  hardware ethernet/) {
                        $mac = (split(" ", $line))[2];
                        $mac =~ s/;//;
                } elsif ($line =~ /^  client-hostname/) {
                        $client = (split(/\"/, $line))[1];
                }
        } else {
                print "$mac $ip\n" if $stop >= $now;
                $ip = ""; $start = ""; $stop = ""; $mac = ""; $client = "";
        }
}
close(LEASE);
