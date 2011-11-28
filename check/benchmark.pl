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


#.............Moo...........
{
    package Foo::Moo;
    use Moo;
    has bar => (is => 'rw', isa => sub { $_[0] =~ /^[+-]?\d+$/ });
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


#............Object::Tiny..............
{
    package Foo::Object::Tiny;
    use Object::Tiny qw(bar);
}
sub ot {
	my $ot = Foo::Object::Tiny->new;#( bar => 32 );
    $ot->bar(24);
    my $x = $ot->bar;
}
	my $ot = Foo::Object::Tiny->new;#( bar => 32 );
sub ot_rw {
    $ot->bar(24);
    my $x = $ot->bar;
}


#............Object::Tiny::XS..............
{
    package Foo::Object::Tiny::XS;
    use Object::Tiny::XS qw(bar);
    #__PACKAGE__->mk_accessors;
}
sub otxs {
	my $otxs = Foo::Object::Tiny::XS->new(bar => 32);
    my $x = $otxs->bar;
}
	my $otxs = Foo::Object::Tiny::XS->new(bar => 32);
sub otxs_rw {
	#$otxs->bar(51);
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
	my Foo::Fields $obj = Foo::Fields->new;
	$obj->{bar} = 42; 
	my $x = $obj->{bar};
}
my Foo::Fields $obj = Foo::Fields->new;
sub fields_rw {
	$obj->{bar} = 42; 
	my $x = $obj->{bar};
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
        hash                    => \&hash,
        Moo                     => \&moo,
        "Moo w/quote_sub"       => \&mooqs,
        "Object::Tiny"          => \&ot,
        "Object::Tiny::XS"      => \&otxs,
        "fields"				=> \&fields,
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
        hash                    => \&hash_rw,
        Moo                     => \&moo_rw,
        "Moo w/quote_sub"       => \&mooqs_rw,
        "Object::Tiny"          => \&ot_rw,
        "Object::Tiny::XS"      => \&otxs_rw,
        "fields"				=> \&fields_rw,
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
Testing Perl 5.012002, Moose 1.24, Mouse 0.91, Moo 0.009007, Object::Tiny 1.08, Object::Tiny::XS 1.01
Benchmark: timing 6000000 iterations of Moo, Moo w/quote_sub, Moose, Mouse, Object::Tiny, Object::Tiny::XS, hash, manual, manual with no checks...
Object::Tiny::XS:  1 secs ( 1.20 usr + -0.01 sys =  1.19 CPU) @ 5042016.81/s
hash, no check  :  3 secs ( 1.86 usr +  0.01 sys =  1.87 CPU) @ 3208556.15/s
Mouse           :  3 secs ( 3.66 usr +  0.00 sys =  3.66 CPU) @ 1639344.26/s
Object::Tiny    :  3 secs ( 3.80 usr +  0.00 sys =  3.80 CPU) @ 1578947.37/s
hash            :  5 secs ( 5.53 usr +  0.01 sys =  5.54 CPU) @ 1083032.49/s
manual, no check:  9 secs ( 9.11 usr +  0.02 sys =  9.13 CPU) @  657174.15/s
Moo             : 17 secs (17.37 usr +  0.03 sys = 17.40 CPU) @  344827.59/s
manual          : 17 secs (17.89 usr +  0.02 sys = 17.91 CPU) @  335008.38/s
Mouse no XS     : 20 secs (20.50 usr +  0.03 sys = 20.53 CPU) @  292255.24/s
Moose           : 21 secs (21.33 usr +  0.03 sys = 21.36 CPU) @  280898.88/s
Moo w/quote_sub : 23 secs (23.07 usr +  0.04 sys = 23.11 CPU) @  259627.87/s
