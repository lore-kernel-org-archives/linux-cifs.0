From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Sun, 18 Nov 2012 21:00:40 -0500
Message-ID: <20121118210040.05cd3eb2@corrin.poochiereds.net>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
	<20121107065651.18dc9f63@tlielax.poochiereds.net>
	<31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
	<20121116210141.33f983dc@corrin.poochiereds.net>
	<74526876.1792050.1353138782508.JavaMail.www@wwinf8223>
	<20121117054429.0212dd49@tlielax.poochiereds.net>
	<1158502718.930616.1353160613998.JavaMail.www@wwinf8308>
	<20121117102824.7d7f985e@tlielax.poochiereds.net>
	<1083321411.931078.1353172977633.JavaMail.www@wwinf8307>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1083321411.931078.1353172977633.JavaMail.www@wwinf8307>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 17 Nov 2012 18:22:57 +0100
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

>=20
>=20
>=20
> > Message du 17/11/12 16:28
> > De : "Jeff Layton"=20
> > A : "sergio.conrad"=20
> > Copie =E0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Objet : Re: cifs autofs krb5i
> >
> > On Sat, 17 Nov 2012 14:56:54 +0100
> > "sergio.conrad"  wrote:
> >=20
> > >=20
> > >=20
> > >=20
> > > > Message du 17/11/12 11:44
> > > > De : "Jeff Layton"=20
> > > > A : "sergio.conrad"=20
> > > > Copie =E0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Objet : Re: cifs autofs krb5i
> > > >
> > > > On Sat, 17 Nov 2012 08:53:02 +0100
> > > > "sergio.conrad" wrote:
> > > >=20
> > > > >=20
> > > > >=20
> > > > >=20
> > > > > > Message du 17/11/12 03:01
> > > > > > De : "Jeff Layton"=20
> > > > > > A : "sergio.conrad"=20
> > > > > > Copie =E0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > Objet : Re: cifs autofs krb5i
> > > > > >
> > > > > > On Fri, 16 Nov 2012 23:37:52 +0100
> > > > > > "sergio.conrad" wrote:
> > > > > >=20
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > I am able to connect to cifs share on Windows 2008 with K=
erberos security via=20
> > > autofs=20
> > > > > with=20
> > > > > > > this map :=20
> > > > > > > * -
> > > > > > >=20
> > > > >=20
> > >=20
> fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,cruid=3D&,file_mode=3D0700=
,dir_mode=3D0700,nounix,noserverin
> > > > > > > o ://figue/data/&
> > > > > > >=20
> > > > > > > Is it working fine with alpha numeric login=20
> > > > > > > fs/cifs/cifs_spnego.c: key description =3D=20
> > > > > > >=20
> > > > >=20
> > >=20
> ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0x1000001;=
creduid=3D0x1000001;user=3Dconrad3
> > > > > > > ;pid=3D0xd331
> > > > > > >=20
> > > > > > >=20
> > > > > > > But if i use numeric only login like 12345678 i have a pr=
oblem :
> > > > > > > fs/cifs/cifs_spnego.c: key description =3D=20
> > > > > > >=20
> > > > >=20
> > >=20
> ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0xbc614e;c=
reduid=3D0xbc614e;user=3D12345678;
> > > > > > > pid=3D0xe5db
> > > > > > > fs/cifs/sess.c: ssetup freeing small buf ffff88003a838140
> > > > > > > CIFS VFS: Send error in SessSetup =3D -126
> > > > > > > fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xi=
d =3D 223) rc =3D -126
> > > > > > > fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D =
222) rc =3D -126
> > > > > > > CIFS VFS: cifs_mount failed w/return code =3D -126
> > > > > > >=20
> > > > > > > What can I do to solve this issue ?
> > > > > >=20
> > > > > >=20
> > > > > > cifs.upcall logs at daemon.debug level. Set up syslog to lo=
g that and
> > > > > > you'll get some details about what it's doing.
> > > > > >=20
> > > > > > --=20
> > > > > > Jeff Layton=20
> > > > > >=20
> > > > >=20
> > > > > Thanks for your response,=20
> > > > > I got the error=20
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5c=
c_16777221 is owned=20
> by=20
> > > > > 16777221, not 12345678
> > > > >=20
> > > > > Perhaps it is a confusion about the uid and the login in a nu=
meric value
> > > > >=20
> > > > > [12345678@centad5 ~]$ id
> > > > > uid=3D16777221(12345678) gid=3D16777216(utilisateurs du domai=
ne)=20
> > > > > groupes=3D16777216(utilisateurs du domaine),16777217(profs)
> > > > >=20
> > > > > The full log is :
> > > > >=20
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: key description:=20
> > > > >=20
> > >=20
> cifs.spnego;0;0;3f000000;ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;se=
c=3Dkrb5;uid=3D0xbc614e;credui
> > > > > d=3D0xbc614e;user=3D12345678;pid=3D0x9b5
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: ver=3D2
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: host=3Dfigue
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: ip=3D130.120.8.11
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: sec=3D1
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: uid=3D12345678
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: creduid=3D12345678
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: user=3D12345678
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: pid=3D2485
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considerin=
g=20
> /tmp/krb5cc_16777221
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5c=
c_16777221 is owned=20
> by=20
> > > > > 16777221, not 12345678
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considerin=
g=20
> /tmp/krb5cc_16777216
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5c=
c_16777216 is owned=20
> by=20
> > > > > 16777216, not 12345678
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: krb5_get_init_creds_keyt=
ab: 13
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: handle_krb5_mech: gettin=
g service ticket for=20
> > > figue
> > > > > Nov 17 08:42:53 centad5 cifs.upcall: cifs_krb5_get_req: unabl=
e to resolve (null)=20
> to=20
> > > > > ccache
> > > > > @
> > > >=20
> > > > What a bizarre setup you have. I imagine all sorts of things ge=
t
> > > > confused by numeric usernames. Many programs will assume that w=
hen
> > > > given a numeric username that it's a uid, not a name. You might
> > > > reconsider that setup -- maybe prefix the numbers with a letter=
 or
