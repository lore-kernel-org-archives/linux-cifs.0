From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: allow multiuser mounts with authtypes besides
 krb5
Date: Fri, 6 Jan 2012 12:49:17 -0500
Message-ID: <20120106124917.567489ba@tlielax.poochiereds.net>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
	<CADT32eJ2cW1wvQG2NpkEqQ5ZwDAHByUv9p-ZsG+NjVtsxEF8zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJ2cW1wvQG2NpkEqQ5ZwDAHByUv9p-ZsG+NjVtsxEF8zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 6 Jan 2012 11:21:44 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jan 6, 2012 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > When the multiuser mount code was initially introduced for cifs, I
> > limited it to sec=3Dkrb5 auth. When a new user walks into a mount, =
we have
> > no way to prompt for a username and password from the kernel, so th=
e
> > only auth type we could support was krb5.
> >
> > This patchset extends the code to allow other auth types to use
> > multiuser mounts. The idea here is for users to put their username =
and
> > password for a particular server or domain into the keyring. The ke=
rnel
>=20
> Would users be able to put their username for a particular domain nam=
e
> and server address as well as server name?
> Was not clear from the description whether it was just the server add=
ress
> or name as well!
>=20

You can add keys a particular host or NT domain name. If it's a host
key, then the userspace tool will add a key for each address that it
resolves for the hostname. For a domain key, it's treated as a string
literal and the kernel will use the domain=3D mount option to construct
the key description.

> > can then look for that key and use those credentials to establish a
> > session on the user's behalf.
> >
> > Because of the quirkiness of keyring permissions, this patchset add=
s a
> > new key type that does not allow the keys to be read from userspace=
=2E
> > That should prevent compromise of the credentials by someone walkin=
g up
> > to the user's machine while she is away at lunch.
> >
> > The userspace tool to stash keys in the keyring is already in
> > cifs-utils, but the current form will not work with this version of=
 the
> > kernel patchset. A patchset that updates the tool to be suitable fo=
r
> > this purpose will follow.
> >
> > Jeff Layton (3):
> > =C2=A0keys: add a "secret" key type
> > =C2=A0cifs: sanitize username handling
> > =C2=A0cifs: fetch credentials out of keyring for non-krb5 auth mult=
iuser
> > =C2=A0 =C2=A0mounts
> >
> > =C2=A0fs/cifs/cifs_spnego.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 10 =
++-
> > =C2=A0fs/cifs/cifsencrypt.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 11 =
++-
> > =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =
=C2=A0195 ++++++++++++++++++++++++++++++++++++++----
> > =C2=A0include/keys/user-type.h =C2=A0 =C2=A0 | =C2=A0 =C2=A03 +-
> > =C2=A0security/keys/internal.h =C2=A0 =C2=A0 | =C2=A0 =C2=A01 +
> > =C2=A0security/keys/key.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0=
 =C2=A01 +
> > =C2=A0security/keys/user_defined.c | =C2=A0 17 ++++
> > =C2=A07 files changed, 214 insertions(+), 24 deletions(-)
> >
> > --
> > 1.7.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
