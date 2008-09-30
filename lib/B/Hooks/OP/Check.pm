use strict;
use warnings;

package B::Hooks::OP::Check;

use parent qw/DynaLoader/;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;
