# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
package devel::Generator::VarMap::Method;

use Class::Dot2;

has name        => (isa => "String");
has prototype   => (isa => "String");
has signature   => (isa => "String");
has body        => (isa => "String");

sub prototype {
    my ($self) = @_;

    my $prototype = $self->__getattr__('prototype');

    return '(' . $prototype . ')';
}

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround

__END__
