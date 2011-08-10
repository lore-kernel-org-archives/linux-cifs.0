From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warnings after merge of the security-testing tree
 (cifs tree related)
Date: Wed, 10 Aug 2011 11:13:22 +1000
Message-ID: <20110810111322.89faa11b60c672d9605c1876@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) produced these warnings:

fs/cifs/xattr.c:39:0: warning: "XATTR_TRUSTED_PREFIX_LEN" redefined
include/linux/xattr.h:27:0: note: this is the location of the previous defi=
nition
fs/cifs/xattr.c:40:0: warning: "XATTR_SECURITY_PREFIX_LEN" redefined
include/linux/xattr.h:21:0: note: this is the location of the previous defi=
nition

Probably caused by commit 9d8f13ba3f48 ("security: new
security_inode_init_security API adds function callback") which included
linux/xattr.h in linux/security.h.  Though I don't understan why these
defines are duplicated anyway.

[Steve, the above commit is *not* in linux-next today due to other
problems.]
--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQdsyAAoJEDMEi1NhKgbsPdgH/Az8s/MgXsTLIcHWEVu/35wT
SOSVTIacv+/9aHYf88uzQ0KNBaK41s3fF8rMRi+IO/m3/h4Af4FI1oRgjDeByuSa
1CYh7+BNcKtCud/IxMBLMeYUmeYShwJ483lo/2VegivbWBy9He74K/CMjlgAADOy
rN+c18CDN7Wvf/1d+eyhQSkAGJSUws1kyWLKNFRvBLpV+K/y7H6bBs8WUXghAAuk
3o1kuhYjh0OxU6NpbcUARnZfnAo7gDE/IxLQkiMfaG4FI3UssQadQu0WT4TMqkru
b1HcWfPny4gyNbQcnpDbVFFm8YhlbFPW7m7JOTX+Ul9FCiznFPKeQ1MT5n6fglI=
=yzsZ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_11_13_22_+1000_LFFemVZlO+G4ug6i--
