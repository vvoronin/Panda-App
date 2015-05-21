package Panda::App::Log::Simple;
use base 'Panda::App::Plugin';

sub setup {
    my $class = shift;
    $class->mk_class_accessor( log =>  Panda::App::Log::Simple::_Impl->new() );
    $class->next::method(@_);
}

package Panda::App::Log::Simple::_Impl;

sub new { bless {},shift; }

sub warn {
        
}

sub debug {
    
}

sub error {
    
}

sub die {
    die @_;
}


1;
