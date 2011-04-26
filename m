From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cifs: sanitize length checking in coalesce_t2
Date: Tue, 26 Apr 2011 12:00:40 -0400
Message-ID: <20110426120040.0c39e56d@corrin.poochiereds.net>
References: <1303819401-14789-4-git-send-email-jlayton@redhat.com>
	<1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<17747.1303828052@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17747.1303828052-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 26 Apr 2011 15:27:32 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > -	__u16 byte_count, total_data_size, total_in_buf, total_in_buf2;
> > +	unsigned int byte_count, total_in_buf;
> > +	__u16 total_data_size, total_in_buf2;
> 
> There's no particular need for any of these to be __u16; I'd recommend making
> them all unsigned int or size_t.
> 

Fair enough. For those two, they can be __u16 with no problem, AFAICT.
Is there some reason that an unsigned int would be better here?

> > +	/* did this field "wrap" ? */
> > +	if (total_in_buf & ~((1<<16)-1))
> > +		return -EINVAL;
> 
> I'd recommend something more like the following:
> 
> 	/* check the server isn't offering too much data */
> 	if (total_in_buf > USHRT_MAX)
> 		return -EINVAL;
> 
> rather than calculating a mask.
> 

Ahh, didn't know about USHRT_MAX, I'll change it to use that instead.

> Also, would EPROTO be a better choice for packet parsing errors than EINVAL?
> 
> > +	/* did this field "wrap" ? */
> > +	if (byte_count & ~((1<<16)-1))
> > +		return -EINVAL;
> 
> Ditto.
> 
> David


Probably -- or EIO maybe. This error eventually gets discarded anyway
once we mark the mid as malformed, so it really doesn't matter much for
this. Still, more specific errors are better so maybe I'll change this
when I respin it.

Thanks for the review.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
