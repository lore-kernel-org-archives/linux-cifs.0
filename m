From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] fs/cifs: suppress a string overflow warning
Date: Mon, 3 Sep 2018 13:15:58 +1000
Message-ID: <20180903131558.21cdeb35@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bxKFgXwdVx5Emd=Or=/qrWf"; protocol="application/pgp-signature"
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/bxKFgXwdVx5Emd=Or=/qrWf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

A powerpc build of cifs with gcc v8.2.0 produces this warning:

fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBNegotiate=E2=80=99:
fs/cifs/cifssmb.c:605:3: warning: =E2=80=98strncpy=E2=80=99 writing 16 byte=
s into a region of size 1 overflows the destination [-Wstringop-overflow=3D]
   strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Since we are already doing a strlen() on the source, change the strncpy
to a memcpy().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/cifs/cifssmb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index dc2f4cf08fe9..dcf939cb9d2f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -601,10 +601,14 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_=
ses *ses)
 	}
=20
 	count =3D 0;
+	/*
+	 * We know that all the name entries in the protocols array
+	 * are short (< 16 bytes anyway) and are NUL terminated.
+	 */
 	for (i =3D 0; i < CIFS_NUM_PROT; i++) {
-		strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
-		count +=3D strlen(protocols[i].name) + 1;
-		/* null at end of source and target buffers anyway */
+		size_t len =3D strlen(protocols[i].name) + 1;
+		memcpy(pSMB->DialectsArray+count, protocols[i].name, len);
+		count +=3D len;
 	}
 	inc_rfc1001_len(pSMB, count);
 	pSMB->ByteCount =3D cpu_to_le16(count);
--=20
2.19.0.rc1

--=20
Cheers,
Stephen Rothwell

--Sig_/bxKFgXwdVx5Emd=Or=/qrWf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAluMp24ACgkQAVBC80lX
0GzYjgf+IJhS302zpGn7gwv3y5UBrsWcFA58Ke1DJPbZArJOIC+51Ueuuep5MKWL
d/fQhR/gPmzQYOlN/MYMvZcCePB0mwQzKvavLdC8RzBvRWpuG7MJHHxXxYN26oYc
Lys7BFxAhM4TzDMM8oPkiSkCtP8pLZ46WHNBUlZ1vvCDevKBFKzc9bgc/fwQ3MQX
xkcokPifqUg5Rq/iGCvZdqa6Sxbg4mpMubg7BZjyI2CWWSFNt8ieUwMR0TjjHnWQ
W+7WDPnYHi0qa7QBvga9KhHwvoLcJO6V8thsHDyoIXht6wBAyulcufPwann63XQI
eKPr6o/ypEbYsSyS2oevowhdbYM7cA==
=y+fl
-----END PGP SIGNATURE-----

--Sig_/bxKFgXwdVx5Emd=Or=/qrWf--
