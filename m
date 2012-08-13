From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifscreds: add a check and warnings for session keyring problems
Date: Mon, 13 Aug 2012 22:21:52 +0100
Message-ID: <6113.1344892912@warthog.procyon.org.uk>
References: <1344447933.32720.3.camel@athlon.garagome> <30167.1342557999@warthog.procyon.org.uk> <1342704916-2224-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Milan
	 =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FKn=3DC3=3DAD=3DC5=3DBEek=3F=3D?=
	<knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344447933.32720.3.camel-77nuZImz6nKt3pJmeLR6bw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> How does one arrange that the session keyring is set up properly for
> various login methods?

These are all the places I have it:

/etc/pam.d/fingerprint-auth	session optional pam_keyinit.so revoke
/etc/pam.d/fingerprint-auth-ac	session optional pam_keyinit.so revoke
/etc/pam.d/gdm-autologin	session optional pam_keyinit.so force revoke
/etc/pam.d/gdm-fingerprint	session optional pam_keyinit.so force revoke
/etc/pam.d/gdm-password		session optional pam_keyinit.so force revoke
/etc/pam.d/gdm-smartcard	session optional pam_keyinit.so force revoke
/etc/pam.d/gdm-welcome		session optional pam_keyinit.so force revoke
/etc/pam.d/kdm			session optional pam_keyinit.so force revoke
/etc/pam.d/kdm-np		session optional pam_keyinit.so force revoke
/etc/pam.d/login		session optional pam_keyinit.so force revoke
/etc/pam.d/password-auth	session optional pam_keyinit.so revoke
/etc/pam.d/password-auth-ac	session optional pam_keyinit.so revoke
/etc/pam.d/remote		session optional pam_keyinit.so force revoke
/etc/pam.d/runuser		session optional pam_keyinit.so revoke
/etc/pam.d/runuser-l		session optional pam_keyinit.so force revoke
/etc/pam.d/smartcard-auth	session optional pam_keyinit.so revoke
/etc/pam.d/smartcard-auth-ac	session optional pam_keyinit.so revoke
/etc/pam.d/sshd			session optional pam_keyinit.so force revoke
/etc/pam.d/sudo			session optional pam_keyinit.so revoke
/etc/pam.d/sudo-i		session optional pam_keyinit.so force revoke
/etc/pam.d/su-l			session optional pam_keyinit.so force revoke
/etc/pam.d/system-auth		session optional pam_keyinit.so revoke
/etc/pam.d/system-auth-ac	session optional pam_keyinit.so revoke
/etc/pam.d/vsftpd		session optional pam_keyinit.so force revoke
/etc/pam.d/xdm			session optional pam_keyinit.so force revoke
/etc/pam.d/xserver		session optional pam_keyinit.so force revoke

> pam_keyinit.so was already in /etc/pam.d/gdm-password, though when
> logged in into Xfce from GDM, then "cifscreds add" typed in
> xfce4-terminal complains about non-persistent keyring.

What name does gdm use when logging in?  I see five different names in =
the
list above.

David
