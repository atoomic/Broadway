#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  coerce.pl
#
#        USAGE:  ./coerce.pl  
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
#      CREATED:  11/28/2011 12:21:43
#     REVISION:  ---

package cPanel::Types::Date;
use Moose::Util::TypeConstraints;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::DateParse;

use Carp;

#subtype 'Dummy:DateTime' => as class_type('DateTime');

subtype 'cPanel:Day' => as 'DateTime';
coerce  'cPanel:Day' => from 'Str' => via {
    /^\d{4}\d{2}\d{2}$/ or croak "Unable to coerce";

    my $dt = DateTime::Format::DateParse->parse_datetime($_);
    $dt->set_formatter(DateTime::Format::Strptime->new(pattern => '%Y%m%d'));
    $dt->set_time_zone('local');
    return $dt;
};

1;

package Test::Coerce;
use Moose;
#use cPanel::Types::Date;

has day => (
    is  => 'rw',
    isa => 'cPanel:Day',
    coerce => 1
);

1;
package main;
use Test::More;
use v5.10;
my $d1 = Test::Coerce->new(day => DateTime->now());
my $d2 = Test::Coerce->new(day => '20111130');
isa_ok $d2->day, 'DateTime', 'day is coerced to a DateTime object';
say $d2->day;


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


