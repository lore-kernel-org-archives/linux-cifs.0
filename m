From: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Subject: Re:Fwd: Re: Tr:Re: CIFS VFS: Unexpected SMB signature ...NULL inode
 in lookup
Date: Thu, 21 Nov 2013 22:11:01 +0100
Message-ID: <1215192824.56474.1385068261669.JavaMail.www@wwinf8224>
References: <774602681.119320.1384957272191.JavaMail.www@wwinf8225>
 <CAH2r5msWyGnKcsmD1L1qVC-NJBOR2cRfMvOC5==9ayEDm-tUcA@mail.gmail.com>
 <CAH2r5mtvDHHCyfnbE3fKwatz+emrq45JA8Lx7zahAmDz9bfZYA@mail.gmail.com>
Reply-To: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtvDHHCyfnbE3fKwatz+emrq45JA8Lx7zahAmDz9bfZYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Thanks, I have upgraded some workstations to Fedora 16 kernel 3.11. I w=
ill check if it=20
solve the issue.

> Message du 20/11/13 16:42
> De : "Steve French"
> A : "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
> Copie =C3=A0 :
> Objet : Fwd: Re: Tr:Re: CIFS VFS: Unexpected SMB signature ...NULL in=
ode in lookup
>
> ---------- Forwarded message ----------
> From: Steve French
> Date: Wed, Nov 20, 2013 at 9:01 AM
> Subject: Re: Re: Tr:Re: CIFS VFS: Unexpected SMB signature ...NULL
> inode in lookup
> To: "sergio.conrad"
>
>
> Looks like 3.10 kernels and later have this. Not sure if others have
> backported it earlier.
>
> On Wed, Nov 20, 2013 at 8:21 AM, wrote:
> >
> > Thanks for your response .
> >
> > I did my tests with a Centos 2.6.32-358.23.2.el6.i686 up to date, i=
t don't seems to
> > backport the update.
> >
> > Could the latest kernel from a Fedora incorporate the update ? it s=
eems to be 3.11.x
> > I will check either if Scientific Linux do this. How could I know b=
efore installing ?
> >
> > Thanks
> > Serge
> >
> >> Message du 20/11/13 15:17
> >> De : sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> >> A : "Jeff Layton"
> >> Copie =C3=A0 :
> >> Objet : Re: Tr:Re: CIFS VFS: Unexpected SMB signature ...NULL inod=
e in lookup
> >>
> >>
> >
> >
> >> Message du 20/11/13 12:33
> >> De : "Jeff Layton"
> >> A : sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> >> Copie =C3=A0 : "linux-cifs vger kernel org"
> >> Objet : Re: Tr:Re: CIFS VFS: Unexpected SMB signature ...NULL inod=
e in lookup
> >>
> >> On Wed, 20 Nov 2013 12:22:08 +0100
> >> sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org wrote:
> >>
> >> >
> >> > I can reproduce the error with this procedure :
> >> >
> >> >
> >> > a script:
> >> >
> >> > for num in $(seq 1 200)
> >> > do
> >> > dd if=3D/dev/zero of=3Dcifsmount/file${num} bs=3D1024 count=3D10=
00
> >> > done
> >> >
> >> >
> >> >
> >> > Execute the script, and send control-C several time when running
> >> >
> >> > 50 % chance i got unexpected SMB signature
> >> >
> >> > any idea ?
> >> >
> >> >
> >>
> >> You need a more recent kernel, or a backport of commit
> >> ad313cb86dfba27f8f2306da304974ef17c91c56.
> >>
> >> >
> >> > > Message du 20/11/13 08:48
> >> > > De : sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
> >> > > A : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > Copie =C3=A0 :
> >> > > Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode i=
n lookup
> >> > >
> >> > >
> >> > > Hello
> >> > > I have open a bug quite a while ago https://bugzilla.samba.org=
/show_bug.cgi?
id=3D9477
> > and
> >> > don't have any news.
> >> > > I am using sec=3Dkrb5i, but have the same problem with ntlmv2.=
=2E.
> >> > >
> >> > > The problem is the same with a centos 6 computer.
> >> > >
> >> > > Perhaps the problem is in the Windows Server ...
> >> > > Do I have to change AllowLegacySrvCall as described in
> >> > http://support.microsoft.com/kb/957441 ?
> >> > > Perhaps I have to put a more recent driver in my server: It is=
 a Dell T610=20
