pycoverage.el
=============

An emacs mode for reporting on coverage stats for python

Dependencies
============

Coverage reporter for Python:

  * coverage.py (currently we only support this)
  * figleaf (support pending)

Installation
============

#. Put something like this in your .emacs

   .. code-block:: lisp
      
      (load-file "/home/matt/work/emacs/pycoverage/pycov2.el")
      (require 'linum)
      (require 'pycov2)
      (add-hook 'python-mode-hook
      (function (lambda ()
      (pycov2-mode)
      (linum-mode))))

#. Install cov2emacs using setuptools or virtualenv or distutils

#. Update the ``cov2emacs-command`` variable with a path to the
   ``cov2emacs`` command that can be run from emacs.

There should be ``.coverage`` file in the directory of the module you
want coverage reporting on (or the parents of that directory).  How
you get it there is currently not solved by this tool, which only
provides a way to view the coverage data in your editor.


Running
=======

M-x pycov2-mode


Ideal Usage
===========

One runs their tests using coverage.  Then they enter
``pycov2-mode``.  That should look for a ``.coverage`` file (or
the figleaf equivalent) and load the overview/results page in another
buffer.  It will also highlight the current file (iff it's timestamp
is <= ``.coverage`` timestamp.  Newer timestamp means no guarantees on
output.) with coverage information.

Todo
====

  * Make it work!
  * Use flymake mode instead of/in combination with compile mode? - Initial Flymake DONE
  * Use missing line numbers instead of covered lines - DONE for coverage.py
  * Make pycoverage-load-report look for a ``.coverage`` file
    recursively up the parents of the file - DONE
  * Make ``cov2emacs`` accept location of ``.coverage`` file - DONE
  * Make report use normal coverage.py text output, since it's a
    little friendlier on the eyes (instead of reporting for every 
    group of lines in a file)
  * Put status in modeline
    * Nothing - current data
    * D - dirty
    * N - no .coverage file available
    * E - Error (see *messages*)
  * Figleaf support
  * Nose integration?

Thanks
======

  * rcov - for code to start from
