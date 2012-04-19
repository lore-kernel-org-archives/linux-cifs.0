From: Lars =?iso-8859-1?Q?M=FCller?= <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: uninitialized variables in the 5.4 release
Date: Thu, 19 Apr 2012 19:52:42 +0200
Message-ID: <20120419175242.GR12994@hip.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk/CTwBz1VvfPIDp"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--Pk/CTwBz1VvfPIDp
Content-Type: multipart/mixed; boundary="HxQt9wRz9wbL5Edg"
Content-Disposition: inline


--HxQt9wRz9wbL5Edg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

older gcc versions (4.3 in the case of SUSE Linux Enterprise 11 SP 1 and
SP 2) complain about uninitialized variables in the recent 5.4 release.

The attached patch makes the build process a bit quieter.

Cheers,

Lars
--=20
Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
Samba Team + SUSE Labs
SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--HxQt9wRz9wbL5Edg
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="bku-uid-gid-uninitialized.diff"

Author: Lars Mueller <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: cifs-utils build warns bkupuid and bkupgid may be used uninitialized
Bugzilla: na

Index: cifs-utils-5.4/mount.cifs.c
===================================================================
--- cifs-utils-5.4.orig/mount.cifs.c
+++ cifs-utils-5.4/mount.cifs.c
@@ -863,8 +863,8 @@ parse_options(const char *data, struct p
 	int got_uid = 0;
 	int got_cruid = 0;
 	int got_gid = 0;
-	uid_t uid, cruid = 0, bkupuid;
-	gid_t gid, bkupgid;
+	uid_t uid, cruid = 0, bkupuid = 0;
+	gid_t gid, bkupgid = 0;
 	char *ep;
 	struct passwd *pw;
 	struct group *gr;

--HxQt9wRz9wbL5Edg--

--Pk/CTwBz1VvfPIDp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFPkFDq4NBiK0FKV8MRAnjFAJ4lTJYYLIwz7cqyEnhuMwEflISopwCggzsj
P1oVrk8WDFz44fJ+eHbadc0=
=DdSg
-----END PGP SIGNATURE-----

--Pk/CTwBz1VvfPIDp--
