From: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: Tr:Re: cifs oplock windows share
Date: Mon, 05 Mar 2012 14:53:35 +0100
Message-ID: <831482704.1355048.1330955614024.JavaMail.www@wwinf8220>
Reply-To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>







> Message du 05/03/12 10:48
> De : "sergio.conrad"=20
> A : "Jeff Layton"=20
> Copie =C3=A0 :=20
> Objet : Re: cifs oplock windows share
>
>=20
> Hi,=20
>=20
> I am sorry for the lack of clarity of my precendents posts:
> subject: mount share problems with fedora core 14, winbind,pam_mount,=
cifs windows 2008/
> subject: why I do echo 0 > /proc/fs/cifs/OplockEnabled on windows 200=
8 share
> subject: It doesn't work in 2K8R2
>=20
> Here is the configuration made in the workstations
>=20
> 1=C2=B0) the workstations are joined to active directory on 2008 with=
 the authconfig command:
> authconfig --update --kickstart --enableshadow --enablemd5 --enablewi=
nbind --enablewinbindauth --smbsecurity=3Dads --smbworkgroup=3D$WORKGRO=
UP --smbrealm=3D$REALM --smbservers=3D$DC --winbindtemplatehomedir=3D/h=
ome/%U --winbindtemplateshell=3D/bin/bash --enablewinbindusedefaultdoma=
in --enablelocauthorize --enablemkhomedir=20
> 2=C2=B0) Changes are made to the files /etc/pam.d/system-auth and /et=
c/pam.d/password-auth with the sed commands
> session optional pam_mount.so
> sed -i 's/\(^.*auth[\t ]*required[\t ]*pam_deny\.so.*\)/auth optional=
 pam_mount\.so use_first_pass\n\1/' /etc/pam.d/system-auth
> sed -i 's/\(^.*session[\t ]*optional[\t ]*pam_mkhomedir\.so.*\)/\1\ns=
ession optional pam_mount\.so/' /etc/pam.d/system-auth
>=20
> #%PAM-1.0
> # This file is auto-generated.
> # User changes will be destroyed the next time authconfig is run.
> auth required pam_env.so
> auth sufficient pam_fprintd.so
> auth sufficient pam_unix.so nullok try_first_pass
> auth requisite pam_succeed_if.so uid >=3D 1000 quiet
> auth sufficient pam_winbind.so use_first_pass
> auth optional pam_mount.so use_first_pass
> auth required pam_deny.so
> account required pam_unix.so broken_shadow
> account sufficient pam_localuser.so
> account sufficient pam_succeed_if.so uid < 1000 quiet
> account [default=3Dbad success=3Dok user_unknown=3Dignore] pam_winbin=
d.so
> account required pam_permit.so
> password requisite pam_cracklib.so try_first_pass retry=3D3 type=3D
> password sufficient pam_unix.so md5 shadow nullok try_first_pass use_=
authtok
> password sufficient pam_winbind.so use_authtok
> password required pam_deny.so
> session optional pam_keyinit.so revoke
> session required pam_limits.so
> -session optional pam_systemd.so
> session optional pam_mount.so
> session optional pam_mkhomedir.so=20
> session [success=3D1 default=3Dignore] pam_succeed_if.so service in c=
rond quiet use_uid
> session required pam_unix.so
>=20
> 3=C2=B0) Changes are made in the /etc/security/pam_mount.conf.xml
>=20
>=20
> 4=C2=B0) Everything is working fine when working only with a few work=
stations.
>=20
> 5=C2=B0) But when the students were working on severals, we find some=
 problems.
> In the /var/log/messages
> Oct 5 16:42:24 u1209-01l kernel: [ 58.783078] CIFS VFS: No response f=
or cmd 114 mid 1
> Oct 5 16:42:24 u1209-01l kernel: [ 58.783094] CIFS VFS: cifs_mount fa=
iled w/return code =3D -112
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:64): Errors=
 from underlying mount program:
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): mount =
error(112): Host is down
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(mount.c:68): Refer =
to the mount.cifs(8) manual page (e.g. man mount.cifs)
> Oct 5 16:42:24 u1209-01l kdm: :0[1926]: pam_mount(pam_mount.c:521): m=
ount of data/u20 failed
> The windows 2008 server share hangs up and must be rebooted
>=20
> 6=C2=B0) I dot not find much informations on this problem execpt in
> http : //blog.dhampir.no/content/cifs-vfs-no-response-for-cmd-n-mid
> "On a few systems, I've noticed CIFS mounts have a tendency to lock u=
p the system when transferring large files, or a shitload of small ones=
 in quick succession. When this happens, the system may or may not comp=
