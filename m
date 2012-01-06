From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: fetch credentials out of keyring for non-krb5
 auth multiuser mounts
Date: Fri, 6 Jan 2012 11:16:32 -0600
Message-ID: <CADT32eJfYjK1ny4ctqdD3id03pWiKJh9j-jNVH-iEao7L6YhEA@mail.gmail.com>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
	<1325855483-8846-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325855483-8846-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 6, 2012 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Fix up multiuser mounts to set the secType and set the username and
> password from the key payload in the vol info for non-krb5 auth types=
=2E
>
> Look for a key of type "secret" with a description of
> "cifs:a:<server address>" or "cifs:d:<domainname>". If that's found,
> then scrape the username and password out of the key payload and use
> that to create a new user session.
>
> Finally, don't have the code enforce krb5 auth on multiuser mounts,
> but do require a kernel with keys support.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0176 +++++++++++++++++++++++++++++++++++++++=
+++++++++++---
> =A01 files changed, 166 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5e96e60..48f2d15 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -38,6 +38,7 @@
> =A0#include <asm/processor.h>
> =A0#include <linux/inet.h>
> =A0#include <linux/module.h>
> +#include <keys/user-type.h>
> =A0#include <net/ipv6.h>
> =A0#include "cifspdu.h"
> =A0#include "cifsglob.h"
> @@ -1594,11 +1595,14 @@ cifs_parse_mount_options(const char *mountdat=
a, const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (vol->multiuser && !(vol->secFlg & CIFSSEC_MAY_KRB5)=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Multiuser mounts currently r=
equire krb5 "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "authentication!");
> +#ifndef CONFIG_KEYS
> + =A0 =A0 =A0 /* Muliuser mounts require CONFIG_KEYS support */
> + =A0 =A0 =A0 if (vol->multiuser) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Multiuser mounts require ker=
nels with "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "CONFIG_KEYS enable=
d.");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_parse_mount_err;
> =A0 =A0 =A0 =A0}
> +#endif

Will this break existing setups when those users update kernel
and/or update cifs module?

>
> =A0 =A0 =A0 =A0if (vol->UNCip =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->UNCip =3D &vol->UNC[2];
> @@ -2061,6 +2065,133 @@ cifs_put_smb_ses(struct cifs_ses *ses)
> =A0 =A0 =A0 =A0cifs_put_tcp_session(server);
> =A0}
>
> +#ifdef CONFIG_KEYS
> +
> +/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
> +#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
> +
> +/* Populate username and pw fields from keyring if possible */
> +static int
> +cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 char *desc, *delim, *payload;
> + =A0 =A0 =A0 ssize_t len;
> + =A0 =A0 =A0 struct key *key;
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D ses->server;
> + =A0 =A0 =A0 struct sockaddr_in *sa;
> + =A0 =A0 =A0 struct sockaddr_in6 *sa6;
> + =A0 =A0 =A0 struct user_key_payload *upayload;
> +
> + =A0 =A0 =A0 desc =3D kmalloc(CIFSCREDS_DESC_SIZE, GFP_KERNEL);
> + =A0 =A0 =A0 if (!desc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 /* try to find an address key first */
> + =A0 =A0 =A0 switch (server->dstaddr.ss_family) {
> + =A0 =A0 =A0 case AF_INET:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa =3D (struct sockaddr_in *)&server->d=
staddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(desc, "cifs:a:%pI4", &sa->sin_a=
ddr.s_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case AF_INET6:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sa6 =3D (struct sockaddr_in6 *)&server-=
>dstaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(desc, "cifs:a:%pI6c", &sa6->sin=
6_addr.s6_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad ss_family (%hu)", server->=
dstaddr.ss_family);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 cFYI(1, "%s: desc=3D%s", __func__, desc);
> + =A0 =A0 =A0 key =3D request_key(&key_type_secret, desc, "");
> + =A0 =A0 =A0 if (IS_ERR(key)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "domainName is =
NULL");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* didn't work, try to find a domain ke=
y */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(desc, "cifs:d:%s", ses->domainN=
ame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: desc=3D%s", __func__, desc=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key =3D request_key(&key_type_secret, d=
esc, "");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(key)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 down_read(&key->sem);
> + =A0 =A0 =A0 upayload =3D key->payload.data;
> + =A0 =A0 =A0 if (IS_ERR_OR_NULL(upayload)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* find first : in payload */
> + =A0 =A0 =A0 payload =3D (char *)upayload->data;
> + =A0 =A0 =A0 delim =3D strnchr(payload, upayload->datalen, ':');
> + =A0 =A0 =A0 cFYI(1, "payload=3D%s", payload);
> + =A0 =A0 =A0 if (!delim) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to find ':' in payload =
(datalen=3D%d)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 upayloa=
d->datalen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 len =3D delim - payload;
> + =A0 =A0 =A0 if (len > MAX_USERNAME_SIZE || len <=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad value from username search=
 (len=3D%ld)", len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 vol->username =3D kstrndup(payload, len, GFP_KERNEL);
> + =A0 =A0 =A0 if (!vol->username) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %ld bytes f=
or username", len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 cFYI(1, "username=3D%s", vol->username);
> +
> + =A0 =A0 =A0 len =3D key->datalen - (len + 1);
> + =A0 =A0 =A0 if (len > MAX_PASSWORD_SIZE || len <=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad len for password search (l=
en=3D%ld)", len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(vol->username);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->username =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ++delim;
> + =A0 =A0 =A0 vol->password =3D kstrndup(delim, len, GFP_KERNEL);
> + =A0 =A0 =A0 if (!vol->password) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to allocate %ld bytes f=
or password", len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(vol->username);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->username =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_key_put;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 cFYI(1, "password=3D%s", vol->password);

I would be wary of printing the password.

> +
> +out_key_put:
> + =A0 =A0 =A0 up_read(&key->sem);
> + =A0 =A0 =A0 key_put(key);
> +out_err:
> + =A0 =A0 =A0 kfree(desc);
> + =A0 =A0 =A0 cFYI(1, "%s: returning %d", __func__, rc);
> + =A0 =A0 =A0 return rc;
> +}
> +#else /* ! CONFIG_KEYS */
> +static inline int
> +cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_ses *ses __attribute=
__((unused)))
> +{
> + =A0 =A0 =A0 return -ENOSYS;
> +}
> +#endif /* CONFIG_KEYS */
> +
> =A0static bool warned_on_ntlm; =A0/* globals init to false automatica=
lly */
>
> =A0static struct cifs_ses *
> @@ -3678,16 +3809,38 @@ int cifs_setup_session(unsigned int xid, stru=
ct cifs_ses *ses,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static int
> +cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
> +{
> + =A0 =A0 =A0 switch(ses->server->secType) {
> + =A0 =A0 =A0 case Kerberos:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFlg =3D CIFSSEC_MUST_KRB5;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 case NTLMv2:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFlg =3D CIFSSEC_MUST_NTLMV2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case NTLM:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFlg =3D CIFSSEC_MUST_NTLM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case RawNTLMSSP:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFlg =3D CIFSSEC_MAY_NTLMSSP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case LANMAN:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->secFlg =3D CIFSSEC_MAY_LANMAN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return cifs_set_cifscreds(vol, ses);
> +}
> +
> =A0static struct cifs_tcon *
> =A0cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
> =A0{
> + =A0 =A0 =A0 int rc;
> =A0 =A0 =A0 =A0struct cifs_tcon *master_tcon =3D cifs_sb_master_tcon(=
cifs_sb);
> =A0 =A0 =A0 =A0struct cifs_ses *ses;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D NULL;
> =A0 =A0 =A0 =A0struct smb_vol *vol_info;
> - =A0 =A0 =A0 char username[28]; /* big enough for "krb50x" + hex of =
ULONG_MAX 6+16 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* We used to ha=
ve this as MAX_USERNAME which is =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* way too big n=
ow (256 instead of 32) */
>
> =A0 =A0 =A0 =A0vol_info =3D kzalloc(sizeof(*vol_info), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (vol_info =3D=3D NULL) {
> @@ -3695,8 +3848,6 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_s=
b, uid_t fsuid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 snprintf(username, sizeof(username), "krb50x%x", fsuid)=
;
> - =A0 =A0 =A0 vol_info->username =3D username;
> =A0 =A0 =A0 =A0vol_info->local_nls =3D cifs_sb->local_nls;
> =A0 =A0 =A0 =A0vol_info->linux_uid =3D fsuid;
> =A0 =A0 =A0 =A0vol_info->cred_uid =3D fsuid;
> @@ -3706,8 +3857,11 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_=
sb, uid_t fsuid)
> =A0 =A0 =A0 =A0vol_info->local_lease =3D master_tcon->local_lease;
> =A0 =A0 =A0 =A0vol_info->no_linux_ext =3D !master_tcon->unix_ext;
>
> - =A0 =A0 =A0 /* FIXME: allow for other secFlg settings */
> - =A0 =A0 =A0 vol_info->secFlg =3D CIFSSEC_MUST_KRB5;
> + =A0 =A0 =A0 rc =3D cifs_set_vol_auth(vol_info, master_tcon->ses);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D ERR_PTR(rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* get a reference for the same TCP session */
> =A0 =A0 =A0 =A0spin_lock(&cifs_tcp_ses_lock);
> @@ -3730,6 +3884,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_s=
b, uid_t fsuid)
> =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNIX)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reset_cifs_unix_caps(0, tcon, NULL, vo=
l_info);
> =A0out:
> + =A0 =A0 =A0 kfree(vol_info->username);
> + =A0 =A0 =A0 kfree(vol_info->password);
> =A0 =A0 =A0 =A0kfree(vol_info);
>
> =A0 =A0 =A0 =A0return tcon;
> --
> 1.7.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