server
> >> > > with a NetExtreme II gigabitE (version 5.2.14 17/12/2009) ?
> >> > >
> >> > > Please help , as the problems continue ...
> >> > > Thanks
> >> > > Serge Conrad
> >> > >
> >> > > Hello ...
> >> > > in the messages, you could see an SMB unexpected signature (21=
 Jan 16:13:16)
> >> > > In the dump file , the trame no 470 is at the same time (16:13=
:16)
> >> > >
> >> > > The environnement is the same as described in
> > https://bugzilla.samba.org/show_bug.cgi?
> >> > id=3D9477
> >> > >
> >> > > Regards,
> >> > >
> >> > > Serge
> >> > >
> >> > > > Message du 25/01/13 16:15
> >> > > > De : "Steve French"
> >> > > > A : "sergio. conrad"
> >> > > > Copie =C3=A0 :
> >> > > > Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL inode=
 in lookup
> >> > > >
> >> > > > You could send the trace to me directly
> >> > > > On Jan 25, 2013 8:42 AM, "sergio.conrad" wrote:
> >> > > >
> >> > > > > Hello
> >> > > > > I do have a network trace for
> >> > > > > https://bugzilla.samba.org/show_bug.cgi?id=3D9477
> >> > > > > But there is the public adress ip of the server in the tra=
ce. I don't know
> >> > > > > how to hide
> >> > > > > this. Could I send the trace to you, or must I find a way =
to hide the
> >> > > > > trace ?
> >> > > > >
> >> > > > > Thanks
> >> > > > > Serge
> >> > > > >
> >> > > > > > Message du 05/12/12 16:18
> >> > > > > > De : "Steve French"
> >> > > > > > A : "sergio.conrad"
> >> > > > > > Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > > > Objet : Re: CIFS VFS: Unexpected SMB signature ...NULL i=
node in lookup
> >> > > > > >
> >> > > > > > Could you open a bugzilla bug at bugzilla.samba.org and =
if possible
> >> > > > > > attach a network trace around the time that this is trig=
gered (if it
> >> > > > > > is trivial to reproduce)
> >> > > > > > https://wiki.samba.org/index.php/Capture_Packets
> >> > > > > >
> >> > > > > > On Wed, Dec 5, 2012 at 8:43 AM, sergio.conrad wrote:
> >> > > > > > > Hello,
> >> > > > > > >
> >> > > > > > > The log are from 2.6.43.8-1.fc15.x86_64.
> >> > > > > > > I see also the error CIFS VFS: Unexpected SMB signatur=
e with the same
> >> > > > > environnement
> >> > > > > on a 3.6.6-1.fc16.x86_64
> >> > > > > > >
> >> > > > > > > Thanks,
> >> > > > > > >
> >> > > > > > > Serge
> >> > > > > > >
> >> > > > > > >
> >> > > > > > >> Message du 04/12/12 20:06
> >> > > > > > >> De : "Steve French"
> >> > > > > > >> A : "sergio.conrad"
> >> > > > > > >> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > > > >> Objet : Re: CIFS VFS: Unexpected SMB signature ...NUL=
L inode in lookup
> >> > > > > > >>
> >> > > > > > >> What kernel version?
> >> > > > > > >>
> >> > > > > > >> I would not expect the "noserverino" mount option to =
be a factor.
> >> > > > > > >> Jeff did fix one warning relating to unexpected signa=
tures in this
> >> > > > > > >> patch, see below (which I don't think is your issue (=
if the signature
> >> > > > > > >> is coming on a transact2 request).
> >> > > > > > >>
> >> > > > > > >> commit 9c4843ea576107a3c1fb94f2f758f198e9fe9e54
> >> > > > > > >> Author: Jeff Layton
> >> > > > > > >> Date: Mon Jun 6 15:40:23 2011 -0400
> >> > > > > > >>
> >> > > > > > >> cifs: silence printk when establishing first session =
on socket
> >> > > > > > >>
> >> > > > > > >> When signing is enabled, the first session that's est=
ablished on a
> >> > > > > > >> socket will cause a printk like this to pop:
> >> > > > > > >>
> >> > > > > > >> CIFS VFS: Unexpected SMB signature
> >> > > > > > >>
> >> > > > > > >> This is because the key exchange hasn't happened yet,=
 so the signature
