From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 14:37:47 -0500
Message-ID: <20101130143747.1fabcc37@corrin.poochiereds.net>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
	<alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>
	<AANLkTinwtjkL_Exr57wDjRiKQTzVFwjuv=kBOw7s5mgS@mail.gmail.com>
	<alpine.DEB.2.00.1011301809050.31075@awakenings.cable.ziggo.nl>
	<AANLkTin3-k4AJRYvL4p8VQqvnnL5mLJJZXNf5mC1RBKg@mail.gmail.com>
	<alpine.DEB.2.00.1011301827580.31075@awakenings.cable.ziggo.nl>
	<AANLkTinneo5HQxeOoCKVXyBZ2_i0AYWj9gqauBWoVAhn@mail.gmail.com>
	<alpine.DEB.2.00.1011301852040.31075@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011301852040.31075-56sTcPfcKMhJlCS1zhbguEjk2N/pv5CcZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010 18:56:49 +0100 (CET)
Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote:

> On Tue, 30 Nov 2010, Shirish Pargaonkar wrote:
> 
> > Wondering why the very same cifs client does not encounter this error against
> > a Windows 2008 server but does against a Windows 2003 server!
> > Perhaps a Windows client also runs into this error against a Windows 2003 server
> > but does handle/resolve it.
> 
> Well from the kernel logs, it looks like the kernel does try to handle 
> it, but fails when trying to resolve a servername that still has part of 
> the share name attached to it.
> 
> Look:
> 
>   fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 261  Offset 56
>   fs/cifs/cifssmb.c: num_referrals: 2 dfs flags: 0x3 ...
>   cifs.upcall: key description: dns_resolver;0;0;3f000000;FOXDFT13\C
>   cifs.upcall: unable to resolve hostname: FOXDFT13\C [Name or service not known]
>   kernel: [94358.873289] CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: FOXDFT13\C
>   CIFS VFS: cifs_compose_mount_options: Failed to resolve server part of 
> \\FOXDFT13\Company to IP: -126
> 
> The full server + share name is "FOXDFT13\Company". It should just resolve 
> the server name "FOXDFT13", and not leave the "\C" attached to it.
> 

I can reproduce this too. Looks like a recent regression, but I don't
see what broke it right offhand. 

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
