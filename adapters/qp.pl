%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright (c) 1998-2013 Paulo Moura <pmoura@logtalk.org>
%
%  Adapter file for Qu-Prolog 9.0 and later versions
%  Last updated on May 9, 2013
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ISO Prolog Standard predicates that we must define because they are
%  not built-in
%
%  add a clause for '$lgt_iso_predicate'/1 declaring each ISO predicate that
%  we must define; there must be at least one clause for this predicate
%  whose call should fail if we don't define any ISO predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% '$lgt_iso_predicate'(?callable).

'$lgt_iso_predicate'(sub_atom(_, _, _, _, _)).
'$lgt_iso_predicate'(subsumes_term(_, _)).
'$lgt_iso_predicate'(term_variables(_, _)).

sub_atom(Atom, _Before, 1, 0, SubAtom) :-		% utterly broken hack just for
	atom_length(Atom, Lenght),					% allowing Logtalk to startup 
	atom_search(Atom, Lenght, SubAtom, Lenght).

subsumes_term(General, Specific) :-
	collect_vars(Specific, Vars),
	'$lgt_qp_subsumes_term'(General, Specific, Vars).

'$lgt_qp_subsumes_term'(General, Specific, Vars) :-
	var(General),
	!,
	(	'$lgt_qp_var_member_chk'(General, Vars) ->
		General == Specific
	;	\+ General \= Specific
	).

'$lgt_qp_subsumes_term'(General, Specific, Vars) :-
	nonvar(Specific),
	functor(General, Functor, Arity),
	functor(Specific, Functor, Arity),
	'$lgt_qp_subsumes_term'(Arity, General, Specific, Vars).

'$lgt_qp_subsumes_term'(0, _, _, _) :-
	!.
'$lgt_qp_subsumes_term'(N, General, Specific, Vars) :-
	arg(N, General,  GenArg),
	arg(N, Specific, SpeArg),
	'$lgt_qp_subsumes_term'(GenArg, SpeArg, Vars),
	M is N-1, !,
	'$lgt_qp_subsumes_term'(M, General, Specific, Vars).

'$lgt_qp_var_member_chk'(Var, [Head| Tail]) :-
	(	Var == Head ->
		true
	;	'$lgt_qp_var_member_chk'(Var, Tail)
	).

term_variables(Term, Variables) :-
	collect_vars(Term, Variables).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  de facto standard Prolog predicates that might be missing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% between(+integer, +integer, ?integer) -- built-in


% forall(+callable, +callable) -- built-in


% format(+stream_or_alias, +character_code_list_or_atom, +list)

format(Stream, Format, Arguments) :-
	atom_chars(Format, Chars),
	format_(Chars, Stream, Arguments).

format_([], _, []).
format_(['~', Spec| Chars], Stream, Arguments) :-
	!,
	format_spec_(Spec, Stream, Arguments, RemainingArguments),
	format_(Chars, Stream, RemainingArguments).
format_([Char| Chars], Stream, Arguments) :-
	put_char(Stream, Char),
	format_(Chars, Stream, Arguments).

format_spec_('a', Stream, [Argument| Arguments], Arguments) :-
%	atom(Argument),
	write(Stream, Argument).
format_spec_('c', Stream, [Argument| Arguments], Arguments) :-
	put_code(Stream, Argument).
format_spec_('s', Stream, [Argument| Arguments], Arguments) :-
	atom_codes(Atom, Argument),
	write(Stream, Atom).
