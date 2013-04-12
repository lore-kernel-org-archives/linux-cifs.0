From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs multiuser sends wrong uid:gid [solved]
Date: Fri, 12 Apr 2013 17:42:56 -0400
Message-ID: <20130412174256.0a2ace02@tlielax.poochiereds.net>
References: <5167D1CF.2080708@steve-ss.com>
	<20130412062721.4768d904@corrin.poochiereds.net>
	<5167E770.10505@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5167E770.10505-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 12 Apr 2013 12:52:32 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On 12/04/13 12:27, Jeff Layton wrote:
> > On Fri, 12 Apr 2013 11:20:15 +0200
> > steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> >
> >> Hi
> >> samba 4.0.5
> >> openSUSE 12.3 cifs-utils-5.9
> >>
> >> I have a share:
> >> [users]
> >> path =3D /home/users
> >> read only =3D No
> >>
> >> I mount it as root:
> >> h16:/tmp # kinit Administrator
> >> Password for Administrator-UiqEU/D402Y@public.gmane.org:
> >>
> >> hh16:/tmp # klist
> >> Ticket cache: FILE:/tmp/krb5cc_0
> >> Default principal: Administrator-UiqEU/D402Y@public.gmane.org
> >>
> >> Valid starting Expires Service principal
> >> 04/12/13 11:06:37 04/12/13 21:06:37 krbtgt/HH3.SITE-UiqEU/D402Y@public.gmane.org
> >> renew until 04/13/13 11:06:30
> >>
> >> hh16:/tmp # mount.cifs //hh16.hh3.site/users /mnt --verbose
> >> -osec=3Dkrb5,multiuser
> >> mount.cifs kernel mount options:
> >> ip=3D192.168.1.16,unc=3D\\hh16.hh3.site\users,sec=3Dkrb5,multiuser=
,user=3Dsteve,pass=3D********
> >>
> >> .
> >> 2013-04-12T11:05:49.678122+02:00 hh16 cifs.upcall: key description=
:
> >> cifs.spnego;0;0;3f000000;ver=3D0x2;host=3Dhh16.hh3.site;ip4=3D192.=
168.1.16;sec=3Dkrb5;uid=3D0x0;creduid=3D0x0;user=3Dsteve;pid=3D0xaa9
> >> 2013-04-12T11:05:49.678807+02:00 hh16 cifs.upcall: ver=3D2
> >> 2013-04-12T11:05:49.678950+02:00 hh16 cifs.upcall: host=3Dhh16.hh3=
=2Esite
> >> 2013-04-12T11:05:49.681949+02:00 hh16 cifs.upcall: ip=3D192.168.1.=
16
> >> 2013-04-12T11:05:49.681974+02:00 hh16 cifs.upcall: sec=3D1
> >> 2013-04-12T11:05:49.681981+02:00 hh16 cifs.upcall: uid=3D0
> >> 2013-04-12T11:05:49.681986+02:00 hh16 cifs.upcall: creduid=3D0
> >> 2013-04-12T11:05:49.681991+02:00 hh16 cifs.upcall: user=3Dsteve
> >> 2013-04-12T11:05:49.682443+02:00 hh16 cifs.upcall: pid=3D2729
> >> 2013-04-12T11:05:49.683046+02:00 hh16 cifs.upcall: find_krb5_cc: s=
candir
> >> error on directory '/run/user/0': No such file or directory
> >> 2013-04-12T11:05:49.683488+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_1000
> >> 2013-04-12T11:05:49.683902+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_1000 is owned by 1000, not 0
> >> 2013-04-12T11:05:49.684385+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_3000034
> >> 2013-04-12T11:05:49.684779+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_3000034 is owned by 3000034, not 0
> >> 2013-04-12T11:05:49.685567+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_3000032
> >> 2013-04-12T11:05:49.686041+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_3000032 is owned by 3000032, not 0
> >> 2013-04-12T11:05:49.686352+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_0
> >> 2013-04-12T11:05:49.686638+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> FILE:/tmp/krb5cc_0 is valid ccache
> >> 2013-04-12T11:05:49.686919+02:00 hh16 cifs.upcall: handle_krb5_mec=
h:
> >> getting service ticket for hh16.hh3.site
> >> 2013-04-12T11:05:49.687248+02:00 hh16 cifs.upcall: handle_krb5_mec=
h:
> >> obtained service ticket
> >> 2013-04-12T11:05:49.687523+02:00 hh16 cifs.upcall: Exit status 0
> >>
> >>
> >> hh16:/tmp # su steve2
> >> steve2@hh16:/tmp> kinit steve2
> >> Password for steve2-UiqEU/D402Y@public.gmane.org:
> >> steve2@hh16:/tmp> cd /mnt/steve2
> >> steve2@hh16:/mnt/steve2> touch j
> >> touch: cannot touch =91j=92: Permission denied
> >> 2
> >> 2013-04-12T11:10:48.599379+02:00 hh16 cifs.upcall: key description=
:
> >> cifs.spnego;3000034;20513;3f000000;ver=3D0x2;host=3Dhh16.hh3.site;=
ip4=3D192.168.1.16;sec=3Dkrb5;uid=3D0x2dc6e2;creduid=3D0x2dc6e2;pid=3D0=
xb5a
> >> 2013-04-12T11:10:48.599412+02:00 hh16 cifs.upcall: ver=3D2
> >> 2013-04-12T11:10:48.601816+02:00 hh16 cifs.upcall: host=3Dhh16.hh3=
=2Esite
> >> 2013-04-12T11:10:48.601840+02:00 hh16 cifs.upcall: ip=3D192.168.1.=
16
> >> 2013-04-12T11:10:48.601847+02:00 hh16 cifs.upcall: sec=3D1
> >> 2013-04-12T11:10:48.601852+02:00 hh16 cifs.upcall: uid=3D3000034
> >> 2013-04-12T11:10:48.601857+02:00 hh16 cifs.upcall: creduid=3D30000=
34
> >> 2013-04-12T11:10:48.602956+02:00 hh16 cifs.upcall: pid=3D2906
> >> 2013-04-12T11:10:48.602978+02:00 hh16 cifs.upcall: find_krb5_cc: s=
candir
> >> error on directory '/run/user/3000034': No such file or directory
> >> 2013-04-12T11:10:48.603432+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_1000
> >> 2013-04-12T11:10:48.604677+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_1000 is owned by 1000, not 3000034
> >> 2013-04-12T11:10:48.605262+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_3000034
> >> 2013-04-12T11:10:48.605779+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> FILE:/tmp/krb5cc_3000034 is valid ccache
> >> 2013-04-12T11:10:48.607568+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_3000032
> >> 2013-04-12T11:10:48.608414+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_3000032 is owned by 3000032, not 3000034
> >> 2013-04-12T11:10:48.608948+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> considering /tmp/krb5cc_0
> >> 2013-04-12T11:10:48.609470+02:00 hh16 cifs.upcall: find_krb5_cc:
> >> /tmp/krb5cc_0 is owned by 0, not 3000034
> >> 2013-04-12T11:10:48.610854+02:00 hh16 cifs.upcall: handle_krb5_mec=
h:
> >> getting service ticket for hh16.hh3.site
> >> 2013-04-12T11:10:48.615154+02:00 hh16 cifs.upcall: handle_krb5_mec=
h:
> >> obtained service ticket
> >> 2013-04-12T11:10:48.615189+02:00 hh16 cifs.upcall: Exit status 0
> >> hh16:/tmp #
> >>
> >> That seems fine except that the wrong uid:gid has been sent to the=
 mount
