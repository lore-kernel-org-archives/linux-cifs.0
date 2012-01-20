From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] mount.cifs: handle errors from rename() in del_mtab
Date: Fri, 20 Jan 2012 08:09:32 -0500
Message-ID: <20120120080932.4f49e1f9@tlielax.poochiereds.net>
References: <1326738193-18339-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326738193-18339-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 16 Jan 2012 13:23:13 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> The new del_mtab code ignored errors from rename(). Make it handle that
> error as well like it does other errors.
> 
> Cc: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index af071c1..78a4811 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1700,7 +1700,11 @@ del_mtab(char *mountpoint)
>  		goto del_mtab_error;
>  	}
>  
> -	rename(mtabtmpfile, MOUNTED);
> +	if (rename(mtabtmpfile, MOUNTED)) {
> +		fprintf(stderr, "del_mtab: error %d when renaming mtab in place\n", errno);
> +		rc = EX_FILEIO;
> +		goto del_mtab_error;
> +	}
>  
>  del_mtab_exit:
>  	unlock_mtab();

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
