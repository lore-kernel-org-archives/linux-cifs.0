From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Mounting error after upgrading to wheezy - Changes in
 mount.cifs from 4.5 to 5.5?
Date: Wed, 18 Dec 2013 11:43:26 -0500
Message-ID: <20131218114326.7f719964@corrin.poochiereds.net>
References: <8f517d28f1398f0410e66e30d0aadd5a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8f517d28f1398f0410e66e30d0aadd5a@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Dec 2013 14:10:17 +0100
Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org> wrote:

> Hi from Munich,
> we have some special issues with the current cifs-utils (5.5) in=20
> Debian Wheezy.
>=20
> A lot of our (raw) logfiles are stored on a Windows 2008 R2=20
> fileserver, while we use Debian to generate the reports.
>=20
> The share is available as
> \\fs01\Share
>=20
> while the logfiles can be found in special subdirs
> DepartmentA\Stats
>=20
> We use a seperate user "stats_user" to access the files. This user ha=
s=20
> no "listing-rights=E2=80=9C above the final "\Stats" directory.
>=20
> Using Windows 7, everything works fine...
> \\fs01\Share\DepartmentA\Stats can be directly mounted to an local=20
> drive...
>=20
> Using cifs-utils (4.5) in Squeeze everything works fine, too!
> mount -t cifs //fs01/Share/DepartmentA/stats /mnt/DepartmentA_stats -=
o=20
> user=3Dstats_user,domain=3Dxy,password=3D'xyz'
> makes all files accessible from Debian.
>=20
> Using the same mount-command with the same user, we got a "permission=
=20
> denied".
> Retrying with a default-user (with listing-rights) the subdirectory i=
s=20
> mounted without any errors...
>=20
> Are there any big changes between 4.5 and 5.5 which can cause this=20
> error? Is there a solution, to avoid the issue?
>=20
> Thank you very much
>=20
> Philipp
>=20

More likely, a change to the kernel and not cifs-utils is causing this
for you. What kernels do your working and non-working configs have?
Does it work if you mount with sec=3Dntlm ?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
