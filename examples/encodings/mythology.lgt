:- encoding('UTF-32').		% this directive, when present, must be the first
							% term, in the first line, of a source file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk (http://logtalk.org/)  
%  
%  Logtalk is free software.    You can redistribute it and/or modify it
%  under the terms of the "GNU General Public License 3" as published by
%  Free Software Foundation. Consult the "LICENSE.txt" file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(mythology).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2008/01/16,
		comment is 'Simple test of the encoding/1 directive.'
	]).

	:- public(divinity/2).
	:- mode(divinity(?atom, ?atom), zero_or_more).
	:- info(divinity/2, [
		comment is 'Table of english and greek names for mythology divinities.',
		argnames is ['English', 'Greek']
	]).

	divinity(hera, 'Ηρα').
	divinity(kalypso, 'Καλυψω').
	divinity(morpheus, 'Μορφευς').
	divinity(poseidon, 'Ποσειδων').
	divinity(zeus, 'Ζευς').

:- end_object.
