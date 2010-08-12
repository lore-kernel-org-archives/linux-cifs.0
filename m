From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build failure after merge of the cifs tree
Date: Thu, 12 Aug 2010 13:17:41 +1000
Message-ID: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX."
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/dns_resolver/dns_key.c: In function 'dns_resolver_instantiate':
net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:99: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:128: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:136: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:143: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:144: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:149: error: implicit declaration of function 'ke=
y_payload_reserve'
net/dns_resolver/dns_key.c:162: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: In function 'dns_resolver_match':
net/dns_resolver/dns_key.c:178: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: In function 'dns_resolver_describe':
net/dns_resolver/dns_key.c:211: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:213: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:217: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: At top level:
net/dns_resolver/dns_key.c:220: error: variable 'key_type_dns_resolver' has=
 initializer but incomplete type
net/dns_resolver/dns_key.c:221: error: unknown field 'name' specified in in=
itializer
net/dns_resolver/dns_key.c:221: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:221: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:222: error: unknown field 'instantiate' specifie=
d in initializer
net/dns_resolver/dns_key.c:222: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:222: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:223: error: unknown field 'match' specified in i=
nitializer
net/dns_resolver/dns_key.c:223: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:223: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:224: error: unknown field 'revoke' specified in =
initializer
net/dns_resolver/dns_key.c:224: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:224: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:225: error: unknown field 'destroy' specified in=
 initializer
net/dns_resolver/dns_key.c:225: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:225: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:226: error: unknown field 'describe' specified i=
n initializer
net/dns_resolver/dns_key.c:226: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:226: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:227: error: unknown field 'read' specified in in=
itializer
net/dns_resolver/dns_key.c:227: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:227: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:237: error: invalid use of undefined type 'struc=
t key_type'
net/dns_resolver/dns_key.c:249: error: implicit declaration of function 'ke=
y_alloc'
net/dns_resolver/dns_key.c:249: error: 'key_type_keyring' undeclared (first=
 use in this function)
net/dns_resolver/dns_key.c:249: error: (Each undeclared identifier is repor=
ted only once
net/dns_resolver/dns_key.c:249: error: for each function it appears in.)
net/dns_resolver/dns_key.c:250: error: 'KEY_POS_ALL' undeclared (first use =
in this function)
net/dns_resolver/dns_key.c:250: error: 'KEY_POS_SETATTR' undeclared (first =
use in this function)
net/dns_resolver/dns_key.c:251: error: 'KEY_USR_VIEW' undeclared (first use=
 in this function)
net/dns_resolver/dns_key.c:251: error: 'KEY_USR_READ' undeclared (first use=
 in this function)
net/dns_resolver/dns_key.c:252: error: 'KEY_ALLOC_NOT_IN_QUOTA' undeclared =
(first use in this function)
net/dns_resolver/dns_key.c:258: error: implicit declaration of function 'ke=
y_instantiate_and_link'
net/dns_resolver/dns_key.c:262: error: implicit declaration of function 're=
gister_key_type'
net/dns_resolver/dns_key.c:268: error: 'struct cred' has no member named 't=
hread_keyring'
net/dns_resolver/dns_key.c:269: error: 'struct cred' has no member named 'j=
it_keyring'
net/dns_resolver/dns_key.c: In function 'exit_dns_resolver':
net/dns_resolver/dns_key.c:285: error: implicit declaration of function 'un=
register_key_type'
net/dns_resolver/dns_key.c:288: error: invalid use of undefined type 'struc=
t key_type'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:124: error: implicit declaration of function '=
request_key'
net/dns_resolver/dns_query.c:124: warning: assignment makes pointer from in=
teger without a cast
net/dns_resolver/dns_query.c:132: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:133: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:133: error: 'KEY_USR_VIEW' undeclared (first u=
se in this function)
net/dns_resolver/dns_query.c:133: error: (Each undeclared identifier is rep=
orted only once
net/dns_resolver/dns_query.c:133: error: for each function it appears in.)
net/dns_resolver/dns_query.c:140: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:144: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:155: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:159: error: dereferencing pointer to incomplet=
e type

Presumably this code has not been built on powerpc before.  Casued by
commit 1a4240f4764ac78adbf4b0ebb49b3bd8c72ffa11 ("DNS: Separate out CIFS
DNS Resolver code") (and the build was probably enabled by commit
c2e8139c9f797baa46515af6d350c51823736cbb ("NFS: Use kernel DNS resolver
[ver #2]").

I can only imagine that linux/key.h is included indirectly on x86.

I have used the version of cifs tree from next-20100811 for today.
--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMY2fVAAoJEDMEi1NhKgbshz8H/3m6+hYkiPGg8OjlzRJgupHp
FmDNLNA+E0LZlVT4JblNMaS+LrgRKdaC4MYOHt8pbkMtfN2n9Rfx1qKv82uIgvuh
XbSGPwKxhgYUDQyPaRPu9+6oHPbLwJ5Hd1ayrNDmsLnyJG0M+AD8QniPkEeQU3XM
yk9bA4x7ZoUJKSUC/QZ/fkNB+xs2drNHRlinf/PdiaJqb83KZ9fYt+J7ukwZXA1T
ofS5UUKJghn5uQGDPn+LbWmt25sskibDbdUvm3HurRSDbCossr4AC4dlh+eVCk1j
tjwavAVFnF+p3YxwumT2TlYrMP+Pf+xtMEL4vCqAKOtBcCxbIPdXtDi98dxQUYA=
=GlKf
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.--
