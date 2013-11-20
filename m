From: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Subject: Re: CIFS VFS: Unexpected SMB signature ...NULL inode in lookup
Date: Wed, 20 Nov 2013 08:48:15 +0100
Message-ID: <1130452222.82558.1384933695314.JavaMail.www@wwinf8313>
Reply-To: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hello
I have open a bug quite a while ago https://bugzilla.samba.org/show_bug=
=2Ecgi?id=3D9477 and don't have any news.=20
I am using sec=3Dkrb5i, but have the same problem with ntlmv2...

The problem is the same with a centos 6 computer.

Perhaps the problem is in the Windows Server ...
Do I have to change AllowLegacySrvCall as described in http://support.m=
icrosoft.com/kb/957441 ?
Perhaps I have to put a more recent driver in my server: It is a Dell T=
610 server
with a NetExtreme II gigabitE (version 5.2.14 17/12/2009) ?

Please help , as the problems continue ...
Thanks=20
Serge Conrad

Hello ...
in the messages, you could see an SMB unexpected signature (21 Jan 16:1=
3:16)
In the dump file , the trame no 470 is at the same time (16:13:16)

The environnement is the same as described in https://bugzilla.samba.or=
g/show_bug.cgi?id=3D9477

Regards,

Serge

> Message du 25/01/13 16:15
> De : "Steve French"=20
> A : "sergio. conrad"=20
> Copie =C3=A0 :=20
> Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode in looku=
p
>
> You could send the trace to me directly
> On Jan 25, 2013 8:42 AM, "sergio.conrad" wrote:
>=20
> > Hello
> > I do have a network trace for
> > https://bugzilla.samba.org/show_bug.cgi?id=3D9477
> > But there is the public adress ip of the server in the trace. I don=
't know
> > how to hide
> > this. Could I send the trace to you, or must I find a way to hide t=
he
> > trace ?
> >
> > Thanks
> > Serge
> >
> > > Message du 05/12/12 16:18
> > > De : "Steve French"
> > > A : "sergio.conrad"
> > > Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode in l=
ookup
> > >
> > > Could you open a bugzilla bug at bugzilla.samba.org and if possib=
le
> > > attach a network trace around the time that this is triggered (if=
 it
> > > is trivial to reproduce)
> > > https://wiki.samba.org/index.php/Capture_Packets
> > >
> > > On Wed, Dec 5, 2012 at 8:43 AM, sergio.conrad wrote:
> > > > Hello,
> > > >
> > > > The log are from 2.6.43.8-1.fc15.x86_64.
> > > > I see also the error CIFS VFS: Unexpected SMB signature with th=
e same
> > environnement
> > on a 3.6.6-1.fc16.x86_64
> > > >
> > > > Thanks,
> > > >
> > > > Serge
> > > >
> > > >
> > > >> Message du 04/12/12 20:06
> > > >> De : "Steve French"
> > > >> A : "sergio.conrad"
> > > >> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >> Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode i=
n lookup
> > > >>
> > > >> What kernel version?
> > > >>
> > > >> I would not expect the "noserverino" mount option to be a fact=
or.
> > > >> Jeff did fix one warning relating to unexpected signatures in =
this
> > > >> patch, see below (which I don't think is your issue (if the si=
gnature
> > > >> is coming on a transact2 request).
> > > >>
> > > >> commit 9c4843ea576107a3c1fb94f2f758f198e9fe9e54
> > > >> Author: Jeff Layton
> > > >> Date: Mon Jun 6 15:40:23 2011 -0400
> > > >>
> > > >> cifs: silence printk when establishing first session on socket
> > > >>
> > > >> When signing is enabled, the first session that's established =
on a
> > > >> socket will cause a printk like this to pop:
> > > >>
> > > >> CIFS VFS: Unexpected SMB signature
> > > >>
> > > >> This is because the key exchange hasn't happened yet, so the s=
ignature
> > > >> field is bogus. Don't try to check the signature on the socket=
 until
