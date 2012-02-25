From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: cifs oplock windows share
Date: Sat, 25 Feb 2012 15:23:36 +0100
Message-ID: <790056146.218351.1330179815970.JavaMail.www@wwinf8305>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry for reposting precedent mail

Hello=20
I am working in a university.
I have integrated 160 linux Fedora 14 clients in a Active directory wit=
h Windows Server 2008 with winbind.
The linux home is local, but the document directory is mounted on a win=
dows share via pam_mount and cifs
The windows share is configured like this in /etc/security/pam_mount.co=
nf.xml
volume user=3D"*" fstype=3D"cifs" server=3D"$SERVEURDONNEES" path=3D"$R=
EPERTOIREDONNES/%(DOMAIN_USER)" mountpoint=3D"~/Documents" options=3D"n=
ounix,noserverino

Everything was working when only a few computers were connected.
Howether, when several linux computers were working, there was the prob=
lem :
ct 5 16:42:24 u1209-01l kernel: [ 58.783078] CIFS VFS: No response for =
cmd 114 mid 1
Oct 5 16:42:24 u1209-01l kernel: [ 58.783094] CIFS VFS: cifs_mount fail=
ed w/return code =3D -112
Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:64): Errors f=
rom underlying mount program:
Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): mount er=
ror(112): Host is down
Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): Refer to=
 the mount.cifs(8) manual page (e.g. man mount.cifs)
Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(pam_mount.c:521): mou=
nt of data/u20 failed

And the windows share went completely out of line: the server must be r=
ebooted ...
I have put=20
modprobe cifs
echo 0 > /proc/fs/cifs/OplockEnabled
on the /etc/rc.d/rc.local in all the linux clients and everything was r=
esolved.

Everything is working fine for several months.

Now in another part of the university, I have put the same system on 10=
0 Fedora 14 clients.
The only difference is the Windows Server is 2008 R2 and don't use the =
same SMB: version 2.1
The problem is back again... The windows share freezes and the windows =
server R2 must be rebooted.
echo 0 > /proc/fs/cifs/OplockEnabled don't seem to work anymore
I don't understand well how to resolve the problem.
Is this a cifs problem ? Must I downgrade the windows Server to 2008 ?
I have read about to put max protocol =3D smb2 in smb.conf. What must I=
 investigate for resolving this ?

Cheers,
Thanks.
Serge

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
