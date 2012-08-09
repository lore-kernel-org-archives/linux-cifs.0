From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session
 keyring problems
Date: Wed, 8 Aug 2012 20:19:38 -0400
Message-ID: <20120808201938.6d1a47a2@corrin.poochiereds.net>
References: <30167.1342557999@warthog.procyon.org.uk>
	<1342704916-2224-1-git-send-email-jlayton@samba.org>
	<1344447933.32720.3.camel@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344447933.32720.3.camel-77nuZImz6nKt3pJmeLR6bw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 08 Aug 2012 19:45:33 +0200
Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff Layton p=C3=AD=C5=A1e v =C4=8Ct 19. 07. 2012 v 09:35 -0400:
> > Many distros do not call into pam_keyinit to set up the session key=
ring
> > properly at login time. When cifscreds add is used in such a sessio=
n,
> > the kernel will spawn a new session keyring in which to install the
> > credentials. That keyring will then go away once the cifscreds proc=
ess
> > exits.
>=20
> How does one arrange that the session keyring is set up properly for
> various login methods?
>=20
> I added "session optional pam_keyinit.so force revoke"
> into /etc/pam.d/login and /etc/pam.d/sshd and "cifscreds add" works f=
ine
> when logged in console (alt+f2) or via ssh.
> Session Keyring
>  812231719 --alswrv   1001   100  keyring: _ses
>  132272983 --alswrv   1001    -1   \_ keyring: _uid.1001
> 1046511393 ----sw-v   1001   100   \_ logon: cifs:a:192.168.1.3
>=20
>=20
> pam_keyinit.so was already in /etc/pam.d/gdm-password, though when
> logged in into Xfce from GDM, then "cifscreds add" typed in
> xfce4-terminal complains about non-persistent keyring.
>=20
> I can see that the name of the top level keyring differs for Xfce ses=
sion:
> Session Keyring
>  666176370 --alswrv   1001    -1  keyring: _uid_ses.1001
>  132272983 --alswrv   1001    -1   \_ keyring: _uid.1001
>=20
> Does anyone know if that is some GDM bug/feature and how avoid it?
>=20
> Sorry if being off-topic here, though I guess it might help others wh=
o
> will run into the problems with cifscreds, too.
>=20

An excellent question. I see the same behavior on a fairly stock Fedora
17 host too. I can only assume that the actual desktop session is
ending up with a different keyring session than gdm had.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
