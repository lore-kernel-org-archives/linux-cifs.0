From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Sat, 17 Nov 2012 14:56:54 +0100
Message-ID: <1158502718.930616.1353160613998.JavaMail.www@wwinf8308>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
 <20121107065651.18dc9f63@tlielax.poochiereds.net>
 <31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
 <20121116210141.33f983dc@corrin.poochiereds.net>
 <74526876.1792050.1353138782508.JavaMail.www@wwinf8223>
 <20121117054429.0212dd49@tlielax.poochiereds.net>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121117054429.0212dd49-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>




> Message du 17/11/12 11:44
> De : "Jeff Layton"=20
> A : "sergio.conrad"=20
> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Objet : Re: cifs autofs krb5i
>
> On Sat, 17 Nov 2012 08:53:02 +0100
> "sergio.conrad"  wrote:
>=20
> >=20
> >=20
> >=20
> > > Message du 17/11/12 03:01
> > > De : "Jeff Layton"=20
> > > A : "sergio.conrad"=20
> > > Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Objet : Re: cifs autofs krb5i
> > >
> > > On Fri, 16 Nov 2012 23:37:52 +0100
> > > "sergio.conrad" wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > I am able to connect to cifs share on Windows 2008 with Kerbero=
s security via=20
autofs=20
> > with=20
> > > > this map :=20
> > > > * -
> > > >=20
> >=20
fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,cruid=3D&,file_mode=3D0700,d=
ir_mode=3D0700,nounix,noserverin
> > > > o ://figue/data/&
> > > >=20
> > > > Is it working fine with alpha numeric login=20
> > > > fs/cifs/cifs_spnego.c: key description =3D=20
> > > >=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0x1000001;cr=
eduid=3D0x1000001;user=3Dconrad3
> > > > ;pid=3D0xd331
> > > >=20
> > > >=20
> > > > But if i use numeric only login like 12345678 i have a problem =
:
> > > > fs/cifs/cifs_spnego.c: key description =3D=20
> > > >=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0xbc614e;cre=
duid=3D0xbc614e;user=3D12345678;
> > > > pid=3D0xe5db
> > > > fs/cifs/sess.c: ssetup freeing small buf ffff88003a838140
> > > > CIFS VFS: Send error in SessSetup =3D -126
> > > > fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D =
223) rc =3D -126
> > > > fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 222) r=
c =3D -126
> > > > CIFS VFS: cifs_mount failed w/return code =3D -126
> > > >=20
> > > > What can I do to solve this issue ?
> > >=20
> > >=20
> > > cifs.upcall logs at daemon.debug level. Set up syslog to log that=
 and
> > > you'll get some details about what it's doing.
> > >=20
> > > --=20
> > > Jeff Layton=20
> > >=20
> >=20
> > Thanks for your response,=20
> > I got the error=20
> > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_1677=
7221 is owned by=20
> > 16777221, not 12345678
> >=20
> > Perhaps it is a confusion about the uid and the login in a numeric =
value
> >=20
> > [12345678@centad5 ~]$ id
> > uid=3D16777221(12345678) gid=3D16777216(utilisateurs du domaine)=20
> > groupes=3D16777216(utilisateurs du domaine),16777217(profs)
> >=20
> > The full log is :
> >=20
> > Nov 17 08:42:53 centad5 cifs.upcall: key description:=20
> >=20
cifs.spnego;0;0;3f000000;ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3D=
krb5;uid=3D0xbc614e;credui
> > d=3D0xbc614e;user=3D12345678;pid=3D0x9b5
> > Nov 17 08:42:53 centad5 cifs.upcall: ver=3D2
> > Nov 17 08:42:53 centad5 cifs.upcall: host=3Dfigue
> > Nov 17 08:42:53 centad5 cifs.upcall: ip=3D130.120.8.11
> > Nov 17 08:42:53 centad5 cifs.upcall: sec=3D1
> > Nov 17 08:42:53 centad5 cifs.upcall: uid=3D12345678
> > Nov 17 08:42:53 centad5 cifs.upcall: creduid=3D12345678
> > Nov 17 08:42:53 centad5 cifs.upcall: user=3D12345678
> > Nov 17 08:42:53 centad5 cifs.upcall: pid=3D2485
> > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considering /tmp=
/krb5cc_16777221
> > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_1677=
7221 is owned by=20
> > 16777221, not 12345678
> > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considering /tmp=
/krb5cc_16777216
> > Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_1677=
7216 is owned by=20
> > 16777216, not 12345678
> > Nov 17 08:42:53 centad5 cifs.upcall: krb5_get_init_creds_keytab: 13
> > Nov 17 08:42:53 centad5 cifs.upcall: handle_krb5_mech: getting serv=
ice ticket for=20
figue
> > Nov 17 08:42:53 centad5 cifs.upcall: cifs_krb5_get_req: unable to r=
esolve (null) to=20
> > ccache
> > @
>=20
> What a bizarre setup you have. I imagine all sorts of things get
> confused by numeric usernames. Many programs will assume that when
> given a numeric username that it's a uid, not a name. You might
> reconsider that setup -- maybe prefix the numbers with a letter or
> something...
>=20
It seems it is a little late for this, we are already in a production s=
tate with Active=20
Directory and winbind for authentication, Windows 2008 as a cifs server=
, Fedora 15 for=20
client and using pam_mount for mounting partition.
As we are experiencing some CIFS VFS: Unexpected SMB signature with thi=
s=20
I am testing some others ways...

