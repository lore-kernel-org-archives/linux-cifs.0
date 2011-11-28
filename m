From: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: Occasional CIFS Errors with a Win 2003 Mount
Date: Mon, 28 Nov 2011 12:25:04 -0800 (PST)
Message-ID: <1322511904.71567.YahooMailNeo@web111007.mail.gq1.yahoo.com>
References: <1322495167.9919.YahooMailNeo@web111014.mail.gq1.yahoo.com> <CADT32eKTF3dx2PeDipEe6o30+=6As3aUhmUvgMFeu9x342fAMQ@mail.gmail.com> <1322503868.88671.YahooMailNeo@web111012.mail.gq1.yahoo.com> <CADT32eK5tNxuZQtmBr37AeXderjKYis8An=ht3=jFSZcAe71cQ@mail.gmail.com> <20111128151204.53a65112@tlielax.poochiereds.net>
Reply-To: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111128151204.53a65112-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks, Jeff. We do have servers running RHEL 6.1. Is that of no benefi=
t? Do I really need 6.2?

Thanks,
-Dan



----- Original Message -----
=46rom: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>; "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linu=
x-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sent: Monday, November 28, 2011 2:12 PM
Subject: Re: Occasional CIFS Errors with a Win 2003 Mount

On Mon, 28 Nov 2011 13:42:52 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Nov 28, 2011 at 12:11 PM, Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wro=
te:
> > Why do I need to do this and how does one bump up the version of th=
eir CIFS module?
>=20
> These messages are logged when cifs reconnects for lack of
> response from the server to the requests within an arbitrary
> amount of duration.
>=20
> With the 1.68 version, there is code in place to reconnect only if th=
e server is
> dead i.e. cifs client reconnects only when server is not responding t=
o
> smb echos.
>=20

Yes. Backporting that to rhel5 however is probably a non-starter as
it's a hugely invasive change. You may want to open a support case with
Red Hat and we'll see what we can do to help you troubleshoot and fix
it.

You may also want to consider moving to RHEL6.2 when it ships which
should have the new reconnect handling code.


> > Thanks,
> > -Dan
> >
> > ----- Original Message -----
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > To: Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Sent: Monday, November 28, 2011 11:29 AM
> > Subject: Re: Occasional CIFS Errors with a Win 2003 Mount
> >
> > On Mon, Nov 28, 2011 at 9:46 AM, Dan The Man <blammy8-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wr=
ote:
> >> We keep having issues accessing content on one of our Win 2003 ser=
vers. We end up needing to restart the server.
> >>
> >> Linux details:
> >>
> >> Linux Version: Red Hat Enterprise Linux Server release 5.7 (Tikang=
a)
> >>
> >> Kernel:2.6.18-274.7.1.el5
> >>
> >> Output of /sbin/modinfo cifs:
> >>
> >> filename:=A0=A0=A0=A0=A0=A0 /lib/modules/2.6.18-274.7.1.el5/kernel=
/fs/cifs/cifs.ko
> >> version:=A0=A0=A0=A0=A0=A0=A0 1.60RH
> >> description:=A0=A0=A0 VFS to access servers complying with the SNI=
A CIFS Specification e.g. Samba and Windows
> >> license:=A0=A0=A0=A0=A0=A0=A0 GPL
> >> author:=A0=A0=A0=A0=A0=A0=A0=A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> srcversion:
> >> =A0CB01A53173C481FE5E6FF69
> >> depends:
> >> vermagic:=A0=A0=A0=A0=A0=A0 2.6.18-274.7.1.el5 SMP mod_unload 686 =
REGPARM 4KSTACKS gcc-4.1
> >> parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CIFSMaxBufSize:Network buffer =
size (not including header). Default: 16384 Range: 8192 to 130048 (int)
> >> parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_rcv:Network buffers i=
n pool. Default: 4 Range: 1 to 64 (int)
> >> parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_small:Small network b=
uffers in pool. Default: 30 Range: 2 to 256 (int)
> >> parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_max_pending:Simultaneous =
requests to server. Default: 50 Range: 2 to 256 (int)
> >>
> >>
> >> /etc/fstab line:
> >>
> >> //citpfile05.uwcx.net/apache/citpwebces004v=A0 /data/apache cifs=A0=
 user,rw,credentials=3D/root/apache_cifs_credentials,uid=3D48,gid=3D48,=
