From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs question: mounting a cifs share located on an IBM
 z/OS mainframe to a linux machine
Date: Wed, 9 Apr 2014 15:38:07 -0400
Message-ID: <20140409153807.05b587fa@tlielax.poochiereds.net>
References: <CACERx8gmfuw+B7zkX+hfTOFrpTghEVkSEMxSK+TZ9QsrG9vFkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACERx8gmfuw+B7zkX+hfTOFrpTghEVkSEMxSK+TZ9QsrG9vFkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Apr 2014 12:22:38 +0300
Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Hi guys,
> Has anyone successfully mounted a cifs share from a z/OS mainframe to
> a linux machine?
> We have a partner who is trying to do that, but the mount fails with =
a
> Input/Output error. The same share is successfully mounted to a
> Windows 7 or a Mac. The attached wireshark captures seem to show that
> the z/OS returns a malformed Protocol Negotiation request to the
> mount.cifs, but returns a correct packet to the Windows machine.
> The user is running an Ububtu 12.04 TLS, kernel version 3.11.0-19-gen=
eric.
> Also tried Ubuntu 10.04 and Centos6.5 with identical results.
> The server is a z/OS 1.13
>=20
> Here are the commands we tried:
>=20
> root@cnaf-app-00:~# mount --verbose -t cifs //192.182.1.212/samba
> /media/samba -o username=3Dmreeves%amoscat0,sec=3Dntlm
> mount.cifs kernel mount options:
> ip=3D192.168.1.212,unc=3D//192.168.1.212/samba,sec=3Dntlm,ver=3D1,use=
r=3Dmreeves,pass=3D********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> root@cnaf-app-00:~# mount --verbose -t cifs //192.182.1.212/samba
> /media/samba -o username=3Dmreeves%amoscat0,sec=3DNTLMv2
> mount.cifs kernel mount options:
> ip=3D192.168.1.212,unc=3D//192.168.1.212/samba,sec=3DNTLMv2,ver=3D1,u=
ser=3Dmreeves,pass=3D********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> root@cnaf-app-00:~# mount --verbose -t cifs //192.168.1.212/samba
> /media/samba -o username=3Dmreeves%amoscat0,sec=3Dlanman
> mount.cifs kernel mount options:
> ip=3D192.168.1.212,unc=3D//192.168.1.212/samba,sec=3Dlanman,ver=3D1,u=
ser=3Dmreeves,pass=3D********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>=20
> smbclient appears to work, but we get some garbage:
> oot@cnaf-app-00:/etc/samba# smbclient //192.168.1.212/samba -U
> mreeves%amoscat0
> Domain=3D[=E2=96=A0=C2=A3=C3=87=E2=96=A0=E2=95=9D=C3=87=E2=96=A0=C3=AA=
=C3=87=E2=96=A0=C2=BC=C3=87=E2=96=A0=C2=A3=C3=87=E2=96=A0=C3=AA=C3=87=E2=
=96=A0=E2=95=9D=C3=87=E2=96=A0
> >
> > =C3=B6=C3=87=E2=96=A0=C3=87=C3=87]
> > OS=3D[=E2=96=A0=C3=AE=C3=87=E2=96=A0=E2=95=9D=C3=87=E2=96=A0=C3=AE=C3=
=87=E2=96=A0=C3=B1=C3=87=E2=96=A0=C3=87=C3=87=E2=96=A0=C3=87=C3=87=E2=96=
=A0=C3=BF=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=C3=A1=
=C3=87=E2=96=A0=E2=94=A4=C3=87=E2=96=A0=C3=87=C3=87]
> > Server=3D[=E2=96=A0=C3=B1=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=E2=94=
=A4=C3=87=E2=96=A0=C3=87=C3=87=E2=96=A0=C3=AE=C3=87=C2=B0=C3=B6=C3=87=C2=
=B1=C3=AA=C3=87=C2=B1=C3=BF=C3=87=C2=B0=C3=B6=C3=87=C2=B1=C3=AA=C3=87=E2=
=96=A0=C3=87=C3=87=C2=B0=C3=BF=C3=87=C2=B0=E2=95=9D=C3=87=C2=B1=C3=AA=C3=
=87=E2=96=A0=C3=87=C3=87=E2=96=A0=C2=A3=C3=87=C2=B0=C3=B1=C3=87=C2=B0=E2=
=95=95=C3=87=C2=B0=C3=89=C3=87=C2=B0=E2=95=9D=C3=87=C2=B1=C2=A3=C3=87=C2=
=B1=C3=AE=C3=87=E2=96=A0=C3=87=C3=87=E2=96=A0=E2=95=95=C3=87=C2=B0=C3=B6=
=C3=87=C2=B1=C3=89=C3=87=C2=B1=C2=A3=C3=87=C2=B0=E2=95=9D=C3=87=C2=B1=C3=
=AA=C3=87=C2=B0=C2=BC=C3=87=E2=96=A0=C3=87=C3=87=E2=96=A0=E2=95=95=C3=87=
=C2=B0=C3=B6=C3=87=C2=B0=C3=B1=C3=87=C2=B0=C2=A3=C3=87=C2=B0=C3=A1=C3=87=
=C2=B0=C3=AA=C3=87=C2=B0=E2=95=9D=C3=87=C2=B1=C3=AA=C3=87=C2=B0=C3=A1=C3=
=87=C2=B0=E2=95=9D=C3=87=C2=B0=E2=95=9D=C3=87=C2=B0=C3=89=C3=87]
> > smb: \> ls
> > .                                   D        0  Thu Apr  3 06:43:17=
 2014
