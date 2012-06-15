From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove extraneous newlines from cERROR and cFYI calls
Date: Fri, 15 Jun 2012 09:20:25 -0500
Message-ID: <CAH2r5mvpvr=VMnN+RVXnXuhBWF90RrdFP31WoL=PA5f=z6LveQ@mail.gmail.com>
References: <1339764822-24528-1-git-send-email-jlayton@redhat.com>
	<1339764822-24528-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339764822-24528-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These look fine.

On Fri, Jun 15, 2012 at 7:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Those macros add a newline on their own, so there's not any need to
> embed one in the message itself.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cache.c =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/cifs/cifsacl.c =A0 =A0 | =A0 =A06 +++---
> =A0fs/cifs/cifsencrypt.c | =A0 48 ++++++++++++++++++++++++-----------=
-------------
> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 10 +++++-----
> =A0fs/cifs/connect.c =A0 =A0 | =A0 14 +++++++-------
> =A0fs/cifs/file.c =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/link.c =A0 =A0 =A0 =A0| =A0 14 +++++++-------
> =A0fs/cifs/smbencrypt.c =A0| =A0 14 +++++++-------
> =A08 files changed, 55 insertions(+), 55 deletions(-)
>
> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
> index 545509c..282d6de 100644
> --- a/fs/cifs/cache.c
> +++ b/fs/cifs/cache.c
> @@ -152,7 +152,7 @@ static uint16_t cifs_super_get_key(const void *co=
okie_netfs_data, void *buffer,
>
> =A0 =A0 =A0 =A0sharename =3D extract_sharename(tcon->treeName);
> =A0 =A0 =A0 =A0if (IS_ERR(sharename)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: couldn't extract sharename=
\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: couldn't extract sharename=
", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sharename =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 3cc1b25..1885da4 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -525,7 +525,7 @@ init_cifs_idmap(void)
> =A0 =A0 =A0 =A0struct key *keyring;
> =A0 =A0 =A0 =A0int ret;
>
> - =A0 =A0 =A0 cFYI(1, "Registering the %s key type\n", cifs_idmap_key=
_type.name);
> + =A0 =A0 =A0 cFYI(1, "Registering the %s key type", cifs_idmap_key_t=
ype.name);
>
> =A0 =A0 =A0 =A0/* create an override credential set with a special th=
read keyring in
> =A0 =A0 =A0 =A0 * which requests are cached
> @@ -572,7 +572,7 @@ init_cifs_idmap(void)
> =A0 =A0 =A0 =A0sidgidtree =3D RB_ROOT;
> =A0 =A0 =A0 =A0register_shrinker(&cifs_shrinker);
>
> - =A0 =A0 =A0 cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring)=
);
> + =A0 =A0 =A0 cFYI(1, "cifs idmap keyring: %d", key_serial(keyring));
> =A0 =A0 =A0 =A0return 0;
>
> =A0failed_put_key:
> @@ -589,7 +589,7 @@ exit_cifs_idmap(void)
> =A0 =A0 =A0 =A0unregister_key_type(&cifs_idmap_key_type);
> =A0 =A0 =A0 =A0put_cred(root_cred);
> =A0 =A0 =A0 =A0unregister_shrinker(&cifs_shrinker);
> - =A0 =A0 =A0 cFYI(1, "Unregistered %s key type\n", cifs_idmap_key_ty=
pe.name);
> + =A0 =A0 =A0 cFYI(1, "Unregistered %s key type", cifs_idmap_key_type=
=2Ename);
> =A0}
>
> =A0void
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 63c460e..db768cb 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -47,20 +47,20 @@ static int cifs_calc_signature(const struct kvec =
*iov, int n_vec,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0if (!server->secmech.sdescmd5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't generate signature=
\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't generate signature=
", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_init(&server->secmech.sdescmd5->sh=
ash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5\n", _=
_func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5", __f=
unc__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_update(&server->secmech.sdescmd5->=
shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->session_key.response, server->=
session_key.len);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -85,7 +85,7 @@ static int cifs_calc_signature(const struct kvec *i=
ov, int n_vec,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[i]=
=2Eiov_base, iov[i].iov_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with payload\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with payload",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -93,7 +93,7 @@ static int cifs_calc_signature(const struct kvec *i=
ov, int n_vec,
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&server->secmech.sdescmd5->s=
hash, signature);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash", __func__);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -399,7 +399,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0wchar_t *server;
>
> =A0 =A0 =A0 =A0if (!ses->server->secmech.sdeschmacmd5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't gene=
rate ntlmv2 hash\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't gene=
rate ntlmv2 hash");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> @@ -415,7 +415,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_init(&ses->server->secmech.sdeschm=
acmd5->shash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: could not =
init hmacmd5\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: could not =
init hmacmd5");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -423,7 +423,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0len =3D ses->user_name ? strlen(ses->user_name) : 0;
> =A0 =A0 =A0 =A0user =3D kmalloc(2 + (len * 2), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (user =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: user mem a=
lloc failure\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: user mem a=
lloc failure");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char =
*)user, 2 * len);
> =A0 =A0 =A0 =A0kfree(user);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with us=
er\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with us=
er", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -460,7 +460,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(char *)domain, 2 * len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(domain);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with domain\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with domain",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -480,7 +480,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(char *)server, 2 * len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with server\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could no=
t update with server",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -489,7 +489,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,=
 char *ntlmv2_hash,
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&ses->server->secmech.sdesch=
macmd5->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0ntlmv2_hash);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash", __func__);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -501,7 +501,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, c=
har *ntlmv2_hash)
> =A0 =A0 =A0 =A0unsigned int offset =3D CIFS_SESS_KEY_SIZE + 8;
>
> =A0 =A0 =A0 =A0if (!ses->server->secmech.sdeschmacmd5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't gene=
rate ntlmv2 hash\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't gene=
rate ntlmv2 hash");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> @@ -527,14 +527,14 @@ CalcNTLMv2_response(const struct cifs_ses *ses,=
 char *ntlmv2_hash)
> =A0 =A0 =A0 =A0rc =3D crypto_shash_update(&ses->server->secmech.sdesc=
hmacmd5->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response + offset, ses->=
auth_key.len - offset);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&ses->server->secmech.sdesch=
macmd5->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response + CIFS_SESS_KEY=
_SIZE);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash", __func__);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -613,7 +613,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const stru=
ct nls_table *nls_cp)
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_init(&ses->server->secmech.sdeschm=
acmd5->shash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init hmacmd5\n=
", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init hmacmd5",=
 __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto setup_ntlmv2_rsp_ret;
> =A0 =A0 =A0 =A0}
>
> @@ -621,14 +621,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const st=
ruct nls_table *nls_cp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response + CIFS_SESS_KEY=
_SIZE,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_HMAC_MD5_HASH_SIZE);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with re=
sponse", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto setup_ntlmv2_rsp_ret;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&ses->server->secmech.sdesch=
macmd5->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash", __func__);
>
> =A0setup_ntlmv2_rsp_ret:
> =A0 =A0 =A0 =A0kfree(tiblob);
> @@ -650,7 +650,7 @@ calc_seckey(struct cifs_ses *ses)
> =A0 =A0 =A0 =A0tfm_arc4 =3D crypto_alloc_blkcipher("ecb(arc4)", 0, CR=
YPTO_ALG_ASYNC);
> =A0 =A0 =A0 =A0if (IS_ERR(tfm_arc4)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(tfm_arc4);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto AP=
I arc4\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto AP=
I arc4");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -668,7 +668,7 @@ calc_seckey(struct cifs_ses *ses)
>
> =A0 =A0 =A0 =A0rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, =
CIFS_CPHTXT_SIZE);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt session ke=
y rc: %d\n", rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt session ke=
y rc: %d", rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_free_blkcipher(tfm_arc4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -705,13 +705,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_In=
fo *server)
>
> =A0 =A0 =A0 =A0server->secmech.hmacmd5 =3D crypto_alloc_shash("hmac(m=
d5)", 0, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(server->secmech.hmacmd5)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto hm=
acmd5\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto hm=
acmd5");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return PTR_ERR(server->secmech.hmacmd5=
);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0server->secmech.md5 =3D crypto_alloc_shash("md5", 0, 0=
);
> =A0 =A0 =A0 =A0if (IS_ERR(server->secmech.md5)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto md=
5\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto md=
5");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(server->secmech.md5);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto crypto_allocate_md5_fail;
> =A0 =A0 =A0 =A0}
> @@ -720,7 +720,7 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info=
 *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_shash_descsize(=
server->secmech.hmacmd5);
> =A0 =A0 =A0 =A0server->secmech.sdeschmacmd5 =3D kmalloc(size, GFP_KER=
NEL);
> =A0 =A0 =A0 =A0if (!server->secmech.sdeschmacmd5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: =
can't alloc hmacmd5\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: =
can't alloc hmacmd5");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto crypto_allocate_hmacmd5_sdesc_fai=
l;
> =A0 =A0 =A0 =A0}
> @@ -732,7 +732,7 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info=
 *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_shash_descsize(=
server->secmech.md5);
> =A0 =A0 =A0 =A0server->secmech.sdescmd5 =3D kmalloc(size, GFP_KERNEL)=
;
> =A0 =A0 =A0 =A0if (!server->secmech.sdescmd5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: =
can't alloc md5\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: =
can't alloc md5");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto crypto_allocate_md5_sdesc_fail;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 5b40073..0170ee8 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4109,7 +4109,7 @@ UnixQFileInfoRetry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || get_bcc(&pSMBr->hdr) < sizeo=
f(FILE_UNIX_BASIC_INFO)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Malformed FI=
LE_UNIX_BASIC_INFO response.\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Malformed FI=
LE_UNIX_BASIC_INFO response. "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Unix Extensions can be disabled on mount "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
by specifying the nosfu mount option.");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> @@ -4195,7 +4195,7 @@ UnixQPathInfoRetry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || get_bcc(&pSMBr->hdr) < sizeo=
f(FILE_UNIX_BASIC_INFO)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Malformed FI=
LE_UNIX_BASIC_INFO response.\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Malformed FI=
LE_UNIX_BASIC_INFO response. "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Unix Extensions can be disabled on mount "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
by specifying the nosfu mount option.");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> @@ -4647,7 +4647,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_=
RSP *pSMBr,
>
> =A0 =A0 =A0 =A0if (*num_of_nodes < 1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "num_referrals: must be at l=
east > 0,"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "but we get num_referra=
ls =3D %d\n", *num_of_nodes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "but we get num_referra=
ls =3D %d", *num_of_nodes);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto parse_DFS_referrals_exit;
> =A0 =A0 =A0 =A0}
> @@ -4664,14 +4664,14 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFE=
R_RSP *pSMBr,
> =A0 =A0 =A0 =A0data_end =3D (char *)(&(pSMBr->PathConsumed)) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(pSMBr->t2.DataCount);
>
> - =A0 =A0 =A0 cFYI(1, "num_referrals: %d dfs flags: 0x%x ...\n",
> + =A0 =A0 =A0 cFYI(1, "num_referrals: %d dfs flags: 0x%x ...",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*num_of_nodes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_to_cpu(pSMBr->DFS=
=46lags));
>
> =A0 =A0 =A0 =A0*target_nodes =3D kzalloc(sizeof(struct dfs_info3_para=
m) *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*num_of_nodes, GFP_KER=
NEL);
> =A0 =A0 =A0 =A0if (*target_nodes =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Failed to allocate buffer fo=
r target_nodes\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Failed to allocate buffer fo=
r target_nodes");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto parse_DFS_referrals_exit;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 78db68a..de281d0 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2410,7 +2410,7 @@ cifs_put_smb_ses(struct cifs_ses *ses)
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server =3D ses->server;
>
> - =A0 =A0 =A0 cFYI(1, "%s: ses_count=3D%d\n", __func__, ses->ses_coun=
t);
> + =A0 =A0 =A0 cFYI(1, "%s: ses_count=3D%d", __func__, ses->ses_count)=
;
> =A0 =A0 =A0 =A0spin_lock(&cifs_tcp_ses_lock);
> =A0 =A0 =A0 =A0if (--ses->ses_count > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> @@ -2698,7 +2698,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0struct cifs_ses *ses =3D tcon->ses;
>
> - =A0 =A0 =A0 cFYI(1, "%s: tc_count=3D%d\n", __func__, tcon->tc_count=
);
> + =A0 =A0 =A0 cFYI(1, "%s: tc_count=3D%d", __func__, tcon->tc_count);
> =A0 =A0 =A0 =A0spin_lock(&cifs_tcp_ses_lock);
> =A0 =A0 =A0 =A0if (--tcon->tc_count > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> @@ -3007,11 +3007,11 @@ bind_socket(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0saddr6 =3D (struct soc=
kaddr_in6 *)&server->srcaddr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (saddr6->sin6_famil=
y =3D=3D AF_INET6)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "cifs: "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI6c, error: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI6c, error: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &saddr6->sin6_addr, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "cifs: "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI4, error: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI4, error: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &saddr4->sin_addr.s_addr, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> @@ -3302,9 +3302,9 @@ void reset_cifs_unix_caps(int xid, struct cifs_=
tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1=
, "resetting capabilities failed");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "Negotiating Unix capabilities "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"with the server failed. =A0Consider "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"mounting with the Unix Extensions\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"disabled, if problems are found, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"with the server failed. Consider "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"mounting with the Unix Extensions "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"disabled if problems are found "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "by specifying the nounix mount "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "option.");
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 513adbc..dd28caa 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3169,7 +3169,7 @@ static int cifs_readpage(struct file *file, str=
uct page *page)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 cFYI(1, "readpage %p at offset %d 0x%x\n",
> + =A0 =A0 =A0 cFYI(1, "readpage %p at offset %d 0x%x",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page, (int)offset, (int)offset);
>
> =A0 =A0 =A0 =A0rc =3D cifs_readpage_worker(file, page, &offset);
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 6b0e064..90d8add 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -56,14 +56,14 @@ symlink_hash(unsigned int link_len, const char *l=
ink_str, u8 *md5_hash)
> =A0 =A0 =A0 =A0md5 =3D crypto_alloc_shash("md5", 0, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(md5)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(md5);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Crypto md5 allocation er=
ror %d\n", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Crypto md5 allocation er=
ror %d", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) + crypto_shash_desc=
size(md5);
> =A0 =A0 =A0 =A0sdescmd5 =3D kmalloc(size, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!sdescmd5) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Memory allocation failur=
e\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Memory allocation failur=
e", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto symlink_hash_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0sdescmd5->shash.tfm =3D md5;
> @@ -71,17 +71,17 @@ symlink_hash(unsigned int link_len, const char *l=
ink_str, u8 *md5_hash)
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_init(&sdescmd5->shash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5 shash=
\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5 shash=
", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto symlink_hash_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D crypto_shash_update(&sdescmd5->shash, link_str,=
 link_len);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update iwth li=
nk_str\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update iwth li=
nk_str", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto symlink_hash_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&sdescmd5->shash, md5_hash);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate md5 h=
ash", __func__);
>
> =A0symlink_hash_err:
> =A0 =A0 =A0 =A0crypto_free_shash(md5);
> @@ -115,7 +115,7 @@ CIFSParseMFSymlink(const u8 *buf,
>
> =A0 =A0 =A0 =A0rc =3D symlink_hash(link_len, link_str, md5_hash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: MD5 hash failure: %d\n", _=
_func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: MD5 hash failure: %d", __f=
unc__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -154,7 +154,7 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len=
, const char *link_str)
>
> =A0 =A0 =A0 =A0rc =3D symlink_hash(link_len, link_str, md5_hash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: MD5 hash failure: %d\n", _=
_func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: MD5 hash failure: %d", __f=
unc__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index d5cd9aa..a0a58fb 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -78,7 +78,7 @@ smbhash(unsigned char *out, const unsigned char *in=
, unsigned char *key)
> =A0 =A0 =A0 =A0tfm_des =3D crypto_alloc_blkcipher("ecb(des)", 0, CRYP=
TO_ALG_ASYNC);
> =A0 =A0 =A0 =A0if (IS_ERR(tfm_des)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(tfm_des);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate des crypt=
o API\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate des crypt=
o API");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto smbhash_err;
> =A0 =A0 =A0 =A0}
>
> @@ -91,7 +91,7 @@ smbhash(unsigned char *out, const unsigned char *in=
, unsigned char *key)
>
> =A0 =A0 =A0 =A0rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, =
8);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt crypt key =
rc: %d\n", rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt crypt key =
rc: %d", rc);
>
> =A0 =A0 =A0 =A0crypto_free_blkcipher(tfm_des);
> =A0smbhash_err:
> @@ -139,14 +139,14 @@ mdfour(unsigned char *md4_hash, unsigned char *=
link_str, int link_len)
> =A0 =A0 =A0 =A0md4 =3D crypto_alloc_shash("md4", 0, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(md4)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(md4);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Crypto md4 allocation er=
ror %d\n", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Crypto md4 allocation er=
ror %d", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) + crypto_shash_desc=
size(md4);
> =A0 =A0 =A0 =A0sdescmd4 =3D kmalloc(size, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!sdescmd4) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Memory allocation failur=
e\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Memory allocation failur=
e", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mdfour_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0sdescmd4->shash.tfm =3D md4;
> @@ -154,17 +154,17 @@ mdfour(unsigned char *md4_hash, unsigned char *=
link_str, int link_len)
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_init(&sdescmd4->shash);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md4 shash=
\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md4 shash=
", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mdfour_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D crypto_shash_update(&sdescmd4->shash, link_str,=
 link_len);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with li=
nk_str\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with li=
nk_str", __func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mdfour_err;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&sdescmd4->shash, md4_hash);
> =A0 =A0 =A0 =A0if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not genereate md4 =
hash\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not genereate md4 =
hash", __func__);
>
> =A0mdfour_err:
> =A0 =A0 =A0 =A0crypto_free_shash(md4);
> --
> 1.7.7.6
>



--=20
Thanks,

Steve
