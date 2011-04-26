From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: refactor mid finding loop in cifs_demultiplex_thread
Date: Tue, 26 Apr 2011 15:39:00 +0100
Message-ID: <17915.1303828740@redhat.com>
References: <1303819401-14789-5-git-send-email-jlayton@redhat.com> <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> ...to reduce the extreme indentation. This should introduce no
> behavioral changes.
> 
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

In fact, you could go further.  In the code you have:

> +				} else {
> +					if (!isLargeBuf) {
> ...
> +					} else {
> ...
> 					}
>  				}

That could be merged and some more indentation removed:

				} else if (!isLargeBuf) {
...
				} else {
...
				}

Though I acknowledge you may want to keep it for the logical structure.

Anyway:

Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
