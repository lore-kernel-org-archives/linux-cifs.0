From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC][cifs-utils PATCH] cifs.upcall: allow scraping of
 KRB5CCNAME out of initiating task's /proc/<pid>/environ file
Date: Sat, 11 Feb 2017 10:16:06 -0500
Message-ID: <1486826166.4233.36.camel@samba.org>
References: <20170211134149.8135-1-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170211134149.8135-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2017-02-11 at 08:41 -0500, Jeff Layton wrote:
> Chad reported that he was seeing a regression in cifs-utils-6.6. Prior
> to that, cifs.upcall was able to find credcaches in non-default FILE:
> locations, but with the rework of that code, that ability was lost.
> 
> Unfortunately, the krb5 library design doesn't really take into account
> the fact that we might need to find a credcache in a process that isn't
> descended from the session.
> 
> When the kernel does an upcall, it passes several bits of info about the
> task that initiated the upcall. One of those things is the PID (the
> tgid, in particular). We can use that info to reach into the
> /proc/<pid>/environ file for the process, and grab whatever value of
> KRB5CCNAME is there.  This patch adds this ability to cifs.upcall.
> 
> I'm not 100% convinced that this is a good idea however, so for now,
> this is disabled unless the command line has a '-e' switch. Anyone
> wishing to play with this should edit their /etc/request-key.conf files
> accordingly.
> 

Meant to put a Reported-by: here for Chad. I'll do that before merging.

> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.8.in |  10 ++++
>  cifs.upcall.c    | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 152 insertions(+), 6 deletions(-)
> 

FWIW, this patch works as expected in cursory, light testing. This
should be superior to the earlier method where we scanned in /tmp as
well -- more efficient, and also able to find non-FILE: credcaches, as
well as ones that lie in other places besides /tmp.

My main concern is that we have to do the environ file scraping while
privileged, and that we end up trusting some info from a userland
process that triggered the upcall in KRB5CCNAME. Does this open any
potential attack vectors that I'm not considering?


diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> index 50f79d18331d..06c6d3a02c2f 100644
> --- a/cifs.upcall.8.in
> +++ b/cifs.upcall.8.in
> @@ -38,6 +38,16 @@ for a particular key type\&. While it can be run directly from the command\-line
>  This option is deprecated and is currently ignored\&.
>  .RE
>  .PP
> +\-\-env-probe|\-e
> +.RS 4
> +Allow cifs.upcall to do an environment probe to help find the credential
> +cache. This can assist the program with finding credential caches in
> +non-default locations. If this is set, then the program will attempt to
> +retrieve the KRB5CCNAME environment variable from the process that initiated
> +the upcall, and then set that in the upcall process for use when searching for
> +a credcache.
> +.RE
> +.PP
>  \--krb5conf=/path/to/krb5.conf|-k /path/to/krb5.conf
>  .RS 4
>  This option allows administrators to set an alternate location for the
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 8f146c92b4a5..1b2c6c19e39e 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -40,6 +40,7 @@
>  #include <dirent.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <fcntl.h>
>  #include <unistd.h>
>  #include <keyutils.h>
>  #include <time.h>
> @@ -154,11 +155,126 @@ err_cache:
>  	return credtime;
>  }
>  
> +#define	ENV_PATH_FMT			"/proc/%d/environ"
> +#define	ENV_PATH_MAXLEN			(6 + 10 + 8 + 1)
> +
> +#define	ENV_NAME			"KRB5CCNAME"
> +#define	ENV_PREFIX			"KRB5CCNAME="
> +#define	ENV_PREFIX_LEN			11
> +
> +#define	ENV_BUF_START			(4096)
> +#define	ENV_BUF_MAX			(131072)
> +
> +/**
> + * get_cachename_from_process_env - scrape value of $KRB5CCNAME out of the
> + * 				    initiating process' environment.
> + * @pid: initiating pid value from the upcall string
> + *
> + * Open the /proc/<pid>/environ file for the given pid, and scrape it for
> + * KRB5CCNAME entries.
> + *
> + * We start with a page-size buffer, and then progressively double it until
> + * we can slurp in the whole thing.
> + *
> + * Note that this is not entirely reliable. If the process is sitting in a
> + * container or something, then this is almost certainly not going to point
> + * where you expect.
> + *
> + * Probably it just won't work, but could a user use this to trick cifs.upcall
> + * into reading a file outside the container, by setting KRB5CCNAME in a
> + * crafty way?
> + *
> + * YMMV here.
> + */
> +static char *
> +get_cachename_from_process_env(pid_t pid)
> +{
> +	int fd, ret;
> +	ssize_t buflen;
> +	ssize_t bufsize = ENV_BUF_START;
> +	char pathname[ENV_PATH_MAXLEN];
> +	char *cachename = NULL;
> +	char *buf = NULL, *pos;
> +
> +	if (!pid) {
> +		syslog(LOG_DEBUG, "%s: pid == 0\n", __func__);
> +		return NULL;
> +	}
> +
> +	pathname[ENV_PATH_MAXLEN - 1] = '\0';
> +	ret = snprintf(pathname, ENV_PATH_MAXLEN, ENV_PATH_FMT, pid);
> +	if (ret >= ENV_PATH_MAXLEN) {
> +		syslog(LOG_DEBUG, "%s: unterminated path!\n", __func__);
> +		return NULL;
> +	}
> +
> +	syslog(LOG_DEBUG, "%s: pathname=%s\n", __func__, pathname);
> +	fd = open(pathname, O_RDONLY);
> +	if (fd < 0) {
> +		syslog(LOG_DEBUG, "%s: open failed: %d\n", __func__, errno);
> +		return NULL;
> +	}
> +retry:
> +	if (bufsize > ENV_BUF_MAX) {
> +		syslog(LOG_DEBUG, "%s: buffer too big: %d\n", __func__, errno);
> +		goto out_close;
> +	}
> +
> +	buf = malloc(bufsize);
> +	if (!buf) {
> +		syslog(LOG_DEBUG, "%s: malloc failure\n", __func__);
> +		goto out_close;
> +	}
> +
> +	buflen = read(fd, buf, bufsize);
> +	if (buflen < 0) {
> +		syslog(LOG_DEBUG, "%s: read failed: %d\n", __func__, errno);
> +		goto out_close;
> +	}
> +
> +	if (buflen == bufsize) {
> +		/* We read to the end of the buffer, double and try again */
> +		syslog(LOG_DEBUG, "%s: read to end of buffer (%zu bytes)\n",
> +					__func__, bufsize);
> +		free(buf);
> +		bufsize *= 2;
> +		if (lseek(fd, 0, SEEK_SET) < 0)
> +			goto out_close;
> +		goto retry;
> +	}
> +
> +	pos = buf;
> +	while (buflen > 0) {
> +		size_t len = strnlen(pos, buflen);
> +
> +		if (len > ENV_PREFIX_LEN &&
> +		    !memcmp(pos, ENV_PREFIX, ENV_PREFIX_LEN)) {
> +			cachename = strndup(pos + ENV_PREFIX_LEN,
> +							len - ENV_PREFIX_LEN);
> +			syslog(LOG_DEBUG, "%s: cachename = %s\n",
> +							__func__, cachename);
> +			break;
> +		}
> +		buflen -= (len + 1);
> +		pos += (len + 1);
> +	}
> +	free(buf);
> +out_close:
> +	close(fd);
> +	return cachename;
> +}
> +
>  static krb5_ccache
> -get_default_cc(void)
> +get_existing_cc(const char *env_cachename)
>  {
>  	krb5_error_code ret;
>  	krb5_ccache cc;
> +	char *cachename;
> +
> +	if (env_cachename) {
> +		if (setenv(ENV_NAME, env_cachename, 1))
> +			syslog(LOG_DEBUG, "%s: failed to setenv %d\n", __func__, errno);
> +	}
>  
>  	ret = krb5_cc_default(context, &cc);
>  	if (ret) {
> @@ -166,6 +282,14 @@ get_default_cc(void)
>  		return NULL;
>  	}
>  
> +	ret = krb5_cc_get_full_name(context, cc, &cachename);
> +	if (ret) {
> +		syslog(LOG_DEBUG, "%s: krb5_cc_get_full_name failed: %d\n", __func__, ret);
> +	} else {
> +		syslog(LOG_DEBUG, "%s: default ccache is %s\n", __func__, cachename);
> +		krb5_free_string(context, cachename);
> +	}
> +
>  	if (!get_tgt_time(cc)) {
>  		krb5_cc_close(context, cc);
>  		cc = NULL;
> @@ -173,7 +297,6 @@ get_default_cc(void)
>  	return cc;
>  }
>  
> -
>  static krb5_ccache
>  init_cc_from_keytab(const char *keytab_name, const char *user)
>  {
> @@ -664,10 +787,11 @@ lowercase_string(char *c)
>  
>  static void usage(void)
>  {
> -	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-t] [-v] [-l] key_serial\n", prog);
> +	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-e] [-t] [-v] [-l] key_serial\n", prog);
>  }
>  
>  static const struct option long_options[] = {
> +	{"env-probe", 0, NULL, 'e'},
>  	{"krb5conf", 1, NULL, 'k'},
>  	{"legacy-uid", 0, NULL, 'l'},
>  	{"trust-dns", 0, NULL, 't'},
> @@ -685,13 +809,14 @@ int main(const int argc, char *const argv[])
>  	size_t datalen;
>  	unsigned int have;
>  	long rc = 1;
> -	int c, try_dns = 0, legacy_uid = 0;
> +	int c, try_dns = 0, legacy_uid = 0, env_probe = 0;
>  	char *buf;
>  	char hostbuf[NI_MAXHOST], *host;
>  	struct decoded_args arg;
>  	const char *oid;
>  	uid_t uid;
>  	char *keytab_name = NULL;
> +	char *env_cachename = NULL;
>  	krb5_ccache ccache = NULL;
>  
>  	hostbuf[0] = '\0';
> @@ -699,11 +824,15 @@ int main(const int argc, char *const argv[])
>  
>  	openlog(prog, 0, LOG_DAEMON);
>  
> -	while ((c = getopt_long(argc, argv, "ck:K:ltv", long_options, NULL)) != -1) {
> +	while ((c = getopt_long(argc, argv, "cek:K:ltv", long_options, NULL)) != -1) {
>  		switch (c) {
>  		case 'c':
>  			/* legacy option -- skip it */
>  			break;
> +		case 'e':
> +			/* do an environmental probe to get the credcache */
> +			env_probe++;
> +			break;
>  		case 't':
>  			try_dns++;
>  			break;
> @@ -794,6 +923,12 @@ int main(const int argc, char *const argv[])
>  		goto out;
>  	}
>  
> +	/*
> +	 * Must do this before setuid, as we need ptrace perms to look at
> +	 * environ file.
> +	 */
> +	env_cachename = get_cachename_from_process_env(env_probe ? arg.pid : 0);
> +
>  	rc = setuid(uid);
>  	if (rc == -1) {
>  		syslog(LOG_ERR, "setuid: %s", strerror(errno));
> @@ -806,7 +941,7 @@ int main(const int argc, char *const argv[])
>  		goto out;
>  	}
>  
> -	ccache = get_default_cc();
> +	ccache = get_existing_cc(env_cachename);
>  	/* Couldn't find credcache? Try to use keytab */
>  	if (ccache == NULL && arg.username != NULL)
>  		ccache = init_cc_from_keytab(keytab_name, arg.username);
> @@ -959,6 +1094,7 @@ out:
>  	SAFE_FREE(arg.ip);
>  	SAFE_FREE(arg.username);
>  	SAFE_FREE(keydata);
> +	SAFE_FREE(env_cachename);
>  	syslog(LOG_DEBUG, "Exit status %ld", rc);
>  	return rc;
>  }

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
