From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: handle the "mand" and "nomand" mount
 options
Date: Tue, 27 Jul 2010 12:42:11 -0400
Message-ID: <20100727124211.6e9e6a20@tlielax.poochiereds.net>
References: <1280163930-983-1-git-send-email-jlayton@samba.org>
	<1280163930-983-2-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280163930-983-2-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 26 Jul 2010 13:05:29 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> These are filesystem-independent mount options that get passed to
> mount.cifs too. Handle them appropriately by enabling and disabling
> MS_MANDLOCK and not handing them off to the kernel.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index c84e72d..1ca9507 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -159,6 +159,8 @@
>  #define OPT_RO         24
>  #define OPT_RW         25
>  #define OPT_REMOUNT    26
> +#define OPT_MAND       27
> +#define OPT_NOMAND     28
>  
>  
>  /* struct for holding parsed mount info for use by privleged process */
> @@ -822,6 +824,10 @@ static int parse_opt_token(const char *token)
>  		return OPT_NO_DEV;
>  	if (strncmp(token, "nobrl", 5) == 0 || strncmp(token, "nolock", 6) == 0)
>  		return OPT_NO_LOCK;
> +	if (strncmp(token, "mand", 4) == 0)
> +		return OPT_MAND;
> +	if (strncmp(token, "nomand", 6) == 0)
> +		return OPT_NOMAND;
>  	if (strncmp(token, "dev", 3) == 0)
>  		return OPT_DEV;
>  	if (strncmp(token, "noexec", 6) == 0)
> @@ -1106,6 +1112,12 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  		case OPT_NO_LOCK:
>  			*filesys_flags &= ~MS_MANDLOCK;
>  			break;
> +		case OPT_MAND:
> +			*filesys_flags |= MS_MANDLOCK;
> +			goto nocopy;
> +		case OPT_NOMAND:
> +			*filesys_flags &= ~MS_MANDLOCK;
> +			goto nocopy;
>  		case OPT_DEV:
>  			*filesys_flags &= ~MS_NODEV;
>  			break;

merged
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
