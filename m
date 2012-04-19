From: Lars =?iso-8859-1?Q?M=FCller?= <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: mount.cifs.c toggle_dac_capability() stores return code
Date: Thu, 19 Apr 2012 20:56:13 +0200
Message-ID: <20120419185612.GT12994@hip.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v6YRErhBvjoBjrPV"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--v6YRErhBvjoBjrPV
Content-Type: multipart/mixed; boundary="nHJAUhyIZkPvF01C"
Content-Disposition: inline


--nHJAUhyIZkPvF01C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again,

the build process of the cifs-utils for Mandriva 2011 made me notice of
the unused variable rc in toggle_dac_capability() of mount.cifs.c.

A bit up in the code we store the return value and do not make use of it
while calling return.

The attached patch intends to fix this.

The failing build result is still visible at
https://build.opensuse.org/package/live_build_log?arch=3Dx86_64&package=3Dc=
ifs-utils&project=3Dnetwork%3Asamba%3ASTABLE&repository=3DMandriva_2011

Cheers,

Lars
--=20
Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
Samba Team + SUSE Labs
SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--nHJAUhyIZkPvF01C
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="mount.cifs-toggle_dac_capability-return-stored-returncode.diff"

Author: Lars Mueller <lmuelle-IBi9RG/b67k@public.gmane.org>
Subject: cifs-utils don't make use of stored return code
Bugzilla: na
Upstream-Reported: http://permalink.gmane.org/gmane.linux.kernel.cifs/5935
Upstream-Acknowledged: Yes

Index: cifs-utils-5.4/mount.cifs.c
===================================================================
--- cifs-utils-5.4.orig/mount.cifs.c
+++ cifs-utils-5.4/mount.cifs.c
@@ -577,7 +577,7 @@ toggle_dac_capability(int writable, int
 	}
 free_caps:
 	cap_free(caps);
-	return 0;
+	return rc;
 }
 #else /* HAVE_LIBCAP */
 static int

--nHJAUhyIZkPvF01C--

--v6YRErhBvjoBjrPV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFPkF/M4NBiK0FKV8MRAnaVAJ4gYdyxw8hpFhFjHqiDEqFKKBKa3QCeNgny
+XTVKTHlK31Gn5FmuP4gg9w=
=5ZVm
-----END PGP SIGNATURE-----

--v6YRErhBvjoBjrPV--
