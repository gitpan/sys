# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
use strict;
use warnings;
use English qw( -no_match_vars );
use Test::More;

if ($ENV{TEST_COVERAGE}) {
    plan( skip_all => 'Disabled when testing coverage.' );
}

if ( not $ENV{CLASS_DOT_AUTHOR} ) {
    my $msg = 'Author test.  Set $ENV{CLASS_DOT_AUTHOR} to a true value to
run.';
    plan( skip_all => $msg );
}

eval 'use Test::YAML::Meta';
if ($EVAL_ERROR) {
    plan(skip_all => 'Test::YAML::Meta required for testing META.yml');
}

plan tests => 2;

meta_spec_ok(undef, '1.3');


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround
