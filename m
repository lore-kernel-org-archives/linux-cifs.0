From: =?iso-8859-2?q?=A3ukasz_Ma=B6ko?= <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org>
Subject: Re: How to deal with such hanging processes?
Date: Sat, 28 Jan 2012 15:50:10 +0100
Message-ID: <201201281550.10554@laptok.ed.pl>
References: <201201272133.35986@laptok.ed.pl> <20120128073021.4eca547e@tlielax.poochiereds.net> <20120128140830.2b48a0c8.ralda@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120128140830.2b48a0c8.ralda-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dnia sobota, 28 stycznia 2012, ralda-Mmb7MZpHnFY@public.gmane.org napisa=B3:
[...]
> That cifs_max_pending=3D2 module parameter helps a lot on my side. It=
 not
> only avoids many cases the cifs process gets stuck it even leads to
> the interesting behavior that such processes vanish (accept the kill)
> after a couple of minutes. In those cases the device even return to a
> working state without an reboot. After that you may unmount normal or
> continue to access the NAS device. Awesome those stuck periods but
> better than having to reboot. Especially as those collisions happen
> much less than without the module parameter.

Exactly. Same for me.
--=20
=A3ukasz Ma=B6ko                                           GG:   244149=
8    _o)
Lukasz.Masko(at)ipipan.waw.pl                                          =
 /\\
Registered Linux User #61028                                           =
_\_V
Ubuntu: staroafryka=F1skie s=B3owo oznaczaj=B1ce "Nie umiem zainstalowa=
=E6 Debiana"
