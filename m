From: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: How to deal with such hanging processes?
Date: Sat, 28 Jan 2012 14:08:30 +0100
Message-ID: <20120128140830.2b48a0c8.ralda@gmx.de>
References: <201201272133.35986@laptok.ed.pl>
	<20120128073021.4eca547e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?Q?=C5=81ukasz_Ma=C5=9Bko?= <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120128073021.4eca547e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hallo Jeff!

> Is this the same NAS that requests a maxmpx of 1? If so, the fact that
> cifs sends more than one request a time to this server might be the
> ultimate cause.
> 
> Obviously the server should handle that situation without corrupting
> its replies, but cifs is clearly broken in this regard and shouldn't be
> sending more than one request at a time to such a server. I doubt
> there's anything you can do until Steve fixes that bug.

That cifs_max_pending=2 module parameter helps a lot on my side. It not
only avoids many cases the cifs process gets stuck it even leads to
the interesting behavior that such processes vanish (accept the kill)
after a couple of minutes. In those cases the device even return to a
working state without an reboot. After that you may unmount normal or
continue to access the NAS device. Awesome those stuck periods but
better than having to reboot. Especially as those collisions happen
much less than without the module parameter.

--
Harald
