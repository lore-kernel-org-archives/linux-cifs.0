From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs.upcall: use strncmp in scandir filter function
Date: Mon, 27 Aug 2012 09:11:43 -0400
Message-ID: <20120827091143.181a8001@corrin.poochiereds.net>
References: <1345730059-2987-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345730059-2987-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Aug 2012 09:54:19 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> We want to require that the filename begins with the correct string,
> not just that it contains it somewhere.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 598a999..12d5900 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -181,10 +181,9 @@ err_cache:
>  
>  static int krb5cc_filter(const struct dirent *dirent)
>  {
> -	if (strstr(dirent->d_name, CIFS_DEFAULT_KRB5_PREFIX))
> -		return 1;
> -	else
> -		return 0;
> +	/* subtract 1 for the null terminator */
> +	return !strncmp(dirent->d_name, CIFS_DEFAULT_KRB5_PREFIX,
> +			sizeof(CIFS_DEFAULT_KRB5_PREFIX) - 1);
>  }
>  
>  static char *

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