> >> for steve2 so he can't write to his cifs mounted folder.
> >>
> >> To investigate this, I made his folder 0777 and then created a fil=
e in
> >> the share:
> >>
> >> hh16:/home/users # chmod 0777 steve2/
> >> hh16:/home/users # su steve2
> >> steve2@hh16:/home/users> cd /mnt/steve2
> >> steve2@hh16:/mnt/steve2> touch testfile
> >> steve2@hh16:/mnt/steve2> ls -l
> >> total 1024
> >> -rw-r--r-- 1 steve2 Domain Users 0 Apr 12 09:58 j
> >> -rwxrwxr-x+ 1 3000019 users 0 Apr 12 11:14 testfile
> >>
> >> cifs has sent 3000019:100 as the uid:gid It should send 3000034:20=
513
> >>
> >> Question:
> >> - why is user=3Dsteve specified on the mount command? (I am unix u=
ser
> >> steve. steve2 is a domain user, but I'm doing the mount as root)
> > Probably because you're su'ing to root without clearing your
> > environment. If you don't specify a username, then mount.cifs will
> > scrape the value of $USER out of your environment and stuff that in=
to
> > the field. It really matters little here though -- the username is
> > ignored when you use kerberos. All that matters is the ticket.
> >
> >> - What am I doing wrong?
> > At first glance, I have to wonder whether "steve2" is mapped to the
> > same uid on the client and server. It seems likely that on the clie=
nt
> > that this krb5 user maps to 3000034, but on the server it maps to
> > 3000019.
> >
> Hi Jeff
> Yes. That was it. The server got the uid from idmap.ldb and the clien=
t=20
> from AD. Or maybe the other way around. Anyway,I tried to force this =
with:
> idmap_ldb use:rfc2307 =3D Yes
> but that's the wrong syntax; but not identified by testparm:(
>=20
> So, for the record, to pull uid:gid from AD and _not_ idmap:
> [global] in smb.conf needs this syntax:
> idmap_ldb:use rfc2307 =3D Yes
>=20
> Personally, I think that all uid:gid should come from AD by default.
>=20

Note that it's not necessarily wrong for them to be mapped
inconsistently -- it just looks weird from the client. When you use
"multiuser" then it also turns off client-side permission checking and
leaves it up to the server.

If you were to change the ownership on the directory to 3000019 on the
server, then everything will likely also work correctly. It's just that
stat() calls would show the ownership as something else on the client.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
