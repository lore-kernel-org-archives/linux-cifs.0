From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Thu, 24 Nov 2011 07:20:36 -0500
Message-ID: <20111124072036.0fa2ad0d@corrin.poochiereds.net>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
	<CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
	<20111109160408.44947815@corrin.poochiereds.net>
	<E1RTHe2-004p4M-7T@intern.SerNet.DE>
	<20111123150427.57a63195@tlielax.poochiereds.net>
	<CAH2r5muKFRup1BwPqGuiy=+kh-NHP4fs42CC-xpZO1ryN-JK-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?QmrDtnJu?= JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org,
	phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muKFRup1BwPqGuiy=+kh-NHP4fs42CC-xpZO1ryN-JK-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Nov 2011 23:26:08 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> We are waiting a dochelp response from ms. In addition more data on the
> perf penalty of cutting  the wsize in half would help. In any case thecmore
> serious problem is ignoring the write error not the wsize default

We know there'll be a perf penalty, and I've done some rough numbers
that show about a 30% decrease in some tests. The question is -- is it
a good idea to default to mount options that give better performance
at the expense of interoperability? My vote is no -- the defaults
should be as safe as possible, but we should allow people to set the
wsize higher if they choose. That's what the proposed patch does.

Also, most applications do not ignore write() errors, but a lot of
applications ignore errors on close(). Even the ones that do check for
errors on close() can't usually do much about it other than to log
the error or crash. It's therefore advantageous to avoid that situation
entirely if we can.

The dochelp response won't mean much, IMO. We know there are servers
with this limitation in the field, but they work with Windows. The
casual user will see that Windows works against those servers and Linux
corrupts data, and will conclude that Linux blows.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
