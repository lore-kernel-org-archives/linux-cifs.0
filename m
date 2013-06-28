From: =?utf-8?q?G=C3=BCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mount error 79 = Can not access a needed shared library
Date: Fri, 28 Jun 2013 04:27:16 +0200
Message-ID: <201306280427.16839.linux@kukkukk.com>
References: <51CCA586.1070105@towo.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Wolff <towo-JHPtuYzOr/0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CCA586.1070105-JHPtuYzOr/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am Donnerstag, 27. Juni 2013, 22:50:14 schrieb Thomas Wolff:
Hello Thomas,

> My attempt to mount with -o iocharset=3Dutf8 fails with this message:
> mount error 79 =3D Can not access a needed shared library
>=20
> By google, I found one hint to "compile and install" nls_utf8.ko but
> without a mention of where to get that from or how to proceed anyway
> (very funny).
>=20
> The system is Debian on a ppc, uname -a:
> Linux MyBookLive 2.6.32.11-svn21605 #1 Fri Oct 15 17:13:23 PDT 2010 p=
pc
> GNU/Linux
>=20
> aptitude search does not show any useful results for nls

All those NLS related stuff is built into the kernel - usually as
modules. So you _cannot_ just install those kernel modules "on the fly"=
=2E

Some linux .config file (used for the kernel build) might contain
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
=2E..
Which results to nls kernel modules in e.g.
lib/modules/2.6.32.11-svn21605/kernel/fs/nls/

Note - check for subpath "2.6.32.11-svn21605" above - it might be
different.
Strange is that utf8 seems to be not build-in in your kernel version.
(Should be the default for years)

Cheers, G=C3=BCnter

>=20
> ------
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
