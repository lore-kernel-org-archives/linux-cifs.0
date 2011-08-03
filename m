From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix missing a decrement of inFlight value
Date: Wed, 3 Aug 2011 16:14:53 -0400
Message-ID: <20110803161453.7e111bf3@tlielax.poochiereds.net>
References: <1312398738-14346-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312398738-14346-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  3 Aug 2011 23:12:18 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> if we failed on getting mid entry in cifs_call_async.
> 
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/transport.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 147aa22..c1b9c4b 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -362,6 +362,8 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>  	mid = AllocMidQEntry(hdr, server);
>  	if (mid == NULL) {
>  		mutex_unlock(&server->srv_mutex);
> +		atomic_dec(&server->inFlight);
> +		wake_up(&server->request_q);
>  		return -ENOMEM;
>  	}
>  

Good catch -- looks correct:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
