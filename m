From: =?iso-8859-2?q?=A3ukasz_Ma=B6ko?= <masko-/XNhcdyn+gCn9IrpMBEE/Q@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Fri, 20 Jan 2012 22:24:15 +0100
Message-ID: <201201202224.16170@laptok.ed.pl>
References: <20120119090752.9b7aea6c.ralda@gmx.de> <20120120143235.1d4d811e@tlielax.poochiereds.net> <CAH2r5mt5KPtK_5Abz8nz_sKH3vT2h=1d7DHHBvX4BSRd37auug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt5KPtK_5Abz8nz_sKH3vT2h=1d7DHHBvX4BSRd37auug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dnia pi=B1tek, 20 stycznia 2012, napisa=B3e=B6:
[...]
> This is certainly a very troublesome device :)

It seems that it behaves like my Welland ME-752GNS which is the reason,=
 why=20
I've subscribed to this list. I have eactly the same problems with proc=
esses=20
which hang and sometimes I cannot even kill them if I don't restart my =
NAS.=20
I'm getting a bit higher transfers (on kernels 3.2.x about 11MB/s, earl=
ier=20
it was at least 2 times lower) but maybe thanks to a gigabit connection=
=2E I=20
have found that cifs_max_pendig=3D2 helps a lot, but still, not complet=
ly.

--=20
=A3ukasz Ma=B6ko                                           GG:   244149=
8    _o)
Lukasz.Masko(at)ipipan.waw.pl                                          =
 /\\
Registered Linux User #61028                                           =
_\_V
Ubuntu: staroafryka=F1skie s=B3owo oznaczaj=B1ce "Nie umiem zainstalowa=
=E6 Debiana"
