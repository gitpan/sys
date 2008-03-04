# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
package devel::Generator::VarMap;

use Cwd;
use Carp 'confess';
use English '-no_match_vars';
use Path::Class;
use Template;
use List::Util 'first';
use Class::Dot2;
use Class::Dot::Meta::Method qw(
    install_sub_from_class
);
use devel::Generator::VarMap::Class;
use devel::Generator::VarMap::Var;
use devel::Generator::VarMap::CompositeAttr;

my @ALWAYS_EXPORT = qw(
    varmap
    class
    subclass
    version
);

my $DEFAULT_TEMPLATE = file("class_template.tt");
my $LIBDIR           = dir("lib");

my $DEFAULT_TT_CONFIG = {
    INCLUDE_PATH => getcwd(),
    INTERPOLATE  => 0,
    PRE_CHOMP    => 0,
    POST_CHOMP   => 1,
    EVAL_PERL    => 0,
};

my $DEFAULT_FILE_MODE = oct 644;

my $TOP_LEVEL_CLASS;
my $CLASSES = { };
my $THIS_VERSION = 1.0;

my $OUTPUT_EXTENSION = ".pm";

my $PERL_TYPE_MAP = {

    "\$" => "SCALARREF",
    "\%" => "HASHREF",
    "\@" => "ARRAYREF",
    "\*" => "GLOBREF",
    q{$} => "SCALAR",
    q{%} => "HASH",
    q{@} => "ARRAY",
    q{*} => "GLOB",
    q{int(} => "INTSCALAR",

};

# Da sugah!
sub varmap (&;);
sub class;
sub subclass;
sub version;

sub import {
    my ($this_class, @args) = @_;
    my $caller_class = caller 0;

    for my $sub_name (@ALWAYS_EXPORT) {
        install_sub_from_class(
            ($this_class, $sub_name) => $caller_class
        );
    }

    return;
} 

sub varmap (&;) {
    my ($code_ref) = @_;
    return $code_ref;
}

sub class {
    my ($class_name, $class_data) = @_;

    $TOP_LEVEL_CLASS = $class_name;
    
    return __create_class($class_name, $class_data, {
        is_root => 1
    });
}

sub subclass {
    my ($subclass_name, $class_data) = @_;

    my $class_name = join q{::} => ($TOP_LEVEL_CLASS, $subclass_name);

    return __create_class($class_name, $class_data);
}

sub __create_class {
    my ($class_name, $class_data, $options_ref) = @_;
    $options_ref ||= { };

    my %vars = $class_data->();

    my $new_class = devel::Generator::VarMap::Class->new({
        name    => $class_name,
        is_root => $options_ref->{is_root},
    });

    my $class_vars = $new_class->vars;

    my $_handle_var_def = sub {
        my ($var_name, $var_value) = @_;

        my $new_var = devel::Generator::VarMap::Var->new();

        my $var_type = "lazy";
        if ($var_name =~ s{^\+}{}xms) {
            $var_type = "eager";
            $new_class->set_has_eager_vars( $new_class->has_eager_vars + 1 );
            $new_var->set_is_eager(1);
        }
        elsif ($var_name =~ s{^\-}{}xms) {
            $var_type = "lazy";
        }

        $new_var->set_name($var_name);
        $new_var->set_value($var_value);
        $new_var->set_type(__varstr_to_perl_type($var_value));

        return $new_var;
    };

    push @{ $class_vars }, map {
        $_handle_var_def->($_, $vars{$_})
    } keys %vars;

    $CLASSES->{$class_name} = $new_class;
    
    return;
}

sub version {
    my ($version) = @_;
    return $THIS_VERSION = $version;
}


sub WRITE_ALL_CLASSES {
    my ($options_ref) = @_;

    return map { render_class($_, $options_ref) } values %{ $CLASSES };
}

sub render_class {
    my ($class, $options_ref) = @_;

    push @{ $class->composites },
        find_subclasses_for_class($class, $options_ref);
    
    render_class_module($class, $options_ref);

    return;
}

    
sub find_subclasses_for_class {
    my ($class) = @_;
    my $name    = $class->name;

    return map { composite_subclass($_) }
        grep { $_ =~ m/^$name\:\:/ } keys %{ $CLASSES };
}

sub composite_subclass {
    my ($subclass) = @_;

    return devel::Generator::VarMap::CompositeAttr->new({
        name    => [split q{::}, $subclass]->[-1],
        class   => $subclass,
    });
}

sub render_class_module {
    my ($class, $options_ref) = @_;
    $options_ref ||= { };

    my $file_mode = defined $options_ref->{mode} ? $options_ref->{mode}
                                                 : $DEFAULT_FILE_MODE;
    my $tt_config = defined $options_ref->{tt}   ? $options_ref->{tt}
                                                 : $DEFAULT_TT_CONFIG;

    my $template = exists $options_ref->{template}
        ? file( $options_ref->{template} )
        : $DEFAULT_TEMPLATE;

    my $stash = {
        class           => $class,
        options         => $options_ref,
        render_date     => scalar localtime,
        current_version => $THIS_VERSION,
        render_program  => $PROGRAM_NAME,
    };

    my $view = Template->new($tt_config);

    my $module_filename = $class->name . $OUTPUT_EXTENSION;
    my $output_filename = $LIBDIR->file( split m{::}, $module_filename );

    warn sprintf(">>> Rendering module (%s) for class (%s) into dir (%s)\n",
        $output_filename, $class->name, $output_filename->dir);

    if (! $output_filename->dir->stat) {
        $output_filename->dir->mkpath(1)
            || confess sprintf("Couldn't create directory (%s): %s",
                $output_filename->dir, $OS_ERROR);  
    }

    my $output_fh = $output_filename->open("w", $file_mode)
        or confess "Couldn't open $output_filename for writing: $OS_ERROR";
    
    $view->process($template->stringify, $stash, $output_fh)
        || confess $view->error();

    $output_fh->close();

    return;
}

sub __varstr_to_perl_type {
    my ($varstr) = @_;

    my $which = first { $varstr =~ m{\Q$_\E}xms } keys %{ $PERL_TYPE_MAP };
    return if not defined $which;

    return $PERL_TYPE_MAP->{$which};
}

END {
    WRITE_ALL_CLASSES;
}

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround

__END__
