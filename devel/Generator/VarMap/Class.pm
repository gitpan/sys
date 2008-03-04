# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
package devel::Generator::VarMap::Class;

use Class::Dot2;

has name            => (isa => "String");
has vars            => (isa => "Array");
has composites      => (isa => "Array");
has has_eager_vars  => (isa => "Bool", default => 0);
has is_root         => (isa => "Bool", default => 0);

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround

__END__
