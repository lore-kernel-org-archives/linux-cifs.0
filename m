From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: cifs unable to access shares with read restricted at root level
 (bso#8950)
Date: Mon, 26 Oct 2015 13:18:17 +0100
Message-ID: <20151026131817.3a8a3ded@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/N+kx8xU/ifxTxOrduy0stlz"; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/N+kx8xU/ifxTxOrduy0stlz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi!

I've recently started working on bso#8950 [1] but I'm both a
kernel/SMB protocol newbie so bear with me... :-)

Shirish Pargaonkar provided a fix but it doesn't work on my setup. I
would like to provide a fix for SUSE even if temporary/hacky. Shirish's
approach seems sound so I've tried debugging it. I've summarized the
situation and my comments here [2].

There are a few things I don't understand yet.

* Where are disconnected dentries stored?
* How do you allocate a new dentry?
* What do d_obtain_alias() and d_splice_dentry() actually do? I've read
  the doc strings several times but I still have a hard time wrapping my
  head around it.

The result I'm getting seems to indicate that when an intermediary path
element is inaccessible an alternate root dentry directly pointing to
the requested path is created. The problem is that the prefixpath of
that is not stored anywhere so when we ask for a pattern to list the
content of that share, we use the path of the dentry from the root
(which is, well /) instead of the share prefixpath.

1: https://bugzilla.samba.org/show_bug.cgi?id=3D8950
2: http://diobla.info/doc/suse-todo#bnc799133

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/N+kx8xU/ifxTxOrduy0stlz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWLhoLAAoJEDIGO5Hchq/8cAUQAI6rU962PkjqounlwnekVAj8
CBzHRvGY6xuYU7CLPydmsN5gnVolin6JrlQd5UL6Bj66tsIYWWeUF4A0yN+ECZkD
8FXlS3rj8Yxc5jaKwbTmyhH5Xl94s4qcURwIdHRg90y+8TbVmqhL+EyT5vAQojMv
p4nryCPsXCu15y5v+fNEUwTeqzr3CFB7VreVEqx9V/QGlVI+AgIe23XdIWzuOyEi
0d52qPivqarBfqS8/CyAmBCLF4H5f5TV7PnvKbj5mpMUeL5fOs7jV35CSmEF3lrZ
xsWgADEpHzmKB7Ye5rGl04dD54kSC+EMteD1fhuT2zacf1g8xsSgrZs1Tct7w5Ir
ePIv6AsjX5T2GtuWuoe42OO6X7ypSFl33s7v89FwuzWf+f6cBPqd2/nmxMjRBg5n
m+eF8q+gXZ/CvbTCCMfA4c3SW7vs40ilEjopCePz0ZreoaxAHIw8fuY1dFPmKfEn
DFXVucFpBdWIH6efdubpIrxTl6nI3+LsHhekUkxIwqkyTxWmzDPpKU/YE4b8Wu4r
udX7FRZVyAWOP4okG4HP2yclnHZoEols0Yac9ktlTEnfnWjlqB+cIzk2EVWVcTGk
+pkL90jNYmcmLWkdPhpjhDXpBTPNuU0eryFko6e5VDbB5v0l1f6hla4/aaCf1qMt
l1Hyoot87amhYF6a1LBz
=0uhE
-----END PGP SIGNATURE-----

--Sig_/N+kx8xU/ifxTxOrduy0stlz--
