#!/usr/bin/env perl

use strict;
use warnings;

use Carp;

BEGIN {
     # uncomment to test pure Perl Mouse
#    $ENV{MOUSE_PUREPERL} = 1;
}

# create object
# + set attribute
# + get attribute

# ...........hash...............

sub hash_nc {
    my $hash = {};
    $hash->{bar} = 32;
    my $x = $hash->{bar};
}

my $hash = {};
sub hash_nc_rw {
    $hash->{bar} = 32;
    my $x = $hash->{bar};
}

# ...........array...............

sub array_nc {
    my $array = [];
    $array->[0] = 32;
    my $x = $array->[0];
}

my $array = [];
sub array_nc_rw {
    $array->[0] = 32;
    my $x = $array->[0];
}

$array->[0] = 32;
sub array_nc_ro {
    my $x = $array->[0];
}


# ...........hash with check...............

sub hash {
	my $hash_check = {};
    my $arg = 32;
    croak "we take an integer" unless defined $arg and $arg =~ /^[+-]?\d+$/;
    $hash_check->{bar} = $arg;
    my $x = $hash_check->{bar};
}

my $hash_check = {};
sub hash_rw {
    my $arg = 32;
    croak "we take an integer" unless defined $arg and $arg =~ /^[+-]?\d+$/;
    $hash_check->{bar} = $arg;
    my $x = $hash_check->{bar};
}

$hash_check->{bar} = 47;
sub hash_ro {
    my $x = $hash_check->{bar};
}

# ...........by hand..............
{
    package Foo::Manual::NoChecks;
    sub new { bless {} => shift }
    sub bar {
        my $self = shift;
        return $self->{bar} unless @_;
        $self->{bar} = shift;
    }
}

sub manual_nc {
	my $manual_nc = Foo::Manual::NoChecks->new;
    $manual_nc->bar(32);
    my $x = $manual_nc->bar;
}

my $manual_nc = Foo::Manual::NoChecks->new;
sub manual_nc_rw {
    $manual_nc->bar(32);
    my $x = $manual_nc->bar;
}

$manual_nc->bar(32);
sub manual_nc_ro {
    my $x = $manual_nc->bar;
}


# ...........by hand with checks..............
{
    package Foo::Manual;
    use Carp;

    sub new { bless {} => shift }
    sub bar {
        my $self = shift;
        if( @_ ) {
            # Simulate argument checking
            my $arg = shift;
            croak "we take an integer" unless defined $arg and $arg =~ /^[+-]?\d+$/;
            $self->{bar} = $arg;
        }
        return $self->{bar};
    }
}
sub manual {
	my $manual = Foo::Manual->new;
    $manual->bar(32);
    my $x = $manual->bar;
}
my $manual = Foo::Manual->new;
sub manual_rw {
    $manual->bar(32);
    my $x = $manual->bar;
}
$manual->bar(32);
sub manual_ro {
    my $x = $manual->bar;
}

#.............Mouse.............
{
    package Foo::Mouse;
    use Mouse;
    has bar => (is => 'rw', isa => "Int");
    __PACKAGE__->meta->make_immutable;
}
sub mouse {
	my $mouse = Foo::Mouse->new;
    $mouse->bar(32);
    my $x = $mouse->bar;
}
my $mouse = Foo::Mouse->new;
sub mouse_rw {
    $mouse->bar(32);
    my $x = $mouse->bar;
}
$mouse->bar(32);
sub mouse_ro {
    my $x = $mouse->bar;
}


#............Moose............
{
    package Foo::Moose;
    use Moose;
    has bar => (is => 'rw', isa => "Int");
    __PACKAGE__->meta->make_immutable;
}
sub moose {
	my $moose = Foo::Moose->new;
    $moose->bar(32);
    my $x = $moose->bar;
}
my $moose = Foo::Moose->new;
sub moose_rw {
    $moose->bar(32);
    my $x = $moose->bar;
}
$moose->bar(32);
sub moose_ro {
    my $x = $moose->bar;
}

#.............Moo...........
{
    package Foo::Moo;
    use Moo;
    has bar => (is => 'rw');
}
sub moo {
	my $moo = Foo::Moo->new;
    $moo->bar(32);
    my $x = $moo->bar;
}
my $moo = Foo::Moo->new;
sub moo_rw {
    $moo->bar(32);
    my $x = $moo->bar;
}
$moo->bar(32);
sub moo_ro {
    my $x = $moo->bar;
}



