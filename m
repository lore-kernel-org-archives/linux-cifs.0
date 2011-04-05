From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: only convert '\' to '/' for dev_name
Date: Tue, 5 Apr 2011 16:06:36 -0700
Message-ID: <20110405160636.1e956ecf@corrin.poochiereds.net>
References: <20110405085147.22dc6829@corrin.poochiereds.net>
	<1302042408-10579-1-git-send-email-luk@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302042408-10579-1-git-send-email-luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  6 Apr 2011 00:26:48 +0200
Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:

> When dev_name is constructed by combining slashes with the different
> parsed_mount_info fields, there can be an unnecessary appended slash
> compared to the original device string. So only convert backslashes
> to slashes to get the device name from the original device string.
> 
> Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
> ---
>  mount.cifs.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 8e1e32b..2cec7e4 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1824,10 +1824,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	/* lengths of different strings + slashes + trailing \0 */
> -	dev_len = strnlen(parsed_info->host, sizeof(parsed_info->host)) +
> -	    strnlen(parsed_info->share, sizeof(parsed_info->share)) +
> -	    strnlen(parsed_info->prefix, sizeof(parsed_info->prefix)) +
> -	    2 + 1 + 1 + 1;
> +	dev_len = strlen(orig_dev) + 1;
>  	dev_name = calloc(dev_len, 1);
>  	if (!dev_name) {
>  		rc = EX_SYSERR;
> @@ -1835,12 +1832,10 @@ int main(int argc, char **argv)
>  	}
>  
>  	/* rebuild device name with forward slashes */
> -	strlcpy(dev_name, "//", dev_len);
> -	strlcat(dev_name, parsed_info->host, dev_len);
> -	strlcat(dev_name, "/", dev_len);
> -	strlcat(dev_name, parsed_info->share, dev_len);
> -	strlcat(dev_name, "/", dev_len);
> -	strlcat(dev_name, parsed_info->prefix, dev_len);
> +	strlcpy(dev_name, orig_dev, dev_len);
> +	while (c = strcspn(dev_name, "\\") < dev_len - 1) {
> +		dev_name[c] = '/';
> +	}
>  
>  	currentaddress = parsed_info->addrlist;
>  	nextaddress = strchr(currentaddress, ',');

Uh, no. That doesn't solve your problem. Imagine your fstab contains a
UNC line this:

    \\\\server\\share

Then you're back to the same issue -- the devname in /proc/mounts
doesn't match the one in fstab. 

I think you just want to pass in orig_dev to mount() as-is (and maybe
get rid of dev_name altogether). The fact that the kernel doesn't print
'\\' sanely in /proc/mounts is a separate (but related) issue, but
passing in the raw devname directly is the most future-proof solution
and shouldn't make the current situation any worse.
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
