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


:- object(tests_utf_32,
	extends(lgtunit)).

	:- info([
		version is 1.1,
		author is 'Parker Jones and Paulo Moura',
		date is 2012/08/06,
		comment is 'Unit tests for the "encodings" example.'
	]).

	unit(mythology).

	test(encodings_utf_32_1) :-
		findall(Greek-English, mythology::divinity(English, Greek), Solutions),
		Solutions == ['Ηρα'-hera, 'Καλυψω'-kalypso, 'Μορφευς'-morpheus, 'Ποσειδων'-poseidon, 'Ζευς'-zeus].

:- end_object.
