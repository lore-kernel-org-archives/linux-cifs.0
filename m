From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: ignore the "_netdev" mount option
Date: Tue, 27 Jul 2010 12:42:28 -0400
Message-ID: <20100727124228.08bce57c@tlielax.poochiereds.net>
References: <1280163930-983-1-git-send-email-jlayton@samba.org>
	<1280163930-983-3-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280163930-983-3-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 26 Jul 2010 13:05:30 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This mount options is used to clue in init scripts that the filesystem
> shouldn't be mounted until networking is available. /bin/mount also passes
> that option to the filesystem however, and cifs currently chokes on it.
> mount.nfs ignores this option -- have mount.cifs do the same.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 1ca9507..89b728c 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -133,6 +133,7 @@
>   * Values for parsing command line options.
>   */
>  #define OPT_ERROR       -1
> +#define OPT_IGNORE      0
>  #define OPT_USERS       1
>  #define OPT_USER        2
>  #define OPT_USER_XATTR  3
> @@ -842,6 +843,8 @@ static int parse_opt_token(const char *token)
>  		return OPT_RW;
>  	if (strncmp(token, "remount", 7) == 0)
>  		return OPT_REMOUNT;
> +	if (strncmp(token, "_netdev", 7) == 0)
> +		return OPT_IGNORE;
>  
>  	return OPT_ERROR;
>  }
> @@ -1140,6 +1143,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  		case OPT_REMOUNT:
>  			*filesys_flags |= MS_REMOUNT;
>  			break;
> +		case OPT_IGNORE:
> +			goto nocopy;
>  		}
>  
>  		/* check size before copying option to buffer */

merged
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
