From: knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session
         keyring problems
Date: Thu, 09 Aug 2012 14:00:43 +0200
Message-ID: <cone.1344513643.733169.18953.1000@athlon>
References: <30167.1342557999@warthog.procyon.org.uk> <1342704916-2224-1-git-send-email-jlayton@samba.org> <1344447933.32720.3.camel@athlon.garagome> <20120808201938.6d1a47a2@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton writes:

> On Wed, 08 Aug 2012 19:45:33 +0200
> Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> > pam_keyinit.so was already in /etc/pam.d/gdm-password, though when
> > logged in into Xfce from GDM, then "cifscreds add" typed in
> > xfce4-terminal complains about non-persistent keyring.
> >
> > I can see that the name of the top level keyring differs for Xfce s=
ession:
> > Session Keyring
> >  666176370 --alswrv   1001    -1  keyring: _uid_ses.1001
> >  132272983 --alswrv   1001    -1   \_ keyring: _uid.1001
> >
> > Does anyone know if that is some GDM bug/feature and how avoid it?
> >
> An excellent question. I see the same behavior on a fairly stock Fedo=
ra
> 17 host too. I can only assume that the actual desktop session is
> ending up with a different keyring session than gdm had.

=46or the sake of curiosity, when logging in remotely with x2go (based =
on NX), =20
the session keyring is okay:
$ keyctl show
Session Keyring
 420490248 --alswrv   1000   100  keyring: _ses
 318990990 --alswrv   1000    -1   \_ keyring: _uid.1000
 909936426 --alswrv   1000   100   |   \_ user: 75fbf6399a9cf084
 909201030 --alswrv   1000   100   |   \_ user: aa10afc0620e9893
 256104206 ----sw-v   1000   100   \_ logon: cifs:a:192.168.1.3

(That is for another user, the extra keys are for ecryptfs).

Later on I will try to run startx from console as well to see if GDM is=
 the =20
suspect.

Milan
