From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Work in progress SMB-Direct driver for the linux kernel
Date: Thu, 1 Feb 2018 09:18:10 +0100
Message-ID: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9tkDIesuZVZslaQHrrRrfc8zSa5BxFpMf"
Cc: Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9tkDIesuZVZslaQHrrRrfc8zSa5BxFpMf
Content-Type: multipart/mixed; boundary="PLNrFNaTTRzWVvOJj8ElGxlmVoKd2MsLZ";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
 "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Ralph_B=c3=b6hme?=
 <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Message-ID: <959c3608-c508-17c4-bad6-fd9421a4a235-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Work in progress SMB-Direct driver for the linux kernel

--PLNrFNaTTRzWVvOJj8ElGxlmVoKd2MsLZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

you were asking about my work in progress of the SMB-Direct driver for
the linux kernel.

I dumped what I have to git://git.samba.org/metze/linux/smbdirect.git
into the smbdirect-work-in-progress branch.

See
https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dshortlog;h=3Dref=
s/heads/smbdirect-work-in-progress

=46rom the README:

This is a work in progress SMB-Direct driver for the linux kernel

It's just a raw dump of what I currently have to get some help
with debugging kernel freezes. A lot of cleanups are required
and real commits with useful commit messages...

The protocol is specified by Microsoft in
[MS-SMBD] SMB2 Remote Direct Memory Access (RDMA) Transport Protocol

The aim is to later reuse parts of this for other operating systems
like FreeBSD.

The first goal is to provide a socket fd to userspace (or in kernel
consumers)
which provides semantics like a TCP socket which is used as transport
for SMB3. Basically frames are submitted with a 4 byte length header.

The second goal will be to provide RDMA read and write support
via ioctl() calls on the main smb-direct socket fd, but the
api for that is not yet designed. But it needs to
avoid data copy as much as possible.

loadchelsio.sh, loadrxe.sh, loadsiw.sh offer some examples
to setup the rdma stack before using 'insmod smbdirect.ko'.

The userspace 'smbdirect-tool' offers some commands for testing.

  "connect <dstaddr> [<dstport> [<srcaddr> [<srcport>]]]"

  "172.31.9.166"
  "172.31.9.166 5445"
  "172.31.9.166 5445 172.31.9.167"
  "fd3a:aaa3:ee87:ff09:f189:7430:7976:6276 5445"

  "listen [<port> [<addr>]]"

  "5445"
  "5445 172.31.9.166"
  "445 fd3a:aaa3:ee87:ff09:f189:7430:7976:6276"

The current state is the following:
- It compiles with v4.{10,11,12,13,14,15}
- The kernel freezes after some time
  on an active connection, e.g. when readv() is called
- Also rmmod smbdirect causes a freeze after some time

As you gave a talk about debugging the linux kernel
you might be able to find the reasons for the (silent) freezes.

metze


--PLNrFNaTTRzWVvOJj8ElGxlmVoKd2MsLZ--

--9tkDIesuZVZslaQHrrRrfc8zSa5BxFpMf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJacs1GAAoJEA219WEoab1WTQYP/A3Jz7VbtPeNi9Kjso74DvaN
diwSPSZInPyUouFniu3KylHq265jQlgTDOl9pBYJfF2RzVqaZGy1l7TZhB8qMibF
uCa6ttRSVx7PSwg2OxnzscDq0b6WfrXRSyvnh2+hNVpvY7qJDWGsa/NiJKvwLm86
B3whPuBG9P+XdHmP1kK0ge+wTN9cfQ5QABrhO+RWnhwYVDgehwuWVQo2IEKH6QKX
3G+9HX/puEIRcSn2zyOw1NH/C4D3k3pYixRWg+Qq3ijd8SWJQ8ayQFOLGxcZ41Fm
APTzXKULz8q28qVNIGEmPXvN55Wq5OGg5I89XLdrSaiczYNq95ot+tCM0sBeCMjz
NI3/tALHy6JD+9DJYq+TDfofjCAhGwsGfJTUa4jvfqKzhFEs4NUyyKHSEnYMLdLs
VnSpAveRF9GO0wKYfxEMZREzFoULQjSfyJ/n/qxG8vnDpHc4iyegY+BxDz4cCgpl
YEpKct8ji1M2d8UZkdlUrSdI7yTECb26oQE/zQ5ABq8hReIZEq70DNUgeJVVeK4c
A+JzRqlt/1U5hF1eyq2vFt4uxNAuxQ0sF+FOGaX24IvFpP9Bs+IBP1uZjlsskmsP
CSQAZ+yaBGQR7xHcA3yhqgV+UGlzwWO6ifLVr5mBEkAF8cg13nPLJnEwNhCnFC+9
47OsP6MC0IyQrpMXaqqS
=TggL
-----END PGP SIGNATURE-----

--9tkDIesuZVZslaQHrrRrfc8zSa5BxFpMf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
