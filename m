From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Use kcalloc instead of kzalloc to allocate array
Date: Mon, 5 Dec 2011 14:27:03 -0500
Message-ID: <20111205142703.697a52c6@corrin.poochiereds.net>
References: <1322600880.1534.344.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322600880.1534.344.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 29 Nov 2011 22:08:00 +0100
Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org> wrote:

> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> ---
> 
> diff -u -p a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> --- a/fs/cifs/cifssmb.c 2011-11-13 11:07:56.343959560 +0100
> +++ b/fs/cifs/cifssmb.c 2011-11-28 19:47:15.006997976 +0100
> @@ -2140,7 +2140,7 @@ cifs_async_writev(struct cifs_writedata
>  		goto async_writev_out;
>  
>  	/* 1 iov per page + 1 for header */
> -	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
> +	iov = kcalloc(wdata->nr_pages + 1, sizeof(*iov), GFP_NOFS);
>  	if (iov == NULL) {
>  		rc = -ENOMEM;
>  		goto async_writev_out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
