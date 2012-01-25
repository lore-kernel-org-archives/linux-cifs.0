From: Robert Euhus <euhus-liste1-RRsrufEBJWcjwdJHFrQ6C0zuTB+3w3uf@public.gmane.org>
Subject: How to use the new multiuser option
Date: Wed, 25 Jan 2012 18:17:19 +0100
Message-ID: <20120125181719.039e1c01@pc213re>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am trying to figure out how to make use of the new multiuser option
in mount.cifs.

What I am trying to accomplish is that on a server which is joined to
an AD-Domain every user has access to their part on the shares without
the need to add an fstab entry for every one of them. If I understood
correctly this is what the multiuser option is for.

=46rom what I understand I would have to mount the share (from the
AD-DC) with some kind of server-account and then every user could just
access that share while his own Kerberos ticket is used for granting
permissions.

My question is now how exactly to do the first part:
- which kerberos ticket is used?
- should I use the host Principal created by winbind when I joined the =
AD?
I already tried to use it by setting 'kerberos method =3D secrets and=20
keytab' in the smb.conf and then exporting it to /etc/krb5.keytab. via=20
'net ads keytab create -U euhus'
But I still get:
--------------------------
root@goto:~# mount -t cifs -o directio,sec=3Dkrb5i,multiuser //dc1.work=
group.intern/test /mnt/test/
mount error(126): Required key not available Refer to the mount.cifs(8)
manual page (e.g. man mount.cifs)
--------------------------

and in the log I found
--------------------------
Jan 25 17:55:12 goto cifs.upcall: key description: cifs.spnego;0;0;3f00=
0000;ver=3D0x2;host=3Ddc1.workgroup.intern;ip4=3D130.75.5.220;sec=3Dkrb=
5;uid=3D0x0;user=3Droot;pid=3D0x4bca
Jan 25 17:55:12 goto cifs.upcall: ver=3D2
Jan 25 17:55:12 goto cifs.upcall: host=3Ddc1.workgroup.intern
Jan 25 17:55:12 goto cifs.upcall: ip=3D130.75.5.220
Jan 25 17:55:12 goto cifs.upcall: sec=3D1
Jan 25 17:55:12 goto cifs.upcall: uid=3D0
Jan 25 17:55:12 goto cifs.upcall: user=3Droot
Jan 25 17:55:12 goto cifs.upcall: pid=3D19402
Jan 25 17:55:12 goto cifs.upcall: find_krb5_cc: considering /tmp/krb5cc=
_101125
Jan 25 17:55:12 goto cifs.upcall: find_krb5_cc: /tmp/krb5cc_101125 is o=
wned by 101125, not 0
Jan 25 17:55:12 goto cifs.upcall: krb5_get_init_creds_keytab: -17653283=
78
Jan 25 17:55:12 goto cifs.upcall: handle_krb5_mech: getting service tic=
ket for cifs/dc1.workgroup.intern
Jan 25 17:55:12 goto cifs.upcall: cifs_krb5_get_req: unable to resolve =
(null) to ccache
Jan 25 17:55:12 goto cifs.upcall: handle_krb5_mech: failed to obtain se=
rvice ticket (-1765328245)
--------------------------

So it seems like I would somehow have to tell cifs.upcall to use the
host key stored in /etc/krb5.keytab ?

This is my /etc/request-key.conf:
--------------------------
#OP     TYPE    DESCRIPTION     CALLOUT INFO    PROGRAM ARG1 ARG2 ARG3 =
=2E..
#=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
create  user    debug:*         negate          /bin/keyctl negate %k 3=
0 %S
create  user    debug:loop:*    *               |/bin/cat
create  user    debug:*         *               /usr/share/keyutils/req=
uest-key-debug.sh %k %d %c %S
create  cifs.spnego     *       *               /usr/sbin/cifs.upcall -=
c %k
create  dns_resolver    *       *               /usr/sbin/cifs.upcall %=
k
negate  *       *               *               /bin/keyctl negate %k 3=
0 %S
--------------------------

Now I don't know what else to try, so any hints are very much appreciat=
ed.

Thanks a lot.

--=20
Robert Euhus, IT-Sicherheit,  RRZN, Leibniz Universit=C3=A4t Hannover
Tel: +49-(0)511-762-79-4467   Schlosswender Str. 5
=46ax: +49-(0)511-762-3003      D-30159 Hannover
