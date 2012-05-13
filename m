From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: failed to fetch the cifs tree
Date: Mon, 14 May 2012 09:54:54 +1000
Message-ID: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Trying to fetch the cifs tree gets this error:

fatal: Couldn't find remote ref refs/heads/for-next

and checking via "git ls-remote" shows that the remote tree has only a
"master" branch that is set to v3.4-rc7.   Something got lost along the
way ...

I will use the cifs tree from next-20120511 for today.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsEnOAAoJEECxmPOUX5FELjkP/0lY6aOgpsvP9hnoCqsWNfmS
PYYfhW9y7ZISuTpZWl86yemKGnFMoaHDWOKvno7be6qm4+YLG89E2EzsU8HczMMo
PVylWKF5c3wo11HrvodUTDrh7TcpwX1flDUqtSOCI11+hC4fOTIbM5KeWdaJ8shO
aQxpW7VEVMzTFvdCA4P8rYdN/ouNFlreyPlh9v9etDPasjbzCbbwQ7DqJW3Rc2vf
7ITDTsU9ivMEANy7WReL9kETl8fnwrV38F3qDFSQUpm3NhAqz9hjjdcwQsqzHXfP
AxJ/1OF19hUr/NGxDRoAWFK7Cmy4s9F2ejNhIXH+Vn05Ho/mk+pDiBKaq7wr/KHI
ENzZ43Yxg4HV7Z5A3ncvAGRCv7MAx3GhQs4x36NMnhB1NeFyQjX4Hfa6dE0xwIhW
10NttoehhGneS2NV5bBkdJ3ANKZovyU5jIo81Z3erLF3BQZrn48larkGir+cNwF3
ISnacmmHBY5AlNKPqhgIeB69t66bKdy/W1rW8BORol/59F1vgll4f+RQFOH2sxcs
3A1qgLB9OVKOxKZ5sExQWo2ZszF2vCmCShZn6dgjmyJPJIacZ6xpQ2ayCUPVhpz9
lZReIhJVUPKFpzO3rQn0pIJkejsh7qer+OQF1MDINKJqygoyXS57IiIUCUHLwDzo
N7P7IhlJATkkXoem3z2o
=4GjZ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO--
