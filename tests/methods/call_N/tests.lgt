
:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2012/12/06,
		comment is 'Unit tests for the call/1-N built-in method.'
	]).

	throws(call_N_1, error(instantiation_error,logtalk(call(_),This))) :-
		this(This),
		call(_).

	throws(call_N_2, error(instantiation_error,logtalk(call(_,_),This))) :-
		this(This),
		call(_, _).

	throws(call_N_3, error(instantiation_error,logtalk(call(_,_,_),This))) :-
		this(This),
		call(_, _, _).

	throws(call_N_4, error(type_error(callable,1),logtalk(call(1),This))) :-
		this(This),
		Goal = 1,
		call(Goal).

	throws(call_N_5, error(type_error(callable,1),logtalk(call(1,_),This))) :-
		this(This),
		Closure = 1,
		call(Closure, _).

	throws(call_N_6, error(type_error(callable,1),logtalk(call(1,_,_),This))) :-
		this(This),
		Closure = 1,
		call(Closure, _, _).

	succeeds(call_N_7) :-
		call(a(X)),
		X == 1.

	succeeds(call_N_8) :-
		call(a, X),
		X == 1.

	succeeds(call_N_9) :-
		call(b(X, Y)),
		X == 1, Y == one.

	succeeds(call_N_10) :-
		call(b(X), Y),
		X == 1, Y == one.

	succeeds(call_N_11) :-
		call(b, X, Y),
		X == 1, Y == one.

	succeeds(call_N_12) :-
		call(c(X, Y, Z)),
		X == 1, Y == one, Z == 'ONE'.

	succeeds(call_N_13) :-
		call(c(X,Y), Z),
		X == 1, Y == one, Z == 'ONE'.

	succeeds(call_N_14) :-
		call(c(X), Y, Z),
		X == 1, Y == one, Z == 'ONE'.

	succeeds(call_N_15) :-
		call(c, X, Y, Z),
		X == 1, Y == one, Z == 'ONE'.

	fails(call_N_16) :-
		Goal = d(_,_,_,_),
		call(Goal).

	fails(call_N_17) :-
		call(d(_,_,_),_).

	fails(call_N_18) :-
		call(d(_,_),_,_).

	fails(call_N_19) :-
		call(d(_),_,_,_).

	fails(call_N_20) :-
		Goal = e(_,_,_,_,_),
		call(Goal).

	fails(call_N_21) :-
		call(e(_,_,_,_),_).

	fails(call_N_22) :-
		call(e(_,_,_),_,_).

	fails(call_N_23) :-
		call(e(_,_),_,_,_).

	fails(call_N_24) :-
		call(e(_),_,_,_,_).

	% some data for the tests
	:- private(d/4).

	:- private(e/5).
	:- dynamic(e/5).

	a(1).
	b(1, one).
	c(1, one, 'ONE').

:- end_object.
