From: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove ENOSPC handling in smb_sendv
Date: Fri, 22 Mar 2013 19:30:09 +0530
Message-ID: <514C63E9.7070502@novell.com>
References: <1363956226-10179-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363956226-10179-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 03/22/2013 06:13 PM, Jeff Layton wrote:
> To my knowledge, no one ever reported seeing this pop.


> Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>

Seemed to have missed Cc Tag.

> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index cf8bf69..653bf26 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -179,13 +179,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
>  		 */
>  		rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
>  				    n_vec - first_vec, remaining);
> -		if (rc == -ENOSPC || rc == -EAGAIN) {
> -			/*
> -			 * Catch if a low level driver returns -ENOSPC. This
> -			 * WARN_ON will be removed by 3.10 if no one reports
> -			 * seeing this.
> -			 */
> -			WARN_ON_ONCE(rc == -ENOSPC);
> +		if (rc == -EAGAIN) {
>  			i++;
>  			if (i >= 14 || (!server->noblocksnd && (i > 2))) {
>  				cifs_dbg(VFS, "sends on sock %p stuck for 15 seconds\n",
> 

Agreed. I have not seen any reports too. Looks good to me.

Acked-by: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
