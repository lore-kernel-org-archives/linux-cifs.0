From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
Date: Fri, 2 Feb 2018 10:25:23 +0100
Message-ID: <2f684247-04ec-1c0f-8153-9b6f8d45f265@samba.org>
References: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org>
 <20180201175247.GT17053@ziepe.ca>
 <CACyXjPyKcLktNqEdBbicSd=3GU7R9BeE-=Dcc2DyCh2sH9wxMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Gr1Dy61ntJfrIWOxHVDW8uol6SM5q11TK"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPyKcLktNqEdBbicSd=3GU7R9BeE-=Dcc2DyCh2sH9wxMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Gr1Dy61ntJfrIWOxHVDW8uol6SM5q11TK
Content-Type: multipart/mixed; boundary="hMQbRiL1uCXWwjo0MHd0U4sQmWNePnsfT";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Message-ID: <2f684247-04ec-1c0f-8153-9b6f8d45f265-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
References: <959c3608-c508-17c4-bad6-fd9421a4a235-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <20180201175247.GT17053-uk2M96/98Pc@public.gmane.org>
 <CACyXjPyKcLktNqEdBbicSd=3GU7R9BeE-=Dcc2DyCh2sH9wxMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CACyXjPyKcLktNqEdBbicSd=3GU7R9BeE-=Dcc2DyCh2sH9wxMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--hMQbRiL1uCXWwjo0MHd0U4sQmWNePnsfT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Jason,

>>> The first goal is to provide a socket fd to userspace (or in kernel
>>> consumers)
>>> which provides semantics like a TCP socket which is used as transport=

>>> for SMB3. Basically frames are submitted with a 4 byte length header.=

>>
>> Part of the point of RDMA is that we don't need to make protocol
>> specific kernel modules like this - is there a specific reason this
>> needs to be in the kernel like this?
>=20
> If I had to guess it would be because Samba currently uses a fork
> model ... it might be years before it gets to a completely threaded
> model.

Yes, and it also means that our client and server code only need
minimal changes in order to work in the same way it would work
over tcp.

Only the RDMA read and writes need some more work, but I have
some ideas where the userspace gives the kernel an fd, offset and length
plus a remove memory descriptor as ioctl on the connection fd. Then the
kernel can get the content from the filesystem and directly pass it to
the rdma adapter, avoiding the copy from kernel to userspace and back.
=46rom userspace we'll just wait in the syscall and don't have to care
about memory registrations and all other complex stuff.

It also happens that smbd sometimes blocks in syscalls like unlink for
a long time. It's good to have the kernel as 2nd entity that takes care
of keepalives.

metze


--hMQbRiL1uCXWwjo0MHd0U4sQmWNePnsfT--

--Gr1Dy61ntJfrIWOxHVDW8uol6SM5q11TK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJadC6GAAoJEA219WEoab1WmNkP/idbxki/iqvPOWqAjX89zjqe
Jsxe2WJ8G/vlXANFatcGs2TFakMiCrdcxzXzAHyKt0uWQozIC400VOg8mZArhbpb
/mU4JK7dl2KOMDihtYDez+Ktshc0xIrDZyXhVRx0ADxCQ8GKOAod9DeYa3OqfY+v
CumwMy9DSStVBysNd3glNbQ8HISrn109a01Zi/Si2krVb5GAIz4AnMQLFBksiJa4
+e2YikdJK7rE0DVv/ZZldUS6UjYoWuKzWwvKKAaLEoDOFizosnZGG1K6Yd/6ESXD
Qt/8k4+E56IPy415xzvxnUYXnoM7XuMNP/utTIiyF26h+g/hX1obT9auxtIwE5bg
MC9Xm8FzFJx7qIV2B4pBEePjdT79sRtjEZ1FwBF8R4aIZaWqLPuuEPnq3sjB6dtE
Z9+SGv2ALlqn5Bvn8teN2rTCzHP+MAV4lgLnq/AaBzANEgpiIHCwbOenxd8n9D3w
KaLilZOwl8dX8y7zueC/ymQ0pi1SOeDEWlDxpGGREPhUBh5MBnt0R22c3nPC2TpK
Ok2sO++1LmiQ1XdGiv6ddlp3ZEoEUHOZ4/MqsrZu1UzTr8Bd8Il3i9kbIbPisgEB
0mPK4NApM43yaCfW2EPVyEEWWMG/gRYt47u73tVlYl7Hi0MUL4LZH6ZbnSp05YB6
dzy1DHnT94Kzeq6qd3OK
=ACIc
-----END PGP SIGNATURE-----

--Gr1Dy61ntJfrIWOxHVDW8uol6SM5q11TK--
