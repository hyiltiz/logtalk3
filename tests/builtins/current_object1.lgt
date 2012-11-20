
:- object(current_object1,
	extends(lgtunit)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2012/11/19,
		comment is 'Unit tests for the current_object/1 built-in predicate.'
	]).

	:- discontiguous(succeeds/1).
	:- discontiguous(fails/1).
	:- discontiguous(throws/2).

	throws(current_object_1_1, error(type_error(object_identifier, 1), logtalk(current_object(1), _))) :-
		current_object(1).

	succeeds(current_object_1_2) :-
		current_object(logtalk).

	fails(current_object_1_3) :-
		current_object(non_exisiting_object).

	% built-in entitiy tests

	succeeds(user) :-
		current_object(user),
		object_property(user, final),
		object_property(user, static),
		(	current_logtalk_flag(threads, supported) ->
			object_property(user, threaded)
		;	true
		).

	succeeds(logtalk) :-
		current_object(logtalk),
		object_property(logtalk, final),
		object_property(logtalk, static),
		(	current_logtalk_flag(threads, supported) ->
			object_property(logtalk, threaded)
		;	true
		),
		implements_protocol(logtalk, expanding),
		implements_protocol(logtalk, monitoring).

:- end_object.