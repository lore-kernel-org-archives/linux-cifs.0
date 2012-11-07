From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: cifs autofs krb5i
Date: Wed, 07 Nov 2012 01:33:17 +0100
Message-ID: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I am using a test computer
kernel 2.6.32-279.11.1.el6.x86_64
joined to an Active directory with winbind

I am getting A kerberos Ticket with the authentication with=20
/etc/security/pam_winbind.conf
krb5_auth =3D yes
krb5_ccache_type =3D FILE

/etc/request-key.conf is configured like this :
create cifs.spnego * * /usr/sbin/cifs.upcall %k
create dns_resolver * * /usr/sbin/cifs.upcall %k


I got the ticket from kerberos
[conrad3@centad5 ~]$ klist
Ticket cache: FILE:/tmp/krb5cc_16777217
Default principal: conrad3-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org

Valid starting Expires Service principal
11/07/12 00:33:48 11/07/12 10:33:48 krbtgt/DOMAIN.LOCAL-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
renew until 11/14/12 00:33:48
11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
renew until 11/14/12 00:33:48
11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
renew until 11/14/12 00:33:48
11/07/12 00:41:57 11/07/12 10:33:48 cifs/figue-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
renew until 11/14/12 00:33:48


When i put a entry in fstab, everything is working when i do mount /par=
tage as a user
=46STAB
//figue/data/conrad4 /partage cifs=20
sec=3Dkrb5i,user,nounix,file_mode=3D0700,dir_mode=3D0700,noauto=20
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.x.xx;sec=3Dkrb5;uid=3D0x1000001;cr=
eduid=3D0x1000001;user=3Dconrad3
;pid=3D0xc2d


Howether i got a problem with fstab, it seems to not pass the creduid o=
ptions,and i=20
obtain=20
CIFS VFS: cifs_mount failed w/return code =3D -126

Hereis my different autofs configuration, with the result in dmesg

AUTOFS
* -fstype=3Dcifs,sec=3Dkrb5i,user=3D& ://figue/data/&
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x0;creduid=
=3D0x0;user=3Dconrad3;pid=3D0xc6e

* -fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D& ://figue/data/&
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x1000001;c=
reduid=3D0x0;user=3Dconrad3;pid=3D
0xd02

* -fstype=3Dcifs,sec=3Dkrb5i,user=3D&,uid=3D&,creduid=3D& ://figue/data=
/&
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x1000001;c=
reduid=3D0x0;user=3Dconrad3;pid=3D
0xd02

What could be done to use autofs ??

Regards Serge


=46ULL DEBUG TRACE :

fs/cifs/cifsfs.c: Devname: //figue/data/conrad3 flags: 0
fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 99 with uid: 0
fs/cifs/connect.c: prefix path /conrad3
fs/cifs/connect.c: Username: conrad3
fs/cifs/connect.c: UNC: \\figue\data ip: 130.120.xx.xx
fs/cifs/connect.c: Socket created
fs/cifs/connect.c: sndbuf 23720 rcvbuf 87380 rcvtimeo 0x1b58
fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 100 with uid: =
0
fs/cifs/connect.c: Existing smb sess not found
fs/cifs/cifssmb.c: secFlags 0x1009
fs/cifs/cifssmb.c: Kerberos only mechanism, enable extended security
fs/cifs/transport.c: For smb_command 114
fs/cifs/transport.c: Sending smb: total_len 82
fs/cifs/connect.c: Demultiplex PID: 3332
fs/cifs/connect.c: rfc1002 length 0xc5
fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D114 mid=3D1 state=3D4
fs/cifs/cifssmb.c: Dialect: 2
fs/cifs/asn1.c: OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
fs/cifs/asn1.c: OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len =3D 8 oid =3D 0x1 0x2 0x348 0x1bb92
fs/cifs/asn1.c: OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
fs/cifs/asn1.c: Need to call asn1_octets_decode() function for=20
not_defined_in_RFC4178@please_ignore
fs/cifs/cifssmb.c: Must sign - secFlags 0x1009
fs/cifs/cifssmb.c: negprot rc 0
fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8001f3fd TimeAdju=
st: -3600
fs/cifs/sess.c: sess setup type 4
fs/cifs/cifs_spnego.c: key description =3D=20
ver=3D0x2;host=3Dfigue;ip4=3D130.120.xx.xx;sec=3Dkrb5;uid=3D0x1000001;c=
reduid=3D0x0;user=3Dconrad3;pid=3D
0xd02
fs/cifs/sess.c: ssetup freeing small buf ffff88003da91140
CIFS VFS: Send error in SessSetup =3D -126
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D 100) rc =
=3D -126
fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 99) rc =3D -12=
6
CIFS VFS: cifs_mount failed w/return code =3D -126


Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
