From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: allow fsc mount option only if
 CONFIG_CIFS_FSCACHE is set
Date: Sat, 27 Nov 2010 07:12:14 -0500
Message-ID: <20101127071214.53d9aac6@tlielax.poochiereds.net>
References: <1290601147-11392-1-git-send-email-sjayaraman@suse.de>
	<1290601147-11392-2-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290601147-11392-2-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 24 Nov 2010 17:49:05 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Currently, it is possible to specify 'fsc' mount option even if
> CONFIG_CIFS_FSCACHE has not been set. The option is being ignored silently
> while the user fscache functionality to work. Fix this by raising error when
> the CONFIG option is not set.
> 
> 
> Reported-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/connect.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 251a17c..32fa4d9 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1352,6 +1352,11 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				"supported. Instead set "
>  				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
>  		} else if (strnicmp(data, "fsc", 3) == 0) {
> +#ifndef CONFIG_CIFS_FSCACHE
> +			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE"
> +				  "kernel config option set");
> +			return 1;
> +#endif
>  			vol->fsc = true;
>  		} else if (strnicmp(data, "mfsymlinks", 10) == 0) {
>  			vol->mfsymlinks = true;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
