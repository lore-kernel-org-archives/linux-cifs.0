From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Use original device string all the way
Date: Fri, 8 Apr 2011 14:14:49 -0400
Message-ID: <20110408141449.6e2ff04c@corrin.poochiereds.net>
References: <20110405160636.1e956ecf@corrin.poochiereds.net>
	<1302079615-14411-1-git-send-email-luk@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302079615-14411-1-git-send-email-luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  6 Apr 2011 10:46:55 +0200
Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:

> Don't construct a device name, but use the original device string
> to mount so the device name in /proc/mounts matches the one in
> /etc/fstab.
> 
> Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
> ---
>  mount.cifs.c |   27 +++------------------------
>  1 files changed, 3 insertions(+), 24 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 8e1e32b..29b0d4c 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1673,12 +1673,11 @@ int main(int argc, char **argv)
>  	char *orgoptions = NULL;
>  	char *mountpoint = NULL;
>  	char *options = NULL;
> -	char *dev_name = NULL, *orig_dev = NULL;
> +	char *orig_dev = NULL;
>  	char *currentaddress, *nextaddress;
>  	int rc = 0;
>  	int already_uppercased = 0;
>  	size_t options_size = MAX_OPTIONS_LEN;
> -	size_t dev_len;
>  	struct parsed_mount_info *parsed_info = NULL;
>  	pid_t pid;
>  	const char *fstype;
> @@ -1823,25 +1822,6 @@ int main(int argc, char **argv)
>  		goto mount_exit;
>  	}
>  
> -	/* lengths of different strings + slashes + trailing \0 */
> -	dev_len = strnlen(parsed_info->host, sizeof(parsed_info->host)) +
> -	    strnlen(parsed_info->share, sizeof(parsed_info->share)) +
> -	    strnlen(parsed_info->prefix, sizeof(parsed_info->prefix)) +
> -	    2 + 1 + 1 + 1;
> -	dev_name = calloc(dev_len, 1);
> -	if (!dev_name) {
> -		rc = EX_SYSERR;
> -		goto mount_exit;
> -	}
> -
> -	/* rebuild device name with forward slashes */
> -	strlcpy(dev_name, "//", dev_len);
> -	strlcat(dev_name, parsed_info->host, dev_len);
> -	strlcat(dev_name, "/", dev_len);
> -	strlcat(dev_name, parsed_info->share, dev_len);
> -	strlcat(dev_name, "/", dev_len);
> -	strlcat(dev_name, parsed_info->prefix, dev_len);
> -
>  	currentaddress = parsed_info->addrlist;
>  	nextaddress = strchr(currentaddress, ',');
>  	if (nextaddress)
> @@ -1889,7 +1869,7 @@ mount_retry:
>  	if (parsed_info->verboseflag)
>  		fprintf(stderr, "\n");
>  
> -	rc = check_mtab(thisprogram, dev_name, mountpoint);
> +	rc = check_mtab(thisprogram, orig_dev, mountpoint);
>  	if (rc)
>  		goto mount_exit;
>  
> @@ -1900,7 +1880,7 @@ mount_retry:
>  
>  	if (!parsed_info->fakemnt) {
>  		toggle_dac_capability(0, 1);
> -		rc = mount(dev_name, ".", fstype, parsed_info->flags, options);
> +		rc = mount(orig_dev, ".", fstype, parsed_info->flags, options);
>  		toggle_dac_capability(0, 0);
>  		if (rc == 0)
>  			goto do_mtab;
> @@ -1948,7 +1928,6 @@ mount_exit:
>  		memset(parsed_info->password, 0, sizeof(parsed_info->password));
>  		munmap(parsed_info, sizeof(*parsed_info));
>  	}
> -	SAFE_FREE(dev_name);
>  	SAFE_FREE(options);
>  	SAFE_FREE(orgoptions);
>  	return rc;

Looks good to me, thanks.

Committed. Should make 4.10 (or whatever we'll call the next release).

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
