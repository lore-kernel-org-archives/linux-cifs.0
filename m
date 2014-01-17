From: Jarno Malmari <jarno.malmari-qk6XLmcB7GT1KXRcyAk9cg@public.gmane.org>
Subject: Re: Problems using mounted Windows 8.1 share
Date: Fri, 17 Jan 2014 13:20:42 +0200
Message-ID: <CAAM7EN=_ppKjbs4ZYGGYxOBRiN9wJrtxdcNzdRQB2BK+fHnPfA@mail.gmail.com>
References: <CAAM7ENkPpcDRya0T6H06tKSC17pmVRLLq8P9wsD0sUXA+qAgsg@mail.gmail.com>
	<20140115082816.279d062d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140115082816.279d062d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 15 January 2014 15:28, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> cifs.ko doesn't currently autonegotiate smb2+ connections. You have to
> explicitly request them, so you're likely still using smb1 with the
> above fstab entry.
>
> If you're getting -EHOSTDOWN errors back, then it sounds likely that
> you're losing connectivity to the server. If updating the server
> changed something then it's likely that that's where the problem is.
>
> I'd take a hard look at whether connections are getting dropped by the
> server and why...

Thanks for the pointers and steering me away from SMB. I was able to
reproduce the issue (sometimes) over a plain TCP connection. I highly
suspect a driver issue on the server machine.

Anyhow, not CIFS related. Case closed.
