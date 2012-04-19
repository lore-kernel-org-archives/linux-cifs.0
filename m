From: Lars =?iso-8859-1?Q?M=FCller?= <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: build breaks with krb5 < 1.7 in the 5.4 release
Date: Thu, 19 Apr 2012 20:00:07 +0200
Message-ID: <20120419180006.GS12994@hip.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p6hDAtPN9q+ZnUca"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--p6hDAtPN9q+ZnUca
Content-Type: multipart/mixed; boundary="OwXh6gFRjCd3qPCM"
Content-Disposition: inline


--OwXh6gFRjCd3qPCM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi linux-cifs,

products coming with MIT krb5 < 1.7 (like SUSE Linux Enterprise 11 SP 1
or SP 2) suffer from the same issue as described by
https://bugzilla.samba.org/show_bug.cgi?id=3D6918

The declaration of krb5_auth_con_set_req_cksumtype is missing.

The attached patch fixes this issue.

Cheers,

Lars
--=20
Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
Samba Team + SUSE Labs
SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--OwXh6gFRjCd3qPCM
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="krb5_auth_con_set_req_cksumtype-implicit-declaration.diff"
Content-Transfer-Encoding: quoted-printable

Author: Lars Mueller <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: cifs-utils build breaks with krb5 < 1.7
Bugzilla: na
Inspiration: https://bugzilla.samba.org/show_bug.cgi?id=3D6918

Index: cifs-utils-5.4/configure.ac
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- cifs-utils-5.4.orig/configure.ac
+++ cifs-utils-5.4/configure.ac
@@ -178,6 +178,9 @@ if test $enable_cifsupcall !=3D "no"; then
 	AC_CHECK_FUNCS([krb5_auth_con_setaddrs krb5_auth_con_set_req_cksumtype])
 fi
=20
+# MIT krb5 < 1.7 does not have this declaration but does have the symbol
+AC_CHECK_DECLS(krb5_auth_con_set_req_cksumtype, [], [], [#include <krb5.h>=
])
+
 LIBS=3D$cu_saved_libs
=20
 AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" !=3D "no"])
Index: cifs-utils-5.4/cifs.upcall.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- cifs-utils-5.4.orig/cifs.upcall.c
+++ cifs-utils-5.4/cifs.upcall.c
@@ -415,6 +415,14 @@ cifs_krb5_get_req(const char *host, cons
 	 */
 	in_data.data =3D discard_const_p(char, gss_cksum);
 	in_data.length =3D 24;
+
+	/* MIT krb5 < 1.7 is missing the prototype, but still has the symbol */
+#if !HAVE_DECL_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE
+	krb5_error_code krb5_auth_con_set_req_cksumtype(
+		krb5_context      context,
+		krb5_auth_context auth_context,
+		krb5_cksumtype    cksumtype);
+#endif
 	ret =3D krb5_auth_con_set_req_cksumtype(context, auth_context, 0x8003);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to set 0x8003 checksum",

--OwXh6gFRjCd3qPCM--

--p6hDAtPN9q+ZnUca
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFPkFKm4NBiK0FKV8MRAjipAJ92jZhRTPc8rW3lO5A5NE2mhg81mQCgsuDt
b6+MMVwbKOOiqK6xxDY87Do=
=lnxM
-----END PGP SIGNATURE-----

--p6hDAtPN9q+ZnUca--
