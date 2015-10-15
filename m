From: Michael Adam <obnox-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Channel Sequence handling - was RE: [PATCH] [SMB3] Send durable
 handle v2 contexts when use of persistent handles required
Date: Thu, 15 Oct 2015 13:15:21 +0200
Message-ID: <20151015111520.GA5143@samba.org>
References: <BN3PR03MB15107EF8D31A9F3B463FD753A0480@BN3PR03MB1510.namprd03.prod.outlook.com>
 <CAH2r5msW2+Mbui=jR3r2TaFspEUJFvLZYSQ5AXwGZ7qK2N5fkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Cc: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msW2+Mbui=jR3r2TaFspEUJFvLZYSQ5AXwGZ7qK2N5fkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2015-10-05 at 14:50 -0500, Steve French wrote:
> On Mon, Oct 5, 2015 at 9:44 AM, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> >> -----Original Message-----
> >> From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve French
> >> Sent: Saturday, October 3, 2015 10:03 PM
> >> ...
> >> I don't know if channel sequence number in the SMB3 request would also
> >> need to be incremented on disconnect though (the documentation is
> >> confusing on that in MS-SMB2) in the case where we only have one
> >> channel.
> >
> > There's nothing special about replay on one channel, after any disconne=
ct you should increment the channel sequence so the server's replay detecti=
on can work properly.
> >
> > Can you point me to the MS-SMB2 text that you find confusing? We can ad=
dress it.
>=20
>=20
> (the doc text in 3.2.4.1 and 3.2.7.1 of MS-SMB2 seems to
> conflict)
>=20
> On disconnect "If Connection.Dialect belongs to the SMB 3.x dialect
> family, and if the Session has more than one channel in
> Session.ChannelList, the client MUST perform the following actions:
>=20
> "Session.ChannelSequence MUST be incremented by 1."
>=20
> but 3.2.4.1 indicates that it is not just for multichannel but also
> for PersistentHandle that it must be incremented (see below)
>=20
> "If Connection.Dialect belongs to the SMB 3.x dialect family and if
> Connection.SupportsMultiChannel or
> Connection.SupportsPersistentHandles is TRUE, the
> client MUST set ChannelSequence in the SMB2 header to Session.ChannelSequ=
ence."

I don't see a contradiction / conflict here:

- 3.2.7.1 tells when to bump the seqnum.
- 3.2.4.1 tells when to send it to the server
  (this makes no statement about the value)

So the document seems to indicate this:

Bumping the channel sequence number is only done
by the Windows client upon connection loss on a
multi-channel session (i.e. a real one, with
more than one channel) and not for a single channel
session (also not on a formerly multi-channel
session, when the last channel goes down).

A new smbtorture test case that I am currently reviewing
indicates that the windows server is OK with this
client behaviour (i.e. not bumping when the last
channel of a session goes down).

Cheers - Michael

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: comment

iEYEARECAAYFAlYfisgACgkQyU9JOBhPkDST8wCff//tYumpGp2R2wKPo4+dLN9W
bVoAnjJzAh7cx70tMRRFIBt+VLxG1SVE
=pwze
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
