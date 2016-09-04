From: Jeff Layton <jlayton@samba.org>
Subject: ANNOUNCE: cifs-utils release 6.6 ready for download
Date: Sat, 03 Sep 2016 20:20:00 -0400
Message-ID: <1472948400.32316.20.camel@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature"; boundary="=-ctadSrC7cnW1PVvK8qm1"
To: linux-cifs@vger.kernel.org, samba@lists.samba.org,
 "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org


--=-ctadSrC7cnW1PVvK8qm1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Time for a new cifs-utils release!

The main change in this release is a set of cleanups to cifs.upcall to
make it more efficient and work better with alternate style credcaches.
No longer does it blithely stumble around in /tmp looking for
credcaches. We now just use the default credcache that to which the
krb5.conf points.

Go forth and download!

webpage:=C2=A0=C2=A0=C2=A0=C2=A0https://wiki.samba.org/index.php/LinuxCIFS_=
utils
tarball:=C2=A0=C2=A0=C2=A0=C2=A0ftp://ftp.samba.org/pub/linux-cifs/cifs-uti=
ls/
git:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.samba.org/cif=
s-utils.git
gitweb:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0http://git.samba.org/?p=3Dcifs-utils.g=
it;a=3Dsummary

Detailed list of changes since 6.5 was released:

commit 62e73b1879077790e930e68f004fe3fbe997f84d
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Tue Jul 12 16:54:04 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0autoconf: set package version to 6.5.1 for interim =
builds
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit bbbf7133aec555c5d27ee3163d6045ecfc4673d9
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Tue Jul 12 16:53:25 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0aclocal: fix typo in idmap.m4
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0We really don't want to do the same check twice.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 9be6e885c3bd63aa6ae9e6351e1b33a4b15d9183
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Sun Aug 21 09:42:59 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: use krb5 routines to get default ccnam=
e
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Currently we end up groveling around in /tmp, tryin=
g to guess what the
=C2=A0=C2=A0=C2=A0=C2=A0credcache will be. Instead, just get the default cc=
name for the user,
=C2=A0=C2=A0=C2=A0=C2=A0and then see if it has a valid tgt. If it doesn't t=
hen we try to use
=C2=A0=C2=A0=C2=A0=C2=A0the keytab to init the credcache before proceeding.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit a3743af0c579cee61b816080de978ae7a7663b05
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Mon Aug 22 07:34:21 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: make the krb5_context a static global =
variable
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0There's no need to keep initing a new context for e=
very function. Just
=C2=A0=C2=A0=C2=A0=C2=A0do it once and reuse as needed.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 3db6b3a814a2908b230fcfbdb82846775e56dd93
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Wed Aug 24 11:39:06 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: remove KRB5_TC_OPENCLOSE
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0The header file says that this is deprecated, and a=
ll of the info I've
=C2=A0=C2=A0=C2=A0=C2=A0seen about it mentioned that it was for performance=
 more than
=C2=A0=C2=A0=C2=A0=C2=A0correctness. It dates back to the original code dum=
p from Igor, so I
=C2=A0=C2=A0=C2=A0=C2=A0think we're safe to just drop it at this point.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 39dbb7b47bea9d6d7cf93ddd53cda501c3898bd6
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Wed Aug 24 11:41:53 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: make get_tgt_time take a ccache arg
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0...instead of dealing with the ccname. Push resolut=
ion of the cache
=C2=A0=C2=A0=C2=A0=C2=A0into the caller.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 7852becab01989634aacc1fb8ff9581a11a7cdcf
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Wed Aug 24 12:56:54 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: stop passing around ccache name string=
s
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Instead, get a ccache handle and pass that around. =
That way we can keep
=C2=A0=C2=A0=C2=A0=C2=A0the cache open until the program is complete as wel=
l.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 7926aaea98cdc96b6544b8e21fb5b0b4422c340d
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Sep 1 21:06:33 2016 -0400

=C2=A0=C2=A0=C2=A0=C2=A0autoconf: set version to 6.6
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

--=20
Jeff Layton <jlayton@samba.org>
--=-ctadSrC7cnW1PVvK8qm1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIvBAABCAAZBQJXy2ixEhxqbGF5dG9uQHNhbWJhLm9yZwAKCRAADmhBGVaCFZKh
D/4s5X5v0wMwQt5xRGwPS7ZG/17+yNjjNaVs61zlpSR+kpBMkap2MszDdjiye0b3
+gxXi0GxtfORvZCNtpPQEW2M1p4fhs+CAV86AOaa+4JhKOIq+o4mCsbg4Zw4P0vf
5zN3vRiTom6N84Ad6RnvJm6ieBQTY+W3imkLUxHoaKoeuCK18uqpOivxX6Zv9UNQ
6L6hlFWgN/CFULTBWAttZrLNG0754yVhw4507GwI71po1uV7e0xEsu8FCKKt7wF2
gEg6ZzONiH01o2smDDcOvLsSNOC6rhCybR8aHQBpRgIzsWFbDqFxSAIwmYlPZ16J
hoiFLM/JnKU54/zp6eaP/cOA6b7tzI63g58TL7nFGXpKmReqaSiu3gK1eT3FXZ/g
sKpNUsGvStZtHV0OmYN2h+fn1Dyy4unAs0kjA15y6lvxp5eMqCYdDpcokU6nTxSn
hNw0CTCpfavcwl03sAKjbDzOwOpGyfPM6UB64MpUiU1BqFj7aN4Gjc06ES180Lfx
82Jkl4lacTyOlwH1r/mo9KxDohHLEyz7wADvaDKXceuB6xRdLyfq657OObl6z17Y
HRZRgqEH0qOYjY33vE/4h08ayxCYvpoJbww79ifRazx2yfAmmb4CXUHcWjaI+cHZ
h3LwlJs9zo/n8ZGE3QvKihmT8Wl+od5nTtowI7KG5uwTZA==
=bRtz
-----END PGP SIGNATURE-----

--=-ctadSrC7cnW1PVvK8qm1--
