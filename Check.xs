#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check.h"

STATIC Perl_check_t orig_PL_check[OP_max];
STATIC AV *check_cbs[OP_max];

#define run_orig_check(type, op) (CALL_FPTR (orig_PL_check[(type)])(aTHX_ op))

STATIC UV initialized = 0;

STATIC void
setup () {
	if (initialized) {
		return;
	}

	initialized = 1;

	Copy (PL_check, orig_PL_check, OP_max, Perl_check_t *);
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

		Perl_check_t cb = (Perl_check_t)SvUV (*hook);
		ret = CALL_FPTR (cb)(aTHX_ ret);
	}

	return ret;
}

void
hook_op_check (opcode type, Perl_check_t cb) {
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
