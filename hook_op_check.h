#ifndef __HOOK_OP_CHECK_H__
#define __HOOK_OP_CHECK_H__

#include "perl.h"

PERL_XS_EXPORT_C void hook_op_check_setup ();
PERL_XS_EXPORT_C void hook_op_check (opcode type, Perl_check_t cb);

#endif
