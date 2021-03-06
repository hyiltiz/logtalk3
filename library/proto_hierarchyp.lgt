%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright (c) 1998-2013 Paulo Moura <pmoura@logtalk.org>
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%  
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%  
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%  
%  Additional licensing terms apply per Section 7 of the GNU General
%  Public License 3. Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



:- protocol(proto_hierarchyp,
	extends(hierarchyp)).

	:- info([
		version is 1.1,
		author is 'Paulo Moura',
		date is 2006/2/20,
		comment is 'Prototype hierarchy protocol.'
	]).

	:- public(parent/1).
	:- mode(parent(?object), zero_or_more).
	:- info(parent/1, [
		comment is 'Returns, by backtracking, all object parents.',
		argnames is ['Parent']
	]).

	:- public(parents/1).
	:- mode(parents(-list), one).
	:- info(parents/1, [
		comment is 'List of all object parents.',
		argnames is ['Parents']
	]).

	:- public(extension/1).
	:- mode(extension(?object), zero_or_more).
	:- info(extension/1, [
		comment is 'Returns, by backtracking, all object direct descendants.',
		argnames is ['Extension']
	]).

	:- public(extensions/1).
	:- mode(extensions(-list), one).
	:- info(extensions/1, [
		comment is 'List of all object direct descendants.',
		argnames is ['Extensions']
	]).

:- end_protocol.
