From: =?iso-8859-2?q?=A3ukasz_Ma=B6ko?= <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org>
Subject: Re: How to deal with such hanging processes?
Date: Sat, 28 Jan 2012 15:54:25 +0100
Message-ID: <201201281554.25466@laptok.ed.pl>
References: <201201272133.35986@laptok.ed.pl> <20120128073021.4eca547e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120128073021.4eca547e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dnia sobota, 28 stycznia 2012, Jeff Layton napisa=B3:
[...]
> The way to deal with them is to solve the problem that causes them to
> hang in the first place. Once they're stuck like that, there's really
> little you can do until the page lock is released. The messages from
> the ring buffer suggest that the server is sending corrupt replies to
> the requests. A network capture might help confirm that.

It is a bit hard to capture it since it is nondeterministic :-/ I'll tr=
y=20
anyway.

> Is this the same NAS that requests a maxmpx of 1? If so, the fact tha=
t
> cifs sends more than one request a time to this server might be the
> ultimate cause.

It was in another thread for a different NAS, but it seems, that it is =
the=20
same in my case.
=20
> Obviously the server should handle that situation without corrupting
> its replies, but cifs is clearly broken in this regard and shouldn't =
be
> sending more than one request at a time to such a server. I doubt
> there's anything you can do until Steve fixes that bug.

So I'm waiting patiently, that's all I can do :-)

--=20
=A3ukasz Ma=B6ko                                                       =
     _o)
Lukasz.Masko(at)ipipan.waw.pl                                          =
 /\\
Registered Linux User #61028                                           =
_\_V
