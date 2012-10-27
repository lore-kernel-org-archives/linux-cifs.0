From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 6/7] cifs.idmap: set a timeout on keys that it
 instantiates
Date: Sat, 27 Oct 2012 07:30:51 -0400
Message-ID: <20121027073051.26023ce7@tlielax.poochiereds.net>
References: <1351336822-16425-1-git-send-email-jlayton@samba.org>
	<1351336822-16425-7-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351336822-16425-7-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Oct 2012 07:20:21 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> ...and add a command-line option to allow the admin to tune that value.
> I think this is a better way to handle this instead of trying to set the
> timeouts in kernel space.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.idmap.8.in |  7 ++++++-
>  cifs.idmap.c    | 15 ++++++++++++++-
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
> index efec7b6..152046b 100644
> --- a/cifs.idmap.8.in
> +++ b/cifs.idmap.8.in
> @@ -22,7 +22,7 @@
>  cifs.idmap \- Userspace helper for mapping ids for Common Internet File System (CIFS)
>  .SH "SYNOPSIS"
>  .HP \w'\ 'u
> -cifs\&.idmap [\-\-version|\-v] {keyid}
> +cifs.idmap [--timeout|-t] [--version|-v] {keyid}
>  .SH "DESCRIPTION"
>  .PP
>  This tool is part of the cifs-utils suite\&.
> @@ -46,6 +46,11 @@ cifs\&.idmap works in conjuction with winbind facility of Samba suite to map own
>  In case winbind and cifs.idmap facilities are unavailable, file objects in a mounted share are assigned uid and gid of the credentials of the process that mounted the share\&. So it is strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs respectively in case services of winbind and cifs.idmap facility are unavailable\&.
>  .SH "OPTIONS"
>  .PP
> +--timeout|-t
> +.RS 4
> +Set the expiration timer, in seconds on the key. The default is 600 seconds (10 minutes). Setting this to 0 will cause the key to never expire.
> +.RE
> +.PP
>  \-\-version|\-v
>  .RS 4
>  Print version number and exit\&.
> diff --git a/cifs.idmap.c b/cifs.idmap.c
> index 9639070..0d51ff6 100644
> --- a/cifs.idmap.c
> +++ b/cifs.idmap.c
> @@ -45,6 +45,7 @@
>  static const char *prog = "cifs.idmap";
>  
>  static const struct option long_options[] = {
> +	{"timeout", 1, NULL, 't'},
>  	{"version", 0, NULL, 'v'},
>  	{NULL, 0, NULL, 0}
>  };
> @@ -221,11 +222,15 @@ int main(const int argc, char *const argv[])
>  	long rc = 1;
>  	key_serial_t key = 0;
>  	char *buf;
> +	int timeout = 600; /* default idmap cache timeout */
>  
>  	openlog(prog, 0, LOG_DAEMON);
>  
> -	while ((c = getopt_long(argc, argv, "v", long_options, NULL)) != -1) {
> +	while ((c = getopt_long(argc, argv, "t:v", long_options, NULL)) != -1) {
>  		switch (c) {
> +		case 't':
> +			timeout = atoi(optarg);
> +			break;

Doh! Just realized that I should have used the str_to_uint helper here.
I'll respin this one...

>  		case 'v':
>  			printf("version: %s\n", VERSION);
>  			goto out;
> @@ -250,6 +255,14 @@ int main(const int argc, char *const argv[])
>  		goto out;
>  	}
>  
> +	/* set timeout on key */
> +	rc = keyctl_set_timeout(key, timeout);
> +	if (rc == -1) {
> +		syslog(LOG_ERR, "unable to set key timeout: %s",
> +			strerror(errno));
> +		goto out;
> +	}
> +
>  	rc = keyctl_describe_alloc(key, &buf);
>  	if (rc == -1) {
>  		syslog(LOG_ERR, "keyctl_describe_alloc failed: %s",


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
