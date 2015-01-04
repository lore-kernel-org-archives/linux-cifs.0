From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Mon, 5 Jan 2015 10:36:37 +1100
Message-ID: <20150104233637.GA20757@gondor.apana.org.au>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <20150104213538.GA19906@gondor.apana.org.au>
 <20150104224909.GB4806@salidar.dom.custoft.eu>
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
	<samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Giel van Schijndel <me-sZ9Uef1cvPWHXe+LvDLADg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150104224909.GB4806-zsKMh+JvXepbNiWYSlF1AbANlwIBtoSN@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jan 04, 2015 at 11:49:09PM +0100, Giel van Schijndel wrote:
>
> > sctx does not point to stack memory so this is bogus.
> > 
> > Only stack memory cleared just before it goes out of scope needs
> > memzero_explicit.
> 
> Is that because the compiler can't safely optimize memset(0) away for a
> variable with greater-than-local scope?

Exactly.  memzero_explicit is not a marker for sensitive data.
Its only purpose is to prevent the compiler from optimising away
zeroing that occurs at the end of a scope.

Daniel, we should add a comment so that people stop sending bogus
patches with memzero_explicit.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
