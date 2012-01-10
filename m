From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: allow admins to specify an alternate krb5.conf
 file
Date: Tue, 10 Jan 2012 13:37:31 -0500
Message-ID: <20120110133731.703e891b@tlielax.poochiereds.net>
References: <1326220007-527-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326220007-527-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Jan 2012 13:26:47 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This was actually requested by the Red Hat QA group, who sometimes work
> with multiple krb5.conf files when testing.
> 
> Requested-by: Marko Myllynen <myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.8.in |    8 +++++++-
>  cifs.upcall.c    |   13 ++++++++++---
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> index 0d79a99..3ae0562 100644
> --- a/cifs.upcall.8.in
> +++ b/cifs.upcall.8.in
> @@ -22,7 +22,7 @@
>  cifs.upcall \- Userspace upcall helper for Common Internet File System (CIFS)
>  .SH "SYNOPSIS"
>  .HP \w'\ 'u
> -cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-uid|\-l] {keyid}
> +cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-uid|\-l] [--krb5conf=/path/to/krb5.conf|-k /path/to/...] {keyid}
>  .SH "DESCRIPTION"
>  .PP
>  This tool is part of the cifs-utils suite\&.
> @@ -38,6 +38,12 @@ for a particular key type\&. While it can be run directly from the command\-line
>  This option is deprecated and is currently ignored\&.
>  .RE
>  .PP
> +\--krb5conf=/path/to/krb5.conf|-k /path/to/krb5.conf
> +.RS 4
> +This option allows administrators to set an alternate location for the
> +krb5.conf file that cifs.upcall will use.
> +.RE
> +.PP
>  \-\-trust\-dns|\-t
>  .RS 4
>  With krb5 upcalls, the name used as the host portion of the service principal defaults to the hostname portion of the UNC\&. This option allows the upcall program to reverse resolve the network address of the server in order to get the hostname\&.
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index f560d21..0d222cb 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -759,12 +759,13 @@ lowercase_string(char *c)
>  
>  static void usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
> +	fprintf(stderr, "Usage: %s [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
>  }
>  
>  const struct option long_options[] = {
> -	{"trust-dns", 0, NULL, 't'},
> +	{"krb5conf", 1, NULL, 'k'},
>  	{"legacy-uid", 0, NULL, 'l'},
> +	{"trust-dns", 0, NULL, 't'},
>  	{"version", 0, NULL, 'v'},
>  	{NULL, 0, NULL, 0}
>  };
> @@ -792,7 +793,7 @@ int main(const int argc, char *const argv[])
>  
>  	openlog(prog, 0, LOG_DAEMON);
>  
> -	while ((c = getopt_long(argc, argv, "cltv", long_options, NULL)) != -1) {
> +	while ((c = getopt_long(argc, argv, "ck:ltv", long_options, NULL)) != -1) {
>  		switch (c) {
>  		case 'c':
>  			/* legacy option -- skip it */
> @@ -800,6 +801,12 @@ int main(const int argc, char *const argv[])
>  		case 't':
>  			try_dns++;
>  			break;
> +		case 'k':
> +			if (setenv("KRB5_CONFIG", optarg, 1) != 0) {
> +				syslog(LOG_ERR, "unable to set $KRB5_CONFIG: %d", errno);
> +				goto out;
> +			}
> +			break;
>  		case 'l':
>  			legacy_uid++;
>  			break;

Oops -- note that this is a patch to cifs.upcall.c in cifs-utils. The
"cifs:" makes it look like a kernel patch, but it isn't...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
