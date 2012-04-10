From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Cleanup handling of NULL value passed for a mount
 option
Date: Tue, 10 Apr 2012 13:17:15 -0400
Message-ID: <20120410131715.5764626d@corrin.poochiereds.net>
References: <201204100823.24207.chris2553@googlemail.com>
	<1334050772.2149.4.camel@localhost>
	<20120410071630.567d70cb@tlielax.poochiereds.net>
	<201204101413.27748.chris2553@googlemail.com>
	<1334064516.2149.9.camel@localhost>
	<1334077947.2149.32.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334077947.2149.32.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Apr 2012 18:12:27 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Allow blank user= and ip= mount option. Also clean up redundant
> checks for NULL values since the token parser will not actually
> match mount options with NULL values unless explicitly specified.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> 
> ---
>  fs/cifs/connect.c |   80 ++++++++++++----------------------------------------
>  1 files changed, 19 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index d81e933..6a86f3d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -109,6 +109,8 @@ enum {
>  
>  	/* Options which could be blank */
>  	Opt_blank_pass,
> +	Opt_blank_user,
> +	Opt_blank_ip,
>  
>  	Opt_err
>  };
> @@ -183,11 +185,15 @@ static const match_table_t cifs_mount_option_tokens = {
>  	{ Opt_wsize, "wsize=%s" },
>  	{ Opt_actimeo, "actimeo=%s" },
>  
> +	{ Opt_blank_user, "user=" },
> +	{ Opt_blank_user, "username=" },
>  	{ Opt_user, "user=%s" },
>  	{ Opt_user, "username=%s" },
>  	{ Opt_blank_pass, "pass=" },
>  	{ Opt_pass, "pass=%s" },
>  	{ Opt_pass, "password=%s" },
> +	{ Opt_blank_ip, "ip=" },
> +	{ Opt_blank_ip, "addr=" },
>  	{ Opt_ip, "ip=%s" },
>  	{ Opt_ip, "addr=%s" },
>  	{ Opt_unc, "unc=%s" },
> @@ -1534,15 +1540,17 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  
>  		/* String Arguments */
>  
> +		case Opt_blank_user:
> +			/* null user, ie. anonymous authentication */
> +			vol->nullauth = 1;
> +			vol->username = NULL;
> +			break;
>  		case Opt_user:
>  			string = match_strdup(args);
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				/* null user, ie. anonymous authentication */
> -				vol->nullauth = 1;
> -			} else if (strnlen(string, MAX_USERNAME_SIZE) >
> +			if (strnlen(string, MAX_USERNAME_SIZE) >
>  							MAX_USERNAME_SIZE) {
>  				printk(KERN_WARNING "CIFS: username too long\n");
>  				goto cifs_parse_mount_err;
> @@ -1611,14 +1619,15 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			}
>  			vol->password[j] = '\0';
>  			break;
> +		case Opt_blank_ip:
> +			vol->UNCip = NULL;
> +			break;
>  		case Opt_ip:
>  			string = match_strdup(args);
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				vol->UNCip = NULL;
> -			} else if (strnlen(string, INET6_ADDRSTRLEN) >
> +			if (strnlen(string, INET6_ADDRSTRLEN) >
>  						INET6_ADDRSTRLEN) {
>  				printk(KERN_WARNING "CIFS: ip address "
>  						    "too long\n");
> @@ -1636,12 +1645,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: invalid path to "
> -						    "network resource\n");
> -				goto cifs_parse_mount_err;
> -			}
> -
>  			temp_len = strnlen(string, 300);
>  			if (temp_len  == 300) {
>  				printk(KERN_WARNING "CIFS: UNC name too long\n");
> @@ -1670,11 +1673,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: invalid domain"
> -						    " name\n");
> -				goto cifs_parse_mount_err;
> -			} else if (strnlen(string, 256) == 256) {
> +			if (strnlen(string, 256) == 256) {
>  				printk(KERN_WARNING "CIFS: domain name too"
>  						    " long\n");
>  				goto cifs_parse_mount_err;
> @@ -1693,11 +1692,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: srcaddr value not"
> -						    " specified\n");
> -				goto cifs_parse_mount_err;
> -			} else if (!cifs_convert_address(
> +			if (!cifs_convert_address(
>  					(struct sockaddr *)&vol->srcaddr,
>  					string, strlen(string))) {
>  				printk(KERN_WARNING "CIFS:  Could not parse"
> @@ -1710,11 +1705,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: Invalid path"
> -						    " prefix\n");
> -				goto cifs_parse_mount_err;
> -			}
>  			temp_len = strnlen(string, 1024);
>  			if (string[0] != '/')
>  				temp_len++; /* missing leading slash */
> @@ -1742,11 +1732,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: Invalid iocharset"
> -						    " specified\n");
> -				goto cifs_parse_mount_err;
> -			} else if (strnlen(string, 1024) >= 65) {
> +			if (strnlen(string, 1024) >= 65) {
>  				printk(KERN_WARNING "CIFS: iocharset name "
>  						    "too long.\n");
>  				goto cifs_parse_mount_err;
> @@ -1771,11 +1757,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: No socket option"
> -						    " specified\n");
> -				goto cifs_parse_mount_err;
> -			}
>  			if (strnicmp(string, "TCP_NODELAY", 11) == 0)
>  				vol->sockopt_tcp_nodelay = 1;
>  			break;
> @@ -1784,12 +1765,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: Invalid (empty)"
> -						    " netbiosname\n");
> -				break;
> -			}
> -
>  			memset(vol->source_rfc1001_name, 0x20,
>  				RFC1001_NAME_LEN);
>  			/*
> @@ -1817,11 +1792,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: Empty server"
> -					" netbiosname specified\n");
> -				break;
> -			}
>  			/* last byte, type, is 0x20 for servr type */
>  			memset(vol->target_rfc1001_name, 0x20,
>  				RFC1001_NAME_LEN_WITH_NULL);
> @@ -1848,12 +1818,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				cERROR(1, "no protocol version specified"
> -					  " after vers= mount option");
> -				goto cifs_parse_mount_err;
> -			}
> -
>  			if (strnicmp(string, "cifs", 4) == 0 ||
>  			    strnicmp(string, "1", 1) == 0) {
>  				/* This is the default */
> @@ -1868,12 +1832,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (!*string) {
> -				printk(KERN_WARNING "CIFS: no security flavor"
> -						    " specified\n");
> -				break;
> -			}
> -
>  			if (cifs_parse_security_flavors(string, vol) != 0)
>  				goto cifs_parse_mount_err;
>  			break;

Looks good.

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
