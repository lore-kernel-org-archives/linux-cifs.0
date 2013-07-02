From: Jeffrey Layton <jlayton@samba.org>
Subject: ANNOUNCE: cifs-utils release 6.1 ready for download
Date: Tue, 02 Jul 2013 15:37:24 -0400
Message-ID: <1372793844.2302.19.camel@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7866977450627425664=="
To: linux-cifs@vger.kernel.org, samba@lists.samba.org,
	samba-technical@lists.samba.org
Return-path: <samba-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org


--===============7866977450627425664==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8jvPOdSAhvNdGof6xAYw"


--=-8jvPOdSAhvNdGof6xAYw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It has been a few months since the last cifs-utils release, and again
there's been almost no activity. Still, at some point we need to get
the bugfixes into the field, no matter how minor they are.

So, nothing much earth-shattering here, mostly just bugfixes, and one
new feature to allow cifs.upcall to use a dedicated keytab.

Go forth and download!

webpage:    https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball:    ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/
git:        git://git.samba.org/cifs-utils.git
gitweb:     http://git.samba.org/?p=3Dcifs-utils.git;a=3Dsummary

Detailed list of changes since 6.0:

commit 0d57c198d6d03117b1e8ebb564ce8ac2535b607d
Author: Jeff Layton <jlayton@samba.org>
Date:   Wed Apr 10 13:24:50 2013 -0400

    cifs-utils: set version to 6.0.1 for interim builds
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 6885a6253aa214cbd6f6adbd5c948b74fa4a27a1
Author: Scott Lovenberg <scott.lovenberg@gmail.com>
Date:   Wed Apr 10 13:16:52 2013 -0400

    mount.cifs: Trivial comment fixes
   =20
    Two trivial comment fixes.
   =20
    Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>

commit 21b5bdcb354bc113473347af5e4995fae2285b58
Author: Peng Haitao <penght@cn.fujitsu.com>
Date:   Fri Apr 12 16:58:49 2013 +0800

    setcifsacl.c: fix a bug of goto setcifsacl_facenum_ret
   =20
    setcifsacl_facenum_ret: is called only if attrlen is equal to -1.
   =20
    Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>

commit 76dacff50330dcc55ad5c08bf8610e0d7e3ca2ec
Author: Peng Haitao <penght@cn.fujitsu.com>
Date:   Fri May 17 17:27:02 2013 +0800

    cifs.upcall: the exit code should be 0 when print version
   =20
    When print version number, the exit code should be 0
    and syslog() should not send "Negating key" to the system logger.
   =20
    Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>

commit e99024cf8f70a1337e09eb9e97a57926f7bc8cac
Author: Jeff Layton <jlayton@samba.org>
Date:   Wed May 29 14:54:26 2013 -0400

    cifs.upcall: allow users to specify dedicated keytab on command-line
   =20
    Currently cifs.upcall only looks at the default system keytab
    (/etc/krb5.keytab). It's often the case however that a dedicated keytab
    is desirable. Allow administrators to set one on the command-line.
   =20
    Reported-by: steve <steve@steve-ss.com>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 069d1efdfab8d0d411b08f2c20f53b111cc92625
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Jul 2 15:13:33 2013 -0400

    cifs-utils: set version to 6.1
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

--=20
Jeffrey Layton <jlayton@samba.org>

--=-8jvPOdSAhvNdGof6xAYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJR0yv0AAoJEAAOaEEZVoIVDtsQAMmlEMMxqIXaKg6GX2x/KmML
k70jtnN4KUMi9H78AOoL6u6z7yix2isb50WSK9shetliQDHfNjDT0/aAPyYT4vrQ
tVxJ9CgKTawlvXRucroAH28OzYF9zhzXNDu5k6Ar2Yv5JuYDgvIazA/kqrywD3PP
sJ2JhqxXtVUUGzem+h6qMkbooOJ2Ijuc3rD+2n7ISsfMZ56VPG5rpZ6okcibgOvx
wL18oVRbKqZptODFQ3N//fyEPmIykEu0BKMAabxfGjUUR36aFeiPslmRfTS5zzDD
vGWkAJhntmZ/FWgyJJTHk3wng48wmuaQZlvx6oAxkOOTqf3eVELeLl4RtQG0WjV9
CYFUDpMXCBAWJYydEb/qk3XqguioKpvdBL95oHKgiOfx2wHbXGs+1x/I08/92DbV
keg5hbFXmPVYqBWdpIDGVf0OQyQkbQ+P7KI1O6FRnnSPoePudJ8OMTuAA7+AuyNd
8dw/j2uHrpNjHqdpfM8ejz1bpdKwWXFWfhft4z6jE4/Ek/id2EvFFQlxK57BUZ87
P2LDXOsrY+BBPAHRgdFi8g3tkrxT8gZ6nh25MI8y4mLuIoRhkrYV87V9+hemx6ck
9O9TX9e6z4yJWXpbtNUIN+sD6sIHTwf3scFptPkLEJFg4ebTAA/FJA2hsNqfc33Z
gmtsglgEKtj1Eelar/Qk
=jBdI
-----END PGP SIGNATURE-----

--=-8jvPOdSAhvNdGof6xAYw--


--===============7866977450627425664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
--===============7866977450627425664==--
