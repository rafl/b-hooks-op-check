#ifndef __HOOK_OP_CHECK_H__
#define __HOOK_OP_CHECK_H__

#include "perl.h"

typedef OP *(*hook_op_check_cb) (pTHX_ OP *);

PERL_XS_EXPORT_C void hook_op_check (opcode type, hook_op_check_cb cb);

#endif
