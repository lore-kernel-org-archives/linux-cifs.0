From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-utils PATCH 2/2] cifscreds: better error handling for
 key_add
Date: Sun, 20 Apr 2014 21:03:22 -0400
Message-ID: <20140420210322.61898c01@ipyr.poochiereds.net>
References: <1397652918-14002-1-git-send-email-jlayton@samba.org>
	<1397652918-14002-2-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397652918-14002-2-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Apr 2014 08:55:18 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> If the string buffers would have been overrun, set errno to EINVAL
> before returning. Then, have the callers report the errors to
> stderr or syslog as appropriate.
> 
> Cc: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Merged...

> ---
>  cifscreds.c     | 6 +++---
>  cifskey.c       | 8 ++++++--
>  pam_cifscreds.c | 8 ++++----
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/cifscreds.c b/cifscreds.c
> index 64d55b0cac0e..5d84c3c87873 100644
> --- a/cifscreds.c
> +++ b/cifscreds.c
> @@ -220,8 +220,8 @@ static int cifscreds_add(struct cmdarg *arg)
>  	while (currentaddress) {
>  		key_serial_t key = key_add(currentaddress, arg->user, pass, arg->keytype);
>  		if (key <= 0) {
> -			fprintf(stderr, "error: Add credential key for %s\n",
> -				currentaddress);
> +			fprintf(stderr, "error: Add credential key for %s: %s\n",
> +				currentaddress, strerror(errno));
>  		} else {
>  			if (keyctl(KEYCTL_SETPERM, key, CIFS_KEY_PERMS) < 0) {
>  				fprintf(stderr, "error: Setting permissons "
> @@ -422,7 +422,7 @@ static int cifscreds_update(struct cmdarg *arg)
>  		key_serial_t key = key_add(addrs[id], arg->user, pass, arg->keytype);
>  		if (key <= 0)
>  			fprintf(stderr, "error: Update credential key "
> -				"for %s\n", addrs[id]);
> +				"for %s: %s\n", addrs[id], strerror(errno));
>  	}
>  
>  	return EXIT_SUCCESS;
> diff --git a/cifskey.c b/cifskey.c
> index 4f01ed0e10bd..919540f549ad 100644
> --- a/cifskey.c
> +++ b/cifskey.c
> @@ -47,13 +47,17 @@ key_add(const char *addr, const char *user, const char *pass, char keytype)
>  	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
>  
>  	/* set key description */
> -	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc))
> +	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc)) {
> +		errno = EINVAL;
>  		return -1;
> +	}
>  
>  	/* set payload contents */
>  	len = snprintf(val, sizeof(val), "%s:%s", user, pass);
> -	if (len >= (int)sizeof(val))
> +	if (len >= (int)sizeof(val)) {
> +		errno = EINVAL;
>  		return -1;
> +	}
>  
>  	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
>  }
> diff --git a/pam_cifscreds.c b/pam_cifscreds.c
> index fb23117953f0..3459105045b2 100644
> --- a/pam_cifscreds.c
> +++ b/pam_cifscreds.c
> @@ -233,8 +233,8 @@ static int cifscreds_pam_add(pam_handle_t *ph, const char *user, const char *pas
>  	while (currentaddress) {
>  		key_serial_t key = key_add(currentaddress, user, password, keytype);
>  		if (key <= 0) {
> -			pam_syslog(ph, LOG_ERR, "error: Add credential key for %s",
> -				currentaddress);
> +			pam_syslog(ph, LOG_ERR, "error: Add credential key for %s: %s",
> +				currentaddress, strerror(errno));
>  		} else {
>  			if ((args & ARG_DEBUG) == ARG_DEBUG) {
>  				pam_syslog(ph, LOG_DEBUG, "credential key for \\\\%s\\%s added",
> @@ -336,8 +336,8 @@ static int cifscreds_pam_update(pam_handle_t *ph, const char *user, const char *
>  	for (id = 0; id < count; id++) {
>  		key_serial_t key = key_add(currentaddress, user, password, keytype);
>  		if (key <= 0) {
> -			pam_syslog(ph, LOG_ERR, "error: Update credential key for %s",
> -				currentaddress);
> +			pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
> +				currentaddress, strerror(errno));
>  		}
>  	}
>  
