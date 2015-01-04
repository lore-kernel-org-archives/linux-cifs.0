From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Mon, 5 Jan 2015 08:35:38 +1100
Message-ID: <20150104213538.GA19906@gondor.apana.org.au>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>,
	"maintainer:X86 ARCHITECTURE..." <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Rahul Bedarkar <rahulbedarkar89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Thomas Pugliese <thomas.pugliese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>,
	"open list:CRYPTO API" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:CERTIFIED WIRELES..." <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:COMMON INTERNET F..." <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"moderated list:COMMON INTERNET F..."
	<samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Giel van Schijndel <me-sZ9Uef1cvPWHXe+LvDLADg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1420394744-20268-1-git-send-email-me-sZ9Uef1cvPWHXe+LvDLADg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jan 04, 2015 at 07:05:40PM +0100, Giel van Schijndel wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear locally allocated/owned buffers. memset(0) may be optimized away.
> 
> All of the affected buffers contain sensitive data, key material or
> derivatives of one of those two.

Nack.
 
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index 8fad72f..b616e63 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -164,7 +164,7 @@ static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
>  		dst[i] = cpu_to_be32(sctx->state[i]);
>  
>  	/* Wipe context */
> -	memset(sctx, 0, sizeof(*sctx));
> +	memzero_explicit(sctx, sizeof(*sctx));

sctx does not point to stack memory so this is bogus.

Only stack memory cleared just before it goes out of scope needs
memzero_explicit.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
