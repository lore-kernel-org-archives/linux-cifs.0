From: "Mantas M." <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Credentials file =?UTF-8?B?4oCTICJ1c2VybmFtZT0iIHNldHRpbmcgaWdubw==?=
 =?UTF-8?B?cmVk?=
Date: Sat, 12 Jan 2013 16:05:14 +0200
Message-ID: <kcrqio$s53$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In cifs-utils 5.9, if I specify a credentials file with the
"credetials=3D..." option, mount-cifs completely ignores the username
specified in that file (a "username=3D..." line).

`git bisect` tells me that it's caused by this commit:

> commit 85d18a1edfa95e9329a57615e92a58a5ab1902c1
> Author: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Date:   Mon Jan 7 07:19:46 2013 -0500
>=20
>     mount.cifs: remove support for "complex" usernames from mount.cif=
s
>    =20
>     In commit 569cfcb3a, we added a warning of the removal for suppor=
t for
>     username=3D options in the form of DOMAIN/username%password. This=
 patch
>     removes that support as promised prior to the 5.9 release.

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
