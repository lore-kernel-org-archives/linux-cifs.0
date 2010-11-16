From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Tue, 16 Nov 2010 09:26:46 -0500
Message-ID: <20101116092646.44bcf91a@corrin.poochiereds.net>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
	<20101113070012.760cf09d@tlielax.poochiereds.net>
	<AANLkTinb-A4kdumURzhkVb9oNojtfW94LPL99GwOr9MU@mail.gmail.com>
	<AANLkTim+SO4TfTJnXHnvaSjbPaoHt4k63hbVbs0gtbn9@mail.gmail.com>
	<20101114203112.5d901619@corrin.poochiereds.net>
	<AANLkTikJVcpezQ54_XrsNMEBewq15YO3iHymoQ-9xc9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikJVcpezQ54_XrsNMEBewq15YO3iHymoQ-9xc9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Nov 2010 10:51:23 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/15 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Sun, 14 Nov 2010 12:38:18 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> 2010/11/13 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> >> > 2010/11/13 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >> >>
> >> >> I don't think this patch deals correctly with servers that are
> >> >> listening on RFC1001_PORT but not CIFS_PORT. With two mounts to=
 the
> >> >> same server that don't specify a port, you'll end up with two s=
ockets,
> >> >> right?
> >> >
> >>
> >> And from another hand: If user doesn't specify the port we should
> >> think that it means the 445 port. If user wants to mount 139 port,=
 he
> >> should specify this port manually. So, there is no error with the
> >> patch in this case.
> >>
> >> From this point of view we should remove trying with 139 port if w=
e
> >> failed with 445 port. What do you think about it?
> >>
> >
> > That sounds like a regression. The mount.cifs manpage says:
> >
> > =A0 =A0 =A0 port=3Darg
> > =A0 =A0 =A0 =A0 =A0 sets the port number on the server to attempt t=
o contact to
> > =A0 =A0 =A0 =A0 =A0 negotiate CIFS support. If the CIFS server is n=
ot listening on this
> > =A0 =A0 =A0 =A0 =A0 port or if it is not specified, the default por=
ts will be tried
> > =A0 =A0 =A0 =A0 =A0 i.e. port 445 is tried and if no response then =
port 139 is tried.
> >
> >
> > I think we ought to preserve that behavior. Perhaps if no port is
> > specified then match any TCP session that is on port 445 or port 13=
9?
> >
>=20
> Jeff, according to my patches (try #2) I think we should replace it t=
his with:
>=20
>    port=3Darg
>            sets the port number on the server to attempt to contact t=
o
> negotiate CIFS support.
>            If the CIFS server is not listening on this port, we retur=
n
> with error. If it is not specified,
>            the default ports will be tried i.e. port 445 is tried and
> if no response then port 139 is tried.
>=20
>=20

Sounds correct to me. Care to do a manpage patch for mount.cifs?

Thanks,
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
