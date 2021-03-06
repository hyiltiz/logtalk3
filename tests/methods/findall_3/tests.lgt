
:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2012/12/26,
		comment is 'Unit tests for the findall/3 built-in method.'
	]).

	test(findall_3_1) :-
		findall(X, a(X, _), L),
		L == [1, 2, 3, 4].

	test(findall_3_2) :-
		findall(Y-L, findall(X, a(X, Y), L), LL),
		LL = [_-[1,2,3,4]].

	a(1, odd).
	a(2, even).
	a(3, odd).
	a(4, even).

:- end_object.
