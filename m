From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_ECB
Date: Fri, 3 Jun 2011 09:10:07 -0400
Message-ID: <20110603091007.7c7b9910@corrin.poochiereds.net>
References: <4DE89FFD.6040006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE89FFD.6040006-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 03 Jun 2011 14:19:01 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> When CONFIG_CRYPTO_ECB is not set, trying to mount a CIFS share with NTLM
> security resulted in mount failure with the following error:
>    "CIFS VFS: could not allocate des crypto API"
> 
> Seems like a leftover from commit 43988d7.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 1cd4c3a..66c68ab 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -7,6 +7,7 @@ config CIFS
>  	select CRYPTO_MD5
>  	select CRYPTO_HMAC
>  	select CRYPTO_ARC4
> +	select CRYPTO_ECB
>  	select CRYPTO_DES
>  	help
>  	  This is the client VFS module for the Common Internet File System

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
