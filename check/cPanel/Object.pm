package cPanel::Object;
use strict 'vars', 'subs';
BEGIN {
    require 5.004;
}

sub import {
    return unless shift eq 'cPanel::Object';
    my $pkg   = caller;

    my $child = !! @{"${pkg}::ISA"};
    eval join "\n",
        "package $pkg;",
        ($child ? () : "\@${pkg}::ISA = 'cPanel::Object';"),
        map {
            defined and !ref and m/^[^\W\d]\w*\z/s or die "Invalid accessor name '$_'";
            my ($sub, $key) = ($_, $_);
            "sub $sub { my (\$self, \$v) = \@_; \$self->{$key} = \$v if defined \$v; \$self->{$key}; }"
        } @_;
    die "Failed to generate $pkg" if $@;
    return 1;
}

sub new {
    my $class = shift;
    bless { @_ }, $class;
}

1;