From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] keys: add a "secret" key type
Date: Tue, 17 Jan 2012 12:59:56 -0600
Message-ID: <CAH2r5muKHFY1AEL1CM82xfZJAdzVhhD1+CkPo2Nz1Q4QmxtvWA@mail.gmail.com>
References: <1325878247-12030-1-git-send-email-jlayton@redhat.com>
	<1325878247-12030-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325878247-12030-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This looks fine and plan to merge via the cifs git tree, unless
anyone has last minute objections.

On Fri, Jan 6, 2012 at 1:30 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> For CIFS, we want to be able to store NTLM credentials (aka username
> and password) in the keyring. We do not, however want to allow users
> to fetch those keys back out of the keyring since that would be a
> security risk.
>
> Unfortunately, due to the nuances of key permission bits, it's not
> possible to do this. We need to grant search permissions so the kerne=
l
> can find these keys, but that also implies permissions to read the
> payload.
>
> Resolve this by adding a new key_type. This key type is essentially
> the same as key_type_user, but does not define a .read op. This
> prevents the payload from ever being visible from userspace.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0include/keys/user-type.h =A0 =A0 | =A0 =A03 ++-
> =A0security/keys/internal.h =A0 =A0 | =A0 =A01 +
> =A0security/keys/key.c =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0security/keys/user_defined.c | =A0 17 +++++++++++++++++
> =A04 files changed, 21 insertions(+), 1 deletions(-)
>
> diff --git a/include/keys/user-type.h b/include/keys/user-type.h
> index c37c342..41b5515 100644
> --- a/include/keys/user-type.h
> +++ b/include/keys/user-type.h
> @@ -17,7 +17,7 @@
>
> =A0/*****************************************************************=
************/
> =A0/*
> - * the payload for a key of type "user"
> + * the payload for a key of type "user" or "secret"
> =A0* - once filled in and attached to a key:
> =A0* =A0 - the payload struct is invariant may not be changed, only r=
eplaced
> =A0* =A0 - the payload must be read with RCU procedures or with the k=
ey semaphore
> @@ -33,6 +33,7 @@ struct user_key_payload {
> =A0};
>
> =A0extern struct key_type key_type_user;
> +extern struct key_type key_type_secret;
>
> =A0extern int user_instantiate(struct key *key, const void *data, siz=
e_t datalen);
> =A0extern int user_update(struct key *key, const void *data, size_t d=
atalen);
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index c7a7cae..2784e07 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -33,6 +33,7 @@
>
> =A0extern struct key_type key_type_dead;
> =A0extern struct key_type key_type_user;
> +extern struct key_type key_type_secret;
>
> =A0/*****************************************************************=
************/
> =A0/*
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 4414abd..3d1d79d 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -996,6 +996,7 @@ void __init key_init(void)
> =A0 =A0 =A0 =A0list_add_tail(&key_type_keyring.link, &key_types_list)=
;
> =A0 =A0 =A0 =A0list_add_tail(&key_type_dead.link, &key_types_list);
> =A0 =A0 =A0 =A0list_add_tail(&key_type_user.link, &key_types_list);
> + =A0 =A0 =A0 list_add_tail(&key_type_secret.link, &key_types_list);
>
> =A0 =A0 =A0 =A0/* record the root user tracking */
> =A0 =A0 =A0 =A0rb_link_node(&root_key_user.node,
> diff --git a/security/keys/user_defined.c b/security/keys/user_define=
d.c
> index 69ff52c..e25782f 100644
> --- a/security/keys/user_defined.c
> +++ b/security/keys/user_defined.c
> @@ -36,6 +36,23 @@ struct key_type key_type_user =3D {
> =A0EXPORT_SYMBOL_GPL(key_type_user);
>
> =A0/*
> + * This key type is essentially the same as key_type_user, but it do=
es
> + * not define a .read op. This is suitable for storing information i=
n
> + * the keyring that you do not want to be readable from userspace. F=
or
> + * instance, passwords or secret encryption keys.
> + */
> +struct key_type key_type_secret =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "secret",
> + =A0 =A0 =A0 .instantiate =A0 =A0=3D user_instantiate,
> + =A0 =A0 =A0 .update =A0 =A0 =A0 =A0 =3D user_update,
> + =A0 =A0 =A0 .match =A0 =A0 =A0 =A0 =A0=3D user_match,
> + =A0 =A0 =A0 .revoke =A0 =A0 =A0 =A0 =3D user_revoke,
> + =A0 =A0 =A0 .destroy =A0 =A0 =A0 =A0=3D user_destroy,
> + =A0 =A0 =A0 .describe =A0 =A0 =A0 =3D user_describe,
> +};
> +EXPORT_SYMBOL_GPL(key_type_secret);
> +
> +/*
> =A0* instantiate a user defined key
> =A0*/
> =A0int user_instantiate(struct key *key, const void *data, size_t dat=
alen)
> --
> 1.7.7.4
>



--=20
Thanks,

Steve
