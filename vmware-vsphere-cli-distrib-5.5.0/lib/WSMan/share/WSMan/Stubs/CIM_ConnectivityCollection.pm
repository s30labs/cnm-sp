package CIM_ConnectivityCollection;
use WSMan::Stubs::Initializable;
use WSMan::Stubs::CIM_SystemSpecificCollection;
use strict;


@CIM_ConnectivityCollection::ISA = qw(_Initializable CIM_SystemSpecificCollection);


#===============================================================================
#			INITIALIZER
#===============================================================================

sub _init{
    my ($self, %args) = @_;
    $self->CIM_SystemSpecificCollection::_init();
    unless(exists $self->{invokableMethods}){
        $self->{invokableMethods} = {};
    }
    unless(exists $self->{id_keys}){
        $self->{id_keys} = ();
    }
    $self->{ConnectivityStatus} = undef;
    $self->{epr_name} = undef;  
    @{$self->{id_keys}} = keys %{{ map { $_ => 1 } @{$self->{id_keys}} }};
    if(keys %args){
        $self->_subinit(%args);
    }
}


#===============================================================================


#===============================================================================
#            ConnectivityStatus accessor method.
#===============================================================================

sub ConnectivityStatus{
    my ($self, $newval) = @_;
    $self->{ConnectivityStatus} = $newval if @_ > 1;
    return $self->{ConnectivityStatus};
}
#===============================================================================


#===============================================================================
#           epr_name accessor method.
#===============================================================================

sub epr_name{
    my ($self, $newval) = @_;
    $self->{epr_name} = $newval if @_ > 1;
    return $self->{epr_name};
}
#===============================================================================


1;
