________________________________________________________________________

This file is part of Logtalk <http://logtalk.org/>  
Copyright (c) 1998-2013 Paulo Moura <pmoura@logtalk.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Additional licensing terms apply per Section 7 of the GNU General
Public License 3. Consult the `LICENSE.txt` file for details.
________________________________________________________________________


CUSTOMIZATION INSTRUCTIONS
==========================

This file contains detailed instructions for customizing your Logtalk 
installation and working environment. Customization is mostly done on
a per-user basis by editing a settings file on the Logtalk user folder 
(whose path is stored on the `LOGTALKUSER` environment variable; this
folder can be (re)created by running the `logtalk_user_setup` shell
command). The default path for the Logtalk user folder is:

	POSIX systems: $HOME/logtalk
	Windows: My Documents\Logtalk


1. DEFINING A DEFAULT PROLOG BACK-END COMPILER
----------------------------------------------

Users of POSIX systems may use the `logtalk_backend_select` shell command
to define an alias, `logtalk`, for one of the provided back-end Prolog
compiler integration scripts.


2. SETTING LIBRARY PATHS
------------------------

In Logtalk, a library is simply a directory containing source files. Library 
paths can be declared using a dynamic, multifile predicate. This allows 
compiling and loading of libraries and library files using the library names
instead of the full library paths.

Inside your Logtalk user folder, you will find a `paths` folder containing 
a sample file which, when loaded, defines the library paths for the Logtalk 
standard library and for all the supplied examples. This file may need to be 
edited to match both your Logtalk installation and your Prolog compiler and 
operating-system requirements. For details, see the `paths/NOTES.txt` file.

Library paths for your own source files directories are preferably defined in
your settings file, described next.


3. CUSTOMIZING LOGTALK SETTINGS
-------------------------------

Logtalk interfaces with a specific Prolog compiler using a adapter file that
can be found on the `adapters` folder in the Logtalk installation folder.
These adapter files define default values of the flags that are used by
Logtalk when compiling source files (for a full description of these flags, 
consult the `Writing, Running, and Debugging Logtalk Programs` section of
the User Manual). The default compiler flag settings are appropriated for the
development (not the deployment) of applications. Check the example settings
on the `settings-sample.lgt` for suggestions.

You may customize the Logtalk compiler flags and add your own library paths
by copy or renaming the `settings-sample.lgt` file in your Logtalk user folder
to `settings.lgt` and editing it. Settings in this file override the default 
values in the adapter files. Some of the default flag values that you
may want to change include:

* `report`
    for less verbose startup and compilation reports

* `scratch_directory`
    to move compiler generated temporary files out of the way or to
    collect them for embedding Logtalk applications

* `portability` and `underscore_variables`
    essential if you're writing portable Logtalk applications

Check the `adapters/NOTES.txt` file for Prolog specific compatibility notes.
Some back-end Prolog compilers don't support all the possible compilation
flags values. In addition, some back-end Prolog compilers provide limited
support for settings files in some operating-systems.


4. CUSTOMIZING DOCUMENTATION PROCESSING SUPPORT
-----------------------------------------------

Inside your Logtalk user folder, you will find a `tools/lgtdoc/xml` folder
containing a set of shell scripts, CSS and XSLT style-sheets, and DTD and
XML Schema files for processing the XML documenting files that are generated 
from the source data collected when compiling source files. You may want to
customize the CSS and XSLT files to modify the layout or style of the resulting
PDF/(X)HTML files or to write new scripts and transformations to generate other
formats. You may also edit the file `custom.ent` in order to specify XML entities
for your personal data that can be used on Logtalk documenting directives. For
details, see the `tools/lgtdoc/NOTES.txt` file.


5. ADDING LOGTALK SUPPORT TO TEXT EDITORS
-----------------------------------------

Inside your Logtalk user folder, you will find a `coding` folder, containing 
support files for several text editors, which add support for syntax 
highlighting and other text editing services for Logtalk source files.
Support for several syntax highlighters (used e.g. by wikis and issue
trackers) is also included. For details, see the `coding/NOTES.txt` file.