> > ..                                  D        0  Thu Apr  3 06:43:17=
 2014
> > ._.DS_Store                               4096  Thu Apr  3 06:43:17=
 2014
> > .DS_Store                                 6148  Thu Apr  3 06:43:39=
 2014
> > shellscript.txt                           3260  Wed Apr  2 19:09:53=
 2014
> >
> >              65535 blocks of size 32768. 65535 blocks available
> > smb: \>
>=20
>=20
> The following appears in the logs:
>=20
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.808997] CIFS VFS:
> RFC1001 size 84 smaller than SMB for mid=3D1
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809034] Bad SMB: : dump
> of 48 bytes of data at 0xffff880019744540
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809037]  54000000
> 424d53ff 00000072 c8018000 . . . T =CB=87 S M B r . . . . . . =C2=BB
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809039]  00000000
> 00000000 00000000 0e260000 . . . . . . . . . . . . . . & .
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809041]  00010000
> 03000211 00010032 0000ffff . . . . . . . . 2 . . . =CB=87 =CB=87 . .
> Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809107] CIFS VFS:
> cifs_mount failed w/return code =3D -5
>=20
> This is the z/OS machine configuration:
>=20
> _IOE_DFS_MODIFY_PATH=3D/opt/dfslocal/home/dfscntl/modify.rendezvous
> _IOE_MVS_DFSDFLT=3DEMCROOT
> _IOE_LFS_SYNC_INTERVAL=3D30
> _IOE_SMB_CLEAR_PW=3DNOTALLOWED
> _IOE_DYNAMIC_EXPORT=3DON
> _IOE_SMB_TRANSPORTS=3DBOTH
> _IOE_SMB_CONNECT_MSGS=3D2
> _IOE_SERVER_NAME=3DEMCZPDT1
> _IOE_SMB_COMPUTER_NAME=3DEMCZPDT1
> _IOE_SMB_DOMAIN_NAME=3DWORKGROUP
> _IOE_SMB_IDMAP=3D/opt/dfslocal/home/dfskern/smbidmap
> _IOE_PROTOCOL_SMB=3DON
> _IOE_WIRE_CODEPAGE=3DISO8859-1
> _EUV_SVC_MSG_LOGGING=3DCONSOLE_LOGGING
> DCE_START_SOCKET_NAME=3D/opt/dfslocal/home/dfscntl/ioepk.soc
> TZ=3DEST5EDT
> _EUV_AUTOLOG=3DNO
> #NLSPATH=3D/usr/lib/nls/msg/%L/%N:/usr/lpp/Printsrv/En_US/%N
> NLSPATH=3D/usr/lib/nls/msg/%L/%N
> LANG=3DEn_US.IBM-1047
> #LIBPATH=3D/usr/lib:/usr/lpp/Printsrv/lib
> LIBPATH=3D/usr/lib
> _IOE_SMB_OCSF=3DOFF
>=20
> I am attaching wireshark captures of both the successful mount from a
> windows machine and the failed one from the linux machine.
>=20
> After my initial mail on the samba-technical list, I was contacted by
> someone in an identical situation who has also been unable to access
> their z/OS shares after switching to  RHEL 6.x from Windows, so I
> guess this is not an isolated incident.
>=20
> If anyone has experience with this and has any ideas, any possible
> problems with the configuration, I would appreciate it!
>=20
> Best Regards,
> Nadezhda

Hi Nadezhda!

This server just looks to be broken.

The server claims to support unicode according to the capability bits
and then sends an ASCII string in the Primary Domain field in the
windows capture -- that's just wrong AFAIK.

In the linux capture, that field is these bytes:

    00 ff 53 4d 42 25 00

=2E..which is also not proper unicode. Even worse, it starts with a NUL=
L,
and then follows with the standard SMB protocol header. Looks maybe
they have some sort of alignment problem there and a trailing SMB got
tacked on to the end of this one. Nasty!

They should really talk to their server vendor ;)

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
