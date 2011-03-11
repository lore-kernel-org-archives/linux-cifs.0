From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Fri, 11 Mar 2011 06:53:09 -0500
Message-ID: <20110311065309.4e14afd6@tlielax.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
	<20110309185427.7858c29b@corrin.poochiereds.net>
	<AANLkTi=pXHjE6tNMm0_nO=Cn3nGH8oZ6Xhm1STh8x1Xe@mail.gmail.com>
	<20110309203044.4fd0498e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110309203044.4fd0498e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Mar 2011 20:30:44 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > 
> > But ... we can stop writeback as soon as kernel_sendmsg returns - once
> > we return from kernel_sendmsg the buffers can (and often will) be
> > freed so we know those pages could not still be used by tcp  (below
> > cifs) once kernel_sendmsg returns.  We can minimize the delay further
> > by making sure we set TCP_NODELAY on the socket (we probably ought to
> > make that the default instead of an option).
> > 
> 
> That's not correct. A return from kernel_sendmsg just means that the
> data has been buffered up, not that it has been sent and acked. We
> shouldn't use that as an indicator to mean that the pages no longer
> need to be stable.
> 

Correction...

Steve is correct that we have no need to keep the page stable after
kernel_sendmsg returns. That codepath copies the data to from the iovec
to the send buffer. I got kernel_sendmsg mixed up with kernel_sendpages.
NFS uses both, depending on how the xdr buffer is layed out.

Eventually we should probably consider moving cifs to use ->sendpage
for writes instead, which would allow us to do sends directly out of
the pagecache. To do that though, we would need to keep the pages
stable until the write is complete, or at least until it has been
ACK'ed (if we can work out a way to do that).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