file_mode=3D0755,dir_mode=3D0755
> >>
> >>
> >>
> >> Errors:
> >>
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 6536
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25973
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25988
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25914
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25896
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25968
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid
> >> =A025981
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25982
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25971
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25967
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25986
> >> Nov 27 20:57:10 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25991
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25979
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 26000
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to
> >> =A0cmd 4 mid 25994
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25985
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25980
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25975
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25974
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25898
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25970
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25965
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25964
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25963
> >> Nov 27 20:57:11 citpwebces004v
> >> =A0kernel:=A0 CIFS VFS: Send error in Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25972
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25966
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25943
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25256
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25997
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25960
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25639
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25931
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11
> >> =A0citpwebces004v kernel:=A0 CIFS VFS: No response to cmd 4 mid 25=
959
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25594
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25287
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25955
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25956
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25969
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25984
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25976
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov
> >> =A027 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response for=
 cmd 162 mid 25983
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25978
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25977
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 26002
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 25796
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 46 mid 25915
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25909
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 25957
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25958
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in
> >> =A0Close =3D -11
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 25962
> >> Nov 27 20:57:11 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52227
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52228
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52229
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52235
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D
> >> =A0-11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52221
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52187
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52053
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52161
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52224
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52196
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid
> >> =A052204
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52222
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52207
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52223
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52160
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52182
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 46 mid 52244
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid
> >> =A052232
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 46 mid 52188
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52231
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 51858
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52022
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52249
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52256
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52253
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52156
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response
> >> =A0for cmd 50 mid 52252
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52254
> >> Nov 27 20:58:20 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:21 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52270
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52275
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 46 mid 52272
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 52171
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52263
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52250
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 52269
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS
> >> =A0VFS: No response for cmd 162 mid 52040
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52260
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52246
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52230
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52133
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52052
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 51991
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52241
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52146
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52186
> >> Nov 27
> >> =A020:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response for cm=
d 162 mid 52205
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52243
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52262
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52264
> >> Nov 27 20:58:23 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 52113
> >> Nov 27 20:58:38 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 114 mid 52296
> >> Nov 27 20:58:50 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 114 mid 52402
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected
> >> =A0lookup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:58:59 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 114 mid 52668
> >> Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected
> >> =A0lookup error -112
> >> Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 20:59:20 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46145
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
read =3D -11
> >> Nov 27 21:03:31 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46997
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47049
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid
> >> =A047058
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47048
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46981
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46826
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46758
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46904
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 45209
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46906
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47032
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46947
> >> Nov 27 21:03:33 citpwebces004v kernel:
> >> =A0CIFS VFS: No response for cmd 162 mid 46912
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 44878
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46834
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46898
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46903
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46896
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47009
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 46819
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 46596
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46820
> >> Nov 27 21:03:33
> >> =A0citpwebces004v kernel:=A0 CIFS VFS: Send error in Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 46741
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47034
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 46833
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 47040
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46932
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46866
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47016
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46988
> >> Nov 27
> >> =A021:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in Clos=
e =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47051
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47050
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47044
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47026
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 47028
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47046
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 47045
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid
> >> =A046941
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46663
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 46951
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47017
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47022
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47020
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 41944
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 47037
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 50 mid 47039
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 162 mid 47038
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS
> >> =A0VFS: No response for cmd 162 mid 47043
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: No response to=
 cmd 4 mid 46850
> >> Nov 27 21:03:33 citpwebces004v kernel:=A0 CIFS VFS: Send error in =
Close =3D -11
> >> Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: No response fo=
r cmd 114 mid 47062
> >> Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >> Nov 27 21:03:48 citpwebces004v kernel:=A0 CIFS VFS: Unexpected loo=
kup error -112
> >>
> >> Thanks in advance for the help in resolving this.
> >> -Dan
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >>
> >
> > Hi, you would not see these errors if you move up the cifs module v=
ersion to
> > something like 1.68.
> >
> > Regards,
> >
> > Shirish
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at=A0 http://vger.kernel.org/majordomo-info.htm=
l
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
