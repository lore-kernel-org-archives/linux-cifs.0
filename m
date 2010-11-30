From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 18:04:39 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011301802250.31075@awakenings.cable.ziggo.nl>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl> <AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com> <AANLkTi=c11fiqZkOkdrdNB6KbsDLV4XSfmPjE3_SScOj@mail.gmail.com>
 <AANLkTinzJ670wHmVeW2ADhx3v0c641fkXeu--Rta9V=N@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinzJ670wHmVeW2ADhx3v0c641fkXeu--Rta9V=N@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010, Shirish Pargaonkar wrote:

> security blob in ntlmssp negotiate request between what cifs client sends
> and what Windows client sends is little different.
> cifs client does not encode OIDs for SPNEGO and NTLMSSP mech type
> in the request. That could be a cause of error at the setup you have but at
> the setup I have, Windows 2008 server seems to be OK with it.
>
> I can make that change, encode them using asn.1 and see if that helps.
> But meanwhile  if even logger is flagging anything, that would be
> useful to know.

I'm really hard trying to follow you here, but not sure I am :)

But anyway, if you would like me to test a patch, I'd be happy to.

Regards,
Robbert