format_spec_('w', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('q', Stream, [Argument| Arguments], Arguments) :-
	writeq(Stream, Argument).
format_spec_('k', Stream, [Argument| Arguments], Arguments) :-
	write_canonical(Stream, Argument).
format_spec_('d', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('D', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('f', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('g', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('G', Stream, [Argument| Arguments], Arguments) :-
	write(Stream, Argument).
format_spec_('i', _, [_| Arguments], Arguments).
format_spec_('n', Stream, Arguments, Arguments) :-
	nl(Stream).
format_spec_('~', Stream, Arguments, Arguments) :-
	put_char(Stream, '~').


% format(+character_code_list_or_atom, +list)

format(Format, Arguments) :-
	current_output(Stream),
	format(Stream, Format, Arguments).


% numbervars(?term, +integer, ?integer) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  predicate properties
%
%  this predicate must return at least static, dynamic, and built_in 
%  properties for an existing predicate
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_predicate_property'(+callable, ?predicate_property)

'$lgt_predicate_property'(Pred, Prop) :-
	predicate_property(Pred, Prop).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  meta-predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% setup_call_cleanup(+callable, +callable, +callable) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Prolog non-standard built-in meta-predicates and meta-directives
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_meta_predicate'(+callable, ?callable, ?atom)
%
% table of meta-predicate patterns for proprietary built-in predicates;
% the third argument, which must be either "predicate" or "control_construct",
% is used to guide the compilation of these meta-predicates in debug mode

'$lgt_prolog_meta_predicate'(Callable, Template, predicate) :-
	predicate_property(Callable, built_in),
	predicate_property(Callable, meta_predicate(Template)),
	!.


% '$lgt_prolog_meta_directive'(@callable, @callable)

'$lgt_prolog_meta_directive'(inline(_, _), inline(0, 0)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  file extension predicates
%
%  these extensions are used by Logtalk load/compile predicates
%
%  you may want to change the extension for Prolog files to match 
%  the one expected by default by your Prolog compiler
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_file_extension'(?atom, ?atom)

'$lgt_file_extension'(logtalk, '.lgt').
'$lgt_file_extension'(prolog, '.ql').
'$lgt_file_extension'(tmp, '.qo').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  back-end Prolog features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_feature'(?atom, ?atom)
%
% back-end Prolog compiler supported features (that are compatible with Logtalk)

'$lgt_prolog_feature'(prolog_dialect, qp).
'$lgt_prolog_feature'(prolog_version, (Major, Minor, Patch)) :-
	current_prolog_flag(version_data, qp(Major, Minor, Patch, _)).
'$lgt_prolog_feature'(prolog_compatible_version, @>=((9,0,0))).

'$lgt_prolog_feature'(encoding_directive, unsupported).
'$lgt_prolog_feature'(tabling, unsupported).
'$lgt_prolog_feature'(threads, unsupported).
'$lgt_prolog_feature'(modules, unsupported).
'$lgt_prolog_feature'(coinduction, unsupported).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  default flag values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_default_flag'(?atom, ?atom)
%
% default values for all flags

% lint compilation flags:
'$lgt_default_flag'(unknown_entities, warning).
'$lgt_default_flag'(misspelt_calls, warning).
'$lgt_default_flag'(singleton_variables, warning).
'$lgt_default_flag'(portability, silent).
'$lgt_default_flag'(redefined_built_ins, silent).
'$lgt_default_flag'(missing_directives, warning).
'$lgt_default_flag'(underscore_variables, singletons).
% optional features compilation flags:
'$lgt_default_flag'(complements, deny).
'$lgt_default_flag'(dynamic_declarations, deny).
'$lgt_default_flag'(events, deny).
'$lgt_default_flag'(context_switching_calls, allow).
% other compilation flags:
'$lgt_default_flag'(scratch_directory, '.lgt_tmp/').
'$lgt_default_flag'(report, on).
'$lgt_default_flag'(clean, on).
'$lgt_default_flag'(code_prefix, '$').
'$lgt_default_flag'(optimize, off).
'$lgt_default_flag'(source_data, on).
'$lgt_default_flag'(debug, off).
% Prolog compiler and loader flags:
'$lgt_default_flag'(prolog_compiler, [assemble_only(true), string_table(256), compiler_heap(4096)]).
'$lgt_default_flag'(prolog_loader, []).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  file predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_os_file_name'(+atom, -atom)
% '$lgt_prolog_os_file_name'(-atom, +atom)
%
% converts between Prolog internal file paths and operating-system paths

'$lgt_prolog_os_file_name'(Path, Path).


% '$lgt_expand_path'(+nonvar, -atom)
%
% expands a file path to a full path

'$lgt_expand_path'(Path, ExpandedPath) :-
	absolute_file_name(Path, ExpandedPath).


% '$lgt_file_exists'(+atom)
%
% checks if a file exists

'$lgt_file_exists'(File) :-
	access(File, 4, 0).


% '$lgt_delete_file'(+atom)
%
% deletes a file

'$lgt_delete_file'(File) :-
	access(File, 4, 0),
	atom_concat('rm "', File, Command0),
	atom_concat(Command0, '"', Command),
	os(system(Command)).


% '$lgt_directory_exists'(+atom)
%
% checks if a directory exists

'$lgt_directory_exists'(Directory) :-
	access(Directory, 4, 0).


% '$lgt_current_directory'(-atom)
%
% gets current working directory

'$lgt_current_directory'(Directory) :-
	getcwd(Directory).


% '$lgt_change_directory'(+atom)
%
% changes current working directory

'$lgt_change_directory'(Directory) :-
	chdir(Directory).


% '$lgt_make_directory'(+atom)
%
% makes a new directory; succeeds if the directory already exists

'$lgt_make_directory'(Directory) :-
	(	access(Directory, 4, 0) ->
		true
	;	atom_concat('mkdir "', Directory, Command0),
		atom_concat(Command0, '"', Command),
		os(system(Command))
	).


% '$lgt_compile_prolog_code'(+atom, +atom, +list)
%
% compile to disk a Prolog file, resulting from a
% Logtalk source file, given a list of options

'$lgt_compile_prolog_code'(File, _, Options) :-
	fcompile(File, Options).


% '$lgt_load_prolog_code'(+atom, +atom, +list)
%
% compile and load a Prolog file, resulting from a
% Logtalk source file, given a list of options

'$lgt_load_prolog_code'(File, _, _) :-
	'$lgt_file_extension'(prolog, Extension),
	atom_concat(Name, Extension, File),
	load(Name).


% '$lgt_compare_file_modification_times'(?atom, +atom, +atom)
%
% compare file modification times

'$lgt_compare_file_modification_times'(Result, File1, File2) :-
	stat(File1, stat(Time1, _)),
	stat(File2, stat(Time2, _)),
	compare(Result, Time1, Time2).


% '$lgt_environment_variable'(?atom, ?atom)
%
% access to operating-system environment variables

'$lgt_environment_variable'(Variable, Value) :-
	getenv(Variable, Value).


% '$lgt_startup_directory'(-atom)
%
% returns the Logtalk startup directory 

'$lgt_startup_directory'(Directory) :-
	getenv('LOGTALK_STARTUP_DIRECTORY', Directory).


% '$lgt_user_directory'(-atom)
%
% returns the Logtalk user directory; fails if unknown

'$lgt_user_directory'(Directory) :-
	getenv('LOGTALKUSER', Directory).


% '$lgt_home_directory'(-atom)
%
% returns the Logtalk home directory; fails if unknown

'$lgt_home_directory'(Directory) :-
	getenv('LOGTALKHOME', Directory).


% '$lgt_decompose_file_name'(+atom, ?atom, ?atom, ?atom)
%
% decomposes a file path in its components; the directory
% must always end with a slash and the extension must be
% the empty atom when it does not exist

'$lgt_decompose_file_name'(File, Directory, Name, Extension) :-
	atom_codes(File, FileCodes),
	(	'$lgt_strrch'(FileCodes, 0'/, [_Slash| BasenameCodes]) ->
		atom_codes(Basename, BasenameCodes),
		atom_concat(Directory, Basename, File)
	;	Directory = './',
		atom_codes(Basename, FileCodes),
		BasenameCodes = FileCodes
	),
	(	'$lgt_strrch'(BasenameCodes, 0'., ExtensionCodes) ->
		atom_codes(Extension, ExtensionCodes),
		atom_concat(Name, Extension, Basename)
	;	Name = Basename,
		Extension = ''
	).

% the following auxiliar predicate was written by Per Mildner and 
% is used here (renamed just to avoid conflicts) with permission

'$lgt_strrch'(Xs, G, Ys) :-
	Xs = [X| Xs1],
	(	X == G ->
		'$lgt_strrch1'(Xs1, G, Xs, Ys)
	;	'$lgt_strrch'(Xs1, G, Ys)
	).

'$lgt_strrch1'(Xs, _G, _Prev, _Ys) :-
	var(Xs),
	!,
	fail.
'$lgt_strrch1'([], _G, Prev, Ys) :-
	Ys = Prev.
'$lgt_strrch1'(Xs, G, Prev, Ys) :-
	Xs = [X| Xs1],
	(	X == G ->
		'$lgt_strrch1'(Xs1, G, Xs, Ys)
	;	'$lgt_strrch1'(Xs1, G, Prev, Ys)
	).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  time and date predicates
%
%  if your Prolog compiler does not provide access to the operating system 
%  time and date just write dummy definitions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_current_date'(?integer, ?integer, ?integer)

'$lgt_current_date'(Year, Month, Day) :-
	realtime(Time),
	localtime(Time, time(Year2, Month2, Day, _, _, _, _)),
	Year is 1900 + Year2,
	Month is Month2 + 1.


% '$lgt_current_time'(?integer, ?integer, ?integer)

'$lgt_current_time'(Hours, Minutes, Seconds) :-
	realtime(Time),
	localtime(Time, time(_, _, _, Hours, Minutes, Seconds, _)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  timing predicate
%
%  if your Prolog compiler does not provide access to a timing predicate 
%  just write dummy definition
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_cpu_time'(-Seconds)

'$lgt_cpu_time'(Seconds) :-
	statistics(runtime, [Start,_]),
	Seconds is Start/1000.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  getting stream current line number
%  (needed for improved compiler error messages)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_stream_current_line_number'(@stream, -integer)

'$lgt_stream_current_line_number'(Stream, Line) :-
	stream_property(Stream, line_number(Line)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  customized version of the read_term/3 predicate for returning the term
%  position (start and end lines; needed for improved error messages)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_read_term'(@stream, -term, +list, -position)

'$lgt_read_term'(Stream, Term, Options, LineBegin-LineEnd) :-
	stream_property(Stream, line_number(LineBegin)),
	read_term(Stream, Term, Options),
	stream_property(Stream, line_number(LineEnd)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Prolog dialect specific term and goal expansion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_term_expansion'(@callable, -callable)

'$lgt_prolog_term_expansion'(_, _) :-
	fail.


% '$lgt_prolog_goal_expansion'(@callable, -callable)

'$lgt_prolog_goal_expansion'(_, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Shortcut to the Logtalk built-in predicate logtalk_load/1
%
%  defined in the adapter files in order to be able to comment it out in case
%  of conflict with some Prolog native feature; it implies conformance with
%  the ISO Prolog standard regarding the definition of the {}/1 syntax
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

{File, Files} :-
	!,
	logtalk_load(File),
	{Files}.
{File} :-
	logtalk_load(File).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  converts between Prolog stream encoding names and XML encoding names
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_logtalk_prolog_encoding'(?atom, ?atom, +stream)

'$lgt_logtalk_prolog_encoding'(_, _, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  experimental lambda support predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_copy_term_without_constraints'(@term, ?term)

'$lgt_copy_term_without_constraints'(Term, Copy) :-
	copy_term(Term, Copy).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  utility predicates used to construct execution context terms
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


'$lgt_exec_ctx'(c(This, r(Sender, Self, MetaCallCtx, Stack)), Sender, This, Self, MetaCallCtx, Stack).

'$lgt_exec_ctx_this_rest'(c(This, Ctx), This, Ctx).	% inheritance only requires updating "this"

'$lgt_exec_ctx_this'(c(This, _), This).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  hooks predicates for writing and assert compiled entity terms
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_write_term_and_source_location'(@stream, @callable, +atom, @callable)

'$lgt_write_term_and_source_location'(Stream, Term, _Kind, _Location) :-
	write_canonical(Stream, Term),
	write(Stream, '.\n').


% '$lgt_assertz_entity_clause'(@clause, +atom)

'$lgt_assertz_entity_clause'(Clause, _Kind) :-
	assertz(Clause).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  annotations
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_default_value_annotation'(@callable, -term, -callable, -callable)

'$lgt_default_value_annotation'(_, _, _, _) :-
	fail.


% '$lgt_default_goal_annotation'(@callable, -callable, -callable, -callable)

'$lgt_default_goal_annotation'(_, _, _, _) :-
	fail.


% '$lgt_default_body_annotation'(@callable, -callable, -callable)

'$lgt_default_body_annotation'(_, _, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  error term normalization
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_normalize_error_term'(@callable, -callable)

'$lgt_normalize_error_term'(
		error(exception(undefined_predicate(recoverable, Predicate, _)), Context),
		error(existence_error(procedure, Functor/Arity), Context)) :-
	functor(Predicate, Functor, Arity).
'$lgt_normalize_error_term'(
		exception(undefined_predicate(recoverable, Predicate, _)),
		error(existence_error(procedure, Functor/Arity), _)) :-
	functor(Predicate, Functor, Arity).
'$lgt_normalize_error_term'(
		exception(instantiation_error(recoverable, _, _, _, _)),
		error(instantiation_error, _)).
'$lgt_normalize_error_term'(
		exception(type_error(unrecoverable, Call, Correct, Arg, _)),
		error(type_error(Type,Culprit), _)) :-
			arg(Arg, Correct, Type),
			arg(Arg, Call, Culprit).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  message token printing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%:- multifile('$lgt_logtalk.print_message_token'/3).
%:- dynamic('$lgt_logtalk.print_message_token'/3).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  end!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
