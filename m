From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_MD4
Date: Mon, 31 Jan 2011 19:29:10 +0530
Message-ID: <4D46C02E.6080308@suse.de>
References: <4D469C99.9050905@suse.de> <1296481296-13270-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296481296-13270-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/31/2011 07:11 PM, Jeff Layton wrote:
> Recently CIFS was changed to use the kernel crypto API for MD4 hashes,
> but the Kconfig dependencies were not changed to reflect this.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

The patch fixed the problem for me.

Reported-and-Tested-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 27917a5..023d11b 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -3,6 +3,7 @@ config CIFS
>  	depends on INET
>  	select NLS
>  	select CRYPTO
> +	select CRYPTO_MD4
>  	select CRYPTO_MD5
>  	select CRYPTO_HMAC
>  	select CRYPTO_ARC4
