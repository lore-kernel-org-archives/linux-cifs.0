From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Regression tests for CIFS client
Date: Fri, 10 Aug 2012 10:57:35 +0530
Message-ID: <50249BC7.2000205@suse.com>
References: <50225505.3080303@suse.com> <20120808084149.26325074@tlielax.poochiereds.net> <5023CB44.8000802@suse.com> <20120809110351.22847557@corrin.poochiereds.net>
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
In-Reply-To: <20120809110351.22847557-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/09/2012 08:33 PM, Jeff Layton wrote:
> On Thu, 09 Aug 2012 20:07:56 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>>>
>>> With all of the recent changes to the read/write code, I think we can
>>> reasonably do O_DIRECT now. Just make sure that you don't request an
>>> oplock on open and ensure that you're not using cache=loose codepaths.
>>>
>> Hmm, I'm not sure yet what is going on wrong.. I disabled oplocks by doing
>>
>>    echo N > /sys/module/cifs/parameters/enable_oplocks
>>
>> (Is there a way for an application to not request oplocks?)
>> and mounted with cache=strict and ran the directIO test alone.
>>
>> strace output (snip)
>> --------------
>> stat("/mnt/cifstests", 0x7fff317e68f0)  = -1 ENOENT (No such file or
>> directory)
>> mkdir("cifstests", 0755)                = 0
>> chdir("cifstests")                      = 0
>> open("testfile", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
>> fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> close(3)                                = 0
>> open("testfile", O_RDONLY|O_DIRECT)     = -1 EINVAL (Invalid argument)
>> write(1, "[Errno 22] Invalid argument: 'te"..., 40) = 40
>>
>> But I see from dmesg oplocks are being granted.
>>
> Sorry, I might not have been clear. I meant that in principle, we could
> probably fix the cifs client to do O_DIRECT properly now that we have
> the strictcache code. It doesn't do that currently, of course...

Ah, ok. What does it take to fix the cifs client? I could take a look.
Are there pointers to discussion threads on this topic?

>>
>> I was trying to set something like:
>>
>> 	user.mime_type = 'text/plain'
>>
>> (the same worked on ext4)
>>
> Are you testing against samba? You might need to set "ea support = yes".

You were spot on. I had assumed that EA would be supported by default.
Now, the extended attribute tests are passing.

>>>>
>>>> What do you think? Is it be a good idea?
>>>>
>>>> I know I have barely scratched the surface, but any suggestion on having
>>>> a working regression test is welcome. And of course, regression tests
>>>> are supposed to evolve over time. Would this be a convenient way to add
>>>> more tests?
>>>>
>>> Sounds like a very worthwhile endeavor. The key to any testing
>>> infrastructure is to make it very easy to run the tests. Any hassle in
>>> setting it up is a reason not to do so, so you want to make sure there
>>> are no such barriers.
>>
>> One such hassle I see with the current tests is that the dependencies on
>> external modules such as xattr and acls. This could be overcome by
>> writing C extensions that could use the C apis. Any other hassles you
>> are noticing?
>>
>>> You also want to make sure that you have the ability to drill down into
>>> a single test failure without needing to run a bunch of goop around it.
>>> The cthon suite is good for this since most of the tests are written in
>>> C. That makes it easy to strace them to track down problems. I assume
>>
>> It is possible to run strace the same way with these tests (like for
>> e.g. the above direct IO strace output). The output does seem a little
>> more verbose. But, any other problems you are seeing with these tests
>> written in python?
>>
>>> we'll be able to write tests in C and just have the python framework
>>> call them?
>>>
>>
>> I initially thought of writing these tests in C. But, later decided in
>> favor of Python because of ease of use, smaller code size and
>> availability of plenty of modules. Making it simpler (simpler here is
>> subjective) means that should be little or no excuse for not writing an
>> regression test when submitting a bug fix for a regression.
>>
>> But, if the consensus is that we would prefer tests in C, I can redo the
>> tests in C. If we do it in C, I think we could use CUnit framework for
>> writing tests as it would be more natural.
>>
> I'm fine with them in python, but eventually there may be need to write
> certain tests in C. As long as the python framework can execute those
> (and I'm fairly sure it can), I don't think it'll be a problem...
> 

Yeah, I agree that we will have a need to write some tests in C and it
is possible to invoke tests written in C with this framework. Perhaps,
I'll see whether I can have some examples so that it will be easy for
others to follow.


Thanks
Suresh
