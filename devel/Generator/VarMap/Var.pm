# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
package devel::Generator::VarMap::Var;

use Class::Dot2;

has name        => (isa => "String");
has value       => (isa => "String");
has is_eager    => (isa => "Bool");
has type        => (isa => "String");

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround

__END__
