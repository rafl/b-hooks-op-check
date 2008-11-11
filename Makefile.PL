use strict;
use warnings;

require 5.008001;

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

makemaker_args(
    $pkg->get_makefile_vars,
    FUNCLIST => [qw/hook_op_check hook_op_check_remove/],
    DL_FUNCS => { 'B::Hooks::OP::Check' => [] },
    dist => { PREOP => 'pod2text lib/B/Hooks/OP/Check.pm > $(DISTVNAME)/README' },
);

extra_tests;

WriteAll;
