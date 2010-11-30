From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 14:56:08 -0500
Message-ID: <20101130145608.59840ea1@corrin.poochiereds.net>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
	<alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>
	<AANLkTinwtjkL_Exr57wDjRiKQTzVFwjuv=kBOw7s5mgS@mail.gmail.com>
	<alpine.DEB.2.00.1011301809050.31075@awakenings.cable.ziggo.nl>
	<AANLkTin3-k4AJRYvL4p8VQqvnnL5mLJJZXNf5mC1RBKg@mail.gmail.com>
	<alpine.DEB.2.00.1011301827580.31075@awakenings.cable.ziggo.nl>
	<AANLkTinneo5HQxeOoCKVXyBZ2_i0AYWj9gqauBWoVAhn@mail.gmail.com>
	<alpine.DEB.2.00.1011301852040.31075@awakenings.cable.ziggo.nl>
	<20101130143747.1fabcc37@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130143747.1fabcc37-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010 14:37:47 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 30 Nov 2010 18:56:49 +0100 (CET)
> Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote:
> 
> > On Tue, 30 Nov 2010, Shirish Pargaonkar wrote:
> > 
> > > Wondering why the very same cifs client does not encounter this error against
> > > a Windows 2008 server but does against a Windows 2003 server!
> > > Perhaps a Windows client also runs into this error against a Windows 2003 server
> > > but does handle/resolve it.
> > 
> > Well from the kernel logs, it looks like the kernel does try to handle 
> > it, but fails when trying to resolve a servername that still has part of 
> > the share name attached to it.
> > 
> > Look:
> > 
> >   fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 261  Offset 56
> >   fs/cifs/cifssmb.c: num_referrals: 2 dfs flags: 0x3 ...
> >   cifs.upcall: key description: dns_resolver;0;0;3f000000;FOXDFT13\C
> >   cifs.upcall: unable to resolve hostname: FOXDFT13\C [Name or service not known]
> >   kernel: [94358.873289] CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: FOXDFT13\C
> >   CIFS VFS: cifs_compose_mount_options: Failed to resolve server part of 
> > \\FOXDFT13\Company to IP: -126
> > 
> > The full server + share name is "FOXDFT13\Company". It should just resolve 
> > the server name "FOXDFT13", and not leave the "\C" attached to it.
> > 
> 
> I can reproduce this too. Looks like a recent regression, but I don't
> see what broke it right offhand. 
> 

I think I found it. Does this patch fix it for you?

--------------------------[snip]----------------------------

[PATCH] cifs: fix parsing of hostname in dfs referrals

The DFS referral parsing code does a memchr() call to find the '\\'
delimiter that separates the hostname in the referral UNC from the
sharename. It then uses that value to set the length of the hostname via
pointer subtraction.  Instead of subtracting the start of the hostname
however, it subtracts the start of the UNC, which causes the code to
pass in a hostname length that is 2 bytes too long.

Regression introduced in commit 1a4240f4.

Reported-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/cifs/dns_resolve.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 0eb8702..548f062 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -66,7 +66,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* Search for server name delimiter */
 	sep = memchr(hostname, '\\', len);
 	if (sep)
-		len = sep - unc;
+		len = sep - hostname;
 	else
 		cFYI(1, "%s: probably server name is whole unc: %s",
 		     __func__, unc);
-- 
1.7.3.2



-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
