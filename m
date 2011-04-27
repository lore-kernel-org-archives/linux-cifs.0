From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cifs: sanitize length checking in coalesce_t2 (try
 #2)
Date: Wed, 27 Apr 2011 12:43:22 -0400
Message-ID: <20110427124322.1369216e@tlielax.poochiereds.net>
References: <1303905796-28087-1-git-send-email-jlayton@redhat.com>
	<17747.1303828052@redhat.com>
	<13543.1303922232@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13543.1303922232-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Apr 2011 17:37:12 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > +	/* don't allow buffer to overflow */
> > +	if (byte_count > CIFSMaxBufSize)
> > +		return -ENOBUFS;
> 
> Shouldn't that be EPROTO too?  (ENOBUFS would seem to be wrong anyway).
> 

No, CIFSMaxBufSize is a limitation of this code, and not a protocol
limitation. In this case, there's not enough space in this buffer so it
seems like the correct error.

> > +	if (total_in_buf & USHRT_MAX)
> > +	if (byte_count & USHRT_MAX)
> 
> Use '>' rather than '&'.  '&' is wrong without a '~'.
> 

Doh! Good catch -- will fix...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
