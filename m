From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cifs: sanitize length checking in coalesce_t2 (try #2)
Date: Wed, 27 Apr 2011 17:37:12 +0100
Message-ID: <13543.1303922232@redhat.com>
References: <1303905796-28087-1-git-send-email-jlayton@redhat.com> <17747.1303828052@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303905796-28087-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> +	/* don't allow buffer to overflow */
> +	if (byte_count > CIFSMaxBufSize)
> +		return -ENOBUFS;

Shouldn't that be EPROTO too?  (ENOBUFS would seem to be wrong anyway).

> +	if (total_in_buf & USHRT_MAX)
> +	if (byte_count & USHRT_MAX)

Use '>' rather than '&'.  '&' is wrong without a '~'.

David
