From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warnings after merge of the cifs tree
Date: Mon, 26 Nov 2018 11:14:15 +1100
Message-ID: <20181126111415.5cf17f39@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RUVevnnGZ=_EZC=qbx=0VoU"; protocol="application/pgp-signature"
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Kees Cook <keescook@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/RUVevnnGZ=_EZC=qbx=0VoU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

fs/cifs/sess.c: In function 'cifs_select_sectype':
fs/cifs/sess.c:527:3: warning: this statement may fall through [-Wimplicit-=
fallthrough=3D]
   switch (requested) {
   ^~~~~~
fs/cifs/sess.c:540:2: note: here
  case CIFS_NEGFLAVOR_LANMAN:
  ^~~~
fs/cifs/connect.c: In function 'cifs_parse_mount_options':
fs/cifs/connect.c:1825:8: warning: this statement may fall through [-Wimpli=
cit-fallthrough=3D]
    if (!(tmp_end < end && tmp_end[1] =3D=3D delim)) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/cifs/connect.c:1832:3: note: here
   case Opt_pass:
   ^~~~

Exposed by my use of -Wimplicit-fallthrough

I am not sure why these only turned up now (as opposed to earlier today).

--=20
Cheers,
Stephen Rothwell

--Sig_/RUVevnnGZ=_EZC=qbx=0VoU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlv7OtcACgkQAVBC80lX
0Gz+Dgf+LpJcZbxKkKV6JW3gTcE1TrMo5YsVG7CfwlY93b+mDdBXBA9+RmbGHZVa
QzEaZjByfKxRfzhqAW2XCHAQcuLVqcoXaINWsZToDOFZ5aNEADXmcEO1IGfdr8rh
gDJCA7dKIcehREAQvCZZrnQrDvCWx62YNa3SEbiwTsgl+NZMfWjwWrbLdYct3N3b
sR7GMkd6UwDbJ4vxI8wEDJYcWaCigOT8krDfsIoR12RaxId2xzL+69eLZvTi49ev
7RNobIv8OZD4F18Q6ZBUmMVP0QOJUUtHMzs0T3Ob/WJiwAioEn1SKHnYi7BPw1Aj
tM2zVVg4BfV59GoLTeHO/cErnnWXGw==
=Ivdr
-----END PGP SIGNATURE-----

--Sig_/RUVevnnGZ=_EZC=qbx=0VoU--