> > > > something...
> > > >=20
> > > It seems it is a little late for this, we are already in a produc=
tion state with=20
> Active=20
> > > Directory and winbind for authentication, Windows 2008 as a cifs =
server, Fedora 15=20
> for=20
> > > client and using pam_mount for mounting partition.
> > > As we are experiencing some CIFS VFS: Unexpected SMB signature wi=
th this=20
> > > I am testing some others ways...
> > >=20
> > > > In any case, it does seem like there is confusion somewhere wit=
h
> > > > numeric uids, but I don't think that confusion is with cifs.upc=
all. If
> > > > that is the correct credcache for this user, then it looks like=
 its
> > > > being created with the wrong ownership.
> > > >=20
> > > > What does the output of "klist" look like when you're logged in=
 as this
> > > > user?
> > > >=20
> > >=20
> > > [12345678@centad5 ~]$ klist
> > > Ticket cache: FILE:/tmp/krb5cc_16777221
> > > Default principal: 12345678-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> > >=20
> > > Valid starting Expires Service principal
> > > 11/17/12 14:34:04 11/18/12 00:34:04 krbtgt/DOMAIN.LOCAL-10W9mfrL9XlgzlvP5gpW4g@public.gmane.org=
CAL
> > > renew until 11/24/12 14:34:04
> > > 11/17/12 14:34:04 11/18/12 00:34:04 CENTAD5$@DOMAIN.LOCAL
> > > renew until 11/24/12 14:34:04
> > > 11/17/12 14:34:04 11/18/12 00:34:04 CENTAD5$@DOMAIN.LOCAL
> > > renew until 11/24/12 14:34:04
> > > [12345678@centad5 ~]$
> > >=20
> > > > How about the output of "stat /tmp/krb5cc_16777216" ?
> > >=20
> > > 16777216 or 16777221 ?=20
> > > I did it for the two files=20
> > >=20
> > > [12345678@centad5 ~]$ id
> > > uid=3D16777221(12345678) gid=3D16777216(utilisateurs du domaine)=20
> > > groupes=3D16777216(utilisateurs du domaine),16777217(profs)
> > > [12345678@centad5 ~]$
> > >=20
> > >=20
> > > [12345678@centad5 ~]$ stat /tmp/krb5cc_16777221=20
> > > File: =AB=A0/tmp/krb5cc_16777221=A0=BB
> > > Size: 3830 Blocks: 8 IO Block: 4096 fichier
> > > Device: 801h/2049d Inode: 1985377 Links: 1
> > > Access: (0600/-rw-------) Uid: (16777221/12345678) Gid: ( 0/ root=
)
> > > Access: 2012-11-17 14:41:37.056868612 +0100
> > > Modify: 2012-11-17 14:41:32.251850184 +0100
> > > Change: 2012-11-17 14:41:32.251850184 +0100
> > >=20
> > >=20
> > > [12345678@centad5 ~]$ stat /tmp/krb5cc_16777216=20
> > > File: =AB=A0/tmp/krb5cc_16777216=A0=BB
> > > Size: 3751 Blocks: 8 IO Block: 4096 fichier
> > > Device: 801h/2049d Inode: 1966082 Links: 1
> > > Access: (0600/-rw-------) Uid: (16777216/ conrad5) Gid: ( 0/ root=
)
> > > Access: 2012-11-16 23:11:47.948511483 +0100
> > > Modify: 2012-11-16 23:11:47.948511483 +0100
> > > Change: 2012-11-16 23:11:47.948511483 +0100
> > > >=20
> >=20
> > Ok, I think I see now. I believe your problem is in the options you=
're
> > passing in at mount time:
> >=20
> >=20
> fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,cruid=3D&,file_mode=3D0700=
,dir_mode=3D0700,nounix,noserverin
> o ://figue/data/&
> >=20
> > ...specifically, the 'uid=3D&' and 'cruid=3D&' options. When mount.=
cifs gets
> > a numeric value for those options, it assumes that it's a uid, not =
a
> > username. You should probably replace those options in your automou=
nt
> > map with something like:
> >=20
> > uid=3D$UID,cruid=3D$UID
> >=20
> > ...which will make it pass in the numeric uid instead (that should =
also
> > be slightly more efficient since you won't need to go to NSS to res=
olve
> > username to uid). You may also want to consider adding:
> >=20
> > gid=3D$GID
> >=20
> > ...but that depends on your needs. See the section on "Variable
> > Substitution" in autofs(5) for info on $UID and $GID.
> >=20
> > Best of luck!
>=20
> It works !
> Thank you, you saved my day, as always !
> I will post here if i resolve the unexpected smb signature with this =
technique
> Serge
>=20

