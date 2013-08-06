From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Regression in mfsymlink handling introduced by "cifs:
 only set ops for inodes in I_NEW state"
Date: Tue, 6 Aug 2013 10:56:23 -0400
Message-ID: <20130806105623.322d32a6@tlielax.poochiereds.net>
References: <51F92F0B.7030504@cam.ac.uk>
	<5201089C.1010403@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sTZJEMOnG2twYKkE3Wy6_Qr"; protocol="application/pgp-signature"
Cc: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5201089C.1010403-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/sTZJEMOnG2twYKkE3Wy6_Qr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Aug 2013 16:30:52 +0200
"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Hi David,
>=20
> > The following commit included in 3.10, and copied to some table-series
> > kernels:
> >=20
> >  commit: c2b93e0699723700f886ce17bb65ffd771195a6d
> >  cifs: only set ops for inodes in I_NEW state
> >=20
> > ... causes a regression in mfsymlink handling under some circumstances.
> >=20
> > Specifically, this patch modified cifs_fattr_to_inode() to only invoke
> > cifs_set_ops() if that inode still had the I_NEW flag set --- preventing
> > an inode's ops-set from from being changed after it had been
> > initialized, preventing an oops if another thread of execution was
> > already chasing that pointer.
> >=20
> > However, mfsymlinks are also affected by this commit.  In the cold-cache
> > case, a user invoking stat() on an mfsymlink will still see the correct
> > results.  But, if the dentry cache is instead populated via
> > cifs_readdir/filldir, then inode property population operates in a two
> > stage mode:
> >=20
> >  - First, the inode is initialized as a regular file, with the
> >    CIFS_FATTR_NEED_REVAL flag set.
> >=20
> >  - Later, when the file is stat()'d, then correct operation depends on
> >    the (re)validation steps from being able to update the inode's
> >    properties --- including the set of file operations permitted.
> >=20
> > (A comment explains:  "trying to get the type and mode can be slow, so
> >  just call those regular files for now, and mark for reval")
> >=20
> > With the above commit, this second revalidation step never updates the
> > operations field, resulting in symlinks not having the readlink(), etc.
> > functions correctly hooked up.
>=20
> > A na=EFve fix-up is to modify the conditional to also permit (re)setting
> > ops on S_IFLNK-mode files; however, I suspect a correct fix lies elsewh=
ere?
>=20
> I guess 'if (inode->i_state & I_NEW)' should be changed to
> 'if ((inode->i_state & I_NEW) || (fattr->cf_flags & CIFS_FATTR_NEED_REVAL=
))'
>=20
> Would that solve the problem?
>=20
> Jeff/Steve, any comment on this?
>=20
> metze
>=20

I don't think so...

Once an inode's operations are set, you really don't want to go
changing them. That opens the door for a malicious server to change the
file type out from under you and cause oopses. The bug report that
Sachin worked on originally had such an oops. In that case it was
caused by something else, but a malicious server could wreak similar
havoc...

The right solution is probably to ensure that the dentry fails
d_revalidate if there's a chance it could turn out to be a mfsymlink.
I think that the easiest way to ensure that would probably be to set the
dentry->d_time to 0 in the readdir code.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/sTZJEMOnG2twYKkE3Wy6_Qr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSAQ6XAAoJEAAOaEEZVoIV4wQP/3lzJfOr6f0KE1cbxKpwGg0g
F/YCfFMQYqDFrE4pkqeiw1xAF8UFertKvqVFmmnyKBaa7jtC/kcQdrtZTqYCT/bz
C74ZHTwuQysD+6G3DyYBJdkz5yCa5WuM1Mx6ihbGWfOCCP7MKsNzsSoNNbe4h3x1
cEVuC6gpIRxIkMwOeWkBA9Oq7Hab7M/JGjhN3VsTv/+cXfSWcvoWsS00qYz22ugn
0+19v2D3912lh1eNTxJpWzkBzBtlwRvHPNya37/yePre0mdfEfpwOBnGsGR+3JAW
m44V2W+f4yz6p22CBaPUChwBI0xmCiIsWnGSJ8Ta0ywzqf532sFEdXVWEXteGyLN
M3yq5alPc+ZN4e7l6YhNwwir87i60O/ukGko+skPXITRSzP2xupPz0lO6T7gJBt/
3B25J3+vA874lQMyVeF2dPKJYFMLCZ/nFmKBGZOjvJv0gKyy9EM9owRYvmYMbZhz
wIJGLmKgidketOm0Q5E8CujYfKLClF0tPqxJqfe/3+GkEe7GcGk0+a2XPdyUIMQe
Rlu9AGT68q2rmn1zOTxae4S777eMJjB6A79fWTGH5ifQ0gwRHwDt7WbcxErIlos9
fGM+jBpDn8YHh1ThzuaE8ddZedb17Mzyv9aQFH0q3VuK1Q8Ml6YEJqEhYuMWd02G
xD5ao2Sw8zopUNQceuth
=OLJy
-----END PGP SIGNATURE-----

--Sig_/sTZJEMOnG2twYKkE3Wy6_Qr--
