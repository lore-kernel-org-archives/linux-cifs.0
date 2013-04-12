From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] setcifsacl.c: fix a bug of goto setcifsacl_facenum_ret
Date: Fri, 12 Apr 2013 06:21:07 -0400
Message-ID: <20130412062107.136b818d@corrin.poochiereds.net>
References: <1365757129-25076-1-git-send-email-penght@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365757129-25076-1-git-send-email-penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 12 Apr 2013 16:58:49 +0800
Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:

> setcifsacl_facenum_ret: is called only if attrlen is equal to -1.
> 
> Signed-off-by: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
>  setcifsacl.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/setcifsacl.c b/setcifsacl.c
> index 67dd29c..4b38459 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -822,9 +822,10 @@ cifsacl:
>  		goto setcifsacl_action_ret;
>  
>  	attrlen = setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0);
> -	if (attrlen == -1)
> +	if (attrlen == -1) {
>  		printf("%s: setxattr error: %s\n", __func__, strerror(errno));
> -	goto setcifsacl_facenum_ret;
> +		goto setcifsacl_facenum_ret;
> +	}
>  
>  	exit_plugin(plugin_handle);
>  	return 0;

Well spotted -- will merge in a day or so if no one objects.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
