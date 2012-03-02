From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: cifs oplock windows share
Date: Fri, 02 Mar 2012 17:21:44 +0100
Message-ID: <1699379793.34636.1330705303637.JavaMail.www@wwinf8310>
References: <790056146.218351.1330179815970.JavaMail.www@wwinf8305>
 <20120228064816.68731aca@tlielax.poochiereds.net>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120228064816.68731aca-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Thanks for your response.

I am actually migrating users data from a windows 2008 R2 file server t=
o another windows 2008.
I fear i don't understand why I have to disable oplocks.

Is the cifs protocol compatible with windows 2008 smb ? Must I specify =
max protocol =3Dsmb2 in samba ?=20

The issue this day:
Linux Cifs mount on Windows 2008 (via pam_mount): work with oplocks dis=
abled.
Linux cifs mount on Windows 2008 R2 (via pam_mount): don't seems to wor=
k even with oplocks disabled
(Perhaps thereis another problem on the server but I don't think so)

Thanks in advance
Serge



> Message du 28/02/12 12:48
> De : "Jeff Layton"=20
> A : "sergio.conrad"=20
> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Objet : Re: cifs oplock windows share
>
> On Sat, 25 Feb 2012 15:23:36 +0100
> "sergio.conrad" wrote:
>=20
> > Sorry for reposting precedent mail
> >=20
> > Hello=20
> > I am working in a university.
> > I have integrated 160 linux Fedora 14 clients in a Active directory=
 with Windows Server 2008 with winbind.
> > The linux home is local, but the document directory is mounted on a=
 windows share via pam_mount and cifs
> > The windows share is configured like this in /etc/security/pam_moun=
t.conf.xml
> > volume user=3D"*" fstype=3D"cifs" server=3D"$SERVEURDONNEES" path=3D=
"$REPERTOIREDONNES/%(DOMAIN_USER)" mountpoint=3D"~/Documents" options=3D=
"nounix,noserverino
> >=20
> > Everything was working when only a few computers were connected.
> > Howether, when several linux computers were working, there was the =
problem :
> > ct 5 16:42:24 u1209-01l kernel: [ 58.783078] CIFS VFS: No response =
for cmd 114 mid 1
> > Oct 5 16:42:24 u1209-01l kernel: [ 58.783094] CIFS VFS: cifs_mount =
failed w/return code =3D -112
> > Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:64): Erro=
rs from underlying mount program:
> > Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): moun=
t error(112): Host is down
> > Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): Refe=
r to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(pam_mount.c:521):=
 mount of data/u20 failed
> >=20
> > And the windows share went completely out of line: the server must =
be rebooted ...
> > I have put=20
> > modprobe cifs
> > echo 0 > /proc/fs/cifs/OplockEnabled
> > on the /etc/rc.d/rc.local in all the linux clients and everything w=
as resolved.
> >=20
> > Everything is working fine for several months.
> >=20
> > Now in another part of the university, I have put the same system o=
n 100 Fedora 14 clients.
> > The only difference is the Windows Server is 2008 R2 and don't use =
the same SMB: version 2.1
> > The problem is back again... The windows share freezes and the wind=
ows server R2 must be rebooted.
> > echo 0 > /proc/fs/cifs/OplockEnabled don't seem to work anymore
> > I don't understand well how to resolve the problem.
> > Is this a cifs problem ? Must I downgrade the windows Server to 200=
8 ?
> > I have read about to put max protocol =3D smb2 in smb.conf. What mu=
st I investigate for resolving this ?
> >=20
> > Cheers,
> > Thanks.
> > Serge
> >=20
> > Une messagerie gratuite, garantie =C3=A0 vie et des services en plu=
s, =C3=A7a vous tente ?
> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
>=20
> I suspect that disabling oplocks just papered over the real problem b=
y
> forcing the I/O to the server to be spread out more evenly.
>=20
> If your server is going unresponsive then it sounds like that server =
is
> broken. That's not generally a good way to handle an error condition.
>=20
> I'm not sure exactly what would cause that though. You may need help
> from the server vendor (aka MS) in order to determine the real cause =
of
> the problem.
>=20
> --=20
> Jeff Layton=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
