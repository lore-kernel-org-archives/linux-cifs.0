From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: handle "sloppy" option appropriately
Date: Thu, 22 Mar 2012 17:16:27 +0000
Message-ID: <1332436587.2377.2.camel@localhost>
References: <1332431754-30780-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332431754-30780-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-03-22 at 11:55 -0400, Jeff Layton wrote:
> cifs.ko has historically been tolerant of options that it does not
> recognize. This is not normal behavior for a filesystem however.
> Usually, it should only do this if you mount with '-s', and autofs
> generally passes -s to the mount command to allow this behavior.
> 
> This patch makes cifs handle the option "sloppy" appropriately. If it's
> present in the options string, then the client will tolerate options
> that it doesn't recognize. If it's not present then the client will
> error out in the presence of options that it does not recognize and
> throw an error message explaining why.
> 
> There is also a companion patch being proposed for mount.cifs to make it
> append "sloppy" to the mount options when passed the '-s' flag. This also
> should (obviously) be applied on top of Sachin's conversion to the
> standard option parser.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e219cae..e845bf5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -88,7 +88,7 @@ enum {
>  	Opt_sign, Opt_seal, Opt_direct,
>  	Opt_strictcache, Opt_noac,
>  	Opt_fsc, Opt_mfsymlinks,
> -	Opt_multiuser,
> +	Opt_multiuser, Opt_sloppy,
>  
>  	/* Mount options which take numeric value */
>  	Opt_backupuid, Opt_backupgid, Opt_uid,
> @@ -167,6 +167,7 @@ static const match_table_t cifs_mount_option_tokens = {
>  	{ Opt_fsc, "fsc" },
>  	{ Opt_mfsymlinks, "mfsymlinks" },
>  	{ Opt_multiuser, "multiuser" },
> +	{ Opt_sloppy, "sloppy" },
>  
>  	{ Opt_backupuid, "backupuid=%s" },
>  	{ Opt_backupgid, "backupgid=%s" },
> @@ -1175,6 +1176,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  	short int override_gid = -1;
>  	bool uid_specified = false;
>  	bool gid_specified = false;
> +	bool sloppy = false;
> +	char *invalid = NULL;
>  	char *nodename = utsname()->nodename;
>  	char *string = NULL;
>  	char *tmp_end, *value;
> @@ -1412,6 +1415,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  		case Opt_multiuser:
>  			vol->multiuser = true;
>  			break;
> +		case Opt_sloppy:
> +			sloppy = true;
> +			break;
>  
>  		/* Numeric Values */
>  		case Opt_backupuid:
> @@ -1859,8 +1865,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  				goto cifs_parse_mount_err;
>  			break;
>  		default:
> -			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
> -						data);
> +			/*
> +			 * An option we don't recognize. Save it off for later
> +			 * if we haven't already found one
> +			 */
> +			if (!invalid)
> +				invalid = data;
>  			break;
>  		}
>  		/* Free up any allocated string */
> @@ -1868,6 +1878,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  		string = NULL;
>  	}
>  
> +	if (!sloppy && invalid) {
> +		printk(KERN_ERR "CIFS: Unknown mount option \"%s\"\n", invalid);
> +		goto cifs_parse_mount_err;
> +	}
> +
>  #ifndef CONFIG_KEYS
>  	/* Muliuser mounts require CONFIG_KEYS support */
>  	if (vol->multiuser) {

Acked-By: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
