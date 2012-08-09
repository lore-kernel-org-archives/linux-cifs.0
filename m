From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Regression tests for CIFS client
Date: Thu, 09 Aug 2012 20:07:56 +0530
Message-ID: <5023CB44.8000802@suse.com>
References: <50225505.3080303@suse.com> <20120808084149.26325074@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120808084149.26325074-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/08/2012 06:11 PM, Jeff Layton wrote:
> On Wed, 08 Aug 2012 17:31:09 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> Here's are the failures seen with 3.1 based kernel. I think the open()
>> with O_DIRECT is expected to fail since cifs doesn't support it (I'd be
>> interesting in knowing exact details). But, I've not dig into the xattr
>> tests, not sure why setattr is failing (even if CIFS_XATTR is set, fs
>> mounted with user_xattr).
>>
>> Test Output
>> ============
>>
>> ======================================================================
>> ERROR: test_directIO (__main__.OpenTests)
>> open a file with O_DIRECT
>> ----------------------------------------------------------------------
>> Traceback (most recent call last):
>>   File "./testcifs.py", line 144, in test_directIO
>>     raise e
>> OSError: [Errno 22] Invalid argument: 'testfile'
>>
> 
> With all of the recent changes to the read/write code, I think we can
> reasonably do O_DIRECT now. Just make sure that you don't request an
> oplock on open and ensure that you're not using cache=loose codepaths.
> 

Hmm, I'm not sure yet what is going on wrong.. I disabled oplocks by doing

   echo N > /sys/module/cifs/parameters/enable_oplocks

(Is there a way for an application to not request oplocks?)
and mounted with cache=strict and ran the directIO test alone.

strace output (snip)
--------------
stat("/mnt/cifstests", 0x7fff317e68f0)  = -1 ENOENT (No such file or
directory)
mkdir("cifstests", 0755)                = 0
chdir("cifstests")                      = 0
open("testfile", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
close(3)                                = 0
open("testfile", O_RDONLY|O_DIRECT)     = -1 EINVAL (Invalid argument)
write(1, "[Errno 22] Invalid argument: 'te"..., 40) = 40

But I see from dmesg oplocks are being granted.

> In point of fact, we do some bounce buffering under the covers, but it
> does avoid the pagecache.
> 
>> ======================================================================
>> ERROR: test_dir_attr (__main__.XattrTests)
>> set attrs, get attrs and remove attrs for a dir
>> ----------------------------------------------------------------------
>> Traceback (most recent call last):
>>   File "./testcifs.py", line 364, in test_dir_attr
>>     raise e
>> IOError: [Errno 95] Operation not supported: 'test'
>>
>> ======================================================================
>> ERROR: test_file_attr (__main__.XattrTests)
>> set attrs, get attrs and remove attrs for a file
>> ----------------------------------------------------------------------
>> Traceback (most recent call last):
>>   File "./testcifs.py", line 343, in test_file_attr
>>     raise e
>> IOError: [Errno 95] Operation not supported: 'testfile'
>>
>> ----------------------------------------------------------------------
>> Ran 22 tests in 0.072s
>>
>> FAILED (errors=3)
>>
> 
> The above I'm not sure about -- maybe depends on which attributes
> you're trying to set?

I was trying to set something like:

	user.mime_type = 'text/plain'

(the same worked on ext4)

>>
>> What do you think? Is it be a good idea?
>>
>> I know I have barely scratched the surface, but any suggestion on having
>> a working regression test is welcome. And of course, regression tests
>> are supposed to evolve over time. Would this be a convenient way to add
>> more tests?
>>
> Sounds like a very worthwhile endeavor. The key to any testing
> infrastructure is to make it very easy to run the tests. Any hassle in
> setting it up is a reason not to do so, so you want to make sure there
> are no such barriers.

One such hassle I see with the current tests is that the dependencies on
external modules such as xattr and acls. This could be overcome by
writing C extensions that could use the C apis. Any other hassles you
are noticing?

> You also want to make sure that you have the ability to drill down into
> a single test failure without needing to run a bunch of goop around it.
> The cthon suite is good for this since most of the tests are written in
> C. That makes it easy to strace them to track down problems. I assume

It is possible to run strace the same way with these tests (like for
e.g. the above direct IO strace output). The output does seem a little
more verbose. But, any other problems you are seeing with these tests
written in python?

> we'll be able to write tests in C and just have the python framework
> call them?
> 

I initially thought of writing these tests in C. But, later decided in
favor of Python because of ease of use, smaller code size and
availability of plenty of modules. Making it simpler (simpler here is
subjective) means that should be little or no excuse for not writing an
regression test when submitting a bug fix for a regression.

But, if the consensus is that we would prefer tests in C, I can redo the
tests in C. If we do it in C, I think we could use CUnit framework for
writing tests as it would be more natural.


Thanks
Suresh
