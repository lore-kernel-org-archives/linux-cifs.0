From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] cifs: sanitize username handling
Date: Tue, 17 Jan 2012 22:41:30 -0600
Message-ID: <CAH2r5msmuYW3+XZXecpan7jkBngy2hZBGMjfy+5C3hsNcWsavQ@mail.gmail.com>
References: <1326836547-7011-1-git-send-email-jlayton@redhat.com>
	<1326836547-7011-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326836547-7011-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged your patch series, but fixed two of the four checkpatch
warnings (one in this patch and one in following one).

On Tue, Jan 17, 2012 at 3:42 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Currently, it's not very clear whether you're allowed to have a NULL
> vol->username or ses->user_name. Some places check for it and some do=
n't.
>
> Make it clear that a NULL pointer is OK in these fields, and ensure t=
hat
> all the callers check for that.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_spnego.c | =A0 10 +++++++---
> =A0fs/cifs/cifsencrypt.c | =A0 11 ++++++++---
> =A0fs/cifs/connect.c =A0 =A0 | =A0 19 ++++++++++++-------
> =A03 files changed, 27 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 2272fd5..e622863 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -113,9 +113,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_MECH_STR_LEN +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UID_KEY_LEN + (sizeof(uid_t) * 2)=
 +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CREDUID_KEY_LEN + (sizeof(uid_t) =
* 2) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0USER_KEY_LEN + strlen(sesInfo->u=
ser_name) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PID_KEY_LEN + (sizeof(pid_t) * 2)=
 + 1;
>
> + =A0 =A0 =A0 if (sesInfo->user_name)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc_len +=3D USER_KEY_LEN + strlen(ses=
Info->user_name);
> +
> =A0 =A0 =A0 =A0spnego_key =3D ERR_PTR(-ENOMEM);
> =A0 =A0 =A0 =A0description =3D kzalloc(desc_len, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (description =3D=3D NULL)
> @@ -152,8 +154,10 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
> =A0 =A0 =A0 =A0dp =3D description + strlen(description);
> =A0 =A0 =A0 =A0sprintf(dp, ";creduid=3D0x%x", sesInfo->cred_uid);
>
> - =A0 =A0 =A0 dp =3D description + strlen(description);
> - =A0 =A0 =A0 sprintf(dp, ";user=3D%s", sesInfo->user_name);
> + =A0 =A0 =A0 if (sesInfo->user_name) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp =3D description + strlen(description=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(dp, ";user=3D%s", sesInfo->user=
_name);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0dp =3D description + strlen(description);
> =A0 =A0 =A0 =A0sprintf(dp, ";pid=3D0x%x", current->pid);
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5d9b9ac..bce99e6 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -420,15 +420,20 @@ static int calc_ntlmv2_hash(struct cifs_ses *se=
s, char *ntlmv2_hash,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* convert ses->user_name to unicode and uppercase */
> - =A0 =A0 =A0 len =3D strlen(ses->user_name);
> + =A0 =A0 =A0 len =3D ses->user_name ? strlen(ses->user_name) : 0;
> =A0 =A0 =A0 =A0user =3D kmalloc(2 + (len * 2), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (user =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "calc_ntlmv2_hash: user mem =
alloc failure\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->user_name, l=
en, nls_cp);
> - =A0 =A0 =A0 UniStrupr(user);
> +
> + =A0 =A0 =A0 if (len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, s=
es->user_name, len, nls_cp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UniStrupr(user);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(user, '\0', 2);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_update(&ses->server->secmech.sdesc=
hmacmd5->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char =
*)user, 2 * len);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a66dcb5..b8f5024 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1997,10 +1997,16 @@ static int match_session(struct cifs_ses *ses=
, struct smb_vol *vol)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* NULL username means anonymous sessio=
n */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->user_name =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!vol->nullauth)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* anything else takes username/passwo=
rd */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->user_name =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ses->user_name, vol->userna=
me,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ses->user_name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->username ?=
 vol->username: "",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MAX_USERNAME_S=
IZE))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (strlen(vol->username) !=3D 0 &&
> @@ -3167,10 +3173,9 @@ cifs_setup_volume_info(struct smb_vol *volume_=
info, char *mount_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0if (volume_info->nullauth) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "null user");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_info->username =3D kzalloc(1, GF=
P_KERNEL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (volume_info->username =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Anonymous login");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(volume_info->username);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_info->username =3D NULL;
> =A0 =A0 =A0 =A0} else if (volume_info->username) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB fixme parse for domain name here=
 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Username: %s", volume_info->u=
sername);
> --
> 1.7.7.5
>



--=20
Thanks,

Steve
