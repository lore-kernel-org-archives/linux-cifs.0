From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session keyring problems
Date: Fri, 20 Jul 2012 15:19:59 +0100
Message-ID: <3498.1342793999@warthog.procyon.org.uk>
References: <1342704916-2224-1-git-send-email-jlayton@samba.org> <30167.1342557999@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342704916-2224-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Many distros do not call into pam_keyinit to set up the session keyri=
ng
> properly at login time. When cifscreds add is used in such a session,
> the kernel will spawn a new session keyring in which to install the
> credentials. That keyring will then go away once the cifscreds proces=
s
> exits.
>=20
> Check for this situation by looking to see if the session and
> user-session keyrings are the same. Throw a warning if so, and add so=
me
> verbiage to the cifscreds manpage that explains the issue. Also, if
> the session keyring can't be queried for any reason, then cause the
> program to error out.
>=20
> Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
