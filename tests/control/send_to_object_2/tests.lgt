
:- object(send_to_object_test_object(_)).

	:- public(p/1).
	p(X) :-
		parameter(1, X).

	:- public(q/2).
	:- protected(r/3).
	:- private(s/4).

:- end_object.


% for testing proxies:
send_to_object_test_object(2).


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2012/12/05,
		comment is 'Unit tests for the (::)/2 built-in control construct.'
	]).

	throws(send_to_object_2_1, error(instantiation_error, logtalk(_::true,user))) :-
		{_::true}.

	throws(send_to_object_2_2, error(type_error(object_identifier,1), logtalk(1::true,user))) :-
		{1::true}.

	throws(send_to_object_2_3, error(instantiation_error, logtalk(logtalk::_,user))) :-
		{logtalk::_}.

	throws(send_to_object_2_4, error(type_error(callable,1), logtalk(logtalk::1,user))) :-
		{logtalk::1}.

	throws(send_to_object_2_5, error(existence_error(object,foo), logtalk(foo::true,user))) :-
		{foo::true}.

	throws(send_to_object_2_6, error(existence_error(predicate_declaration,foo/0), logtalk(logtalk::foo,user))) :-
		{logtalk::foo}.

	throws(send_to_object_2_7, error(permission_error(access,protected_predicate,r/3), logtalk(send_to_object_test_object(_)::r(_,_,_),user))) :-
		{send_to_object_test_object(_)::r(_,_,_)}.

	throws(send_to_object_2_8, error(permission_error(access, private_predicate,s/4), logtalk(send_to_object_test_object(_)::s(_,_,_,_),user))) :-
		{send_to_object_test_object(_)::s(_,_,_,_)}.

	throws(send_to_object_2_9, error(instantiation_error, logtalk({_}::true,user))) :-
		{{_}::true}.

	throws(send_to_object_2_10, error(type_error(object_identifier,1), logtalk({1}::true,user))) :-
		{{1}::true}.

	throws(send_to_object_2_11, error(existence_error(procedure,foo/0), logtalk({foo}::true,user))) :-
		{{foo}::true}.

	succeeds(send_to_object_2_12) :-
		send_to_object_test_object(1)::p(X),
		X == 1.

	succeeds(send_to_object_2_13) :-
		{send_to_object_test_object(_)}::p(X),
		X == 2.

	fails(send_to_object_2_14) :-
		send_to_object_test_object(_)::q(_, _).

:- end_object.
