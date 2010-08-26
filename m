From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the cifs tree
Date: Thu, 26 Aug 2010 11:02:29 +1000
Message-ID: <20100826110229.931ab5bf.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/sess.c: In function 'CIFS_SessSetup':
fs/cifs/sess.c:623: warning: unused variable 'ntlmsspblob'

Introduced by commit 9fbc590860e75785bdaf8b83e48fabfe4d4f7d58 ("[CIFS]
Fix ntlmv2 auth with ntlmssp").

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdb0lAAoJEDMEi1NhKgbs18kH/15opIEe5erl4cfcnq0ltBZr
P2tWui20d1QUCpswswWOjQmtlrO3er7hTUkXVEQixG75Gj4iRQ7kagDNrb3RzALM
TcnMfM3jvm3fxPw4AuNF5auc+d23phQ1yRmlhWhb+iUdg4PACylJ64657lxOmFTq
BqojFhmHDNyeKppp1fObzlgn776V07/6+b937+qjBzSGzD2F8GakZ4SDJMw0VmY4
82RnFXMIReZbCQ5CukBhQjLF9ylBsHPbL/Hi6YjlxlNguT7tVLBZO02J3IYF4kb6
LVU0la/fYDUbi0rZok2j8JOZvEuX3LEMZmB4Cw8JdU73st81h7YR0TYxQzduWvo=
=o8Se
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG--
