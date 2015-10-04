From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 4/4] [SMB3] Send durable handle v2 contexts when use of
 persistent handles required
Date: Sun, 4 Oct 2015 13:33:47 +0300
Message-ID: <CAKywueQ05vWzv-OUizG3Z2Zso_xk_uKSj=mfbvdpDhsm9UqVqg@mail.gmail.com>
References: <1443916442-42466-1-git-send-email-smfrench@gmail.com>
	<1443916442-42466-4-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443916442-42466-4-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2015-10-04 2:54 GMT+03:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> CC: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |   1 +
>  fs/cifs/smb2pdu.c  | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/smb2pdu.h  |  45 ++++++++++++++++++++
>  fs/cifs/smbfsctl.h |   2 +-
>  4 files changed, 168 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 51353bb..ec31a03 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1022,6 +1022,7 @@ struct cifs_fid {
>         __u64 persistent_fid;   /* persist file id for smb2 */
>         __u64 volatile_fid;     /* volatile file id for smb2 */
>         __u8 lease_key[SMB2_LEASE_KEY_SIZE];    /* lease key for smb2 */
> +       __u8 create_guid[16];
>  #endif
>         struct cifs_pending_open *pending_open;
>         unsigned int epoch;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c744b57..c135046 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1148,13 +1148,130 @@ add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
>         return 0;
>  }
>
> +static struct create_durable_v2 *
> +create_durable_v2_buf(struct cifs_fid *pfid)
> +{
> +       struct create_durable_v2 *buf;
> +
> +       buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
> +       if (!buf)
> +               return NULL;
> +
> +       buf->ccontext.DataOffset = cpu_to_le16(offsetof
> +                                       (struct create_durable_v2, dcontext));
> +       buf->ccontext.DataLength = cpu_to_le32(sizeof(struct durable_context_v2));
> +       buf->ccontext.NameOffset = cpu_to_le16(offsetof
> +                               (struct create_durable_v2, Name));
> +       buf->ccontext.NameLength = cpu_to_le16(4);
> +
> +       buf->dcontext.Timeout = 0; /* Should this be configurable by workload */
> +       buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
> +       get_random_bytes(buf->dcontext.CreateGuid, 16);
> +       memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
> +
> +       /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
> +       buf->Name[0] = 'D';
> +       buf->Name[1] = 'H';
> +       buf->Name[2] = '2';
> +       buf->Name[3] = 'Q';
> +       return buf;
> +}
> +
> +static struct create_durable_handle_reconnect_v2 *
> +create_reconnect_durable_v2_buf(struct cifs_fid *fid)
> +{
> +       struct create_durable_handle_reconnect_v2 *buf;
> +
> +       buf = kzalloc(sizeof(struct create_durable_handle_reconnect_v2),
> +                       GFP_KERNEL);
> +       if (!buf)
> +               return NULL;
> +
> +       buf->ccontext.DataOffset =
> +               cpu_to_le16(offsetof(struct create_durable_handle_reconnect_v2,
> +                                    dcontext));
> +       buf->ccontext.DataLength =
> +               cpu_to_le32(sizeof(struct durable_reconnect_context_v2));
> +       buf->ccontext.NameOffset =
> +               cpu_to_le16(offsetof(struct create_durable_handle_reconnect_v2,
> +                           Name));
> +       buf->ccontext.NameLength = cpu_to_le16(4);
> +
> +       buf->dcontext.Fid.PersistentFileId = fid->persistent_fid;
> +       buf->dcontext.Fid.VolatileFileId = fid->volatile_fid;
> +       buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
> +       memcpy(buf->dcontext.CreateGuid, fid->create_guid, 16);
> +
> +       /* SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2 is "DH2C" */
> +       buf->Name[0] = 'D';
> +       buf->Name[1] = 'H';
> +       buf->Name[2] = '2';
> +       buf->Name[3] = 'C';
> +       return buf;
> +}
> +
>  static int
> -add_durable_context(struct kvec *iov, unsigned int *num_iovec,
> +add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
> +                   struct cifs_open_parms *oparms)
> +{
> +       struct smb2_create_req *req = iov[0].iov_base;
> +       unsigned int num = *num_iovec;
> +
> +       iov[num].iov_base = create_durable_v2_buf(oparms->fid);
> +       if (iov[num].iov_base == NULL)
> +               return -ENOMEM;
> +       iov[num].iov_len = sizeof(struct create_durable_v2);
> +       if (!req->CreateContextsOffset)
> +               req->CreateContextsOffset =
> +                       cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
> +                                                               iov[1].iov_len);
> +       le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
> +       inc_rfc1001_len(&req->hdr, sizeof(struct create_durable_v2));
> +       *num_iovec = num + 1;
> +       return 0;
> +}
> +
> +static int
> +add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
>                     struct cifs_open_parms *oparms)
>  {
>         struct smb2_create_req *req = iov[0].iov_base;
>         unsigned int num = *num_iovec;
>
> +       /* indicate that we don't need to relock the file */
> +       oparms->reconnect = false;
> +
> +       iov[num].iov_base = create_reconnect_durable_v2_buf(oparms->fid);
> +       if (iov[num].iov_base == NULL)
> +               return -ENOMEM;
> +       iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
> +       if (!req->CreateContextsOffset)
> +               req->CreateContextsOffset =
> +                       cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
> +                                                               iov[1].iov_len);
> +       le32_add_cpu(&req->CreateContextsLength,
> +                       sizeof(struct create_durable_handle_reconnect_v2));
> +       inc_rfc1001_len(&req->hdr,
> +                       sizeof(struct create_durable_handle_reconnect_v2));
> +       *num_iovec = num + 1;
> +       return 0;
> +}
> +
> +static int
> +add_durable_context(struct kvec *iov, unsigned int *num_iovec,
> +                   struct cifs_open_parms *oparms, bool use_persistent)
> +{
> +       struct smb2_create_req *req = iov[0].iov_base;
> +       unsigned int num = *num_iovec;
> +
> +       if (use_persistent) {
> +               if (oparms->reconnect)
> +                       return add_durable_reconnect_v2_context(iov, num_iovec,
> +                                                               oparms);
> +               else
> +                       return add_durable_v2_context(iov, num_iovec, oparms);
> +       }
> +
>         if (oparms->reconnect) {
>                 iov[num].iov_base = create_reconnect_durable_buf(oparms->fid);
>                 /* indicate that we don't need to relock the file */
> @@ -1272,7 +1389,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>                         ccontext->Next =
>                                 cpu_to_le32(server->vals->create_lease_size);
>                 }
> -               rc = add_durable_context(iov, &num_iovecs, oparms);
> +
> +               rc = add_durable_context(iov, &num_iovecs, oparms,
> +                                       tcon->use_persistent);
>                 if (rc) {
>                         cifs_small_buf_release(req);
>                         kfree(copy_path);
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index b26da75..ff88d9f 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -590,6 +590,44 @@ struct create_durable {
>         } Data;
>  } __packed;
>
> +/* See MS-SMB2 2.2.13.2.11 */
> +/* Flags */
> +#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
> +struct durable_context_v2 {
> +       __le32 Timeout;
> +       __le32 Flags;
> +       __u64 Reserved;
> +       __u8 CreateGuid[16];
> +} __packed;
> +
> +struct create_durable_v2 {
> +       struct create_context ccontext;
> +       __u8   Name[8];
> +       struct durable_context_v2 dcontext;
> +} __packed;
> +
> +/* See MS-SMB2 2.2.13.2.12 */
> +struct durable_reconnect_context_v2 {
> +       struct {
> +               __u64 PersistentFileId;
> +               __u64 VolatileFileId;
> +       } Fid;
> +       __u8 CreateGuid[16];
> +       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> +} __packed;
> +
> +/* See MS-SMB2 2.2.14.2.12 */
> +struct durable_reconnect_context_v2_rsp {
> +       __le32 Timeout;
> +       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
> +} __packed;
> +
> +struct create_durable_handle_reconnect_v2 {
> +       struct create_context ccontext;
> +       __u8   Name[8];
> +       struct durable_reconnect_context_v2 dcontext;
> +} __packed;
> +
>  #define COPY_CHUNK_RES_KEY_SIZE        24
>  struct resume_key_req {
>         char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
> @@ -643,6 +681,13 @@ struct fsctl_get_integrity_information_rsp {
>  /* Integrity flags for above */
>  #define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF  0x00000001
>
> +/* See MS-SMB2 2.2.31.3 */
> +struct network_resiliency_req {
> +       __le32 Timeout;
> +       __le32 Reserved;
> +} __packed;
> +/* There is no buffer for the response ie no struct network_resiliency_rsp */
> +
>
>  struct validate_negotiate_info_req {
>         __le32 Capabilities;
> diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> index a639d0d..f996dae 100644
> --- a/fs/cifs/smbfsctl.h
> +++ b/fs/cifs/smbfsctl.h
> @@ -90,7 +90,7 @@
>  #define FSCTL_SRV_ENUMERATE_SNAPSHOTS 0x00144064
>  /* Retrieve an opaque file reference for server-side data movement ie copy */
>  #define FSCTL_SRV_REQUEST_RESUME_KEY 0x00140078
> -#define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4 /* BB add struct */
> +#define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4
>  #define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
>  #define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
>  #define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
> --
> 1.9.1

The whole series looks good to me. You can add my

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

tag to each of 4 patches.

-- 
Best regards,
Pavel Shilovsky.
