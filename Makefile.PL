use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-OP-Check';
all_from 'lib/B/Hooks/OP/Check.pm';

requires 'parent';
configure_requires 'ExtUtils::Depends';

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::Check');
$pkg->install('hook_op_check.h');
$pkg->add_xs('Check.xs');
$pkg->add_pm('lib/B/Hooks/OP/Check.pm' => '$(INST_LIB)/B/Hooks/OP/Check.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args($pkg->get_makefile_vars);

WriteAll;