Great! Now that I think about it though, there's a problem with my
suggestion. $UID and $GID represent the uid/gid of the user who's
triggering the mount, and that's not necessarily the same as the user
who owns the directory (which is what you were trying to do with your
original map).

What may make more sense is to reinstate your original autofs map, and
apply something like this (untested) patch something like this to
mount.cifs. Note too that you can use the '-v' option to the mount
command to see what options it's passing in.

Really though, what you may best off with is to consider setting
up //figue/data as a multiuser mount...

---------------------[snip]----------------------

mount.cifs: treat uid=3D,gid=3D,cruid=3D options as name before assumin=
g they're a number

Sergio Conrad reported a problem trying to set up an autofs map to do
a krb5 mount. In his environment, many users have usernames that are
comprised entirely of numbers. While that's a bit odd, POSIX apparently
allows for it.

The current code assumes that when a numeric argument is passed to one
of the above options, that it's a uid or gid. Instead, try to treat the
argument as a user or group name first, and only try to treat it as a
number if that fails.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index a9632b4..9760d1f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1003,57 +1003,55 @@ parse_options(const char *data, struct parsed_m=
ount_info *parsed_info)
 				goto nocopy;
=20
 			got_uid =3D 1;
+			pw =3D getpwnam(value);
+			if (pw) {
+				uid =3D pw->pw_uid;
+				goto nocopy;
+			}
+
 			errno =3D 0;
 			uid =3D strtoul(value, &ep, 10);
 			if (errno =3D=3D 0 && *ep =3D=3D '\0')
 				goto nocopy;
=20
-			pw =3D getpwnam(value);
-			if (pw =3D=3D NULL) {
-				fprintf(stderr, "bad user name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-
-			uid =3D pw->pw_uid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option uid=3D\"%s\"\n", value);
+			return EX_USAGE;
 		case OPT_CRUID:
 			if (!value || !*value)
 				goto nocopy;
=20
 			got_cruid =3D 1;
+			pw =3D getpwnam(value);
+			if (pw) {
+				cruid =3D pw->pw_uid;
+				goto nocopy;
+			}
+
 			errno =3D 0;
 			cruid =3D strtoul(value, &ep, 10);
 			if (errno =3D=3D 0 && *ep =3D=3D '\0')
 				goto nocopy;
=20
-			pw =3D getpwnam(value);
-			if (pw =3D=3D NULL) {
-				fprintf(stderr, "bad user name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-			cruid =3D pw->pw_uid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option: cruid=3D\"%s\"\n", value);
+			return EX_USAGE;
 		case OPT_GID:
 			if (!value || !*value)
 				goto nocopy;
=20
 			got_gid =3D 1;
+			gr =3D getgrnam(value);
+			if (gr) {
+				gid =3D gr->gr_gid;
+				goto nocopy;
+			}
+
 			errno =3D 0;
 			gid =3D strtoul(value, &ep, 10);
 			if (errno =3D=3D 0 && *ep =3D=3D '\0')
 				goto nocopy;
=20
-			gr =3D getgrnam(value);
-			if (gr =3D=3D NULL) {
-				fprintf(stderr, "bad group name \"%s\"\n", value);
-				return EX_USAGE;
-			}
-
-			gid =3D gr->gr_gid;
-			goto nocopy;
-
+			fprintf(stderr, "bad option: gid=3D\"%s\"\n", value);
+			return EX_USAGE;
 		/* fmask fall through to file_mode */
 		case OPT_FMASK:
 			fprintf(stderr,
--=20
1.7.11.7


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
