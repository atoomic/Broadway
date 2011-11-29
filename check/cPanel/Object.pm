package cPanel::Object;
use strict 'vars', 'subs';
use Carp;
BEGIN {
    require 5.004;
}

sub import {
    return unless shift eq __PACKAGE__;
    my $pkg   = caller;

    @{"${pkg}::ISA"} = 'cPanel::Object';
    map {
		my $method = "${pkg}::$_";
        my $code = _get_accessor_for($_); 
        { no strict 'refs'; *$method = $code; }
    } @_;

    return 1;
}

sub _get_accessor_for {
	my ($key) = @_;
	
	return unless caller eq __PACKAGE__;	
    defined $key and !ref $key and $key =~ /^[^\W\d]\w*\z/s or croak("Invalid accessor name '$key'");

	sub {
		my ($self, $v) = @_;
		$self->{$key} = $v if defined $v;
		$self->{$key};
	};
}

sub new {
    my $class = shift;
    bless { @_ }, $class;
}

1;