> >> > > > > > >> field is bogus. Don't try to check the signature on t=
he socket until
> >> > > > > the
> >> > > > > > >> first session has been established. Also, eliminate t=
he specific check
> >> > > > > > >> for SMB_COM_NEGOTIATE since this check covers that ca=
se too.
> >> > > > > > >>
> >> > > > > > >>
> >> > > > > > >> On Tue, Dec 4, 2012 at 7:23 AM, sergio.conrad wrote:
> >> > > > > > >> > Hi,
> >> > > > > > >> >
> >> > > > > > >> > I have a problem with users losing their connection=
s from linux
> >> > > > > clients with cifs
> >> > > > > share. (Windows 2008) :CIFS VFS: Unexpected SMB signature
> >> > > > > > >> > I am using two methods for mounting: pam_mount and =
autofs, both
> >> > > > > with same results.
> >> > > > > > >> >
> >> > > > > > >> > I am using mount options nounix,noserverino
> >> > > > > > >> >
> >> > > > > > >> > I am lauching cifs module on boot (rc.local) with
> >> > > > > > >> > modprobe cifs
> >> > > > > > >> > echo 0 > /proc/fs/cifs/OplockEnabled
> >> > > > > > >> > echo 1 > /proc/fs/cifs/MultiuserMount
> >> > > > > > >> > echo 7 > /proc/fs/cifs/cifsFYI
> >> > > > > > >> >
> >> > > > > > >> > What happens :
> >> > > > > > >> > in /var/log/messages
> >> > > > > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >> > > > > > >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.140040] CIF=
S VFS:
> >> > > > > Unexpected lookup error
> >> > > > > -512
> >> > > > > > >> > Dec 3 17:31:01 u1205-08l kernel: [ 3732.334939] CIF=
S VFS:
> >> > > > > Unexpected SMB signature
> >> > > > > > >> >
> >> > > > > > >> > This user was working since one hour with no proble=
m :
> >> > > > > > >> > Daemon log :
> >> > > > > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: key descripti=
on:
> >> > > > > cifs.spnego;0;0;3f000000
> >> > > > > > >> >
> >> > > > >
> >> > > > >
> > ;ver=3D0x2;host=3Dfigue;ip4=3D130.xxx.xxx.xxx;sec=3Dkrb5;uid=3D0x10=
00005;creduid=3D0x1000005;us
> >> > > > > > >> > er=3D21206xxx;pid=3D0x65f
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ver=3D2
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: host=3Dfigue
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: ip=3D130.120.=
8.11
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: sec=3D1
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: uid=3D1677722=
1
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: creduid=3D167=
77221
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: user=3D21206x=
xx
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: pid=3D1631
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc:=
 considering
> >> > > > > /tmp/krb5cc_167
> >> > > > > > >> > 77221
> >> > > > > > >> > Dec 3 16:29:35 u1205-08l cifs.upcall: find_krb5_cc:
> >> > > > > FILE:/tmp/krb5cc_16777221 i
> >> > > > > > >> > s valid ccache
> >> > > > > > >> >
> >> > > > > > >> > in dmesg
> >> > > > > > >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > > > > > >> > fs/cifs/inode.c: Getting info on \21206xxx\TP9
> >> > > > > > >> > [ 3735.419612] fs/cifs/transport.c: For smb_command=
 50
> >> > > > > > >> > [ 3735.419615] fs/cifs/transport.c: Sending smb: to=
tal_len 104
> >> > > > > > >> > [ 3735.420257] fs/cifs/connect.c: RFC1002 header 0x=
23
> >> > > > > > >> > [ 3735.420261] fs/cifs/connect.c: invalid transact2=
 word count
> >> > > > > > >> > [ 3735.422403] fs/cifs/transport.c: cifs_sync_mid_r=
esult: cmd=3D50
> >> > > > > mid=3D37012 state=3D4
> >> > > > > > >> > [ 3735.422406] CIFS VFS: Unexpected SMB signature
> >> > > > > > >> > [ 3735.422408] Status code returned 0xc0000022
> >> > > > > NT_STATUS_ACCESS_DENIED
> >> > > > > > >> > [ 3735.422411] fs/cifs/netmisc.c: Mapping smb error=
 code 0xc0000022
