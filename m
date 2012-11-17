From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Sat, 17 Nov 2012 08:53:02 +0100
Message-ID: <74526876.1792050.1353138782508.JavaMail.www@wwinf8223>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
 <20121107065651.18dc9f63@tlielax.poochiereds.net>
 <31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
 <20121116210141.33f983dc@corrin.poochiereds.net>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121116210141.33f983dc-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>




> Message du 17/11/12 03:01
> De : "Jeff Layton"=20
> A : "sergio.conrad"=20
> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Objet : Re: cifs autofs krb5i
>
> On Fri, 16 Nov 2012 23:37:52 +0100
> "sergio.conrad"  wrote:
>=20
> > Hi,
> >=20
> > I am able to connect to cifs share on Windows 2008 with Kerberos se=
curity via autofs=20
with=20
> > this map :=20
> > * -
> >=20
fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,cruid=3D&,file_mode=3D0700,d=
ir_mode=3D0700,nounix,noserverin
> > o ://figue/data/&
> >=20
> > Is it working fine with alpha numeric login=20
> > fs/cifs/cifs_spnego.c: key description =3D=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0x1000001;cr=
eduid=3D0x1000001;user=3Dconrad3
> > ;pid=3D0xd331
> >=20
> >=20
> > But if i use numeric only login like 12345678 i have a problem :
> > fs/cifs/cifs_spnego.c: key description =3D=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0xbc614e;cre=
duid=3D0xbc614e;user=3D12345678;
> > pid=3D0xe5db
> > fs/cifs/sess.c: ssetup freeing small buf ffff88003a838140
> > CIFS VFS: Send error in SessSetup =3D -126
> > fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D 223)=
 rc =3D -126
> > fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 222) rc =3D=
 -126
> > CIFS VFS: cifs_mount failed w/return code =3D -126
> >=20
> > What can I do to solve this issue ?
>=20
>=20
> cifs.upcall logs at daemon.debug level. Set up syslog to log that and
> you'll get some details about what it's doing.
>=20
> --=20
> Jeff Layton=20
>=20

Thanks for your response,=20
I got the error=20
Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_16777221=
 is owned by=20
16777221, not 12345678

Perhaps it is a confusion about the uid and the login in a numeric valu=
e

[12345678@centad5 ~]$ id
uid=3D16777221(12345678) gid=3D16777216(utilisateurs du domaine)=20
groupes=3D16777216(utilisateurs du domaine),16777217(profs)

The full log is :

Nov 17 08:42:53 centad5 cifs.upcall: key description:=20
cifs.spnego;0;0;3f000000;ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3D=
krb5;uid=3D0xbc614e;credui
d=3D0xbc614e;user=3D12345678;pid=3D0x9b5
Nov 17 08:42:53 centad5 cifs.upcall: ver=3D2
Nov 17 08:42:53 centad5 cifs.upcall: host=3Dfigue
Nov 17 08:42:53 centad5 cifs.upcall: ip=3D130.120.8.11
Nov 17 08:42:53 centad5 cifs.upcall: sec=3D1
Nov 17 08:42:53 centad5 cifs.upcall: uid=3D12345678
Nov 17 08:42:53 centad5 cifs.upcall: creduid=3D12345678
Nov 17 08:42:53 centad5 cifs.upcall: user=3D12345678
Nov 17 08:42:53 centad5 cifs.upcall: pid=3D2485
Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considering /tmp/krb=
5cc_16777221
Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_16777221=
 is owned by=20
16777221, not 12345678
Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: considering /tmp/krb=
5cc_16777216
Nov 17 08:42:53 centad5 cifs.upcall: find_krb5_cc: /tmp/krb5cc_16777216=
 is owned by=20
16777216, not 12345678
Nov 17 08:42:53 centad5 cifs.upcall: krb5_get_init_creds_keytab: 13
Nov 17 08:42:53 centad5 cifs.upcall: handle_krb5_mech: getting service =
ticket for figue
Nov 17 08:42:53 centad5 cifs.upcall: cifs_krb5_get_req: unable to resol=
ve (null) to=20
ccache
@

Bye,
Serge Conrad



Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
