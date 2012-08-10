From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Regression tests for CIFS client
Date: Fri, 10 Aug 2012 06:41:31 -0400
Message-ID: <20120810064131.682541e8@corrin.poochiereds.net>
References: <50225505.3080303@suse.com>
	<20120808084149.26325074@tlielax.poochiereds.net>
	<5023CB44.8000802@suse.com>
	<20120809110351.22847557@corrin.poochiereds.net>
	<50249BC7.2000205@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50249BC7.2000205-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 Aug 2012 10:57:35 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 08/09/2012 08:33 PM, Jeff Layton wrote:
> > On Thu, 09 Aug 2012 20:07:56 +0530
> > Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> >>>
> >>> With all of the recent changes to the read/write code, I think we can
> >>> reasonably do O_DIRECT now. Just make sure that you don't request an
> >>> oplock on open and ensure that you're not using cache=loose codepaths.
> >>>
> >> Hmm, I'm not sure yet what is going on wrong.. I disabled oplocks by doing
> >>
> >>    echo N > /sys/module/cifs/parameters/enable_oplocks
> >>
> >> (Is there a way for an application to not request oplocks?)
> >> and mounted with cache=strict and ran the directIO test alone.
> >>
> >> strace output (snip)
> >> --------------
> >> stat("/mnt/cifstests", 0x7fff317e68f0)  = -1 ENOENT (No such file or
> >> directory)
> >> mkdir("cifstests", 0755)                = 0
> >> chdir("cifstests")                      = 0
> >> open("testfile", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> >> fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> >> close(3)                                = 0
> >> open("testfile", O_RDONLY|O_DIRECT)     = -1 EINVAL (Invalid argument)
> >> write(1, "[Errno 22] Invalid argument: 'te"..., 40) = 40
> >>
> >> But I see from dmesg oplocks are being granted.
> >>
> > Sorry, I might not have been clear. I meant that in principle, we could
> > probably fix the cifs client to do O_DIRECT properly now that we have
> > the strictcache code. It doesn't do that currently, of course...
> 
> Ah, ok. What does it take to fix the cifs client? I could take a look.
> Are there pointers to discussion threads on this topic?
> 

No real discussion on this so far, just something I had considered when
Pavel did the strictcache code. cache=strict (and cache=none for that
matter) basically does dio already when it doesn't have an oplock. When
cache=strict is in force you can just make an O_DIRECT open not request
one at all and you're basically done.

There are some things to be worked out:

1) what to do about cache=loose? Should an O_DIRECT open make it use a
different codepath?

2) what to do about mmap? Currently we fall back to buffered I/O
codepaths for mmap even when we don't have an oplock. Should we do
anything different if someone tries to mmap an O_DIRECT file?

One of the complicating factors is that we have different sets of
file_operations for different cache= values. If you unify those, it
might make it easier to do all of this.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
