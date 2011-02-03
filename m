From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Possible slab memory corruption while updating
 extended stats
Date: Thu, 3 Feb 2011 15:10:42 -0500
Message-ID: <20110203151042.6b8469e3@barsoom.rdu.redhat.com>
References: <1296762959-24783-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296762959-24783-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  3 Feb 2011 13:55:59 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Updating extended statistics here can cause slab memory corruption
> when callback functions frees (mid_entry) slab memory.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 945b220..f3c5ea6 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -635,9 +635,6 @@ multi_t2_fnd:
>  				mid_entry->midState = MID_RESPONSE_RECEIVED;
>  				list_del_init(&mid_entry->qhead);
>  				mid_entry->callback(mid_entry);
> -#ifdef CONFIG_CIFS_STATS2
> -				mid_entry->when_received = jiffies;
> -#endif
>  				break;
>  			}
>  			mid_entry = NULL;
> -- 
> 1.6.0.2
> 


Good catch.

Would it be better to move this up above the call to "callback" instead
of eliminating it? I'm not so sure about the value of those stats, but
it seems like they'll be wrong if you eliminate those lines altogether.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
