#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check.h"

typedef OP *(*orig_check_t) (pTHX_ OP *op);

STATIC orig_check_t orig_PL_check[OP_max];
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
		hook_op_check_cb cb;
		MAGIC *mg;
		void *user_data = NULL;
		SV **hook = av_fetch (hooks, i, 0);

		if (!hook || !*hook) {
			continue;
		}

		if ((mg = mg_find (*hook, PERL_MAGIC_ext))) {
			user_data = (void *)mg->mg_ptr;
		}

		cb = INT2PTR (hook_op_check_cb, SvUV (*hook));
		ret = CALL_FPTR (cb)(aTHX_ ret, user_data);
	}

	return ret;
}

void
hook_op_check (opcode type, hook_op_check_cb cb, void *user_data) {
	AV *hooks;
	SV *hook;

	if (!initialized) {
		setup ();
	}

	hooks = check_cbs[type];

	if (!hooks) {
		hooks = newAV ();
		check_cbs[type] = hooks;
		PL_check[type] = check_cb;
	}

	hook = newSVuv (PTR2UV (cb));
	sv_magic (hook, NULL, PERL_MAGIC_ext, (const char *)user_data, 0);
	av_push (hooks, hook);
}

MODULE = B::Hooks::OP::Check  PACKAGE = B::Hooks::OP::Check

PROTOTYPES: DISABLE
