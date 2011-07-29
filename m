From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: check_newline returns EX_USAGE on error,
 not -1
Date: Fri, 29 Jul 2011 09:28:19 -0400
Message-ID: <20110729092819.660b14c6@tlielax.poochiereds.net>
References: <1311938070-885-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlieskov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311938070-885-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 29 Jul 2011 07:14:30 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Reported-by: Jan Lieskovsky <jlieskov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 107a5a5..aa4581f 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1419,8 +1419,7 @@ static int check_newline(const char *progname, const char *name)
>  static int check_mtab(const char *progname, const char *devname,
>  		      const char *dir)
>  {
> -	if (check_newline(progname, devname) == -1 ||
> -	    check_newline(progname, dir) == -1)
> +	if (check_newline(progname, devname) || check_newline(progname, dir))
>  		return EX_USAGE;
>  	return 0;
>  }

Given that this has (minor) security implications, I've gone ahead and
committed this to the repo.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
