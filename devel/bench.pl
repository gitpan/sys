use strict;
use warnings;

use Benchmark 'cmpthese';

use English '-no_match_vars';
use sys ();

cmpthese(-1, {

    sys => sub {
        my $v = sys->version;
    },
    sysclass => sub {
        my $v = sys::version;
    },
    English => sub {
        my $v = $PERL_VERSION;
    },
    perlvar => sub {
        my $v = $^V;
    },
});
