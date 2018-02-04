From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
Date: Sun, 04 Feb 2018 11:39:13 -0500
Message-ID: <1517762353.3936.41.camel@redhat.com>
References: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org>
         <20180201175247.GT17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xfm7t2NJyMQBcnOqPecr"
Cc: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ralph =?ISO-8859-1?Q?B=F6hme?= <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201175247.GT17053-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org


--=-xfm7t2NJyMQBcnOqPecr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-02-01 at 10:52 -0700, Jason Gunthorpe wrote:
> On Thu, Feb 01, 2018 at 09:18:10AM +0100, Stefan Metzmacher wrote:
>=20
> > The first goal is to provide a socket fd to userspace (or in kernel
> > consumers)
> > which provides semantics like a TCP socket which is used as transport
> > for SMB3. Basically frames are submitted with a 4 byte length header.
>=20
> Part of the point of RDMA is that we don't need to make protocol
> specific kernel modules like this - is there a specific reason this
> needs to be in the kernel like this?

Although your question was partially answered, I think the precise cause
is that to behave like an SMB3 server, the model involves opening a TCP
connection, doing auth over that, then negotiating whether or not RDMA
connections are possible, then opening the RDMA connections.  On our
end, once the auth happens, smbd forks and the new user process handles
the connection from that point on (which is integral to smbd's security
model).  Because of this, and because the client initiates the RDMA
connection and will only use a single well known port to connect to,
incoming RDMA connections after negotiation would always go to the
master smbd process and not the forked client authed smbd process.=20
Because we don't have a way of then handing the RDMA connection from one
process to another forked process, the model breaks down.  Possible
solutions are:

1) Don't make the master process listen on the well known RDMA port.=20
Let each client register to listen on the port only after the
negotiation has completed, listen until it finds the proper client
connection, then stop listening on the port.  This obviously makes
multiple client connections race for which server is listening.  I have
no idea if the Microsoft client would even retry a connection if it went
to the wrong process the first time and was rejected.

2) Create a new listen model where a process could register to listen on
a specific port + remote IP address(es).  That way all connection
attempts from the specific remote IP address(es) and the local port
would go to the specific process.  This could be contained within the
CMA and need not impact normal sockets processes.  I would envision that
the smbd would get the negotiation packet from the client with a list of
the RDMA devices it can connect across, would work out which of those
devices it could accept connections from, would initiate all necessary
listens, and finally would send the reply packet to the client.

3) Make a kernel module as they are doing to handle the incoming
connections and multiplex between processes.

4) Make smbd threaded so that it can listen on the well known port and
then hand a connection off to a specific thread once established.

I'm partial to either 2 or 4 myself.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-xfm7t2NJyMQBcnOqPecr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlp3NzEACgkQuCajMw5X
L92zaQ/+LKgPoSGc2Sxzu2NTi3KPWozzaefusiAdWc61zzAWqGQrTP3XxTIbnRIe
bvuedo9bkNaQdYWpolIqZQ+JQ6nxogDyJfSibwxpWTI7gtKpTyVKczWazCjGzLCK
d9VQVwDmhfb8fmCB+evNUZ5S08ExDUHStz6vAG42sOxHMdVuqwUcDgZbF0SEN3mg
8eVF75oDQ+93PeNR/vISif/Rmsk6Tq12W97GLE/KcJMNxwyaan3B1JAVDxO3/0RB
G3rqcr3acObW2L22q8tZka0xKmgkkaO7z6Aa3RrNPgpV96zCegDwcE5ZnC2ZVZMJ
A7nf1rw9dkoQq5iDp410/qJzFCIGid7lZsi1UBcB+ZAb9fqxZj/nvorQMcPzNi7a
0PTXTdOutc6CkTF3ZRdDvAgN2kpwrKXT+20yiClnouLNwUorQ/TS9q2t650ZaS94
vvD2TqoqYvRzVeMUZY+Np8qHgkxs7JvWmL2IzXMi1vf37HeKs8fBXrzyxnBCDeFO
cicbxGf63NN7d1k8Ip6i6SNmM65q5kJKSfu5Hy5s5aaUDJjZ2CcOFHyWOTMI7iKc
pRjupbk48f6q939MHIm/d12ax7UIC3A3XVloXLVe1lXIft7OrTq7I2kc7P2O6jLz
yDWXMKASdqt9j+4pvJxIuhW8OzDZnmfh1UZZZA6RIKQ1uLH0oMM=
=IMgt
-----END PGP SIGNATURE-----

--=-xfm7t2NJyMQBcnOqPecr--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
