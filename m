From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: CIFS VFS: Unexpected SMB signature ...NULL inode in lookup
Date: Fri, 07 Dec 2012 15:19:51 +0100
Message-ID: <413918845.327740.1354889991393.JavaMail.www@wwinf8228>
References: <546150668.69990.1354627396422.JavaMail.www@wwinf8225>
 <CAH2r5mv6mzbNCCd=sGf7Kb2nDiMrYyemFQTib9cW-YfAL1ydEg@mail.gmail.com>
 <1556345377.173552.1354718585931.JavaMail.www@wwinf8225>
 <CAH2r5msFLc2Sv1oYO6MVHQVSYQBt9fs+TWHAsgtwPxq302ayBA@mail.gmail.com>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msFLc2Sv1oYO6MVHQVSYQBt9fs+TWHAsgtwPxq302ayBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I did it at https://bugzilla.samba.org/show_bug.cgi?id=3D9477
I will try to do a network trace, but the bug don't
appears often. About three times every day but not on the same machine.=
=20

Thanks,
Serge
> Message du 05/12/12 16:18
> De : "Steve French"=20
> A : "sergio.conrad"=20
> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode in looku=
p
>
> Could you open a bugzilla bug at bugzilla.samba.org and if possible
> attach a network trace around the time that this is triggered (if it
> is trivial to reproduce)
> https://wiki.samba.org/index.php/Capture_Packets
>=20
> On Wed, Dec 5, 2012 at 8:43 AM, sergio.conrad  wrote:
> > Hello,
> >
> > The log are from 2.6.43.8-1.fc15.x86_64.
> > I see also the error CIFS VFS: Unexpected SMB signature with the sa=
me environnement on a 3.6.6-1.fc16.x86_64
> >
> > Thanks,
> >
> > Serge
> >
> >
> >> Message du 04/12/12 20:06
> >> De : "Steve French"
> >> A : "sergio.conrad"
> >> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode in lo=
okup
> >>
> >> What kernel version?
> >>
> >> I would not expect the "noserverino" mount option to be a factor.
> >> Jeff did fix one warning relating to unexpected signatures in this
> >> patch, see below (which I don't think is your issue (if the signat=
ure
> >> is coming on a transact2 request).
> >>
> >> commit 9c4843ea576107a3c1fb94f2f758f198e9fe9e54
> >> Author: Jeff Layton
> >> Date: Mon Jun 6 15:40:23 2011 -0400
> >>
> >> cifs: silence printk when establishing first session on socket
> >>
> >> When signing is enabled, the first session that's established on a
> >> socket will cause a printk like this to pop:
> >>
> >> CIFS VFS: Unexpected SMB signature
> >>
> >> This is because the key exchange hasn't happened yet, so the signa=
ture
> >> field is bogus. Don't try to check the signature on the socket unt=
il the
> >> first session has been established. Also, eliminate the specific c=
heck
> >> for SMB_COM_NEGOTIATE since this check covers that case too.
> >>
> >>
> >> On Tue, Dec 4, 2012 at 7:23 AM, sergio.conrad wrote:
> >> > Hi,
> >> >
> >> > I have a problem with users losing their connections from linux =
clients with cifs share. (Windows 2008) :CIFS VFS: Unexpected SMB signa=
ture
> >> > I am using two methods for mounting: pam_mount and autofs, both =
with same results.
> >> >
> >> > I am using mount options nounix,noserverino
> >> >
> >> > I am lauching cifs module on boot (rc.local) with
> >> > modprobe cifs
> >> > echo 0 > /proc/fs/cifs/OplockEnabled
> >> > echo 1 > /proc/fs/cifs/MultiuserMount
> >> > echo 7 > /proc/fs/cifs/cifsFYI
> >> >
> >> > What happens :
> >> > in /var/log/messages
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.140040] CIFS VFS: Unexpe=
cted lookup error -512
> >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.334939] CIFS VFS: Unexpe=
cted SMB signature
> >> >
> >> > This user was working since one hour with no problem :
> >> > Daemon log :
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: key description: cifs.spne=
go;0;0;3f000000
> >> > ;ver=3D0x2;host=3Dfigue;ip4=3D130.xxx.xxx.xxx;sec=3Dkrb5;uid=3D0=
x1000005;creduid=3D0x1000005;us
> >> > er=3D21206xxx;pid=3D0x65f
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ver=3D2
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: host=3Dfigue
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ip=3D130.120.8.11
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: sec=3D1
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: uid=3D16777221
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: creduid=3D16777221
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: user=3D21206xxx
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: pid=3D1631
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc: considering =
/tmp/krb5cc_167
> >> > 77221
> >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc: FILE:/tmp/kr=
b5cc_16777221 i
> >> > s valid ccache
> >> >
> >> > in dmesg
> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > fs/cifs/inode.c: Getting info on \21206xxx\TP9
> >> > [ 3735.419612] fs/cifs/transport.c: For smb_command 50
> >> > [ 3735.419615] fs/cifs/transport.c: Sending smb: total_len 104
> >> > [ 3735.420257] fs/cifs/connect.c: RFC1002 header 0x23
> >> > [ 3735.420261] fs/cifs/connect.c: invalid transact2 word count
> >> > [ 3735.422403] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D=
50 mid=3D37012 state=3D4
> >> > [ 3735.422406] CIFS VFS: Unexpected SMB signature
> >> > [ 3735.422408] Status code returned 0xc0000022 NT_STATUS_ACCESS_=
DENIED
> >> > [ 3735.422411] fs/cifs/netmisc.c: Mapping smb error code 0xc0000=
022 to POSIX err -13
> >> > [ 3735.422413] fs/cifs/cifssmb.c: Send error in QPathInfo =3D -1=
3
> >> > [ 3735.422415] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid=
 =3D 76854) rc =3D -13
> >> > [ 3735.422424] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 7=
6855 with uid: 16777221
> >> > [ 3735.422427] fs/cifs/dir.c: parent inode =3D 0xf14481f0 name i=
s: TP9 and dentry =3D 0xf074e300
> >> > [ 3735.422429] fs/cifs/dir.c: NULL inode in lookup
> >> > [ 3735.422430] fs/cifs/dir.c: Full path: \21206xxx\TP9 inode =3D=
 0x (null)
> >> >
> >> > I don't understand what happens...
> >> > NULL inode in lookup ... What about noserverino option ?
> >> > Perhaps an unresponsive server... The network infrastructure is =
old. Last year I got this working very well, but the server was in a be=
tter place (switch and network infrastructure speaking)
> >> >
> >> > Regards,
> >> > Thanks in advance
> >> > Serge Conrad
> >> >
> >> > Une messagerie gratuite, garantie =C3=A0 vie et des services en =
plus, =C3=A7a vous tente ?
> >> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
cifs" in
> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > More majordomo info at http://vger.kernel.org/majordomo-info.htm=
l
> >>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at http://vger.kernel.org/majordomo-info.html
> >>
> >
> > Une messagerie gratuite, garantie =C3=A0 vie et des services en plu=
s, =C3=A7a vous tente ?
> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
>=20
>=20
>=20
> --=20
> Thanks,
>=20
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
