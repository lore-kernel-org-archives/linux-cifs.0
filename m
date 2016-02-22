From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: ANNOUNCE: cifs-utils release 6.5 ready for download
Date: Mon, 22 Feb 2016 11:22:32 -0500
Message-ID: <20160222112232.7b181f28@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CsD2jUYNTuYS6uAH+hxY1JE"; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/CsD2jUYNTuYS6uAH+hxY1JE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Nothing Earth-shattering here, but it has been quite some time (well
over a year!) since the last release.

There has been little activity other than a few minor bugfixes. But,
this is probably a reasonable time to do a release that to make things
easier on the packaging folks:

webpage:    https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball:    ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/
git:        git://git.samba.org/cifs-utils.git
gitweb:     http://git.samba.org/?p=3Dcifs-utils.git;a=3Dsummary

Here is a detailed list of changes since 6.4 was released:

commit d21675b34a77868cac7e0131ddac79a32d8809ba
Author: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date:   Mon Dec 8 06:09:44 2014 -0500

    autoconf: set version to 6.4.1 for interim builds
   =20
    Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

commit 6603cef0f06c450196a1bca06bb143d8fcda5651
Author: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Date:   Fri Dec 5 23:19:29 2014 +0100

    mtab.c: include <paths.h> for _PATH_MOUNTED
   =20
    Signed-off-by: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>

commit dd13ac8a25d409a0d3d068b5b2b96f921f2613f2
Author: Uri Simchoni <urisimchoni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Thu Nov 19 21:48:15 2015 +0200

    manpage: clarify use of backupuid and backupgid in mount.cifs.8
   =20
    Assert that backup intent shall only be attempted if the user matches
    the backupuid or backupgid parameter.
   =20
    Signed-off-by: Uri Simchoni <uri-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

commit be5046ae3fabca17f19672f7b4019efb6a869298
Author: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Thu Jan 7 11:02:49 2016 +0100

    mount.cifs: ignore x-* mount options
   =20
    x-* prefix is used for userspace mount options and it's pretty
    commonly used to extend fstab configuration in systemd world (e.g.
    x-systemd.automount). These options is necessary to ignored.
   =20
    The command mount(8) does not pass x-* mount options to mount.<type>
    helpers, but in some use-cases it's possible that the cifs helper reads
    mount options from fstab or users directly call mount.cifs and copy & p=
ast
    mount options, etc.
   =20
    This patch marks all options prefixed by "x-" as OPT_IGNORE to make
    things more robust for end-users. We already uses the same concept for
    _netdev.
   =20
    Signed-off-by: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

commit 7b2b35586d10c04f501222701c3382455a07ff9e
Author: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Fri Jan 8 17:54:39 2016 +0530

    autoconf: Use $(DEFS) when building idmapwb.so and pam_cifscreds.so
   =20
    We should pass the macros defined in $(DEFS) when building idmapwb.so
    and pam_cifscreds.so. The autoconf process sets the macro HAVE_CONFIG_H
    using the $(DEFS) variable. This macro has to be defined to allow the
    source files to include config.h
   =20
    Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit 7edaddd4d91cdb06a55f25fd66c609c4c43168f8
Author: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date:   Mon Feb 22 10:31:25 2016 -0500

    autoconf: set version to 6.5
   =20
    Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--Sig_/CsD2jUYNTuYS6uAH+hxY1JE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWyzXIAAoJEAAOaEEZVoIVweYP/3i3oJR66ojiQlJxHpsXhTdO
Cf6Z1FIPc2i1ZVLl+ATfQE3FHLdUQm3SYXQTi59zwVTaa9fTvP8qlwmhU484vKWY
9Rsm1jI39lvf+G14tNP0+GpkP0zb6ZRIReW1mIA6UQI8NbCU+A2q0tVmaHLscvYS
YHKOkD3V4xLBO3ENvM8sgxu9s1UPTUNuuI9/h55oV89Z6oVsKVfskg8TNRCbi/kS
90PaqbXhBcF7PA6RkRl2yKgGM0xCZKko0dtfEak9YsMC69ZG4+Z6EUNKAZi9b+61
z0cI9j4mSYmc7esEyWNcCQgXVuFD/9rluqipnSR3idQdkihZLYmqB5nHL5X7ceMJ
5zv5703TjRQMGS/YZfSYh0eoLsoGr0iY6qt1GJ7OvHAw71fDghlST+2n1vNGoNgK
oRsAhYnu/wVF9PcRphOn4sq48nwjzIbSm2J4sfD257983i209Y7RoLSbN0EmgA8A
GU8fM+2wad7blc/8pIi2crvZcm6J64Cuxqf0mcO0jWMqUgP002RBtGiLq15O5w9K
CdbKv10NTY6+wJFVtSfWIicFzD1RaolFkj4+nEhvsMDJGkHT6HyP9k6novGn6BMF
R/auSmTfowjRCB5O99fbLTJ49x0XVIqsY3BjPr7UQQsplw66qCA3xPth5BaVPa1Y
F6ydCj7Q5l7glfjvjQYU
=iIOx
-----END PGP SIGNATURE-----

--Sig_/CsD2jUYNTuYS6uAH+hxY1JE--
