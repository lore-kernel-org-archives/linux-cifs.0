From: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Subject: Re: UNS: Re: Data corruption problem
Date: Fri, 18 Feb 2011 15:49:50 -0600
Message-ID: <20110218214950.GG25484@solid-constructs.com>
References: <20110211051458.GD27051@solid-constructs.com>
 <20110218183003.GF25484@solid-constructs.com>
 <20110218154552.7cf091a8@corrin.poochiereds.net>
Reply-To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110218154552.7cf091a8-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 18, 2011 at 03:45:52PM -0500, Jeff Layton wrote:
> I asked before, but I don't think you ever gave a conclusive answer...
>
> Did the kernel report an error when you did a fsync() or close()? I
> suspect that it did, but sadly a lot of programs don't bother to check
> for that (usually because they're not really able to deal with it).

the write is in java and is FileOutputStream.write() which returns void
implying that any failure will come as a thrown exception, which is
caught 2 lines down and stack trace dumped and then break() is called so
we would immediately stop writing.  Since the files continue past the
bad data, no error occurs during write().

But, I just found this:

          try {
              datain.close();
              dataout.close();
          } catch (IOException e) {
              // Do nothing
          }

I'll fix the code and have the tests rerun over the weekend or Monday
and see if we get any exceptions from close().

> >     From a Linux client (hostname: acorn):
> >     Feb 17 16:54:30 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
> >     Feb 17 16:57:10 acorn kernel:  CIFS VFS: No response to cmd 47 mid 46382
> >     Feb 17 16:57:10 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
> >     Feb 17 16:57:16 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
> >     Feb 17 16:57:31 acorn kernel:  CIFS VFS: No response for cmd 50 mid 46388
> >     Feb 17 16:59:52 acorn kernel:  CIFS VFS: No response to cmd 47 mid 64873
> >     Feb 17 16:59:52 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
> >     Feb 17 16:59:53 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
>
> Those mean that calls to the server were occasionally timing out.
> That's not terribly unusual under heavy load. Until very recently when
> that happened, the kernel would treat that like a hard error and would
> disconnect the socket.
>
> You may want to test something more recent (like 2.6.38-rc5) to see if
> the problems go away with that. Since you mention you're using CentOS
> you could also open a bug at bugzilla.redhat.com and I'll try to look
> at it when I get time.
>
> If you have a RH support contract you may also want to open a support
> case with this problem which would allow me to give it more priority.

Thank you.  I'll be back :)

--

Wayne Walker
wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org
(512) 633-8076
Senior Consultant
Solid Constructs, LLC

> A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > > A: Top-posting.
> > > > Q: What is the most annoying thing in e-mail?
