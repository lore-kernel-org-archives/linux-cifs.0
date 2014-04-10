From: Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: mount.cifs question: mounting a cifs share located on an IBM z/OS
 mainframe to a linux machine
Date: Thu, 10 Apr 2014 20:41:02 +0300
Message-ID: <CACERx8iEFmb+y+N4NAeqpcDtqZi+C-EWPuvA01E+1QpR4bKynw@mail.gmail.com>
References: <CACERx8gmfuw+B7zkX+hfTOFrpTghEVkSEMxSK+TZ9QsrG9vFkA@mail.gmail.com>
	<20140409153807.05b587fa@tlielax.poochiereds.net>
	<CACERx8gGJQ6ykNp5XGVX_YZdOL9figHG-2v7y39Bs4_ha6f7Hg@mail.gmail.com>
	<20140409162739.65689422@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140409162739.65689422-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,
Thank you for the detailed explanation! The stricter checking makes
sense to me now.
Can you tell me what is wrong with the Protocol Negotiation response
returned to the windows client (the win_cifs.cap)? I thought it was
correct, as it has indeed 18 bytes after bcc, and you can see that the
primary domain is WORKGROUP, obviously I am missing something...

Regards,
Nadya

On Wed, Apr 9, 2014 at 11:27 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 9 Apr 2014 23:04:20 +0300
> Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Hi Jeff,
>> Thanks for the answer!
>> I agree that something is broken with the server. However, since the=
 server
>> sends correct packets to Windows and Mac (as evidenced by the other
>> capture), I thought there may be something in the linux client that =
exposes
>> a hidden bug on the server, and there may be a workaround, and someo=
ne
>> among the experienced CIFS masters might have heard of it :).
>>
>> I may try and find out what that is when I have time...
>>
>
> They're not correct packets, unfortunately, it's just that Windows an=
d
> Macs are less strict about checking of frame lengths than the linux
> client is.
>
> The problem in your case is coming from the checkSMB function, which
> verifies that the lengths in the packet match up. In this case, the
> RFC1001 length at the start of the frame is shorter than the the leng=
th
> we get back from smbCalcSize (which totals up the header length, word
> count and byte count).
>
> In point of fact, it looks like the BCC is where things are broken. I=
t
> says that it's 18 bytes, but the frame ends 15 bytes later. If we end=
ed
> up trusting the BCC in that frame then we'd quite possibly end up
> walking off the end of the packet. Since cifs.ko lives in the kernel,
> we're a bit paranoid about buffer overruns. ;)
>
> You can relax the checks in there (at your own risk!) but I don't thi=
nk
> we'd be amenable to any patches that do so in the mainline kernel.
>
>>
>>
>> Regards,
>>
>> Nadya
>>
>>
>> On Wed, Apr 9, 2014 at 10:38 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>
>> > On Wed, 9 Apr 2014 12:22:38 +0300
>> > Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> >
>> > > Hi guys,
>> > > Has anyone successfully mounted a cifs share from a z/OS mainfra=
me to
>> > > a linux machine?
>> > > We have a partner who is trying to do that, but the mount fails =
with a
>> > > Input/Output error. The same share is successfully mounted to a
>> > > Windows 7 or a Mac. The attached wireshark captures seem to show=
 that
>> > > the z/OS returns a malformed Protocol Negotiation request to the
>> > > mount.cifs, but returns a correct packet to the Windows machine.
>> > > The user is running an Ububtu 12.04 TLS, kernel version
>> > 3.11.0-19-generic.
>> > > Also tried Ubuntu 10.04 and Centos6.5 with identical results.
>> > > The server is a z/OS 1.13
>> > >
>> > > Here are the commands we tried:
>> > >
>> > > root@cnaf-app-00:~# mount --verbose -t cifs //192.182.1.212/samb=
a
>> > > /media/samba -o username=3Dmreeves%amoscat0,sec=3Dntlm
>> > > mount.cifs kernel mount options:
>> > > ip=3D192.168.1.212,unc=3D//
>> > 192.168.1.212/samba,sec=3Dntlm,ver=3D1,user=3Dmreeves,pass=3D*****=
***
>> > > mount error(5): Input/output error
>> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>> > > root@cnaf-app-00:~# mount --verbose -t cifs //192.182.1.212/samb=
a
>> > > /media/samba -o username=3Dmreeves%amoscat0,sec=3DNTLMv2
>> > > mount.cifs kernel mount options:
>> > > ip=3D192.168.1.212,unc=3D//
>> > 192.168.1.212/samba,sec=3DNTLMv2,ver=3D1,user=3Dmreeves,pass=3D***=
*****
>> > > mount error(5): Input/output error
>> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>> > > root@cnaf-app-00:~# mount --verbose -t cifs //192.168.1.212/samb=
a
>> > > /media/samba -o username=3Dmreeves%amoscat0,sec=3Dlanman
>> > > mount.cifs kernel mount options:
>> > > ip=3D192.168.1.212,unc=3D//
>> > 192.168.1.212/samba,sec=3Dlanman,ver=3D1,user=3Dmreeves,pass=3D***=
*****
>> > > mount error(5): Input/output error
>> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>> > >
>> > > smbclient appears to work, but we get some garbage:
>> > > oot@cnaf-app-00:/etc/samba# smbclient //192.168.1.212/samba -U
>> > > mreeves%amoscat0
>> > > Domain=3D[=E2=96=A0=C2=A3=C3=87=E2=96=A0=E2=95=9D=C3=87=E2=96=A0=
=C3=AA=C3=87=E2=96=A0=C2=BC=C3=87=E2=96=A0=C2=A3=C3=87=E2=96=A0=C3=AA=C3=
=87=E2=96=A0=E2=95=9D=C3=87=E2=96=A0
>> > > >
>> > > > =C3=B6=C3=87=E2=96=A0=C3=87=C3=87]
>> > > > OS=3D[=E2=96=A0=C3=AE=C3=87=E2=96=A0=E2=95=9D=C3=87=E2=96=A0=C3=
=AE=C3=87=E2=96=A0=C3=B1=C3=87=E2=96=A0=C3=87=C3=87=E2=96=A0=C3=87=C3=87=
=E2=96=A0=C3=BF=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=
=C3=A1=C3=87=E2=96=A0=E2=94=A4=C3=87=E2=96=A0=C3=87=C3=87]
>> > > >
>> > Server=3D[=E2=96=A0=C3=B1=C3=87=E2=96=A0=C3=AA=C3=87=E2=96=A0=E2=94=
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
>> > > > smb: \> ls
>> > > > .                                   D        0  Thu Apr  3 06:=
43:17
>> > 2014
>> > > > ..                                  D        0  Thu Apr  3 06:=
43:17
>> > 2014
>> > > > ._.DS_Store                               4096  Thu Apr  3 06:=
43:17
>> > 2014
>> > > > .DS_Store                                 6148  Thu Apr  3 06:=
43:39
>> > 2014
>> > > > shellscript.txt                           3260  Wed Apr  2 19:=
09:53
>> > 2014
>> > > >
>> > > >              65535 blocks of size 32768. 65535 blocks availabl=
e
>> > > > smb: \>
>> > >
>> > >
>> > > The following appears in the logs:
>> > >
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.808997] CIFS VFS:
>> > > RFC1001 size 84 smaller than SMB for mid=3D1
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809034] Bad SMB: :=
 dump