> >> > > > > to POSIX err
> >> > > > > -13
> >> > > > > > >> > [ 3735.422413] fs/cifs/cifssmb.c: Send error in QPa=
thInfo =3D -13
> >> > > > > > >> > [ 3735.422415] fs/cifs/dir.c: CIFS VFS: leaving cif=
s_lookup (xid =3D
> >> > > > > 76854) rc =3D -13
> >> > > > > > >> > [ 3735.422424] fs/cifs/dir.c: CIFS VFS: in cifs_loo=
kup as Xid:
> >> > > > > 76855 with uid:
> >> > > > > 16777221
> >> > > > > > >> > [ 3735.422427] fs/cifs/dir.c: parent inode =3D 0xf1=
4481f0 name is:
> >> > > > > TP9 and dentry =3D
> >> > > > > 0xf074e300
> >> > > > > > >> > [ 3735.422429] fs/cifs/dir.c: NULL inode in lookup
> >> > > > > > >> > [ 3735.422430] fs/cifs/dir.c: Full path: \21206xxx\=
TP9 inode =3D 0x
> >> > > > > (null)
> >> > > > > > >> >
> >> > > > > > >> > I don't understand what happens...
> >> > > > > > >> > NULL inode in lookup ... What about noserverino opt=
ion ?
> >> > > > > > >> > Perhaps an unresponsive server... The network infra=
structure is
> >> > > > > old. Last year I
> >> > > > > got this working very well, but the server was in a better=
 place (switch
> >> > > > > and network
> >> > > > > infrastructure speaking)
> >> > > > > > >> >
> >> > > > > > >> > Regards,
> >> > > > > > >> > Thanks in advance
> >> > > > > > >> > Serge Conrad
> >> > > > > > >> >
> >> > > > > > >> > Une messagerie gratuite, garantie =C3=A0 vie et des=
 services en plus, =C3=A7a
> >> > > > > vous tente ?
> >> > > > > > >> > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >> > > > > > >> > --
> >> > > > > > >> > To unsubscribe from this list: send the line "unsub=
scribe
> >> > > > > linux-cifs" in
> >> > > > > > >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > > > >> > More majordomo info at http://vger.kernel.org/major=
domo-info.html
> >> > > > > > >>
> >> > > > > > >>
> >> > > > > > >>
> >> > > > > > >> --
> >> > > > > > >> Thanks,
> >> > > > > > >>
> >> > > > > > >> Steve
> >> > > > > > >> --
> >> > > > > > >> To unsubscribe from this list: send the line "unsubsc=
ribe linux-cifs"
> >> > > > > in
> >> > > > > > >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > > > >> More majordomo info at http://vger.kernel.org/majordo=
mo-info.html
> >> > > > > > >>
> >> > > > > > >
> >> > > > > > > Une messagerie gratuite, garantie =C3=A0 vie et des se=
rvices en plus, =C3=A7a
> >> > > > > vous tente ?
> >> > > > > > > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >> > > > > >
> >> > > > > >
> >> > > > > >
> >> > > > > > --
> >> > > > > > Thanks,
> >> > > > > >
> >> > > > > > Steve
> >> > > > > > --
> >> > > > > > To unsubscribe from this list: send the line "unsubscrib=
e linux-cifs" in
> >> > > > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > > > > More majordomo info at http://vger.kernel.org/majordomo-=
info.html
> >> > > > > >
> >> > > > >
> >> > > > > Une messagerie gratuite, garantie =C3=A0 vie et des servic=
es en plus, =C3=A7a vous
> >> > > > > tente ?
> >> > > > > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >> > > > >
> >> > > >
> >> > >
> >> > > Une messagerie gratuite, garantie =C3=A0 vie et des services e=
n plus, =C3=A7a vous tente ?
> >> > > Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
> >> > > --
> >> > > To unsubscribe from this list: send the line "unsubscribe linu=
x-cifs" in
> >> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > > More majordomo info at http://vger.kernel.org/majordomo-info.h=
tml
> >> > >
> >> >
> >> >
> >> >
> >> > >
> >> > >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
cifs" in
> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > More majordomo info at http://vger.kernel.org/majordomo-info.htm=
l
> >>
> >>
> >> --
> >> Jeff Layton
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at http://vger.kernel.org/majordomo-info.html
> >>
> >
> >
> >
> >
> >
> >
> >
> >>
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve
>
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
