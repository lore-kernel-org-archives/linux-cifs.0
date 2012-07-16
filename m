From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fw: mount.cifs multiuser w/o krb5? How?
Date: Mon, 16 Jul 2012 23:53:22 +0100
Message-ID: <8040.1342479202@warthog.procyon.org.uk>
References: <20120716072106.00993484@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Milan =?utf-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120716072106.00993484-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 11 Jul 2012 21:05:31 +0200
> Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > Jeff Layton writes:
> >=20
> > >> cifscreds add is more or less equivalent to a command like this:
> > >
> > >     $ keyctl add logon cifs:a:ip_address 'username:password' @s
> > >
> >=20
> > There seems to be a general problem with adding keys (@s) to the de=
fault =20
> > "session" keyring. Adding user type keys (@u) works.
> >=20
> > $ keyctl add logon description data @s
> > does not add anything to the _uid_ses:UID keyring, which is automat=
ically =20
> > created after login.
> >=20
> > Interestingly, when a new session keyring is added, then it works:
> >=20
> > [root@client ~]# su - zmrzlinka
> > [zmrzlinka@client ~]$ keyctl show
> > Session Keyring
> > 1037083570 --alswrv   1001    -1  keyring: _uid_ses.1001

The problem is here.

Your process here does not have its own session keyring.  Instead it fa=
lls
back to the user-session keyring when it can (you can see this by the
"_uid.ses.<uid>" name on the keyring).

In the kernel, lookup_user_key() has special logic in the kernel for ha=
ndling
the case where you try and modify the session keyring when you don't ha=
ve one.
That includes adding a link into it to a new key:

	case KEY_SPEC_SESSION_KEYRING:
		if (!cred->session_keyring) {
			/* always install a session keyring upon access if one
			 * doesn't exist yet */
			ret =3D install_user_keyrings();
			if (ret < 0)
				goto error;
			if (lflags & KEY_LOOKUP_CREATE)
				ret =3D join_session_keyring(NULL);
			else
				ret =3D install_session_keyring(
					cred->user->session_keyring);

			if (ret < 0)
				goto error;
			goto reget_creds;
		} else if (cred->session_keyring =3D=3D
			   cred->user->session_keyring &&
			   lflags & KEY_LOOKUP_CREATE) {
			ret =3D join_session_keyring(NULL);
			if (ret < 0)
				goto error;
			goto reget_creds;
		}

lookup_user_key() is called with KEY_LOOKUP_CREATE set when the add_key=
()
system call invokes it to get the destination keyring.  That means that=
 a new
session keyring will be created for the cifscreds process (note the
join_session_keyring() calls) - and will be destroyed when that process=
 exits.

Your system should call pam_keyinit from the login process to set up yo=
ur
session keyring.  This has been around for a few years, but not all
distributions choose to use it (as far as I can tell, Debian and Ubuntu=
 fall
into this category).

On a Fedora-based system, you see:

	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	 222025610 --alswrv   4043  4043  keyring: _ses
	  60559872 --alswrv   4043    -1   \_ keyring: _uid.4043

The default name for the session keyring is _ses.  Because processes on=
 Fedora
have a session keyring allocated by PAM, this then works:

	[dhowells@andromeda ~]$ cifscreds add www.redhat.com
	Password:=20
	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	 222025610 --alswrv   4043  4043  keyring: _ses
	  60559872 --alswrv   4043    -1   \_ keyring: _uid.4043
	   4690765 ----sw-v   4043  4043   \_ logon: cifs:a:2.19.119.214

Note that the behaviour can be reproduced on Fedora by this:

	keyctl session _uid_ses.<uid>

So, for me, I would do:

	keyctl session _uid_ses.4043

which will create a new shell that has the user-session process as the =
session
keyring, which will then fail to work exactly as if there was no specif=
ically
assigned session keyring:

	[dhowells@andromeda ~]$ keyctl add user a a @s
	341403701
	[dhowells@andromeda ~]$ keyctl show
	Session Keyring
	 961618603 --alswrv   4043    -1  keyring: _uid_ses.4043
	  60559872 --alswrv   4043    -1   \_ keyring: _uid.4043

David
