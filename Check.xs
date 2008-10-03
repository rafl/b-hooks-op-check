#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check.h"

STATIC hook_op_check_cb orig_PL_check[OP_max];
STATIC AV *check_cbs[OP_max];

#define run_orig_check(type, op) (CALL_FPTR (orig_PL_check[(type)])(aTHX_ op))

STATIC UV initialized = 0;

STATIC void
setup () {
	if (initialized) {
		return;
	}

	initialized = 1;

	Copy (PL_check, orig_PL_check, OP_max, hook_op_check_cb);
	Zero (check_cbs, OP_max, AV *);
}

STATIC OP *
check_cb (pTHX_ OP *op) {
	I32 i;
	AV *hooks = check_cbs[op->op_type];
	OP *ret = run_orig_check (op->op_type, op);

	if (!hooks) {
		return ret;
	}

	for (i = 0; i <= av_len (hooks); i++) {
		SV **hook = av_fetch (hooks, i, 0);

		if (!hook || !*hook) {
			continue;
		}

		hook_op_check_cb cb = (hook_op_check_cb)SvUV (*hook);
		ret = CALL_FPTR (cb)(aTHX_ ret);
	}

	return ret;
}

void
hook_op_check (opcode type, hook_op_check_cb cb) {
	AV *hooks;

	if (!initialized) {
		setup ();
	}

	hooks = check_cbs[type];

	if (!hooks) {
		hooks = newAV ();
		check_cbs[type] = hooks;
		PL_check[type] = check_cb;
	}

	av_push (hooks, newSVuv ((UV)cb));
}

MODULE = B::Hooks::OP::Check  PACKAGE = B::Hooks::OP::Check

PROTOTYPES: DISABLE
