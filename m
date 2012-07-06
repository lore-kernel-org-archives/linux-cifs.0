From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs multiuser w/o krb5? How?
Date: Fri, 6 Jul 2012 14:15:43 -0400
Message-ID: <20120706141543.1b564c11@tlielax.poochiereds.net>
References: <1341427937.3252.6.camel@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341427937.3252.6.camel-77nuZImz6nKt3pJmeLR6bw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 04 Jul 2012 20:52:17 +0200
Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
>=20
> I would like to have a single cifs mount accessible by multiple users
> allowing them to create files with their respective uid.
>=20
> Having spent some time on RTFM and Google search on this mailing list=
,
> it seems that the "multiuser" option of mount.cifs could make me happ=
y.
> And it should work now also for systems w/o krb5.
>=20
>=20
> My intention is to avoid use of any directory services or domain (sma=
ll
> network of mainly linux clients). The test platform (both server and
> client) are Arch linux, kernel 3.4.4-2-ARCH x86-64, cifs-utils 5.4-1.
>=20

Thanks for giving this a go. It's quite new, so there may be some kinks
to work out. Those cifs-utils and kernel versions should be fine for
this.

> The smb.conf on the server has
> security =3D user
> client ntlmv2 auth =3D yes
>=20
> I can post full smb.conf, if needed. Users have the same uid on both
> client and server.
>=20
> From the client, I am able to mount - as root - //server/share with
> credentials of user1 and user1 can access the share. Mounting and
> accessing works also for user2.
>=20
> [root@client /]$ mount
> //server/share on /mnt type cifs (rw,relatime,sec=3Dntlmv2,unc=3D\\se=
rver
> \share,username=3Duser1,domain=3DWORKGROUP,uid=3D0,noforceuid,gid=3D0=
,
> noforcegid,addr=3D192.168.1.3,unix,posixpaths,serverino,acl,
> rsize=3D1048576,wsize=3D65536,actimeo=3D1
>=20
> To move on for multiuser: adding the credentials to the keyring:
> [user1@client /]$ cifscreds add server
> and typing in the password.
>=20
> (Similarly for user2.)
>=20
> When I remount the same share with "multiuser" option with the
> credentials of user1, the share is accessible only by the root user, =
the
> users user1 and user2 cannot list the mount point (cannot access /mnt=
:
> Permission denied)
>=20

Can you clarify exactly what you did above? How, exactly did you
remount the share?

> What do I do wrong?
>=20
> Adding cifscreds has exit code 0. Running "cifscreds clearall" result=
s
> in "You have no stashed cifs credentials. If you want to add them use=
:
> cifscreds add" and exit code 1. That's weird.
>=20

After you do the "cifscreds add", if you then do a "keyctl show" does
it show the cifs keys attached to your session keyring?

One thing that may be biting you: cifscreds attaches the keys to the
session keyring. If you do the "add" in one session and then try to
access from another, it won't work since the keys just aren't present.
The fact that "clearall" doesn't find any creds leads me to suspect
that's what's going on here.

The scope of a "session" in keys parlance is unfortunately somewhat
poorly defined, but you basically need to do the "cifscreds add" from
each login. A graphical login on the console would be a single session
however.

> The manpage of cifscreds reads "The cifscreds utility requires a kern=
el
> built with support for the login key type." What is the name of kerne=
l
> config option to check?
>=20

There's no specific configuration. Newer kernels should all get the "lo=
gin"
key type as it's part of the "core" keys API.

> Further it reads "When a cifs filesystem is mounted with the "multius=
er"
> option, and does not use krb5 authentication, it needs to be able to =
get
> the credentials for each user from somewhere. The cifscreds program i=
s
> the tool used to provide these credentials to the kernel."
>=20
> However, man page of mount.cifs mentions "Because the kernel cannot
> prompt for passwords, multiuser mounts are limited to mounts using se=
c=3D
> options that don't require passwords." Does that include NTLMv2 or it=
s
> variants? Do I have to do something extra to let the kernel know abou=
t
> the credentials?
>=20

The cifscreds manpage is correct, and the mount.cifs one probably needs
updating.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
