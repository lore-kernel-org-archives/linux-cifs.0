From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu
 12.04)
Date: Tue, 22 May 2012 09:32:58 -0400
Message-ID: <20120522093258.053bb179@corrin.poochiereds.net>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
	<20120519083749.513816b0@tlielax.poochiereds.net>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777F@AUSX7MCPS302.AMER.DELL.COM>
	<CAH2r5msirj=AYseNMp7YFuCCYzv42ruLfDa-Ac0+DGg5yDt3WQ@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F7780@AUSX7MCPS302.AMER.DELL.COM>
	<B284DF0EE72EBA488F6C7ED035128BF5105B607C12@AUSX7MCPS302.AMER.DELL.COM>
	<20120521114454.7a58efb7@corrin.poochiereds.net>
	<CAP6d-HW0izrXAXHWaP2vANhf12WHEKCB2Hqi1F6gDF1ct0yVfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott_Purcell-8PEkshWhKlo@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wood <esiotrot-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAP6d-HW0izrXAXHWaP2vANhf12WHEKCB2Hqi1F6gDF1ct0yVfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 22 May 2012 15:24:56 +0200
Michael Wood <esiotrot-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 21 May 2012 17:44, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Mon, 21 May 2012 09:59:44 -0500
> > <Scott_Purcell-DYMqY+WieiM@public.gmane.org> wrote:
> >
> >> Early responses are not encouraging. =C2=A0It sounds like this was=
 not an accidently happening, but they *intend* to obscure the root lev=
el of the share.
> >>
> >> Might it work to try to downgrade my Samba installation to a versi=
on prior to the introduction of this bug? =C2=A0If so, do you know whic=
h version would be the latest to still work?
> >>
> >
> > No, it was not intentional, just not simple to fix.
>=20
> I think you misinterpreted Scott's message :)
>=20
> I read it to mean that the people who set up his NAS intended for the
> root of the share to be "obscured".  Not that the cifsfs developers
> intended to break things.
>=20

Yes, he mailed that to me privately later. He also asked whether
downgrading the client's kernel might help here. It might, but you'll
need to go pretty far back -- pre-3.0 or so...

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
