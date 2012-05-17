From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: don't send a mandatory ver= option to the
 kernel
Date: Thu, 17 May 2012 06:48:22 -0400
Message-ID: <20120517064822.61b0d728@corrin.poochiereds.net>
References: <1336763001-7315-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336763001-7315-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 May 2012 15:03:21 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Traditionally, this ver= option was used to specify the "options
> version" that we're passing in. It has always been set to '1' though
> and we have never changed that.
> 
> Eventually we want to have a ver= (or vers=) option that allows users
> to specify the SMB version that they want to use to talk to the server.
> 
> At that point, this option will just get in the way. Let's go ahead
> and remove it now in preparation for that day.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |   20 +++++++-------------
>  1 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 0408158..3041987 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -100,12 +100,6 @@
>  #define MAX_DOMAIN_SIZE 64
>  
>  /*
> - * value of the ver= option that gets passed to the kernel. Used to indicate
> - * behavioral changes introduced in the mount helper.
> - */
> -#define OPTIONS_VERSION "1"
> -
> -/*
>   * mount.cifs has been the subject of many "security" bugs that have arisen
>   * because of users and distributions installing it as a setuid root program
>   * before it had been audited for security holes. The default behavior is
> @@ -1833,21 +1827,21 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>  			goto assemble_exit;
>  	}
>  
> -	/* copy in ver= string. It's not really needed, but what the hell */
> -	if (*parsed_info->options)
> -		strlcat(parsed_info->options, ",", sizeof(parsed_info->options));
> -	strlcat(parsed_info->options, "ver=", sizeof(parsed_info->options));
> -	strlcat(parsed_info->options, OPTIONS_VERSION, sizeof(parsed_info->options));
> -
>  	/* copy in user= string */
>  	if (parsed_info->got_user) {
> -		strlcat(parsed_info->options, ",user=",
> +		if (*parsed_info->options)
> +			strlcat(parsed_info->options, ",",
> +				sizeof(parsed_info->options));
> +		strlcat(parsed_info->options, "user=",
>  			sizeof(parsed_info->options));
>  		strlcat(parsed_info->options, parsed_info->username,
>  			sizeof(parsed_info->options));
>  	}
>  
>  	if (*parsed_info->domain) {
> +		if (*parsed_info->options)
> +			strlcat(parsed_info->options, ",",
> +				sizeof(parsed_info->options));
>  		strlcat(parsed_info->options, ",domain=",
>  			sizeof(parsed_info->options));
>  		strlcat(parsed_info->options, parsed_info->domain,

Committed...
-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
