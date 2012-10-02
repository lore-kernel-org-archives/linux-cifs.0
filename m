From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH] cifs: retry kernel_sendmsg only in case of
 -EAGAIN
Date: Mon, 1 Oct 2012 21:40:17 -0400
Message-ID: <20121001214017.60f41311@corrin.poochiereds.net>
References: <506948FD.3090602@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506948FD.3090602-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 01 Oct 2012 13:10:45 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> In smb_sendv(), we seem to retry if kernel_sendmsg() returned either
> -ENOSPC or -EAGAIN. In either case after multiple attempts, we set the
> error to -EAGAIN before breaking out of the loop.
> 
> First, it is not clear to me when kernel_sendmsg() can return -ENOSPC,
> and what it would mean and why should we retry. It makes me wonder
> whether this check is part of some old code. Also, there seem to be no
> need to set the error back to -EAGAIN before we break out the loop.
> Fix this by making cifs retry only if kernel_sendmsg() returns -EAGAIN.
> 
> If the above discussion make sense, here is a patch to fix this.
> ---
> 
> Retry kernel_sendmsg() only in case of -EAGAIN and remove redundant
> error assignment.
> 
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> ---
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d9b639b..a33db4c 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -154,7 +154,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>  	while (total_len) {
>  		rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
>  				    n_vec - first_vec, total_len);
> -		if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
> +		if (rc == -EAGAIN) {
>  			i++;
>  			/*
>  			 * If blocking send we try 3 times, since each can block
> @@ -177,7 +177,6 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
>  			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
>  				cERROR(1, "sends on sock %p stuck for 15 seconds",
>  				    ssocket);
> -				rc = -EAGAIN;
>  				break;
>  			}
>  			msleep(1 << i);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

That ENOSPC has been there a long time, and I think you're correct that
it's of questionable value.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
