From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: WARN_ON_ONCE if kernel_sendmsg() returns -ENOSPC
Date: Wed, 3 Oct 2012 06:04:10 -0400
Message-ID: <20121003060410.07c30803@tlielax.poochiereds.net>
References: <506BE618.7050606@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506BE618.7050606-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 03 Oct 2012 12:45:36 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> kernel_sendmsg() is less likely to return -ENOSPC and it might be
> a bug to do so. However, in the past there might have been cases
> where a -ENOSPC was returned from a low level driver.
> 
> Add a WARN_ON_ONCE() to ensure that it is safe to assume that -ENOSPC
> is no longer returned. This -ENOSPC specific handling will be removed
> once we are sure it is no longer returned.
> 
> Also, avoid setting -ENOSPC to -EAGAIN while at it.
> 
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/transport.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d9b639b..afe000f 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -155,6 +155,10 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>  		rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
>  				    n_vec - first_vec, total_len);
>  		if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
> +			/*
> +			 * Catch if a low level driver returns -ENOSPC.
> +			 */
> +			WARN_ON_ONCE(rc == -ENOSPC);
>  			i++;
>  			/*
>  			 * If blocking send we try 3 times, since each can block
> @@ -177,7 +181,6 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>  			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
>  				cERROR(1, "sends on sock %p stuck for 15 seconds",
>  				    ssocket);
> -				rc = -EAGAIN;

Do you really want to remove this reset? This will change the behavior
if the lower levels do indeed return -ENOSPC. That will now bubble back
up to the upper levels and it will likely abort the call instead of
retrying.

I think it would be best that we add the WARN_ON_ONCE but not change
anything else. If no one reports seeing that warning fire for 2 or 3
releases then we can safely remove the -ENOSPC handling. Maybe shoot
for that in 3.10 or so?

You may want to add a comment to remind us to revisit that for the 3.10
cycle.

>  				break;
>  			}
>  			msleep(1 << i);

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
