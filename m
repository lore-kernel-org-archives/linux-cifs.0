From: Milan =?UTF-8?Q?Kn=C3=AD=C5=BEek?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session
 keyring problems
Date: Wed, 15 Aug 2012 22:39:28 +0200
Message-ID: <1345063168.23732.18.camel@athlon.garagome>
References: <1344447933.32720.3.camel@athlon.garagome>
	 <30167.1342557999@warthog.procyon.org.uk>
	 <1342704916-2224-1-git-send-email-jlayton@samba.org>
	 <6113.1344892912@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6113.1344892912-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

David Howells p=C3=AD=C5=A1e v Po 13. 08. 2012 v 22:21 +0100:
> Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > How does one arrange that the session keyring is set up properly fo=
r
> > various login methods?
> ...
> > pam_keyinit.so was already in /etc/pam.d/gdm-password, though when
> > logged in into Xfce from GDM, then "cifscreds add" typed in
> > xfce4-terminal complains about non-persistent keyring.
>=20
> What name does gdm use when logging in?  I see five different names i=
n the
> list above.
>=20
In Arch, gdm-welcome is used for GDM greeter (run under user gdm) and
gdm-password for the user about to log in.

I tried to change the "optional" to "required" in gdm-password:
  session required pam_keyinit.so force revoke
and the user was not able to login then. With "optional", the user logs
in but the keyring is then probably created by some other process w/o
pam_keyinit.

With
   session optional pam_keyinit.so force revoke debug
the /var/log/gdm/:0-slave.log shows:
gdm-password][19678]: pam_keyinit(gdm-password:session): OPEN 1
gdm-password][19678]: pam_keyinit(gdm-password:session): UID:1000 [0]
GID:100 [100]
gdm-password][19678]: pam_keyinit(gdm-password:session): JOIN =3D -1

A bit of googling revealed some info (comment 13):
https://bugs.freedesktop.org/show_bug.cgi?id=3D49211

I do not understand much of the comments there and what is causing the
failure (gdm, kernel, pam_keyinit), however I can see that you - David =
-
got involved (comment 26) and provided a patch to kernel.

If it is related, in which version of kernel was this patch released?

My versions are: linux 3.4.8-1-ARCH, gdm 3.4.1-2


regards,
Milan
