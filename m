From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 3/3] CIFS: implement v3.11 preauth integrity
Date: Fri, 16 Feb 2018 14:37:21 -0600
Message-ID: <CAH2r5ms1V_DyC_xp0o1Cug1bk9_bK-6t3AVQMA0JwEE0YWygNw@mail.gmail.com>
References: <20180216181929.21383-1-aaptel@suse.com> <20180216181929.21383-4-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180216181929.21383-4-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor fixup (sparse spotted a spelling mistake for "authentication")

On Fri, Feb 16, 2018 at 12:19 PM, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrote:
> SMB3.11 clients must implement pre-authentification integrity.
>
> * new mechanism to certify requests/responses happening before Tree
>   Connect.
> * supersedes VALIDATE_NEGOTIATE
> * fixes signing for SMB3.11
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  5 +++--
>  fs/cifs/smb2misc.c  | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.c   | 25 +++++++++++++++++++++
>  fs/cifs/smb2pdu.h   |  1 +
>  fs/cifs/smb2proto.h |  2 ++
>  fs/cifs/transport.c | 17 ++++++++++++++
>  6 files changed, 112 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 765fc2c9fd91..c294093f04d5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -675,7 +675,8 @@ struct TCP_Server_Info {
>         unsigned int    max_read;
>         unsigned int    max_write;
>  #ifdef CONFIG_CIFS_SMB311
> -       __u8    preauth_sha_hash[64]; /* save initital negprot hash */
> +        /* save initital negprot hash */
> +       __u8    preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
>  #endif /* 3.1.1 */
>         struct delayed_work reconnect; /* reconnect workqueue job */
>         struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
> @@ -864,7 +865,7 @@ struct cifs_ses {
>         __u8 smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
>         __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
>  #ifdef CONFIG_CIFS_SMB311
> -       __u8 preauth_sha_hash[64];
> +       __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
>  #endif /* 3.1.1 */
>  };
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 76d03abaa38c..da012c3ab700 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -706,3 +706,67 @@ smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
>
>         return 0;
>  }
> +
> +#ifdef CONFIG_CIFS_SMB311
> +/**
> + * smb311_update_preauth_hash - update @ses hash with the packet data in @iov
> + *
> + * Assumes @iov does not contain the rfc1002 length and iov[0] has the
> + * SMB2 header.
> + */
> +int
> +smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
> +{
> +       int i, rc;
> +       struct sdesc *d;
> +       struct smb2_sync_hdr *hdr;
> +
> +       if (ses->server->tcpStatus == CifsGood) {
> +               /* skip non smb311 connections */
> +               if (ses->server->dialect != SMB311_PROT_ID)
> +                       return 0;
> +
> +               /* skip last sess setup response */
> +               hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
> +               if (hdr->Flags & SMB2_FLAGS_SIGNED)
> +                       return 0;
> +       }
> +
> +       rc = smb311_crypto_shash_allocate(ses->server);
> +       if (rc)
> +               return rc;
> +
> +       d = ses->server->secmech.sdescsha512;
> +       rc = crypto_shash_init(&d->shash);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: could not init sha512 shash\n", __func__);
> +               return rc;
> +       }
> +
> +       rc = crypto_shash_update(&d->shash, ses->preauth_sha_hash,
> +                                SMB2_PREAUTH_HASH_SIZE);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: could not update sha512 shash\n", __func__);
> +               return rc;
> +       }
> +
> +       for (i = 0; i < nvec; i++) {
> +               rc = crypto_shash_update(&d->shash,
> +                                        iov[i].iov_base, iov[i].iov_len);
> +               if (rc) {
> +                       cifs_dbg(VFS, "%s: could not update sha512 shash\n",
> +                                __func__);
> +                       return rc;
> +               }
> +       }
> +
> +       rc = crypto_shash_final(&d->shash, ses->preauth_sha_hash);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: could not finalize sha512 shash\n",
> +                        __func__);
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +#endif
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ab4c20687cc0..4b6920de2541 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -453,6 +453,10 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>                 return rc;
>
>         req->sync_hdr.SessionId = 0;
> +#ifdef CONFIG_CIFS_SMB311
> +       memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
> +       memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
> +#endif
>
>         if (strcmp(ses->server->vals->version_string,
>                    SMB3ANY_VERSION_STRING) == 0) {
> @@ -564,6 +568,15 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>
>         /* BB: add check that dialect was valid given dialect(s) we asked for */
>
> +#ifdef CONFIG_CIFS_SMB311
> +       /*
> +        * Keep a copy of the hash after negprot. This hash will be
> +        * the starting hash value for all sessions made from this
> +        * server.
> +        */
> +       memcpy(server->preauth_sha_hash, ses->preauth_sha_hash,
> +              SMB2_PREAUTH_HASH_SIZE);
> +#endif
>         /* SMB2 only has an extended negflavor */
>         server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
>         /* set it to the maximum buffer size value we can send with 1 credit */
> @@ -621,6 +634,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>                 return 0;
>  #endif
>
> +       /* In SMB3.11 preauth integrity supersedes validate negotiate */
> +       if (tcon->ses->server->dialect == SMB311_PROT_ID)
> +               return 0;
> +
>         /*
>          * validation ioctl must be signed, so no point sending this if we
>          * can not sign it (ie are not known user).  Even if signing is not
> @@ -1148,6 +1165,14 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>         sess_data->buf0_type = CIFS_NO_BUFFER;
>         sess_data->nls_cp = (struct nls_table *) nls_cp;
>
> +#ifdef CONFIG_CIFS_SMB311
> +       /*
> +        * Initialize the session hash with the server one.
> +        */
> +       memcpy(ses->preauth_sha_hash, ses->server->preauth_sha_hash,
> +              SMB2_PREAUTH_HASH_SIZE);
> +#endif
> +
>         while (sess_data->func)
>                 sess_data->func(sess_data);
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 2a2b34ccaf49..8b901c69a65a 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -264,6 +264,7 @@ struct smb2_negotiate_req {
>  #define SMB311_SALT_SIZE                       32
>  /* Hash Algorithm Types */
>  #define SMB2_PREAUTH_INTEGRITY_SHA512  cpu_to_le16(0x0001)
> +#define SMB2_PREAUTH_HASH_SIZE 64
>
>  struct smb2_preauth_neg_context {
>         __le16  ContextType; /* 1 */
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 3b8e9c2e55bc..cbcce3f7e86f 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -204,5 +204,7 @@ extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
>                                         enum securityEnum);
>  #ifdef CONFIG_CIFS_SMB311
>  extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
> +extern int smb311_update_preauth_hash(struct cifs_ses *ses,
> +                                     struct kvec *iov, int nvec);
>  #endif
>  #endif                 /* _SMB2PROTO_H */
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 9779b3292d8e..665661464067 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -37,6 +37,7 @@
>  #include "cifsglob.h"
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
> +#include "smb2proto.h"
>  #include "smbdirect.h"
>
>  /* Max number of iovectors we can use off the stack when sending requests. */
> @@ -751,6 +752,12 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         if (rc < 0)
>                 goto out;
>
> +#ifdef CONFIG_CIFS_SMB311
> +       if (ses->status == CifsNew)
> +               smb311_update_preauth_hash(ses, rqst->rq_iov+1,
> +                                          rqst->rq_nvec-1);
> +#endif
> +
>         if (timeout == CIFS_ASYNC_OP)
>                 goto out;
>
> @@ -789,6 +796,16 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         else
>                 *resp_buf_type = CIFS_SMALL_BUFFER;
>
> +#ifdef CONFIG_CIFS_SMB311
> +       if (ses->status == CifsNew) {
> +               struct kvec iov = {
> +                       .iov_base = buf + 4,
> +                       .iov_len = get_rfc1002_length(buf)
> +               };
> +               smb311_update_preauth_hash(ses, &iov, 1);
> +       }
> +#endif
> +
>         credits = ses->server->ops->get_credits(midQ);
>
>         rc = ses->server->ops->check_receive(midQ, ses->server,
> --
> 2.12.3
>



-- 
Thanks,

Steve
