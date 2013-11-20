From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2][CIFS] Validate Negotiate Info
Date: Wed, 20 Nov 2013 09:33:48 +0400
Message-ID: <CAKywueSdjH-AWsy4JhssF8+3aHFNYnyOnRkAG0DiWwcrHh4oUw@mail.gmail.com>
References: <CAH2r5mufCuB6b1aLbezcdPW8uAsFs7ojoW-L3E5MhrouEb9kVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mufCuB6b1aLbezcdPW8uAsFs7ojoW-L3E5MhrouEb9kVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/11/19 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From e4608aa57f9948a5e160ecb8590c885f76796e34 Mon Sep 17 00:00:00 2001
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Tue, 19 Nov 2013 12:58:08 -0600
> Subject: [PATCH] [CIFS] Check SMB3 dialects against downgrade attacks
>
> When we are running SMB3 or SMB3.02 connections which are signed
> we need to validate the protocol negotiation information,
> to ensure that thenegotiate protocol response was not tampered with.
>
> Add the missing FSCTL which is sent at mount time (immediately after
> the SMB3 Tree Connect) to validate that the capabilities match
> what we think the server sent.
>
> "Secure dialect negotiation is introduced in SMB3 to protect against
> man-in-the-middle attempt to downgrade dialect negotiation.
> The idea is to prevent an eavesdropper from downgrading the initially
> negotiated dialect and capabilities between the client and the server."
>
> For more explanation see 2.2.31.4 of MS-SMB2 or
> http://blogs.msdn.com/b/openspecification/archive/2012/06/28/smb3-secure-dialect-negotiation.aspx
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |  1 +
>  fs/cifs/smb2ops.c   |  1 +
>  fs/cifs/smb2pdu.c   | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.h   | 12 ++++++---
>  fs/cifs/smb2proto.h |  1 +
>  fs/cifs/smbfsctl.h  |  2 +-
>  6 files changed, 89 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index d9ea7ad..f918a99 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -384,6 +384,7 @@ struct smb_version_operations {
>   int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
>   struct cifsFileInfo *target_file, u64 src_off, u64 len,
>   u64 dest_off);
> + int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index a3968ee..757da3e 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1319,6 +1319,7 @@ struct smb_version_operations smb30_operations = {
>   .create_lease_buf = smb3_create_lease_buf,
>   .parse_lease_buf = smb3_parse_lease_buf,
>   .clone_range = smb2_clone_range,
> + .validate_negotiate = smb3_validate_negotiate,
>  };
>
>  struct smb_version_values smb20_values = {
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1e136ee..7756f9b 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -454,6 +454,80 @@ neg_exit:
>   return rc;
>  }
>
> +int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
> +{
> + int rc = 0;
> + struct validate_negotiate_info_req vneg_inbuf;
> + struct validate_negotiate_info_rsp *pneg_rsp;
> + u32 rsplen;
> +
> + cifs_dbg(VFS, "validate negotiate ");
> + vneg_inbuf.Capabilities =
> + cpu_to_le32(tcon->ses->server->vals->req_capabilities);
> + memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
> +
> + /*
> + * validation ioctl must be signed, so no point sending this if we
> + * can not sign it.  We could eventually change this to selectively
> + * sign just this, the first and only signed request on a connection.
> + * This is good enough for now since a user who wants better security
> + * would also enable signing on the mount. Having validation of
> + * negotiate info for signed connections helps reduce attack vectors
> + */
> + if (tcon->ses->server->sign == false)
> + return 0; /* validation requires signing */

Shouldn't we move the above check and comments before we set
Capabilities and Guid of vneg_inbuf?

> +
> + if (tcon->ses->sign)
> + vneg_inbuf.SecurityMode =
> + cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
> + else if (global_secflags & CIFSSEC_MAY_SIGN)
> + vneg_inbuf.SecurityMode =
> + cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
> + else
> + vneg_inbuf.SecurityMode = 0;
> +
> + vneg_inbuf.DialectCount = cpu_to_le16(1);
> + vneg_inbuf.Dialects[0] =
> + cpu_to_le16(tcon->ses->server->vals->protocol_id);
> +
> + rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> + FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> + (char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
> + (char **)&pneg_rsp, &rsplen);
> +
> + if (rc != 0) {
> + cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
> + return -EIO;
> + }
> +
> + if (rsplen != sizeof(struct validate_negotiate_info_rsp)) {
> + cifs_dbg(VFS, "invalid size of protocol negotiate response\n");
> + return -EIO;
> + }
> +
> + /* check validate negotiate info response matches what we got earlier */
> + if (pneg_rsp->Dialect !=
> + cpu_to_le16(tcon->ses->server->vals->protocol_id))
> + goto vneg_out;
> +
> + if (pneg_rsp->SecurityMode != cpu_to_le16(tcon->ses->server->sec_mode))
> + goto vneg_out;
> +
> + /* do not validate server guid because not saved at negprot time yet */
> +
> + if ((le32_to_cpu(pneg_rsp->Capabilities) | SMB2_NT_FIND |
> +      SMB2_LARGE_FILES) != tcon->ses->server->capabilities)
> + goto vneg_out;
> +
> + /* validate negotiate successful */
> + cifs_dbg(FYI, "validate negotiate info successful\n");
> + return 0;
> +
> +vneg_out:
> + cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
> + return -EIO;
> +}
> +
>  int
>  SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>   const struct nls_table *nls_cp)
> @@ -829,6 +903,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
> *ses, const char *tree,
>      ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
>   cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
>   init_copy_chunk_defaults(tcon);
> + if (tcon->ses->server->ops->validate_negotiate)
> + rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
>  tcon_exit:
>   free_rsp_buf(resp_buftype, rsp);
>   kfree(unc_path);
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index f88320b..2022c54 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -577,13 +577,19 @@ struct copychunk_ioctl_rsp {
>   __le32 TotalBytesWritten;
>  } __packed;
>
> -/* Response and Request are the same format */
> -struct validate_negotiate_info {
> +struct validate_negotiate_info_req {
>   __le32 Capabilities;
>   __u8   Guid[SMB2_CLIENT_GUID_SIZE];
>   __le16 SecurityMode;
>   __le16 DialectCount;
> - __le16 Dialect[1];
> + __le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
> +} __packed;
> +
> +struct validate_negotiate_info_rsp {
> + __le32 Capabilities;
> + __u8   Guid[SMB2_CLIENT_GUID_SIZE];
> + __le16 SecurityMode;
> + __le16 Dialect; /* Dialect in use for the connection */
>  } __packed;
>
>  #define RSS_CAPABLE 0x00000001
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index b4eea10..93adc64 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -162,5 +162,6 @@ extern int smb2_lockv(const unsigned int xid,
> struct cifs_tcon *tcon,
>        struct smb2_lock_element *buf);
>  extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
>      __u8 *lease_key, const __le32 lease_state);
> +extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
>
>  #endif /* _SMB2PROTO_H */
> diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> index a4b2391f..0e538b5 100644
> --- a/fs/cifs/smbfsctl.h
> +++ b/fs/cifs/smbfsctl.h
> @@ -90,7 +90,7 @@
>  #define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4 /* BB add struct */
>  #define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
>  #define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
> -#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204 /* BB add struct */
> +#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
>  /* Perform server-side data movement */
>  #define FSCTL_SRV_COPYCHUNK 0x001440F2
>  #define FSCTL_SRV_COPYCHUNK_WRITE 0x001480F2
> --
> 1.8.3.1

Except the note above, the patch looks good.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
