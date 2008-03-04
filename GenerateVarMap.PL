# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
use strict;
use warnings;

use devel::Generator::VarMap;

version "0.1";

class "sys" => varmap { qw(
    arg     $_
    version $^V
    accumulator $^A
    compiling $^C
    debugging $^D
    inplace_edit $^I
    perldb $^P
    last_regexp_code_result $^R
    exceptions_being_caught $^S
    basetime $^T
    warnings $^W
    executable_name $^W

    stdout \*STDOUT
    stderr \*STDERR
)};

subclass "re" => varmap { qw(
    matches \%+
)};

subclass "re::match" => varmap { qw(
    last_paren $+
    submatch_result $^N
    match_start \@-
    match_end \@+
)};

subclass "input" => varmap { qw(
    line_number $.
    record_separator $/
)};

subclass "output" => varmap { (qw(
        autoflush $|
        record_separator $\
    ),
    field_separator => q{$,},
)};

subclass "interpolation" => varmap { qw(
    list_separator $"
    subscript_separator $;
)};

subclass "format" => varmap { qw(
    page_number $%
    lines_per_page $=
    lines_left $-
    name $~
    top_name $^
    line_break_characters $:
    format_formfeed $^L
)};

subclass "os" => varmap { qw(
    fd_max $^F
    +name $^O
    child_error $?
    error $!
    errno $!
    extended_error $^E
)};

subclass "eval" => varmap { qw(
    error $@
)};

subclass "process" => varmap { qw(
    pid $$
    uid $<
    euid $>
    gid $(
    egid $)
    name $0
)};

subclass "process::user" => varmap { qw(
    real_id $<
    effective_id $>
)};

subclass "process::group" => varmap { qw(
    real_id $(
    effective_id $)
)};