#........... Moo using Sub::Quote..............
{
    package Foo::Moo::QS;
    use Moo;
    use Sub::Quote;
    has bar => (is => 'rw', isa => quote_sub q{ $_[0] =~ /^[+-]?\d+$/ });
}
sub mooqs {
	my $mooqs = Foo::Moo::QS->new;
    $mooqs->bar(32);
    my $x = $mooqs->bar;
}
my $mooqs = Foo::Moo::QS->new;
sub mooqs_rw {
    $mooqs->bar(32);
    my $x = $mooqs->bar;
}
$mooqs->bar(32);
sub mooqs_ro {
    my $x = $mooqs->bar;
}


#............Object::Tiny..............
{
    package Foo::Object::Tiny;
    use Object::Tiny qw(bar);
}
sub ot {
	my $ot = Foo::Object::Tiny->new( bar => 32 );
#    $ot->bar(24);
    my $x = $ot->bar;
}
my $ot = Foo::Object::Tiny->new( bar => 32 );
sub ot_ro {
    my $x = $ot->bar;
}


#............Object::Tiny::XS..............
{
    package Foo::Object::Tiny::XS;
    use Object::Tiny::XS qw(bar);
}
sub otxs {
	my $otxs = Foo::Object::Tiny::XS->new(bar => 32);
    my $x = $otxs->bar;
}
my $otxs = Foo::Object::Tiny::XS->new(bar => 32);
sub otxs_ro {
    my $x = $otxs->bar();
}

#............ Class Inspector ............

#......... fields ................

{
	package Foo::Fields;
	use fields qw(bar);

	sub new {
	    my Foo::Fields $self = shift;
	    $self = fields::new($self) unless ref $self;
	    return $self;
	}

}

sub fields {
	my Foo::Fields $fields = Foo::Fields->new;
	$fields->{bar} = 42; 
	my $x = $fields->{bar};
}
my Foo::Fields $fields = Foo::Fields->new;
sub fields_rw {
	$fields->{bar} = 42; 
	my $x = $fields->{bar};
}
$fields->{bar} = 42; 
sub fields_ro {
	my $x = $fields->{bar};
}

#..... XSAccessor
{
	package Foo::XSAccessor;
	use Class::XSAccessor
	    replace     => 1,
	    constructor => 'new',
	    accessors => {
	        speed => 'speed',
	    };
}
sub xsaccessor {
	my $xsa_o = Foo::XSAccessor->new(speed => 42);
	$xsa_o->speed(63);
	my $x = $xsa_o->speed;
}

my $xsa_o = Foo::XSAccessor->new(speed => 42);
sub xsaccessor_rw {
	$xsa_o->speed(63);
	my $x = $xsa_o->speed;
}
$xsa_o->speed(63);
sub xsaccessor_ro {
	my $x = $xsa_o->speed;
}

#.... cPanel::Object
{
    package Foo::cPanel::Object;                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                            
    use cPanel::Object qw{ bar };
}

sub cpanel_object {
	my $cpo = Foo::cPanel::Object->new(bar => 42);
	$cpo->bar(43);
	my $x = $cpo->bar;
}

my $cpo = Foo::cPanel::Object->new(bar => 42);
sub cpanel_object_rw {
	$cpo->bar(43);
	my $x = $cpo->bar;
}
$cpo->bar(43);
sub cpanel_object_ro {
	my $x = $cpo->bar;
}

#-------

use Benchmark 'timethese';
use Data::Dumper;
use v5.10;

print "Testing Perl $], Moose $Moose::VERSION, Mouse $Mouse::VERSION, Moo $Moo::VERSION [ MOUSE PP $ENV{MOUSE_PUREPERL} ] \n";
say "# Create + Read + Write only :";
my $time = -10;
my $results = timethese(
    $time,
    {
        Moose                   => \&moose,
        Mouse                   => \&mouse,
        manual                  => \&manual,
        "manual, no check"      => \&manual_nc,
        'hash, no check'        => \&hash_nc,
        'array, no check'        => \&array_nc,
        hash                    => \&hash,
        Moo                     => \&moo,
        "Moo w/quote_sub"       => \&mooqs,
        "Object::Tiny"          => \&ot,
        "Object::Tiny::XS"      => \&otxs,
        "fields"				=> \&fields,
        "Class::XSAccessor"		=> \&xsaccessor,
        "cPanel::Object"		=> \&cpanel_object,
    }
);
display($results);

