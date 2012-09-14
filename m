From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: running out of addresses is not a system
 error
Date: Fri, 14 Sep 2012 09:54:57 -0400
Message-ID: <20120914095457.7469e6a3@corrin.poochiereds.net>
References: <1347450999-25309-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, azelinka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347450999-25309-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Sep 2012 07:56:39 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This patch fixes a minor regression. It used to be that when the mount
> helper would run out of addresses that it would return EX_FAIL to
> userspace. It now returns EX_SYSERR which is incorrect. Reinstate
> the correct error code.
> 
> Reported-by: Ales Zelinka <azelinka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3fd472a..7ee859b 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -2119,7 +2119,7 @@ int main(int argc, char **argv)
>  mount_retry:
>  	if (!currentaddress) {
>  		fprintf(stderr, "Unable to find suitable address.\n");
> -		rc = EX_SYSERR;
> +		rc = EX_FAIL;
>  		goto mount_exit;
>  	}
>  	strlcpy(options, "ip=", options_size);

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
