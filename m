From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the cifs tree
Date: Mon, 25 Jun 2018 09:15:31 +1000
Message-ID: <20180625091531.60fe90e9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TBAvP483fDhCQS/v8MsLHSl"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/TBAvP483fDhCQS/v8MsLHSl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/smb2ops.c: In function 'smb311_queryfs':
fs/cifs/smb2ops.c:1543:11: error: 'struct cifs_tcon' has no member named 'p=
osix_extensions'
  if (!tcon->posix_extensions)
           ^~
At top level:
fs/cifs/smb2ops.c:1534:1: warning: 'smb311_queryfs' defined but not used [-=
Wunused-function]
 smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 ^~~~~~~~~~~~~~

Caused by commit

   ("smb3: add support for statfs for smb3.1.1 posix extensions")

# CONFIG_CIFS_SMB311 is not set

I have used the cifs tree from next-20180622 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/TBAvP483fDhCQS/v8MsLHSl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlswJhMACgkQAVBC80lX
0GzXSwf6AzHV6J1Eh3MwNgqgtrlt7OY7JSC0e14fCb+qtukbZORzOqX9/jfBhdXL
4BC3dXYvQP5dd4yOITl5uGo3kCxheCqYTmyeGUMQe08vlkNtSuG9TsVA4kWJEcN5
TkEJnuvxeZl5/urYs+jItpf2R+b/LfseE1iyNW035KbEYwITwbWY2GMBdJpigapO
1d05JLS1eTyZWNU1j1cns+7nN8HsTm52jgpgtYhKFdjIcJiMcC78VyXHYxgO3hZT
bHEiOmq2uYjoYltumlDNYQheZkTwdufgq0XbAA0g8JNz8ebYTda0b9uYY6Dm/UuQ
MLCpzPNwoso40PqSudVBh+D8usZTOg==
=PNzG
-----END PGP SIGNATURE-----

--Sig_/TBAvP483fDhCQS/v8MsLHSl--
