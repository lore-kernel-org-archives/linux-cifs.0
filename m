From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: don't pass credentials= option to the
 kernel
Date: Fri, 11 May 2012 14:12:47 -0400
Message-ID: <20120511141247.00a309c0@corrin.poochiereds.net>
References: <1335983157-4413-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335983157-4413-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  2 May 2012 14:25:57 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> We handle this option in userspace, so there's little value in also
> passing it to the kernel.
> 
> Also fix minor double-comma nit in the options string.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index c90ce3e..0408158 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1023,7 +1023,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
>  					rc, strerror(rc), value);
>  				return rc;
>  			}
> -			break;
> +			goto nocopy;
>  
>  		case OPT_UID:
>  			if (!value || !*value)
> @@ -1834,7 +1834,9 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>  	}
>  
>  	/* copy in ver= string. It's not really needed, but what the hell */
> -	strlcat(parsed_info->options, ",ver=", sizeof(parsed_info->options));
> +	if (*parsed_info->options)
> +		strlcat(parsed_info->options, ",", sizeof(parsed_info->options));
> +	strlcat(parsed_info->options, "ver=", sizeof(parsed_info->options));
>  	strlcat(parsed_info->options, OPTIONS_VERSION, sizeof(parsed_info->options));
>  
>  	/* copy in user= string */

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