> > the
> > > >> first session has been established. Also, eliminate the specif=
ic check
> > > >> for SMB_COM_NEGOTIATE since this check covers that case too.
> > > >>
> > > >>
> > > >> On Tue, Dec 4, 2012 at 7:23 AM, sergio.conrad wrote:
> > > >> > Hi,
> > > >> >
> > > >> > I have a problem with users losing their connections from li=
nux
> > clients with cifs
> > share. (Windows 2008) :CIFS VFS: Unexpected SMB signature
> > > >> > I am using two methods for mounting: pam_mount and autofs, b=
oth
> > with same results.
> > > >> >
> > > >> > I am using mount options nounix,noserverino
> > > >> >
> > > >> > I am lauching cifs module on boot (rc.local) with
> > > >> > modprobe cifs
> > > >> > echo 0 > /proc/fs/cifs/OplockEnabled
> > > >> > echo 1 > /proc/fs/cifs/MultiuserMount
> > > >> > echo 7 > /proc/fs/cifs/cifsFYI
> > > >> >
> > > >> > What happens :
> > > >> > in /var/log/messages
> > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.140040] CIFS VFS:
> > Unexpected lookup error
> > -512
> > > >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.334939] CIFS VFS:
> > Unexpected SMB signature
> > > >> >
> > > >> > This user was working since one hour with no problem :
> > > >> > Daemon log :
> > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: key description:
> > cifs.spnego;0;0;3f000000
> > > >> >
> >
> > ;ver=3D0x2;host=3Dfigue;ip4=3D130.xxx.xxx.xxx;sec=3Dkrb5;uid=3D0x10=
00005;creduid=3D0x1000005;us
> > > >> > er=3D21206xxx;pid=3D0x65f
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ver=3D2
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: host=3Dfigue
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ip=3D130.120.8.11
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: sec=3D1
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: uid=3D16777221
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: creduid=3D16777221
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: user=3D21206xxx
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: pid=3D1631
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc: consider=
ing
> > /tmp/krb5cc_167
> > > >> > 77221
> > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc:
> > FILE:/tmp/krb5cc_16777221 i
> > > >> > s valid ccache
> > > >> >
> > > >> > in dmesg
> > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >> > fs/cifs/inode.c: Getting info on \21206xxx\TP9
> > > >> > [ 3735.419612] fs/cifs/transport.c: For smb_command 50
> > > >> > [ 3735.419615] fs/cifs/transport.c: Sending smb: total_len 1=
04
> > > >> > [ 3735.420257] fs/cifs/connect.c: RFC1002 header 0x23
> > > >> > [ 3735.420261] fs/cifs/connect.c: invalid transact2 word cou=
nt
> > > >> > [ 3735.422403] fs/cifs/transport.c: cifs_sync_mid_result: cm=
d=3D50
> > mid=3D37012 state=3D4
> > > >> > [ 3735.422406] CIFS VFS: Unexpected SMB signature
> > > >> > [ 3735.422408] Status code returned 0xc0000022
> > NT_STATUS_ACCESS_DENIED
> > > >> > [ 3735.422411] fs/cifs/netmisc.c: Mapping smb error code 0xc=
0000022
> > to POSIX err
> > -13
> > > >> > [ 3735.422413] fs/cifs/cifssmb.c: Send error in QPathInfo =3D=
 -13
> > > >> > [ 3735.422415] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup =
(xid =3D
> > 76854) rc =3D -13
> > > >> > [ 3735.422424] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xi=
d:
> > 76855 with uid:
> > 16777221
> > > >> > [ 3735.422427] fs/cifs/dir.c: parent inode =3D 0xf14481f0 na=
me is:
> > TP9 and dentry =3D
> > 0xf074e300
> > > >> > [ 3735.422429] fs/cifs/dir.c: NULL inode in lookup
> > > >> > [ 3735.422430] fs/cifs/dir.c: Full path: \21206xxx\TP9 inode=
 =3D 0x
> > (null)
> > > >> >
> > > >> > I don't understand what happens...
> > > >> > NULL inode in lookup ... What about noserverino option ?
> > > >> > Perhaps an unresponsive server... The network infrastructure=
 is
> > old. Last year I
> > got this working very well, but the server was in a better place (s=
witch
> > and network
> > infrastructure speaking)
> > > >> >
> > > >> > Regards,
> > > >> > Thanks in advance
> > > >> > Serge Conrad
> > > >> >
> > > >> > Une messagerie gratuite, garantie =C3=A0 vie et des services=
 en plus, =C3=A7a
> > vous tente ?
> > > >> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> > > >> > --
> > > >> > To unsubscribe from this list: send the line "unsubscribe
> > linux-cifs" in
> > > >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >> > More majordomo info at http://vger.kernel.org/majordomo-info=
=2Ehtml
> > > >>
> > > >>
> > > >>
> > > >> --
> > > >> Thanks,
> > > >>
> > > >> Steve
> > > >> --
> > > >> To unsubscribe from this list: send the line "unsubscribe linu=
x-cifs"
> > in
> > > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > >> More majordomo info at http://vger.kernel.org/majordomo-info.h=
tml
> > > >>
> > > >
> > > > Une messagerie gratuite, garantie =C3=A0 vie et des services en=
 plus, =C3=A7a
> > vous tente ?
> > > > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-c=
ifs" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > >
> >
> > Une messagerie gratuite, garantie =C3=A0 vie et des services en plu=
s, =C3=A7a vous
> > tente ?
> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
