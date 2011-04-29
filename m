From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS Not Responding Error On Working System
Date: Fri, 29 Apr 2011 09:32:56 -0400
Message-ID: <20110429093256.3c33cd01@corrin.poochiereds.net>
References: <4DB9BFBA.3020403@softtalker.com>
	<BANLkTinoC1d=NBLyzXa61cB+tR-+4F50zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mike <miked-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinoC1d=NBLyzXa61cB+tR-+4F50zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 29 Apr 2011 07:13:05 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Apr 28, 2011 at 2:27 PM, Mike <miked-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org> wrote:
> > Hopefully I am submitting this to the correct email list. =C2=A0I h=
ave been doing
> > Google searches and haven't found anyone that has the same string i=
n their
> > log file, so I'm looking for help on this issue.
> >
> > Recently I lost my hard drive and had to reinstall Debian. =C2=A0I =
am now getting
> > these errors in /var/log/syslog and I can't figure out why:
> > Apr 28 11:57:05 rockenfield kernel: [1479867.192022] CIFS VFS: Serv=
er peart
> > has not responded in 300 seconds. Reconnecting...
> >
> > The weird thing is that there are no problems. =C2=A0I can view the=
 shares on the
> > remote Windows machine (peart is WinXP 64 SP2) with no problems wha=
tsoever.
> > =C2=A0Also my Windows machine can see my samba shares as well, so b=
oth directions
> > work fine and I'm not sure why these messages are occurring.
> >
> >
> > Here is my /etc/fstab (samba/cifs mounts only, trimmed to applicabl=
e
> > content):
> > //peart/mp3 =C2=A0/mnt/peart/mp3 cifs
> > defaults,credentials=3D/etc/samba/smbpass.peart,_netdev 0 0
> > //peart/software =C2=A0/mnt/peart/software cifs
> > defaults,credentials=3D/etc/samba/smbpass.peart,_netdev 0 0
> > //peart/backup =C2=A0/mnt/peart/backup cifs
> > defaults,credentials=3D/etc/samba/smbpass.peart,_netdev 0 0
> > //peart/dvd =C2=A0/mnt/peart/dvd cifs
> > defaults,credentials=3D/etc/samba/smbpass.peart,_netdev 0 0
> >
> >
> > Here is my /etc/samba/smb.conf:
> > [global]
> > =C2=A0 workgroup =3D HOME_NETWORK
> > =C2=A0 netbios name =3D ROCKENFIELD
> > =C2=A0 server string =3D %h server - Debian GNU/Linux
> > =C2=A0 dns proxy =3D no
> > =C2=A0 name resolve order =3D lmhosts host wins bcast
> > =C2=A0 interfaces =3D 192.168.123.0/24 eth1
> > =C2=A0 bind interfaces only =3D yes
> > =C2=A0 hosts allow =3D 192.168.123.
> > =C2=A0 log file =3D /var/log/samba/log.%m
> > =C2=A0 max log size =3D 1000
> > =C2=A0 syslog =3D 0
> > =C2=A0 panic action =3D /usr/share/samba/panic-action %d
> > =C2=A0 security =3D user
> > =C2=A0 encrypt passwords =3D true
> > =C2=A0 passdb backend =3D tdbsam
> > =C2=A0 obey pam restrictions =3D yes
> > =C2=A0 unix password sync =3D yes
> > =C2=A0 passwd program =3D /usr/bin/passwd %u
> > =C2=A0 passwd chat =3D *Enter\snew\s*\spassword:* %n\n *Retype\snew=
\s*\spassword:*
> > %n\n *password\supdated\ssuccessfully* .
> > =C2=A0 pam password change =3D yes
> > =C2=A0 socket options =3D TCP_NODELAY SO_RCVBUF=3D8192 SO_SNDBUF=3D=
8192
> > [homes]
> > =C2=A0 comment =3D Home Directories
> > =C2=A0 browseable =3D no
> > =C2=A0 read only =3D no
> > =C2=A0 create mask =3D 0700
> > =C2=A0 directory mask =3D 0700
> > =C2=A0 valid users =3D %S
> > [printers]
> > =C2=A0 comment =3D All Printers
> > =C2=A0 browseable =3D no
> > =C2=A0 path =3D /var/spool/samba
> > =C2=A0 printable =3D yes
> > =C2=A0 guest ok =3D no
> > =C2=A0 read only =3D yes
> > =C2=A0 create mask =3D 0700
> > [print$]
> > =C2=A0 comment =3D Printer Drivers
> > =C2=A0 path =3D /var/lib/samba/printers
> > =C2=A0 browseable =3D yes
> > =C2=A0 read only =3D yes
> > =C2=A0 guest ok =3D no
> >
> >
> > I am running Debian wheezy/testing (7.0). =C2=A0The kernel version =
is
> > 2.6.38-2-amd64. =C2=A0Samba version is 3.5.8~dfsg-1 (obtained from =
"dpkg -l |
> > grep samba"). =C2=A0This is just a home network, so I don't have a =
Domain
> > Controller or anything fancy. =C2=A0It's just a Debian box and a Wi=
nXP box and
> > I'm sharing files/directories on each side.
> >
> > Any help is greatly appreciated. =C2=A0Thanks!
> > -MikeD
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
> May be some issues like firewall etc.?
> Can you capture wireshark traces on either side and see if you see
> any network in response to a mount reuqest from a cifs client?

To be clear...

What sort of host is "peart" here? WinXP?
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
