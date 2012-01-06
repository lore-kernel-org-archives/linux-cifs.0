From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs: allow multiuser mounts with authtypes besides krb5
Date: Fri, 6 Jan 2012 11:21:44 -0600
Message-ID: <CADT32eJ2cW1wvQG2NpkEqQ5ZwDAHByUv9p-ZsG+NjVtsxEF8zg@mail.gmail.com>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325855483-8846-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 6, 2012 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> When the multiuser mount code was initially introduced for cifs, I
> limited it to sec=3Dkrb5 auth. When a new user walks into a mount, we=
 have
> no way to prompt for a username and password from the kernel, so the
> only auth type we could support was krb5.
>
> This patchset extends the code to allow other auth types to use
> multiuser mounts. The idea here is for users to put their username an=
d
> password for a particular server or domain into the keyring. The kern=
el

Would users be able to put their username for a particular domain name
and server address as well as server name?
Was not clear from the description whether it was just the server addre=
ss
or name as well!

> can then look for that key and use those credentials to establish a
> session on the user's behalf.
>
> Because of the quirkiness of keyring permissions, this patchset adds =
a
> new key type that does not allow the keys to be read from userspace.
> That should prevent compromise of the credentials by someone walking =
up
> to the user's machine while she is away at lunch.
>
> The userspace tool to stash keys in the keyring is already in
> cifs-utils, but the current form will not work with this version of t=
he
> kernel patchset. A patchset that updates the tool to be suitable for
> this purpose will follow.
>
> Jeff Layton (3):
> =A0keys: add a "secret" key type
> =A0cifs: sanitize username handling
> =A0cifs: fetch credentials out of keyring for non-krb5 auth multiuser
> =A0 =A0mounts
>
> =A0fs/cifs/cifs_spnego.c =A0 =A0 =A0 =A0| =A0 10 ++-
> =A0fs/cifs/cifsencrypt.c =A0 =A0 =A0 =A0| =A0 11 ++-
> =A0fs/cifs/connect.c =A0 =A0 =A0 =A0 =A0 =A0| =A0195 ++++++++++++++++=
++++++++++++++++++++++----
> =A0include/keys/user-type.h =A0 =A0 | =A0 =A03 +-
> =A0security/keys/internal.h =A0 =A0 | =A0 =A01 +
> =A0security/keys/key.c =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0security/keys/user_defined.c | =A0 17 ++++
> =A07 files changed, 214 insertions(+), 24 deletions(-)
>
> --
> 1.7.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
