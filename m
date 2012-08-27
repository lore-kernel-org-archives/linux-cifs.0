From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: silence compiler warnings about ignoring
 return code
Date: Mon, 27 Aug 2012 09:11:54 -0400
Message-ID: <20120827091154.00abff64@corrin.poochiereds.net>
References: <1345731505-3491-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345731505-3491-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Aug 2012 10:18:25 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> In this case we explicitly don't care what these functions return, so
> declare a couple of unused variables to catch the results.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index f843bb4..3fd472a 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1964,8 +1964,8 @@ restore_privs:
>  		if (dacrc)
>  			rc = rc ? rc : dacrc;
>  	} else {
> -		setfsuid(oldfsuid);
> -		setfsgid(oldfsgid);
> +		uid_t __attribute__((unused)) uignore = setfsuid(oldfsuid);
> +		gid_t __attribute__((unused)) gignore = setfsgid(oldfsgid);
>  	}
>  
>  	return rc;

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
