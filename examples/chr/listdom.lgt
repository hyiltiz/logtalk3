%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>    
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Slim Abdennadher, Thom Fruehwirth, LMU, July 1998
% Finite (enumeration, list) domain solver over integers
%
% * ported to hProlog by Tom Schrijvers, K.U.Leuven


% :- module(listdom,[]).

:- use_module( library(chr)).

:- use_module( library(lists)).


%% for domain constraints
:- op( 700,xfx,'::').
:- op( 600,xfx,'..').

%% for inequality constraints
:- op( 700,xfx,lt).
:- op( 700,xfx,le).
:- op( 700,xfx,ne).

%% for domain constraints
?- op( 700,xfx,'::').
?- op( 600,xfx,'..').

%% for inequality constraints
?- op( 700,xfx,lt).
?- op( 700,xfx,le).
?- op( 700,xfx,ne).

:- constraints (::)/2, (le)/2, (lt)/2, (ne)/2, add/3, mult/3.
%% X::Dom - X must be element of the finite list domain Dom

%% special cases
X::[] <=> fail.				
%%X::[Y] <=> X=Y.
%%X::[A|L] <=> ground(X) | (member(X,[A|L]) -> true).

%% intersection of domains for the same variable
X::L1, X::L2 <=> is_list(L1), is_list(L2) | 
intersection(L1,L2,L) , X::L.

X::L, X::Min..Max <=> is_list(L) |  
remove_lower(Min,L,L1), remove_higher(Max,L1,L2), 
X::L2.


%% interaction with inequalities

X le Y, X::L1,  Y::L2 ==> is_list(L1),is_list(L2),  
min_list(L1,MinX), min_list(L2,MinY), MinX > MinY | 
max_list(L2,MaxY), Y::MinX..MaxY.
X le Y, X::L1,  Y::L2 ==> is_list(L1),is_list(L2),  
max_list(L1,MaxX), max_list(L2,MaxY), MaxX > MaxY  | 
min_list(L1,MinX), X::MinX..MaxY.

X lt Y, X::L1,  Y::L2 ==> is_list(L1), is_list(L2), 
max_list(L1,MaxX), max_list(L2,MaxY), 
MaxY1 is MaxY - 1, MaxY1 < MaxX |
min_list(L1,MinX), X::MinX..MaxY1.
X lt Y, X::L1,  Y::L2 ==> is_list(L1), is_list(L2), 
min_list(L1,MinX), min_list(L2,MinY),  
MinX1 is MinX + 1, MinX1 > MinY |
max_list(L2,MaxY), Y :: MinX1..MaxY.

X ne Y \  Y::D <=> ground(X), is_list(D), member(X,D) | select(X,D,D1), Y::D1.
Y ne X \  Y::D <=> ground(X), is_list(D), member(X,D) | select(X,D,D1), Y::D1.
Y::D \ X ne Y <=>  ground(X), is_list(D), \+ member(X,D) | true.
Y::D \ Y ne X <=>  ground(X), is_list(D), \+ member(X,D) | true.


%% interaction with addition
%% no backpropagation yet!

add(X,Y,Z), X::L1, Y::L2 ==> is_list(L1), is_list(L2) | 
all_addition(L1,L2,L3), Z::L3.

%% interaction with multiplication
%% no backpropagation yet!

mult(X,Y,Z), X::L1, Y::L2 ==> is_list(L1), is_list(L2) |
all_multiplication(L1,L2,L3), Z::L3.


%% auxiliary predicates =============================================

remove_lower(_,[],L1):- !, L1=[].
remove_lower(Min,[X|L],L1):-
	X@<Min,
	!,
	remove_lower(Min,L,L1).
remove_lower(Min,[X|L],[X|L1]):-
	remove_lower(Min,L,L1).

remove_higher(_,[],L1):- !, L1=[].
remove_higher(Max,[X|L],L1):-
	X@>Max,
	!,
	remove_higher(Max,L,L1).
remove_higher(Max,[X|L],[X|L1]):-
	remove_higher(Max,L,L1).

intersection([], _, []).
intersection([Head|L1tail], L2, L3) :-
	memberchk(Head, L2),
	!,
	L3 = [Head|L3tail],
	intersection(L1tail, L2, L3tail).
intersection([_|L1tail], L2, L3) :-
	intersection(L1tail, L2, L3).

all_addition(L1,L2,L3) :- 
	setof(Z, X^Y^(member(X,L1), member(Y,L2), Z is X + Y), L3).

all_multiplication(L1,L2,L3) :-
	setof(Z, X^Y^(member(X,L1), member(Y,L2), Z is X * Y), L3).


%% EXAMPLE ==========================================================

/*
?- X::[1,2,3,4,5,6,7], Y::[2,4,6,7,8,0], Y lt X, X::4..9, X ne Y, 
add(X,Y,Z), mult(X,Y,Z).
*/

%% end of handler listdom.pl =================================================
%% ===========================================================================
  

/*

?- X::[1,2,3,4,5,6,7], Y::[2,4,6,7,8,0], Y lt X, X::4..9, X ne Y,
   add(X,Y,Z), mult(X,Y,Z).

Bad call to builtin predicate: _9696 =.. ['add/3__0',AttVar4942,AttVar5155,AttVar6836|_9501] in predicate mknewterm / 3
*/