> In any case, it does seem like there is confusion somewhere with
> numeric uids, but I don't think that confusion is with cifs.upcall. I=
f
> that is the correct credcache for this user, then it looks like its
> being created with the wrong ownership.
>=20
> What does the output of "klist" look like when you're logged in as th=
is
> user?
>=20

[12345678@centad5 ~]$ klist
Ticket cache: FILE:/tmp/krb5cc_16777221
Default principal: 12345678-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org

Valid starting Expires Service principal
11/17/12 14:34:04 11/18/12 00:34:04 krbtgt/DOMAIN.LOCAL-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
renew until 11/24/12 14:34:04
11/17/12 14:34:04 11/18/12 00:34:04 CENTAD5$@DOMAIN.LOCAL
renew until 11/24/12 14:34:04
11/17/12 14:34:04 11/18/12 00:34:04 CENTAD5$@DOMAIN.LOCAL
renew until 11/24/12 14:34:04
[12345678@centad5 ~]$

> How about the output of "stat /tmp/krb5cc_16777216" ?

16777216 or 16777221 ?=20
I did it for the two files=20

[12345678@centad5 ~]$ id
uid=3D16777221(12345678) gid=3D16777216(utilisateurs du domaine)=20
groupes=3D16777216(utilisateurs du domaine),16777217(profs)
[12345678@centad5 ~]$


[12345678@centad5 ~]$ stat /tmp/krb5cc_16777221=20
=46ile: =C2=AB=C2=A0/tmp/krb5cc_16777221=C2=A0=C2=BB
Size: 3830 Blocks: 8 IO Block: 4096 fichier
Device: 801h/2049d Inode: 1985377 Links: 1
Access: (0600/-rw-------) Uid: (16777221/12345678) Gid: ( 0/ root)
Access: 2012-11-17 14:41:37.056868612 +0100
Modify: 2012-11-17 14:41:32.251850184 +0100
Change: 2012-11-17 14:41:32.251850184 +0100


[12345678@centad5 ~]$ stat /tmp/krb5cc_16777216=20
=46ile: =C2=AB=C2=A0/tmp/krb5cc_16777216=C2=A0=C2=BB
Size: 3751 Blocks: 8 IO Block: 4096 fichier
Device: 801h/2049d Inode: 1966082 Links: 1
Access: (0600/-rw-------) Uid: (16777216/ conrad5) Gid: ( 0/ root)
Access: 2012-11-16 23:11:47.948511483 +0100
Modify: 2012-11-16 23:11:47.948511483 +0100
Change: 2012-11-16 23:11:47.948511483 +0100
>=20
> --=20
> Jeff Layton=20
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
