From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [BUG] Regression in mfsymlink handling introduced by "cifs: only
 set ops for inodes in I_NEW state"
Date: Tue, 06 Aug 2013 16:30:52 +0200
Message-ID: <5201089C.1010403@samba.org>
References: <51F92F0B.7030504@cam.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A31C8E9624A60FDF2276808"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F92F0B.7030504-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A31C8E9624A60FDF2276808
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi David,

> The following commit included in 3.10, and copied to some table-series
> kernels:
>=20
>  commit: c2b93e0699723700f886ce17bb65ffd771195a6d
>  cifs: only set ops for inodes in I_NEW state
>=20
> ... causes a regression in mfsymlink handling under some circumstances.=

>=20
> Specifically, this patch modified cifs_fattr_to_inode() to only invoke
> cifs_set_ops() if that inode still had the I_NEW flag set --- preventin=
g
> an inode's ops-set from from being changed after it had been
> initialized, preventing an oops if another thread of execution was
> already chasing that pointer.
>=20
> However, mfsymlinks are also affected by this commit.  In the cold-cach=
e
> case, a user invoking stat() on an mfsymlink will still see the correct=

> results.  But, if the dentry cache is instead populated via
> cifs_readdir/filldir, then inode property population operates in a two
> stage mode:
>=20
>  - First, the inode is initialized as a regular file, with the
>    CIFS_FATTR_NEED_REVAL flag set.
>=20
>  - Later, when the file is stat()'d, then correct operation depends on
>    the (re)validation steps from being able to update the inode's
>    properties --- including the set of file operations permitted.
>=20
> (A comment explains:  "trying to get the type and mode can be slow, so
>  just call those regular files for now, and mark for reval")
>=20
> With the above commit, this second revalidation step never updates the
> operations field, resulting in symlinks not having the readlink(), etc.=

> functions correctly hooked up.

> A na=C3=AFve fix-up is to modify the conditional to also permit (re)set=
ting
> ops on S_IFLNK-mode files; however, I suspect a correct fix lies elsewh=
ere?

I guess 'if (inode->i_state & I_NEW)' should be changed to
'if ((inode->i_state & I_NEW) || (fattr->cf_flags & CIFS_FATTR_NEED_REVAL=
))'

Would that solve the problem?

Jeff/Steve, any comment on this?

metze


--------------enig2A31C8E9624A60FDF2276808
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlIBCJ8ACgkQm70gjA5TCD9JZQCdFtjd0zSBcCWa3mdcS/2qkwXK
b/oAnRq5EkjoG9su98djf7/3M+tlZnZp
=1QQd
-----END PGP SIGNATURE-----

--------------enig2A31C8E9624A60FDF2276808--
