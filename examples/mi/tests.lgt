%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>    
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.3,
		author is 'Parker Jones and Paulo Moura',
		date is 2012/07/04,
		comment is 'Unit tests for the "mi" example.'
	]).

	:- uses(lgtunit, [op(700, xfx, '=~='), '=~='/2]).

	unit(xyz).
	unit(t).
	unit(xyzt).
	unit(xyz(_, _, _)).
	unit(t(_)).
	unit(xyzt(_, _, _, _)).

	test(mi_1) :-
		xyzt::rotate(1, 2, 3),
		xyzt::translate(4),
		xyzt::xyzt(X, Y, Z, T),
		T == 4, X == 1, Y == 2, Z == 3.

	test(mi_2) :-
		findall(
			Pred-Arity-Object-Functor,
			xyzt::(current_predicate(Functor/Arity), functor(Pred, Functor, Arity), predicate_property(Pred, declared_in(Object))),
			Solutions
		),
		list::msort(Solutions,SolutionsSorted),
		SolutionsSorted = [
			t(_)-1-t-t,
            translate(_)-1-t-translate,
			rotate(_,_,_)-3-xyz-rotate, 
			xyz(_,_,_)-3-xyz-xyz, 
			xyzt(_,_,_,_)-4-xyzt-xyzt
		].

	test(mi_3) :-
		xyzt(2,3,4,7)::distance(Distance),
		Distance =~= 5.385164807134504.

	test(mi_4) :-
		xyzt(2,3,4,7)::time(Time),
		Time == 7.

	test(mi_5) :-
		findall(
			Pred-Arity-Object-Functor,
			xyzt(2,3,4,7)::(current_predicate(Functor/Arity), functor(Pred, Functor, Arity), predicate_property(Pred, declared_in(Object))),
			Solutions
		),
		list::msort(Solutions,SolutionsSorted),
		SolutionsSorted= [distance(_)-1-xyz(_,_,_)-distance, time(_)-1-t(_)-time].

:- end_object.
