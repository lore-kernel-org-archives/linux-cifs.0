From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 11/15] cifs: fix cifs_show_options to show "username="
 or "multiuser"
Date: Tue, 5 Oct 2010 18:19:58 -0400
Message-ID: <20101005181958.065772d5@tlielax.poochiereds.net>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-12-git-send-email-jlayton@redhat.com>
	<AANLkTikafmJ14vib9-0SPZ6AaTmjpeps7VGzd5SSgoni@mail.gmail.com>
	<AANLkTimkxBpNLN+pAXaKsXf5dPy19LFeszjadCyjCeGH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimkxBpNLN+pAXaKsXf5dPy19LFeszjadCyjCeGH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Oct 2010 17:01:18 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> In reviewing this patch which changes the show_options on cifs mounts
> to not display the network username (when multiuser mount flag is
> turned on) ie not display the username sent on SMB SessionSetup.
>=20
> 1) Would there be value in showing the network (cifs) username that i=
s
> associated with the uid (fsuid) of this process?  (Presumably the
> username we send in cifs sessionsetup could be slightly different tha=
n
> the local username for this unix uid).
>=20

That'll make the output of /proc/mounts differ depending on "current".
Also, consider the case where random local user cats /proc/mounts (a
lot of scripts do that). Now we have to go find the tlink for him so we
can get to the session, which might mean an upcall to userspace to try
and establish one, several round trips to the server, etc. That seems
like a bad idea to me.

There might be value in getting at that info eventually but...

1) with krb5 it's absolutely worthless since we generally manufacture a
username based on the fsuid for multiuser mounts.

2) /proc/mounts is probably the wrong interface for such a thing.
When/if we are able to make multiuser mounts using non-krb5 auth, then
the user should be able to get at that info via the keyring...

> 2) In the future can't the domain name differ as well (so should we
> special case the domain name - or perhaps showing the default domain
> is fine?)
>=20

Maybe. But for now there aren't multiple domains per mount. I think we
ought to keep this as simple as possible. We can always change that
later if the need arises.

> On Tue, Oct 5, 2010 at 4:59 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> > In reviewing this patch which changes the show_options on cifs moun=
ts to not
> > display the network username (when multiuser mount flag is turned o=
n) ie not
> > display the username sent on SMB SessionSetup.
> >
> > 1) Would there be value in showing the network (cifs) username that=
 is
> > associated with the uid (fsuid) of this process?=A0 (Presumably the=
 username
> > we send in cifs sessionsetup could be slightly different than the l=
ocal
> > username for this unix uid).
> >
> > 2) In the future can't the domain name differ as well (so should we=
 special
> > case the domain name - or perhaps showing the default domain is fin=
e?)
> >
> > On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >>
> >> ...based on CIFS_MOUNT_MULTIUSER flag.
> >>
> >> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsfs.c | =A0 =A06 +++++-
> >> =A01 files changed, 5 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 2b897e3..51090cec 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -371,8 +371,12 @@ cifs_show_options(struct seq_file *s, struct =
vfsmount
> >> *m)
> >> =A0 =A0 =A0 =A0srcaddr =3D (struct sockaddr *)&tcon->ses->server->=
srcaddr;
> >>
> >> =A0 =A0 =A0 =A0seq_printf(s, ",unc=3D%s", tcon->treeName);
> >> - =A0 =A0 =A0 if (tcon->ses->userName)
> >> +
> >> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",multiuser");
> >> + =A0 =A0 =A0 else if (tcon->ses->userName)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",username=3D%s", tco=
n->ses->userName);
> >> +
> >> =A0 =A0 =A0 =A0if (tcon->ses->domainName)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",domain=3D%s", tcon-=
>ses->domainName);
> >>
> >> --
> >> 1.7.2.3
> >>
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
