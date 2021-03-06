package LSIESG_SCSIProtocolController;
use WSMan::Stubs::Initializable;
use WSMan::Stubs::CIM_SCSIProtocolController;
use strict;


@LSIESG_SCSIProtocolController::ISA = qw(_Initializable CIM_SCSIProtocolController);


#===============================================================================
#			INITIALIZER
#===============================================================================

sub _init{
    my ($self, %args) = @_;
    $self->CIM_SCSIProtocolController::_init();
    unless(exists $self->{invokableMethods}){
        $self->{invokableMethods} = {};
    }
    unless(exists $self->{id_keys}){
        $self->{id_keys} = ();
    }
    $self->{SCSIProtocolEndpoint_Name} = undef;
    $self->{epr_name} = undef;  
    @{$self->{id_keys}} = keys %{{ map { $_ => 1 } @{$self->{id_keys}} }};
    if(keys %args){
        $self->_subinit(%args);
    }
}


#===============================================================================


#===============================================================================
#            SCSIProtocolEndpoint_Name accessor method.
#===============================================================================

sub SCSIProtocolEndpoint_Name{
    my ($self, $newval) = @_;
    $self->{SCSIProtocolEndpoint_Name} = $newval if @_ > 1;
    return $self->{SCSIProtocolEndpoint_Name};
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
