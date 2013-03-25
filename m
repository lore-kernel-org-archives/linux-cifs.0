From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs: cifs: use kmemdup instead of kmalloc + memcpy
Date: Sun, 24 Mar 2013 23:19:09 -0500
Message-ID: <CAH2r5ms00QczVYwpMDjkYP3Y_8YPoKCNzeH5xuS1QUN-LwrrcA@mail.gmail.com>
References: <1363018952-12431-1-git-send-email-silviupopescu1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1363018952-12431-1-git-send-email-silviupopescu1990@gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Merged into cifs-2.6.git (for-next branch)

On Mon, Mar 11, 2013 at 11:22 AM, Silviu-Mihai Popescu
<silviupopescu1990@gmail.com> wrote:
> This replaces calls to kmalloc followed by memcpy with a single call to
> kmemdup. This was found via make coccicheck.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  fs/cifs/cifs_spnego.c |    3 +--
>  fs/cifs/cifsacl.c     |    3 +--
>  fs/cifs/cifssmb.c     |    3 +--
>  fs/cifs/sess.c        |    8 ++++----
>  4 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 10e7747..b7ae3cb 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -37,12 +37,11 @@ cifs_spnego_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
>         int ret;
>
>         ret = -ENOMEM;
> -       payload = kmalloc(prep->datalen, GFP_KERNEL);
> +       payload = kmemdup(prep->data, prep->datalen, GFP_KERNEL);
>         if (!payload)
>                 goto error;
>
>         /* attach the data */
> -       memcpy(payload, prep->data, prep->datalen);
>         key->payload.data = payload;
>         ret = 0;
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index f1e3f25..0bba930 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -63,11 +63,10 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
>                 key->datalen = prep->datalen;
>                 return 0;
>         }
> -       payload = kmalloc(prep->datalen, GFP_KERNEL);
> +       payload = kmemdup(prep->data, prep->datalen, GFP_KERNEL);
>         if (!payload)
>                 return -ENOMEM;
>
> -       memcpy(payload, prep->data, prep->datalen);
>         key->payload.data = payload;
>         key->datalen = prep->datalen;
>         return 0;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 7353bc5..d900bf0 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3742,12 +3742,11 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
>                         rc = -EINVAL;
>                         *pbuflen = 0;
>                 } else {
> -                       *acl_inf = kmalloc(*pbuflen, GFP_KERNEL);
> +                       *acl_inf = kmemdup(pdata, *pbuflen, GFP_KERNEL);
>                         if (*acl_inf == NULL) {
>                                 *pbuflen = 0;
>                                 rc = -ENOMEM;
>                         }
> -                       memcpy(*acl_inf, pdata, *pbuflen);
>                 }
>         }
>  qsec_out:
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 76809f4..6f83881 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -399,12 +399,12 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
>                 return -EINVAL;
>         }
>         if (tilen) {
> -               ses->auth_key.response = kmalloc(tilen, GFP_KERNEL);
> +               ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
> +                                                GFP_KERNEL);
>                 if (!ses->auth_key.response) {
>                         cERROR(1, "Challenge target info allocation failure");
>                         return -ENOMEM;
>                 }
> -               memcpy(ses->auth_key.response, bcc_ptr + tioffset, tilen);
>                 ses->auth_key.len = tilen;
>         }
>
> @@ -761,14 +761,14 @@ ssetup_ntlmssp_authenticate:
>                         goto ssetup_exit;
>                 }
>
> -               ses->auth_key.response = kmalloc(msg->sesskey_len, GFP_KERNEL);
> +               ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
> +                                                GFP_KERNEL);
>                 if (!ses->auth_key.response) {
>                         cERROR(1, "Kerberos can't allocate (%u bytes) memory",
>                                         msg->sesskey_len);
>                         rc = -ENOMEM;
>                         goto ssetup_exit;
>                 }
> -               memcpy(ses->auth_key.response, msg->data, msg->sesskey_len);
>                 ses->auth_key.len = msg->sesskey_len;
>
>                 pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
> --
> 1.7.9.5
>



-- 
Thanks,

Steve
