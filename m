From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/19] cifs: remove rfc1002 header from smb2_negotiate_req
Date: Fri, 17 Nov 2017 11:02:00 -0800
Message-ID: <CAKywueRtN3a7_xsenaD9WqEDWOD=GXOy=X+Nxy6JLTHSnNwkoQ@mail.gmail.com>
References: <20171109011433.14468-1-lsahlber@redhat.com> <20171109011433.14468-3-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109011433.14468-3-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-08 17:14 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 26 +++++++++++---------------
>  fs/cifs/smb2pdu.h |  2 +-
>  2 files changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5331631386a2..f5cf9953955c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -398,8 +398,8 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
>  }
>
>  #ifdef CONFIG_CIFS_SMB311
> -/* offset is sizeof smb2_negotiate_req - 4 but rounded up to 8 bytes */
> -#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) - 4 */
> +/* offset is sizeof smb2_negotiate_req but rounded up to 8 bytes */
> +#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) */
>
>
>  #define SMB2_PREAUTH_INTEGRITY_CAPABILITIES    cpu_to_le16(1)
> @@ -429,9 +429,7 @@ build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
>  static void
>  assemble_neg_contexts(struct smb2_negotiate_req *req)
>  {
> -
> -       /* +4 is to account for the RFC1001 len field */
> -       char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT + 4;
> +       char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT;
>
>         build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
>         /* Add 2 to size to round to 8 byte boundary */
> @@ -439,8 +437,6 @@ assemble_neg_contexts(struct smb2_negotiate_req *req)
>         build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
>         req->NegotiateContextOffset = cpu_to_le32(OFFSET_OF_NEG_CONTEXT);
>         req->NegotiateContextCount = cpu_to_le16(2);
> -       inc_rfc1001_len(req, 4 + sizeof(struct smb2_preauth_neg_context)
> -                       + sizeof(struct smb2_encryption_neg_context)); /* calculate hash */

Ok. I still think something is not right here. We added 2 contexts of
"4 + sizeof(struct smb2_preauth_neg_context) + sizeof(struct
smb2_encryption_neg_context)" size to the req buffer...


>  }
>  #else
>  static void assemble_neg_contexts(struct smb2_negotiate_req *req)
> @@ -477,6 +473,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>         int blob_offset, blob_length;
>         char *security_blob;
>         int flags = CIFS_NEG_OP;
> +       unsigned int total_len;
>
>         cifs_dbg(FYI, "Negotiate protocol\n");
>
> @@ -485,30 +482,30 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>                 return -EIO;
>         }
>
> -       rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req);
> +       rc = smb2_plain_req_init(SMB2_NEGOTIATE, NULL, (void **) &req, &total_len);
>         if (rc)
>                 return rc;
>
> -       req->hdr.sync_hdr.SessionId = 0;
> +       req->sync_hdr.SessionId = 0;
>
>         if (strcmp(ses->server->vals->version_string,
>                    SMB3ANY_VERSION_STRING) == 0) {
>                 req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>                 req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>                 req->DialectCount = cpu_to_le16(2);
> -               inc_rfc1001_len(req, 4);
> +               total_len += 4;
>         } else if (strcmp(ses->server->vals->version_string,
>                    SMBDEFAULT_VERSION_STRING) == 0) {
>                 req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>                 req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>                 req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>                 req->DialectCount = cpu_to_le16(3);
> -               inc_rfc1001_len(req, 6);
> +               total_len += 6;
>         } else {
>                 /* otherwise send specific dialect */
>                 req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
>                 req->DialectCount = cpu_to_le16(1);
> -               inc_rfc1001_len(req, 2);
> +               total_len += 2;
>         }
>
>         /* only one of SMB2 signing flags may be set in SMB2 request */
> @@ -531,10 +528,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>                         assemble_neg_contexts(req);

... but we do not update total_len variable,


>         }
>         iov[0].iov_base = (char *)req;
> -       /* 4 for rfc1002 length field */
> -       iov[0].iov_len = get_rfc1002_length(req) + 4;
> +       iov[0].iov_len = total_len;
                                     ^^^
which is later used here to set iov_len. So, as a result we are
missing those 2 negotiate contexts.

> -       rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
> +       rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
>         cifs_small_buf_release(req);
>         rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
>         /*
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index c2ec934be968..0fe2382597ad 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -195,7 +195,7 @@ struct smb2_symlink_err_rsp {
>  #define SMB2_CLIENT_GUID_SIZE 16
>
>  struct smb2_negotiate_req {
> -       struct smb2_hdr hdr;
> +       struct smb2_sync_hdr sync_hdr;
>         __le16 StructureSize; /* Must be 36 */
>         __le16 DialectCount;
>         __le16 SecurityMode;
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Best regards,
Pavel Shilovsky
