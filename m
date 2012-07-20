From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Use errno instead of having unknown error
Date: Fri, 20 Jul 2012 14:50:51 -0400
Message-ID: <20120720145051.79fe66e1@tlielax.poochiereds.net>
References: <1342690708-15087-1-git-send-email-luk@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342690708-15087-1-git-send-email-luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 19 Jul 2012 11:38:28 +0200
Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:

> When access() fails, use errno for a sensible error message.
> 
> Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
> ---
>  mount.cifs.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 6f3f382..f47f416 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -590,6 +590,7 @@ static int open_cred_file(char *file_name,
>  	i = access(file_name, R_OK);
>  	if (i) {
>  		toggle_dac_capability(0, 0);
> +		i = errno;
>  		goto return_i;
>  	}
>  

Merged...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
