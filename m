From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the cifs tree
Date: Mon, 6 Aug 2012 10:48:41 +1000
Message-ID: <20120806104841.07ed3708b600529ff7eb6fa6@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Aug_2012_10_48_41_+1000_Q0A.8HsKl6VsDv18"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Mon__6_Aug_2012_10_48_41_+1000_Q0A.8HsKl6VsDv18
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/Kconfig:3: syntax error
fs/Kconfig:244: missing end statement for this entry
fs/Kconfig:5: missing end statement for this entry
fs/cifs/Kconfig:2: invalid statement
fs/cifs/Kconfig:3: unexpected option "depends"
fs/cifs/Kconfig:4: unexpected option "select"
fs/cifs/Kconfig:5: unexpected option "select"
fs/cifs/Kconfig:6: unexpected option "select"
fs/cifs/Kconfig:7: unexpected option "select"
fs/cifs/Kconfig:8: unexpected option "select"
fs/cifs/Kconfig:9: unexpected option "select"
fs/cifs/Kconfig:10: unexpected option "select"
fs/cifs/Kconfig:11: unexpected option "select"
fs/cifs/Kconfig:12: unexpected option "select"
fs/cifs/Kconfig:13: invalid statement
fs/cifs/Kconfig:14: unknown statement "This"
fs/cifs/Kconfig:15: unknown statement "CIFS"
fs/cifs/Kconfig:16: unknown statement "SMB"
fs/cifs/Kconfig:17: unknown statement "PC"
fs/cifs/Kconfig:18: unknown statement "file"
fs/cifs/Kconfig:19: unknown statement "and"
fs/cifs/Kconfig:20: unknown statement "server"
fs/cifs/Kconfig:21: unknown statement "support"
fs/cifs/Kconfig:22: unknown statement "well"
fs/cifs/Kconfig:25: syntax error
fs/cifs/Kconfig:24: unknown statement "The"
fs/cifs/Kconfig:25: unknown statement "client"
fs/cifs/Kconfig:26: unknown statement "support"
fs/cifs/Kconfig:27: unknown statement "session"
fs/cifs/Kconfig:28: unknown statement "safe"
fs/cifs/Kconfig:29: unknown statement "signing"
fs/cifs/Kconfig:30: unknown statement "If"
fs/Kconfig:274: unexpected end statement
fs/Kconfig:279: unexpected end statement

Caused by commit 12f3f9b7c80c ("Remove sparse warning in cifsfs.c").
Please, please build test after doing updates and before publishing your
tree.

I have used the cifs tree from next-20120803 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Aug_2012_10_48_41_+1000_Q0A.8HsKl6VsDv18
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQHxRpAAoJEECxmPOUX5FE4ooP/jn+QY9oPxV6evy7omzvSTky
/9mrnVDZR61plLzThUAUhUfKXWO3Q7XvSEVctWOYZakJvcbfX4omw9hOyu5uiEw6
IGGpZSguf3S3Cz/vCp+UcsM0ui2PCiwln923IAuEaOLimLacpvpN33HoOasKLwdf
vKx3w2WRHICR773lz+ILqToVEoZ6g+tYZWO2IT4FB2CYxESnAVB41BStvl81boyL
wNx4uH8gueJ1l/+0cUhPmWMz9Z+yxCfCUqmvUEteWTEq1XKCisZVi/+4uo8AUA/n
LAYi3Es4UiLe7UfqX7uRkgeMy8l7uAGOMmSsfYNw/0SzPk70BGXokWKtjWbIXNJi
8mG+/l5xM5r3HLKXU5u0JBNIG6DZ2ceuwMfTW3Abm62YqfCwA4OadpS4fCOu421X
O541RMViWG6VxingM8KnKQyt6mHZCazNGatilWzz8Agv5Y37fPAJFAkFgSzuOLlh
XGkWCyyO+3Bnym+zNcIF31bKOd5REtGmkvl+HTmErOYJRbiLreQHDglkarzZfp0a
zEr5JLayAIUWi1iX9nMd7/VLko/fxfzXPZjRvfNnT5QAJgEa4J/TDDrTKMlik6Vi
EOy4gv4SlJqlvd+DcC7kJbKFc9Ap5nRpp8fsUulxA88C1VfY8GZqRdskdwIpLHl5
zV0mlgI75tDNiSGv8X0F
=yqaf
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2012_10_48_41_+1000_Q0A.8HsKl6VsDv18--
