From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Data corruption problem
Date: Fri, 18 Feb 2011 15:45:52 -0500
Message-ID: <20110218154552.7cf091a8@corrin.poochiereds.net>
References: <20110211051458.GD27051@solid-constructs.com>
 <20110218183003.GF25484@solid-constructs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110218183003.GF25484-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 18 Feb 2011 12:30:04 -0600
Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Feb 10, 2011 at 11:14:59PM -0600, Wayne Walker wrote:
> > First, I'm not certain whether this is samba, the linux cifs driver, or
> > something else.
> > 
> > During testing, one of my QA guys was running an inhouse program that
> > generates pseudo-random, but fully recreatable, data and writes it to
> > a file, the file is named with a name that is essentially the seed to
> > the pseudo- random stream, so, given a filename, it can read the file
> > and verify that the data is correct.
> ... snip ...
> 
> So, my QA guy has repeated the failure - 93 times, only from a linux box, so it appears to definitely be a cifs driver issue.
> 
> What can I do to gather useful info?  tcpdump on both client and server drop too many packets to be useful.
> 

I asked before, but I don't think you ever gave a conclusive answer...

Did the kernel report an error when you did a fsync() or close()? I
suspect that it did, but sadly a lot of programs don't bother to check
for that (usually because they're not really able to deal with it).

>     From a Linux client (hostname: acorn):
>     Feb 17 16:54:30 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>     Feb 17 16:57:10 acorn kernel:  CIFS VFS: No response to cmd 47 mid 46382
>     Feb 17 16:57:10 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>     Feb 17 16:57:16 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>     Feb 17 16:57:31 acorn kernel:  CIFS VFS: No response for cmd 50 mid 46388
>     Feb 17 16:59:52 acorn kernel:  CIFS VFS: No response to cmd 47 mid 64873
>     Feb 17 16:59:52 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>     Feb 17 16:59:53 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>  

Those mean that calls to the server were occasionally timing out.
That's not terribly unusual under heavy load. Until very recently when
that happened, the kernel would treat that like a hard error and would
disconnect the socket.

You may want to test something more recent (like 2.6.38-rc5) to see if
the problems go away with that. Since you mention you're using CentOS
you could also open a bug at bugzilla.redhat.com and I'll try to look
at it when I get time.

If you have a RH support contract you may also want to open a support
case with this problem which would allow me to give it more priority.

Cheers,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