>> > > of 48 bytes of data at 0xffff880019744540
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809037]  54000000
>> > > 424d53ff 00000072 c8018000 . . . T =CB=87 S M B r . . . . . . =C2=
=BB
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809039]  00000000
>> > > 00000000 00000000 0e260000 . . . . . . . . . . . . . . & .
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809041]  00010000
>> > > 03000211 00010032 0000ffff . . . . . . . . 2 . . . =CB=87 =CB=87=
 . .
>> > > Apr  4 10:27:28 ubu-14-server1 kernel: [ 4652.809107] CIFS VFS:
>> > > cifs_mount failed w/return code =3D -5
>> > >
>> > > This is the z/OS machine configuration:
>> > >
>> > > _IOE_DFS_MODIFY_PATH=3D/opt/dfslocal/home/dfscntl/modify.rendezv=
ous
>> > > _IOE_MVS_DFSDFLT=3DEMCROOT
>> > > _IOE_LFS_SYNC_INTERVAL=3D30
>> > > _IOE_SMB_CLEAR_PW=3DNOTALLOWED
>> > > _IOE_DYNAMIC_EXPORT=3DON
>> > > _IOE_SMB_TRANSPORTS=3DBOTH
>> > > _IOE_SMB_CONNECT_MSGS=3D2
>> > > _IOE_SERVER_NAME=3DEMCZPDT1
>> > > _IOE_SMB_COMPUTER_NAME=3DEMCZPDT1
>> > > _IOE_SMB_DOMAIN_NAME=3DWORKGROUP
>> > > _IOE_SMB_IDMAP=3D/opt/dfslocal/home/dfskern/smbidmap
>> > > _IOE_PROTOCOL_SMB=3DON
>> > > _IOE_WIRE_CODEPAGE=3DISO8859-1
>> > > _EUV_SVC_MSG_LOGGING=3DCONSOLE_LOGGING
>> > > DCE_START_SOCKET_NAME=3D/opt/dfslocal/home/dfscntl/ioepk.soc
>> > > TZ=3DEST5EDT
>> > > _EUV_AUTOLOG=3DNO
>> > > #NLSPATH=3D/usr/lib/nls/msg/%L/%N:/usr/lpp/Printsrv/En_US/%N
>> > > NLSPATH=3D/usr/lib/nls/msg/%L/%N
>> > > LANG=3DEn_US.IBM-1047
>> > > #LIBPATH=3D/usr/lib:/usr/lpp/Printsrv/lib
>> > > LIBPATH=3D/usr/lib
>> > > _IOE_SMB_OCSF=3DOFF
>> > >
>> > > I am attaching wireshark captures of both the successful mount f=
rom a
>> > > windows machine and the failed one from the linux machine.
>> > >
>> > > After my initial mail on the samba-technical list, I was contact=
ed by
>> > > someone in an identical situation who has also been unable to ac=
cess
>> > > their z/OS shares after switching to  RHEL 6.x from Windows, so =
I
>> > > guess this is not an isolated incident.
>> > >
>> > > If anyone has experience with this and has any ideas, any possib=
le
>> > > problems with the configuration, I would appreciate it!
>> > >
>> > > Best Regards,
>> > > Nadezhda
>> >
>> > Hi Nadezhda!
>> >
>> > This server just looks to be broken.
>> >
>> > The server claims to support unicode according to the capability b=
its
>> > and then sends an ASCII string in the Primary Domain field in the
>> > windows capture -- that's just wrong AFAIK.
>> >
>> > In the linux capture, that field is these bytes:
>> >
>> >     00 ff 53 4d 42 25 00
>> >
>> > ...which is also not proper unicode. Even worse, it starts with a =
NULL,
>> > and then follows with the standard SMB protocol header. Looks mayb=
e
>> > they have some sort of alignment problem there and a trailing SMB =
got
>> > tacked on to the end of this one. Nasty!
>> >
>> > They should really talk to their server vendor ;)
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
