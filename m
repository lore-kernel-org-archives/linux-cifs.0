From: Milan =?UTF-8?Q?Kn=C3=AD=C5=BEek?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session
 keyring problems
Date: Wed, 08 Aug 2012 19:45:33 +0200
Message-ID: <1344447933.32720.3.camel@athlon.garagome>
References: <30167.1342557999@warthog.procyon.org.uk>
	 <1342704916-2224-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342704916-2224-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton p=C3=AD=C5=A1e v =C4=8Ct 19. 07. 2012 v 09:35 -0400:
> Many distros do not call into pam_keyinit to set up the session keyri=
ng
> properly at login time. When cifscreds add is used in such a session,
> the kernel will spawn a new session keyring in which to install the
> credentials. That keyring will then go away once the cifscreds proces=
s
> exits.

How does one arrange that the session keyring is set up properly for
various login methods?

I added "session optional pam_keyinit.so force revoke"
into /etc/pam.d/login and /etc/pam.d/sshd and "cifscreds add" works fin=
e
when logged in console (alt+f2) or via ssh.
Session Keyring
 812231719 --alswrv   1001   100  keyring: _ses
 132272983 --alswrv   1001    -1   \_ keyring: _uid.1001
1046511393 ----sw-v   1001   100   \_ logon: cifs:a:192.168.1.3


pam_keyinit.so was already in /etc/pam.d/gdm-password, though when
logged in into Xfce from GDM, then "cifscreds add" typed in
xfce4-terminal complains about non-persistent keyring.

I can see that the name of the top level keyring differs for Xfce sessi=
on:
Session Keyring
 666176370 --alswrv   1001    -1  keyring: _uid_ses.1001
 132272983 --alswrv   1001    -1   \_ keyring: _uid.1001

Does anyone know if that is some GDM bug/feature and how avoid it?

Sorry if being off-topic here, though I guess it might help others who
will run into the problems with cifscreds, too.

Regards,
Milan
