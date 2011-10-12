From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: review of patch "cifs: untangle server->maxBuf and
 CIFSMaxBufSize"
Date: Wed, 12 Oct 2011 15:43:08 -0400
Message-ID: <20111012154308.5584c466@tlielax.poochiereds.net>
References: <CAH2r5mug5PmrbhmAazv62xQGgFmH8TjZEL84WOnbvO59hccPwQ@mail.gmail.com>
	<20111012132510.68c3d986@tlielax.poochiereds.net>
	<CAH2r5mvG_NTvnjAhxZWMnkBbpMXqLoJaBWiyqnA5DOdABCTmkw@mail.gmail.com>
	<20111012152243.42356adb@tlielax.poochiereds.net>
	<CAH2r5msW=B69uZQRbdqOhMu8oRV9hVJ7kgEimfbW0cqvqAqi0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bNshh.jKvvELGGJFKkZxyBN"; protocol="application/pgp-signature"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msW=B69uZQRbdqOhMu8oRV9hVJ7kgEimfbW0cqvqAqi0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/bNshh.jKvvELGGJFKkZxyBN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011 14:28:42 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 12, 2011 at 2:22 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 12 Oct 2011 14:06:13 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Wed, Oct 12, 2011 at 12:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> >> > On Wed, 12 Oct 2011 12:15:29 -0500
> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> Reviewing changes to fs/cifs/connect.c in
> >> >> http://git.samba.org/?p=3Djlayton/linux.git;a=3Dcommit;h=3Db82a2550=
1cb18b86fd247da15c886762fdc5404c
> >> >>
> >> >> It looks like the following logic changes from setting rsize to what
> >> >> the server claims it can support (negotiated maxBuf) to what our
> >> >> maximum buffer size is:
> >> >>
> >> >> @@ -3130,8 +3130,7 @@ try_mount_again:
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(DBG2, =
"no very large read support, rsize now 127K");
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(tcon->ses->capabilities & CAP_LAR=
GE_READ_X))
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =
=3D min(cifs_sb->rsize,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(tcon->ses->server->maxBuf - MAX_C=
IFS_HDR_SIZE));
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =
=3D min(cifs_sb->rsize, CIFSMaxBufSize);
> >> >>
> >> >>
> >> >> Is that what we want?
> >> >>
> >> >
> >> > I think so, yes. That's part of untangling the mess.
> >> >
> >> > According to the protocol docs, the server should only be bound by t=
he
> >> > client's MaxBufSize for reads. Therefore, the maxBuf advertised by t=
he
> >> > server should have no bearing on the rsize.
> >>
> >> That may be true, but the following phrase in the description of
> >> SMB Read (not ReadX) worried me:
> >>
> >> "If a read requests more data than can be placed in a message of
> >> MaxBufferSize for the SMB
> >> connection, the server MUST abort the connection to the client."
> >>
> >
> > I don't think that cifs.ko ever does old-school SMB Read calls, does
> > it? We don't seem to even have the command defined in cifspdu.h...
>=20
> We don't do the older SMB Read, but it brought up the obvious
> question - would a server process the newer SMB ReadX and
> and the older style read the same way when evaluating that
> read size is not too large.
>=20
> In any case - probably safe enough as you noted.
>=20

I'm not sure -- most servers from this millenium set CAP_LARGE_READX so
the point is somewhat moot...

It's hard to get too worked up on the others, but I'll note that
MS-CIFS is a bit unclear on this point. In most places it seems to
treat the client and server's MaxBufferSize independently. But, in some
places (like the above quote you pointed out), it seems to co-mingle
them and refer to a MaxBufferSize for the connection.

In any case, for READ_ANDX, I used this quote as my guide, which seems
to indicate that only the client's MaxBufferSize matters for reads:

"If reading the requested number of bytes would lead to a response
message size larger than the established
Server.Connection.ClientMaxBufferSize and
Server.Connection.ClientCapabilities does not have CAP_LARGE_READX set,
the server MUST abort the connection to the client. If
Server.Connection.ClientCapabilities has CAP_LARGE_READX set, the
response message MAY exceed the negotiated buffer size if the FID
refers to a disk file."

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/bNshh.jKvvELGGJFKkZxyBN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOle3NAAoJEAAOaEEZVoIVjvgP/3geSSQHda3LcutV54YarRiO
lOuULym6ynOIaPpgoKf7WkMxsRFTp7CNmydH6p2Pq4pRevgcsyDMVBQ4vjbdvHKC
2ZrPSqTrvcTZO+UWAi4byKTn7hUbuKj9bdr4fJN+b9HMs+1w9fczFv1E3Xf2kSW+
9ak3OOt6rWuGuGyA9IF7jdwTferjTgwBZyFki93AxTHo/e02t/v7h2r5EzFJNlfT
EATSu3NwdV9hLTUw2rMVQGIhqUa1plad/Vj1FkDcd+Mqdnr9CW1B9kLlLCrpac02
4zwg/pGCYnkwwbP2sxJ/fdjWIpjmERTljA4wpAlt2B6+6U0T3mDd2btARrwA8REC
sgPfSqfFo/CEdkTmGZZn3dEheEmSGfKtalcyaVorO7vmqqcjcFDb5QiAeNsQZ29v
lPa7vXSIinZ/++c43yMqUNjyd1iBwGdAb/nE/gzIhn+SmxtjVSHw3CenbA/AEdWy
uCUewE73oYIbOOsmeLK8XtlY/PnrFY0Qe7zuGTQVD8iTj4BQg/HH1SUOB1ssooeI
qwQTVozwxGYAjlYNah7IWjIGiPe047LagdlvAfvFu6P7dUtRPVA1KNErMIcyaj2K
BmTh01Mt1Y7rqw34iedTw6KDLr9AWCdoZ8TZpx/BqRz7anjKyIxalj86jbe9nOxo
IXw9ZxlHh0K9tqILGM9T
=g3Gh
-----END PGP SIGNATURE-----

--Sig_/bNshh.jKvvELGGJFKkZxyBN--
