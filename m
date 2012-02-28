From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs oplock windows share
Date: Tue, 28 Feb 2012 06:48:16 -0500
Message-ID: <20120228064816.68731aca@tlielax.poochiereds.net>
References: <790056146.218351.1330179815970.JavaMail.www@wwinf8305>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <790056146.218351.1330179815970.JavaMail.www@wwinf8305>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 25 Feb 2012 15:23:36 +0100
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

> Sorry for reposting precedent mail
>=20
> Hello=20
> I am working in a university.
> I have integrated 160 linux Fedora 14 clients in a Active directory w=
ith Windows Server 2008 with winbind.
> The linux home is local, but the document directory is mounted on a w=
indows share via pam_mount and cifs
> The windows share is configured like this in /etc/security/pam_mount.=
conf.xml
> volume user=3D"*" fstype=3D"cifs" server=3D"$SERVEURDONNEES" path=3D"=
$REPERTOIREDONNES/%(DOMAIN_USER)" mountpoint=3D"~/Documents" options=3D=
"nounix,noserverino
>=20
> Everything was working when only a few computers were connected.
> Howether, when several linux computers were working, there was the pr=
oblem :
> ct 5 16:42:24 u1209-01l kernel: [ 58.783078] CIFS VFS: No response fo=
r cmd 114 mid 1
> Oct 5 16:42:24 u1209-01l kernel: [ 58.783094] CIFS VFS: cifs_mount fa=
iled w/return code =3D -112
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:64): Errors=
 from underlying mount program:
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): mount =
error(112): Host is down
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): Refer =
to the mount.cifs(8) manual page (e.g. man mount.cifs)
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(pam_mount.c:521): m=
ount of data/u20 failed
>=20
> And the windows share went completely out of line: the server must be=
 rebooted ...
> I have put=20
> modprobe cifs
> echo 0 > /proc/fs/cifs/OplockEnabled
> on the /etc/rc.d/rc.local in all the linux clients and everything was=
 resolved.
>=20
> Everything is working fine for several months.
>=20
> Now in another part of the university, I have put the same system on =
100 Fedora 14 clients.
> The only difference is the Windows Server is 2008 R2 and don't use th=
e same SMB: version 2.1
> The problem is back again... The windows share freezes and the window=
s server R2 must be rebooted.
> echo 0 > /proc/fs/cifs/OplockEnabled don't seem to work anymore
> I don't understand well how to resolve the problem.
> Is this a cifs problem ? Must I downgrade the windows Server to 2008 =
?
> I have read about to put max protocol =3D smb2 in smb.conf. What must=
 I investigate for resolving this ?
>=20
> Cheers,
> Thanks.
> Serge
>=20
> Une messagerie gratuite, garantie =C3=A0 vie et des services en plus,=
 =C3=A7a vous tente ?
> Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net

I suspect that disabling oplocks just papered over the real problem by
forcing the I/O to the server to be spread out more evenly.

If your server is going unresponsive then it sounds like that server is
broken. That's not generally a good way to handle an error condition.

I'm not sure exactly what would cause that though. You may need help
from the server vendor (aka MS) in order to determine the real cause of
the problem.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