say "# Read + Write only :";
$results = timethese(
    $time,
    {
        Moose                   => \&moose_rw,
        Mouse                   => \&mouse_rw,
        manual                  => \&manual_rw,
        "manual, no check"      => \&manual_nc_rw,
        'hash, no check'        => \&hash_nc_rw,
        'array, no check'       => \&array_nc_rw,
        hash                    => \&hash_rw,
        Moo                     => \&moo_rw,
        "Moo w/quote_sub"       => \&mooqs_rw,
        #"Object::Tiny"          => \&ot_rw,
        #"Object::Tiny::XS"      => \&otxs_rw,
        "fields"				=> \&fields_rw,
        "Class::XSAccessor"		=> \&xsaccessor_rw,
        "cPanel::Object"		=> \&cpanel_object_rw,
    }
);
display($results);

say "# Read only :";
$results = timethese(
    $time,
    {
        Moose                   => \&moose_ro,
        Mouse                   => \&mouse_ro,
        manual                  => \&manual_ro,
        "manual, no check"      => \&manual_nc_ro,
        #'hash, no check'        => \&hash_nc_ro,
        'array, no check'       => \&array_nc_ro,
        hash                    => \&hash_ro,
        Moo                     => \&moo_ro,
        "Moo w/quote_sub"       => \&mooqs_ro,
        "Object::Tiny"          => \&ot_ro,
        "Object::Tiny::XS"      => \&otxs_ro,
        "fields"				=> \&fields_ro,
        "Class::XSAccessor"		=> \&xsaccessor_ro,
        "cPanel::Object"		=> \&cpanel_object_ro,
    }
);
display($results);



sub display {
	my $results = shift;
	
	my %h = map { my $k = $_; my $a = $results->{$k}; $k => $a->[5] / $a->[1]  } keys %$results;
	
	my @methods = sort { $h{$b} <=> $h{$a}} keys %h;
	foreach my $method (@methods) {
		say $method, "\t\t", ': @ ', sprintf('%02d', $h{$method}), ' / sec';
	}
}

__END__
# Create + Read + Write only :
array, no check		: @ 1997467 / sec
hash, no check		: @ 1542022 / sec
Object::Tiny::XS		: @ 742717 / sec
Class::XSAccessor		: @ 676957 / sec
hash		: @ 607349 / sec
Mouse		: @ 504122 / sec
Object::Tiny		: @ 490119 / sec
manual, no check		: @ 405734 / sec
Moo		: @ 330829 / sec
cPanel::Object		: @ 324587 / sec
manual		: @ 234056 / sec
Moo w/quote_sub		: @ 163839 / sec
Moose		: @ 117027 / sec
fields		: @ 86778 / sec

# Read + Write only :
array, no check		: @ 4411075 / sec
hash, no check		: @ 3814984 / sec
fields		: @ 3744914 / sec
Moo		: @ 2940717 / sec
Class::XSAccessor		: @ 2780314 / sec
Mouse		: @ 2525239 / sec
hash		: @ 1286219 / sec
manual, no check		: @ 901870 / sec
cPanel::Object		: @ 668084 / sec
manual		: @ 428740 / sec
Moose		: @ 390980 / sec
Moo w/quote_sub		: @ 344925 / sec

# Read only :
array, no check		: @ 14160456 / sec
fields		: @ 8340944 / sec
hash		: @ 8222589 / sec
Class::XSAccessor		: @ 7267358 / sec
Moo		: @ 6990505 / sec
Object::Tiny::XS		: @ 6616615 / sec
Mouse		: @ 5173894 / sec
Object::Tiny		: @ 2143657 / sec
Moo w/quote_sub		: @ 2085235 / sec
manual, no check		: @ 1854791 / sec
Moose		: @ 1747625 / sec
cPanel::Object		: @ 1392971 / sec
manual		: @ 1323322 / sec