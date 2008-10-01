use strict;
use warnings;

package B::Hooks::OP::Check;

use parent qw/DynaLoader/;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;

__END__
=head1 NAME

B::Hooks::OP::Check - Wrap OP check callbacks

=head1 SYNOPSIS

    # include "hook_op_check.h"

    STATIC OP *my_const_check_op (pTHX_ OP *op) {
        /* ... */
        return op;
    }

    void
    setup ()
        CODE:
            hook_op_check (OP_CONST, my_const_check_op);

=head1 BIG FAT WARNING

This is B<ALPHA> software. Things may change. Use at your own risk.

=head1 DESCRIPTION

This module provides a c api for xs modules to hook into the callbacks of
C<PL_check>.

=head1 FUNCTIONS

=head2 void hook_op_check (opcode type, Perl_check_t cb)

Register the callback C<cb> to be called after the C<PL_check> function for
opcodes of the given C<type>.

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This module is free software.

You may distribute this code under the same terms as Perl itself.

=cut
