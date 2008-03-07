# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
use strict;
use warnings;
require 5.00600;

use Carp qw(carp croak);
use English qw(-no_match_vars);

use inc::Module::Install;

my $THIS_VERSION = '0.2';

name                'sys';
author              'Ask Solem <asksh@cpan.org>';
version             $THIS_VERSION;
license             'bsd';
abstract            'The Object Oriented English.pm';
all_from            'lib/sys.pod';

requires            'version' => 0;
requires            'Class::Dot' => 2.0;

# Debian stable doesn't have Test::Exception 0.22 yet, but it's about time _you should_.
build_requires      'Test::Simple'     => 0.42;
build_requires      'Test::Exception'  => 0.22;

perl_version        5.006_000;

no_index            directory => 'examples';

no_index            directory => 'devel';

distribution_type   'module';

tests('t/*.t t/*/*.t t/*/*/*.t');

        
package ExtUtils::MakeMaker::_version;
    use strict;
    use warnings;
    
    use Carp;
    use English qw(-no_match_vars);

    eval 'use version qw(qv)';

package main;

    auto_install;
    sign();
    WriteAll;


