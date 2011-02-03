From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Possible slab memory corruption while updating
 extended stats (repost)
Date: Thu, 3 Feb 2011 16:04:00 -0500
Message-ID: <20110203160400.129c0129@tlielax.poochiereds.net>
References: <1296765078-25531-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296765078-25531-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  3 Feb 2011 14:31:18 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Updating extended statistics here can cause slab memory corruption
> if a callback function frees slab memory (mid_entry).
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 945b220..1f32a28 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -633,11 +633,11 @@ incomplete_rcv:
>  				mid_entry->largeBuf = isLargeBuf;
>  multi_t2_fnd:
>  				mid_entry->midState = MID_RESPONSE_RECEIVED;
> -				list_del_init(&mid_entry->qhead);
> -				mid_entry->callback(mid_entry);
>  #ifdef CONFIG_CIFS_STATS2
>  				mid_entry->when_received = jiffies;
>  #endif
> +				list_del_init(&mid_entry->qhead);
> +				mid_entry->callback(mid_entry);
>  				break;
>  			}
>  			mid_entry = NULL;

Looks good.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
