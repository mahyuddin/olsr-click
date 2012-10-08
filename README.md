OLSR CLICK PACKAGE
================

The package provides the OLSR related elements for the Click modular router. 
The implementation is based on the implementation of Bart Braem available here:

    http://www.pats.ua.ac.be/software/olsr/

The Click scripts are reorganized for interoperability with Linux and Network Simulator 3 (NS3).


INSTALLATION
------------

This section describes how you can install this package -- which is
named 'sample' -- and, by extension, any package you build based on this
one.

Before you can build a package, you must install Click into some
directory DIR. (You set DIR with the '--prefix=DIR' option to Click's
'./configure'.) We often use '/usr/local/click', but if you do not have
permission on that directory, '$HOME' or '$HOME/click' works just as well.

Now you must configure your package, telling it where the Click install
directory is. The best way to do this is to run './configure --prefix=DIR',
where DIR is the Click install directory. The package will be installed in
DIR, where the Click drivers can find it. (The package './configure' has
several interesting options, like '--disable-linuxmodule'; run './configure
--help' to see them.)

Next, just run 'make install'. This will build and install element
collections for both drivers, manual pages for the package's elements, and
an 'elementmap' for the package.

We have supplied a simple configuration that tests the 'sample'
package, 'test.click'. Note the 'require(sample);' line: this is what tells
the Click drivers to load the 'sample' package.


GUIDE TO THE SOURCE
-------------------

This section describes which files make up this simple package, and how
to alter those files for your own package.  Creating a new package is very
simple: just create a directory for the package, copy and alter the
'configure.ac' and 'Makefile.in' files, run 'autoconf' and './configure',
and add your element sources.


'configure.ac'
..............

Autoconf generates './configure' from this script.  Alter
'configure.ac' to refer to your package, rather than the "sample" package.
Packages rely on Click's configuration process, so package 'configure.ac'
files are quite short.

Autoconf has a useful info(1) manual.


'Makefile.in'
.............

'./configure' generates a Makefile from 'Makefile.in'.  Most of
'Makefile.in' can generally stay as is.  However, if you develop a complex
source hierarchy -- where the element source code is in a separate
directory, for example -- you will need to alter it.  Look particularly at
the 'top_builddir' and 'subdir' variables.


Element source
..............

Element source code designed for a package looks just like normal
element source code. This is normally the only actual C++ code you will
need to write; Click automatically generates the boilerplate that turns
your elements into a package. Take a look at 'sampleelt.cc' and
'sampleelt.hh'.

'make elemlist' is useful when you add or remove elements from the
package. It rebuilds the lists of valid element source files stored in
'kelements.conf' and 'uelements.conf'.


GENERATED FILES
---------------

Building a package creates a bunch of files with unusual extensions.
Here are the files, and what they are for.


'kelements.conf', 'uelements.conf'
..................................

These files list the element source code to be compiled into the kernel
package and user-level package, respectively. They are automatically
generated by 'click-buildtool findelem'. 'Click-buildtool' only considers
C++ source files named 'WHATEVER.cc' that contain an 'EXPORT_ELEMENT' or
'ELEMENT_PROVIDES' line.

 Run 'make elemlist' to rebuild 'kelements.conf' and 'uelements.conf'.


'kelements.mk', 'uelements.mk'
..............................

These files contain definitions for the 'ELEMENT_OBJS' Make variable,
which tell Make what element source code to compile.  They are generated by
'click-buildtool elem2make' from 'kelements.conf' and 'uelements.conf',
respectively.


'kpackage.cc', 'upackage.cc'
............................

These files define the 'init_module' and 'cleanup_module' functions
that actually export your new elements to the relevant driver. They are
generated by 'click-buildtool elem2package' from 'kelements.conf' and
'uelements.conf', respectively.


'FILE.ko', 'FILE.uo'
....................

These are object files destined for the Linux kernel package and the
user-level package, respectively.


'FILE.kd', 'FILE.ud'
....................

These files automatically track dependencies for '.ko' objects and
'.uo' objects, respectively. GCC generates them.


'elementmap-PACKAGENAME.xml'
............................

This file lists the elements included in the package. Tools like
'click-check', 'click-devirtualize', and 'click-undead' look for your
package's elementmap in order to determine the properties of your elements.
It is generated by 'click-mkelemmap'.