letely lock up, and lines like these will appear in your syslog:"
> ...
>=20
> I have experimented this in /etc/rc.d/rc.local
> modprobe cifs
> echo 0 > /proc/fs/cifs/OplockEnabled
> and the problem seems to be resolved. (On windows 2008)=20
> 7=C2=B0)=20
> With windows 2008 R2, this do not resolve the problem...
> dcdiag gives ... (sorry in french)
> D=C3=A9marrage du test : SysVolCheck
> [SVT1] Une op=C3=A9ration net use ou LsaPolicy a =C3=A9chou=C3=A9 ave=
c l'erreur 64,
> Le nom r=C3=A9seau sp=C3=A9cifi=C3=A9 n'est plus disponible..
> ......................... Le test SysVolCheck
> de SVT1 a =C3=A9chou=C3=A9
>=20
> D=C3=A9marrage du test : NetLogons
> [SVT1] Une op=C3=A9ration net use ou LsaPolicy a =C3=A9chou=C3=A9 ave=
c l'erreur 64,
> Le nom r=C3=A9seau sp=C3=A9cifi=C3=A9 n'est plus disponible..
> ......................... Le test NetLogons
> de SVT1 a =C3=A9chou=C3=A9
> D=C3=A9marrage du test : Services
> Impossible d'ouvrir IPC distant =C3=A0 [svt1.svt.snap.fsi] : erreur 0=
x40
> =C2=AB Le nom r=C3=A9seau sp=C3=A9cifi=C3=A9 n'est plus disponible. =C2=
=BB
> ......................... Le test Services
> de SVT1 a =C3=A9chou=C3=A9
>=20
> Thank you for looking at this problem.
> Serge
>=20
>=20
> > Message du 02/03/12 17:43
> > De : "Jeff Layton"=20
> > A : "sergio.conrad"=20
> > Copie =C3=A0 : linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Objet : Re: cifs oplock windows share
> >
> > On Fri, 02 Mar 2012 17:21:44 +0100
> > "sergio.conrad" wrote:
> >=20
> > >=20
> > > Thanks for your response.
> > >=20
> > > I am actually migrating users data from a windows 2008 R2 file se=
rver to another windows 2008.
> > > I fear i don't understand why I have to disable oplocks.
> > >=20
> >=20
> > I fear that I don't either. I was just speculating.
> >=20
> > > Is the cifs protocol compatible with windows 2008 smb ?=20
> >=20
> > Yes. I often test against win2k8 and don't see this problem.
> >=20
> > > Must I specify max protocol =3Dsmb2 in samba ?=20
> >=20
> > You mean in smb.conf? The cifs client doesn't use that at all. That=
's
> > for the samba userspace code. cifs.ko does not support smb2 at this
> > time.=20
> >=20
> > > The issue this day:
> > > Linux Cifs mount on Windows 2008 (via pam_mount): work with oploc=
ks disabled.
> > > Linux cifs mount on Windows 2008 R2 (via pam_mount): don't seems =
to work even with oplocks disabled
> > > (Perhaps thereis another problem on the server but I don't think =
so)
> > >=20
> >=20
> > I can't help much with this since you haven't provided any details.
> >=20
> > "works" and "doesn't work" doesn't tell me anything about what's re=
ally
> > wrong. If you say "it failed with this error message" or "I got thi=
s
> > error message in the log when I attempted it", then that may tell u=
s
> > something.
> >=20
> > --=20
> > Jeff Layton=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> Une messagerie gratuite, garantie =C3=A0 vie et des services en plus,=
 =C3=A7a vous tente ?
> Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
>=20

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
