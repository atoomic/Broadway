#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  xs-accessor.pl
#
#        USAGE:  ./xs-accessor.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Nicolas Rochelemagne (NR), nicolas.rochelemagne@cpanel.net
#      COMPANY:  cPanel, Inc
#      VERSION:  1.0
#      CREATED:  11/29/2011 08:55:05
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use v5.10;

package SuperFast;
use Class::XSAccessor
    replace     => 1,
    constructor => 'new',
#    getters     => {
#        get_speed => 'speed',
#    },
#    setters => {
#        set_speed => 'speed',
#    },
    accessors => {
        speed => 'speed',
    },
    predicates => {
        has_speed => 'speed',
    };

package main;
use Test::More;
my $o = SuperFast->new(speed => 'flash');
#say $o->get_speed;

say $o->speed;
$o->speed('max') and say $o->speed;



=pod
use Data::Printer colored => 1,  caller_info => 1, multiline => 0, sort_keys => 1, alias => 'dp';
# add colors to Data::Dumper with Data::Printer https://metacpan.org/module/Data::Printer
=cut

=pod
use GetOpt::Compact::WithCmd;
# options in a script: GetOpt::Compact::WithCmd https://metacpan.org/module/Getopt::Compact::WithCmd
# alternative with App::Rad, Getopt::Euclid
=cut

=pod

- tie hash or array to disk : DBM::Deep https://metacpan.org/module/DBM::Deep

- store data : Storable 
read flood control :
http://www.perl.com/pub/2004/11/11/floodcontrol.html

- list manipulation : List::Util

- iteration : Object::Iterate

- Logging : Log::Log4perl, Log::Dispatchb
Log::Log4perl::init_and_watch('root-logger.conf'); # idea is to provide a namespace in the config foreach module

my $logger = Log::Log4perl->new('CurrentModule');
$logger->error("here is an error");
# debug, info, warn, error, fatal
#
# # config sample
# log4perl.rootLogger = ERROR, myFILE, Screen
# log4perl.category.Module1 = DEBUG, myFILE
# log4perl.category.Module1.Module2 = FATAL, Screen

=cut

=pod
### Perl Composer

sub composer {
    my (@subs) = @_;

    sub {
        my $s = shift;
        foreach my $sub (@subs) {
            $s = $sub->($s);
        }
        return $s;
    };
}
# use the composer
my $a_b_c = composer(\&a, \&b, \&c);
$string = $a_b_c->($string);

=cut


