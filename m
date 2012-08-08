From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Regression tests for CIFS client
Date: Wed, 08 Aug 2012 17:31:09 +0530
Message-ID: <50225505.3080303@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi everyone,

The CIFS client never had proper regression tests and we try to tweak
the connectathon tests a little bit and run to avoid regressions
creeping in. I think a testsuite that checks for regressions would be
useful.

I spent sometime hacking up a set of tests. These tests use Python and
PyUnit framework which I think might help quickly adding newer tests.
Tests are written based on the past bug reports and experiences.

The primary intent of the tests is to provide some basic infrastructure
upon which tests can be added easily in the future and these tests are
by no means comprehensive. I have tried to avoid duplicating tests
already done by Connectathon and other tests but there could still be a
few duplicates in there. The tests are only lightly tested.

Currently cifstests is hosted here:

   https://github.com/sureshjayaram/cifstests

Feel free to try out and let me know your feedback or any comments and
suggestions.

Here's are the failures seen with 3.1 based kernel. I think the open()
with O_DIRECT is expected to fail since cifs doesn't support it (I'd be
interesting in knowing exact details). But, I've not dig into the xattr
tests, not sure why setattr is failing (even if CIFS_XATTR is set, fs
mounted with user_xattr).

Test Output
============

======================================================================
ERROR: test_directIO (__main__.OpenTests)
open a file with O_DIRECT
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./testcifs.py", line 144, in test_directIO
    raise e
OSError: [Errno 22] Invalid argument: 'testfile'

======================================================================
ERROR: test_dir_attr (__main__.XattrTests)
set attrs, get attrs and remove attrs for a dir
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./testcifs.py", line 364, in test_dir_attr
    raise e
IOError: [Errno 95] Operation not supported: 'test'

======================================================================
ERROR: test_file_attr (__main__.XattrTests)
set attrs, get attrs and remove attrs for a file
----------------------------------------------------------------------
Traceback (most recent call last):
  File "./testcifs.py", line 343, in test_file_attr
    raise e
IOError: [Errno 95] Operation not supported: 'testfile'

----------------------------------------------------------------------
Ran 22 tests in 0.072s

FAILED (errors=3)


What do you think? Is it be a good idea?

I know I have barely scratched the surface, but any suggestion on having
a working regression test is welcome. And of course, regression tests
are supposed to evolve over time. Would this be a convenient way to add
more tests?


Thanks
Suresh
