package Panda::App;
use strict;
use warnings;
use feature 'say';
use Carp;
use Class::Load ':all';
use Class::Accessor::Inherited::XS { inherited => [qw/cfg/], };
use parent 'Class::Accessor::Inherited::XS';
use mro 'c3';

my $is_inited;
my %components;
my %deps;

sub define_component {
    my ( $class, $name, $comp_class, $config ) = @_;
    $components{$name} = $comp_class;
}

sub pre_configure  { }
sub configure      { }
sub post_configure { }
sub setup          { }

sub init {
    my ($class) = @_;
    $class->_load_components();
    $class->pre_configure();
    $class->configure();
    $class->post_configure();
    $class->setup();
}

sub _load_components {
    my $class = shift;
    use Data::Dumper;
    while ( my ( $from, $deps ) = each %deps ) {
        foreach my $dep_name (@$deps) {
            if ( !defined $components{$dep_name} ) {
                confess sprintf( "Component %s required by %s is not defined", $dep_name, $from );
            }
            my $dep_class =  $components{$dep_name};
            $dep_class = 'Panda::App::' . $dep_class unless $dep_class =~ /^\+/;
            load_class($dep_class);
            $class->mixin_add($dep_class);
        }
    }
}

sub mixin_add {
    my ($class,$mixin) = @_;
    # TODO: extract
    no strict 'refs';
    unshift @{"${class}::ISA"},$mixin;     
}

sub mk_class_accessor {
    my ($class,$name,$value) = @_;
    # TODO: extract
    $class->mk_inherited_accessors($name);
    $class->$name($value);
}

sub run { }    # mb?

sub import {
    my $class = shift;
    my ($package) = caller();
    $deps{$package} = [@_];
}

sub register_part {
    my ( $class, $part, $value ) = @_;
    $class->_parts( {} ) unless $class->_parts;
    my $part_name = 'Mini::App::Plugin::' . $value;
    $class->_parts->{$part} = $part_name;
}

1;
