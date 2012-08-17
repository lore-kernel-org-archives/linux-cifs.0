From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session
 keyring problems
Date: Fri, 17 Aug 2012 12:02:42 -0400
Message-ID: <20120817120242.53ee6504@tlielax.poochiereds.net>
References: <1344447933.32720.3.camel@athlon.garagome>
	<30167.1342557999@warthog.procyon.org.uk>
	<1342704916-2224-1-git-send-email-jlayton@samba.org>
	<6113.1344892912@warthog.procyon.org.uk>
	<1345063168.23732.18.camel@athlon.garagome>
	<1345218866.32023.5.camel@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345218866.32023.5.camel-77nuZImz6nKt3pJmeLR6bw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Aug 2012 17:54:26 +0200
Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Milan Kn=C3=AD=C5=BEek p=C3=AD=C5=A1e v St 15. 08. 2012 v 22:39 +0200=
:
> > David Howells p=C3=AD=C5=A1e v Po 13. 08. 2012 v 22:21 +0100:
> > > Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >=20
> > With
> >    session optional pam_keyinit.so force revoke debug
> > the /var/log/gdm/:0-slave.log shows:
> > gdm-password][19678]: pam_keyinit(gdm-password:session): OPEN 1
> > gdm-password][19678]: pam_keyinit(gdm-password:session): UID:1000 [=
0]
> > GID:100 [100]
> > gdm-password][19678]: pam_keyinit(gdm-password:session): JOIN =3D -=
1
> >=20
> > A bit of googling revealed some info (comment 13):
> > https://bugs.freedesktop.org/show_bug.cgi?id=3D49211
> > I do not understand much of the comments there and what is causing =
the
> > failure (gdm, kernel, pam_keyinit), however I can see that you - Da=
vid
> > - got involved (comment 26) and provided a patch to kernel.
>=20
> Recompiling 3.4.8 kernel with the patch applied (plus another one
> mentioned in that patch description) solved the problem - in Xfce
> session opened from GDM the session keyring exists and "cifscreds add
> server" works. (And mounting CIFS shares with multiuser option as wel=
l.)
>=20
> Thanks!
>=20
> regards,
> Milan
>=20

Awesome! David, are there any plans to push this patch to mainline?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
