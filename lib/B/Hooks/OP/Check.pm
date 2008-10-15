use strict;
use warnings;

package B::Hooks::OP::Check;

use parent qw/DynaLoader/;

our $VERSION = '0.03';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;

__END__
=head1 NAME

B::Hooks::OP::Check - Wrap OP check callbacks

=head1 SYNOPSIS

    # include "hook_op_check.h"

    STATIC OP *my_const_check_op (pTHX_ OP *op, void *user_data) {
        /* ... */
        return op;
    }

    void
    setup ()
        CODE:
            hook_op_check (OP_CONST, my_const_check_op, NULL);

=head1 BIG FAT WARNING

This is B<ALPHA> software. Things may change. Use at your own risk.

=head1 DESCRIPTION

This module provides a c api for XS modules to hook into the callbacks of
C<PL_check>.

L<ExtUtils::Depends> is used to export all functions for other XS modules to
use. Include the following in your Makefile.PL:

    my $pkg = ExtUtils::Depends->new('Your::XSModule', 'B::Hooks::OP::Check');
    WriteMakefile(
        ... # your normal makefile flags
        $pkg->get_makefile_vars,
    );

Your XS module can now include C<hook_op_check.h>.

=head1 TYPES

=head2 typedef OP *(*hook_op_check_cb) (pTHX_ OP *, void *);

Type that callbacks need to implement.

=head1 FUNCTIONS

=head2 void hook_op_check (opcode type, hook_op_check_cb cb, void *user_data)

Register the callback C<cb> to be called after the C<PL_check> function for
opcodes of the given C<type>.

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008 Florian Ragwitz

This module is free software.

You may distribute this code under the same terms as Perl itself.

=cut
