From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs multiuser w/o krb5? How?
Date: Mon, 9 Jul 2012 06:26:08 -0400
Message-ID: <20120709062608.3a67445f@tlielax.poochiereds.net>
References: <1341427937.3252.6.camel@athlon.garagome>
	<20120706141543.1b564c11@tlielax.poochiereds.net>
	<1341612593.26748.9.camel@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341612593.26748.9.camel-77nuZImz6nKt3pJmeLR6bw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 07 Jul 2012 00:09:53 +0200
Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff Layton p=C3=AD=C5=A1e v P=C3=A1 06. 07. 2012 v 14:15 -0400:
>=20
> Hello Jeff,
>=20
> > On Wed, 04 Jul 2012 20:52:17 +0200
> > Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > To move on for multiuser: adding the credentials to the keyring:
> > > [user1@client /]$ cifscreds add server
> > > and typing in the password.
> > >=20
> > > (Similarly for user2.)
> > >=20
> > > When I remount the same share with "multiuser" option with the
> > > credentials of user1, the share is accessible only by the root us=
er, the
> > > users user1 and user2 cannot list the mount point (cannot access =
/mnt:
> > > Permission denied)
> > >=20
> >=20
> > Can you clarify exactly what you did above? How, exactly did you
> > remount the share?
>=20
> I actually unmounted and mounted again with the extra "multiuser"
> option.
>=20

Ok, good...

> > > Adding cifscreds has exit code 0. Running "cifscreds clearall" re=
sults
> > > in "You have no stashed cifs credentials. If you want to add them=
 use:
> > > cifscreds add" and exit code 1. That's weird.
> > >=20
> >=20
> > After you do the "cifscreds add", if you then do a "keyctl show" do=
es
> > it show the cifs keys attached to your session keyring?
> >=20
> > One thing that may be biting you: cifscreds attaches the keys to th=
e
> > session keyring. If you do the "add" in one session and then try to
> > access from another, it won't work since the keys just aren't prese=
nt.
> > The fact that "clearall" doesn't find any creds leads me to suspect
> > that's what's going on here.
> >=20
> > The scope of a "session" in keys parlance is unfortunately somewhat
> > poorly defined, but you basically need to do the "cifscreds add" fr=
om
> > each login. A graphical login on the console would be a single sess=
ion
> > however.
>=20
> Hm, I will need to read more on the keyrings in kernel...
>=20
> Anyway, here are some details:
> [root@client /]# su - zmrzlinka
> [zmrzlinka@client ~]$ keyctl show
> Session Keyring
>   14048542 --alswrv   1001    -1  keyring: _uid_ses.1001
>  320075663 --alswrv   1001    -1   \_ keyring: _uid.1001
> [zmrzlinka@client ~]$ cifscreds add -u zmrzlinka toillet
> Password: [blabla]
> [zmrzlinka@client ~]$ keyctl show
> Session Keyring
>   14048542 --alswrv   1001    -1  keyring: _uid_ses.1001
>  320075663 --alswrv   1001    -1   \_ keyring: _uid.1001
>=20
> It does not seem to change anything. Is there a way how to add the ke=
y
> to the keyring using "keyctl" instead of "cifscreds" (for testing
> purposes)?
>=20
> Regards,
> Milan

Ok, that at least gives us something to go on. Running this under
strace might give us some sort of clue as to the problem as well.

cifscreds add is more or less equivalent to a command like this:

    $ keyctl add logon cifs:a:ip_address 'username:password' @s

If the server is multi-homed, then cifscreds add will add a key for eac=
h
address in the list returned when the hostname is resolved.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
