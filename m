From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Fri, 16 Nov 2012 23:37:52 +0100
Message-ID: <31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
 <20121107065651.18dc9f63@tlielax.poochiereds.net>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121107065651.18dc9f63-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am able to connect to cifs share on Windows 2008 with Kerberos securi=
ty via autofs with=20
this map :=20
* -
fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,cruid=3D&,file_mode=3D0700,d=
ir_mode=3D0700,nounix,noserverin
o ://figue/data/&

Is it working fine with alpha numeric login=20
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0x1000001;cr=
eduid=3D0x1000001;user=3Dconrad3
;pid=3D0xd331


But if i use numeric only login like 12345678 i have a problem :
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.8.11;sec=3Dkrb5;uid=3D0xbc614e;cre=
duid=3D0xbc614e;user=3D12345678;
pid=3D0xe5db
fs/cifs/sess.c: ssetup freeing small buf ffff88003a838140
CIFS VFS: Send error in SessSetup =3D -126
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D 223) rc =
=3D -126
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 222) rc =3D -1=
26
CIFS VFS: cifs_mount failed w/return code =3D -126

What can I do to solve this issue ?
Thanks in advance,
Serge

> Message du 07/11/12 12:57
> De : "Jeff Layton"=20
> A : "sergio.conrad"=20
> Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Objet : Re: cifs autofs krb5i
>
> On Wed, 07 Nov 2012 01:33:17 +0100
> "sergio.conrad"  wrote:
>=20
> > Hi,
> >=20
> > I am using a test computer
> > kernel 2.6.32-279.11.1.el6.x86_64
> > joined to an Active directory with winbind
> >=20
> > I am getting A kerberos Ticket with the authentication with=20
> > /etc/security/pam_winbind.conf
> > krb5_auth =3D yes
> > krb5_ccache_type =3D FILE
> >=20
> > /etc/request-key.conf is configured like this :
> > create cifs.spnego * * /usr/sbin/cifs.upcall %k
> > create dns_resolver * * /usr/sbin/cifs.upcall %k
> >=20
> >=20
> > I got the ticket from kerberos
> > [conrad3@centad5 ~]$ klist
> > Ticket cache: FILE:/tmp/krb5cc_16777217
> > Default principal: conrad3-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> >=20
> > Valid starting Expires Service principal
> > 11/07/12 00:33:48 11/07/12 10:33:48 krbtgt/DOMAIN.LOCAL-10W9mfrL9XkN2LvcTqJorw@public.gmane.org=
L
> > renew until 11/14/12 00:33:48
> > 11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
> > renew until 11/14/12 00:33:48
> > 11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
> > renew until 11/14/12 00:33:48
> > 11/07/12 00:41:57 11/07/12 10:33:48 cifs/figue-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> > renew until 11/14/12 00:33:48
> >=20
> >=20
> > When i put a entry in fstab, everything is working when i do mount =
/partage as a user
> > FSTAB
> > //figue/data/conrad4 /partage cifs=20
> > sec=3Dkrb5i,user,nounix,file_mode=3D0700,dir_mode=3D0700,noauto=20
> > fs/cifs/cifs_spnego.c: key description =3D=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.x.xx;sec=3Dkrb5;uid=3D0x1000001;cr=
eduid=3D0x1000001;user=3Dconrad3
> > ;pid=3D0xc2d
> >=20
> >=20
> > Howether i got a problem with fstab, it seems to not pass the credu=
id options,and i=20
> > obtain=20
> > CIFS VFS: cifs_mount failed w/return code =3D -126
> >=20
> > Hereis my different autofs configuration, with the result in dmesg
> >=20
> > AUTOFS
> > * -fstype=3Dcifs,sec=3Dkrb5i,user=3D& ://figue/data/&
> > fs/cifs/cifs_spnego.c: key description =3D=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x0;creduid=
=3D0x0;user=3Dconrad3;pid=3D0xc6e
> >=20
> > * -fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D& ://figue/data/&
> > fs/cifs/cifs_spnego.c: key description =3D=20
> >=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x1000001;c=
reduid=3D0x0;user=3Dconrad3;pid=3D
> > 0xd02
> >=20
> > * -fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,creduid=3D& ://figue/=
data/&
>=20
> That option should be "cruid=3D&". "creduid=3D" isn't a mount option.
>=20
> --=20
> Jeff Layton=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
