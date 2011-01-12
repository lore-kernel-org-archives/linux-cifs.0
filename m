From: "Q (Igor Mammedov)" <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] cifs.upcall: add keytab support for unattended mounts
Date: Wed, 12 Jan 2011 09:56:34 +0300
Message-ID: <AANLkTimxsXh5LgVD690=xjfiqgnELNMQObVUa5Yjkote@mail.gmail.com>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
	<1294409505-2999-6-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-6-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Igor Mammedov <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Jan 7, 2011 at 5:11 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Based on a patch from a few years ago by Igor Mammedov. This patch
> adds the ability for cifs.upcall to establish a TGT using the
> system-default keytab.
>
> Cc: Igor Mammedov <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =C2=A0cifs.upcall.c | =C2=A0 78 +++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++
> =C2=A01 files changed, 78 insertions(+), 0 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 3dbcd6e..479517c 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -54,6 +54,7 @@
>
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFS_DEFAULT_KRB5_DIR =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "/tmp"
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFS_DEFAULT_KRB5_PREFIX =C2=
=A0 =C2=A0 =C2=A0 =C2=A0"krb5cc_"
> +#define CIFS_DEFAULT_KRB5_KEYTAB =C2=A0 =C2=A0 =C2=A0 "/etc/krb5.key=
tab"
>
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0MAX_CCNAME_LEN =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PATH_MAX + 5
>
> @@ -185,6 +186,78 @@ static int krb5cc_filter(const struct dirent *di=
rent)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> +static char *
> +init_cc_from_keytab(const char *keytab_name, const char *user)
> +{
> + =C2=A0 =C2=A0 =C2=A0 krb5_context context =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 krb5_error_code ret;
> + =C2=A0 =C2=A0 =C2=A0 krb5_creds my_creds;
> + =C2=A0 =C2=A0 =C2=A0 krb5_keytab keytab =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 krb5_principal me =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 krb5_ccache cc =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 char *ccname =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 memset((char *) &my_creds, 0, sizeof(my_creds)=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_init_context(&context);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_init_context: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_kt_resolve(context, keytab_name, =
&keytab);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_kt_resolve: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_parse_name(context, user, &me);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_parse_name: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_get_init_creds_keytab(context, &m=
y_creds, me,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 keytab, 0, NULL, NULL);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_get_init_creds_keytab: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_cc_default(context, &cc);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_cc_default: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_cc_initialize(context, cc, me);
> + =C2=A0 =C2=A0 =C2=A0 if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_cc_initialize: %d", (int)ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto icfk_cleanup;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D krb5_cc_store_cred(context, cc, &my_cr=
eds);
> + =C2=A0 =C2=A0 =C2=A0 if (ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, =
"krb5_cc_store_cred: %d", (int)ret);
> +
> + =C2=A0 =C2=A0 =C2=A0 ccname =3D strdup(krb5_cc_default_name(context=
));
> + =C2=A0 =C2=A0 =C2=A0 if (ccname =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "U=
nable to allocate memory");
> +icfk_cleanup:
> + =C2=A0 =C2=A0 =C2=A0 my_creds.client =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 krb5_free_cred_contents(context, &my_creds);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (me)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 krb5_free_principa=
l(context, me);
> + =C2=A0 =C2=A0 =C2=A0 if (cc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 krb5_cc_close(cont=
ext, cc);
> + =C2=A0 =C2=A0 =C2=A0 if (keytab)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 krb5_kt_close(cont=
ext, keytab);
> + =C2=A0 =C2=A0 =C2=A0 if (context)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 krb5_free_context(=
context);
> + =C2=A0 =C2=A0 =C2=A0 return ccname;
> +}
> +
> =C2=A0/* search for a credcache that looks like a likely candidate */
> =C2=A0static char *find_krb5_cc(const char *dirname, uid_t uid)
> =C2=A0{
> @@ -702,6 +775,7 @@ int main(const int argc, char *const argv[])
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct decoded_args arg;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *oid;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uid_t uid;
> + =C2=A0 =C2=A0 =C2=A0 char *keytab_name =3D CIFS_DEFAULT_KRB5_KEYTAB=
;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0hostbuf[0] =3D '\0';
> =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&arg, 0, sizeof(arg));
> @@ -793,6 +867,10 @@ int main(const int argc, char *const argv[])
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_=
DIR, uid);
>
> + =C2=A0 =C2=A0 =C2=A0 /* Couldn't find credcache? Try to use keytab =
*/
> + =C2=A0 =C2=A0 =C2=A0 if (ccname =3D=3D NULL && arg.username !=3D NU=
LL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ccname =3D init_cc=
_from_keytab(keytab_name, arg.username);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0host =3D arg.hostname;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0// do mech specific authorization
> --
> 1.7.3.4
>
>
