From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/7] CIFS: add use_ipc flag to SMB2_ioctl()
Date: Tue, 28 Feb 2017 18:36:03 -0800
Message-ID: <CAKywueRi7PYm6Qk5ggfZ-Za=mwi3QZVPSKN=MiVkm5n39cVWbw@mail.gmail.com>
References: <20170228184034.18771-1-aaptel@suse.com> <20170228184034.18771-4-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-4-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-28 10:40 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> when set, use the session IPC tree id instead of the tid in the provided
> tcon.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2file.c  |  3 ++-
>  fs/cifs/smb2ops.c   | 23 ++++++++++++++++-------
>  fs/cifs/smb2pdu.c   | 17 +++++++++++++++--
>  fs/cifs/smb2proto.h |  3 ++-
>  4 files changed, 35 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index b2aff0c..b4b1f03 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -73,7 +73,8 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>                 nr_ioctl_req.Timeout = 0; /* use server default (120 seconds) */
>                 nr_ioctl_req.Reserved = 0;
>                 rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
> -                       fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY, true,
> +                       fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
> +                       true /* is_fsctl */, false /* use_ipc */,
>                         (char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
>                         NULL, NULL /* no return info */);
>                 if (rc == -EOPNOTSUPP) {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index a44b4db..02937cc 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -282,6 +282,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>
>         rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                         FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
> +                       false /* use_ipc */,
>                         NULL /* no data input */, 0 /* no data input */,
>                         (char **)&out_buf, &ret_data_len);
>         if (rc != 0)
> @@ -571,6 +572,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
> +                       false /* use_ipc */,
>                         NULL, 0 /* no input */,
>                         (char **)&res_key, &ret_data_len);
>
> @@ -635,7 +637,8 @@ smb2_clone_range(const unsigned int xid,
>                 /* Request server copy to target from src identified by key */
>                 rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>                         trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
> -                       true /* is_fsctl */, (char *)pcchunk,
> +                       true /* is_fsctl */, false /* use_ipc */,
> +                       (char *)pcchunk,
>                         sizeof(struct copychunk_ioctl), (char **)&retbuf,
>                         &ret_data_len);
>                 if (rc == 0) {
> @@ -787,7 +790,8 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
> -                       true /* is_fctl */, &setsparse, 1, NULL, NULL);
> +                       true /* is_fctl */, false /* use_ipc */,
> +                       &setsparse, 1, NULL, NULL);
>         if (rc) {
>                 tcon->broken_sparse_sup = true;
>                 cifs_dbg(FYI, "set sparse rc = %d\n", rc);
> @@ -857,7 +861,8 @@ smb2_duplicate_extents(const unsigned int xid,
>         rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>                         trgtfile->fid.volatile_fid,
>                         FSCTL_DUPLICATE_EXTENTS_TO_FILE,
> -                       true /* is_fsctl */, (char *)&dup_ext_buf,
> +                       true /* is_fsctl */, false /* use_ipc */,
> +                       (char *)&dup_ext_buf,
>                         sizeof(struct duplicate_extents_to_file),
>                         NULL,
>                         &ret_data_len);
> @@ -891,7 +896,8 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
>         return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SET_INTEGRITY_INFORMATION,
> -                       true /* is_fsctl */, (char *)&integr_info,
> +                       true /* is_fsctl */, false /* use_ipc */,
> +                       (char *)&integr_info,
>                         sizeof(struct fsctl_set_integrity_information_req),
>                         NULL,
>                         &ret_data_len);
> @@ -910,7 +916,8 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SRV_ENUMERATE_SNAPSHOTS,
> -                       true /* is_fsctl */, NULL, 0 /* no input data */,
> +                       true /* is_fsctl */, false /* use_ipc */,
> +                       NULL, 0 /* no input data */,
>                         (char **)&retbuf,
>                         &ret_data_len);
>         cifs_dbg(FYI, "enum snaphots ioctl returned %d and ret buflen is %d\n",
> @@ -1220,7 +1227,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
> -                       true /* is_fctl */, (char *)&fsctl_buf,
> +                       true /* is_fctl */, false /* use_ipc */,
> +                       (char *)&fsctl_buf,
>                         sizeof(struct file_zero_data_information), NULL, NULL);
>         free_xid(xid);
>         return rc;
> @@ -1254,7 +1262,8 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
> -                       true /* is_fctl */, (char *)&fsctl_buf,
> +                       true /* is_fctl */, false /* use_ipc */,
> +                       (char *)&fsctl_buf,
>                         sizeof(struct file_zero_data_information), NULL, NULL);
>         free_xid(xid);
>         return rc;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ad83b3d..8c4532d 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -620,6 +620,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>
>         rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                 FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> +               false /* use_ipc */,
>                 (char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
>                 (char **)&pneg_rsp, &rsplen);
>
> @@ -1683,8 +1684,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>   */
>  int
>  SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
> -          u64 volatile_fid, u32 opcode, bool is_fsctl, char *in_data,
> -          u32 indatalen, char **out_data, u32 *plen /* returned data len */)
> +          u64 volatile_fid, u32 opcode, bool is_fsctl, bool use_ipc,
> +          char *in_data, u32 indatalen,
> +          char **out_data, u32 *plen /* returned data len */)
>  {
>         struct smb2_ioctl_req *req;
>         struct smb2_ioctl_rsp *rsp;
> @@ -1721,6 +1723,16 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         if (rc)
>                 return rc;
>
> +       if (use_ipc) {
> +               if (ses->ipc_tid == 0) {
> +                       cifs_small_buf_release(req);
> +                       return -ENOTCONN;
> +               }
> +
> +               cifs_dbg(FYI, "replacing tid 0x%x with IPC tid 0x%x\n",
> +                        req->hdr.sync_hdr.TreeId, ses->ipc_tid);
> +               req->hdr.sync_hdr.TreeId = ses->ipc_tid;
> +       }
>         if (encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
> @@ -1843,6 +1855,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SET_COMPRESSION, true /* is_fsctl */,
> +                       false /* use_ipc */,
>                         (char *)&fsctl_input /* data input */,
>                         2 /* in data len */, &ret_data /* out data */, NULL);
>
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 85fc7a7..11d9f30 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -121,7 +121,8 @@ extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
>                      struct smb2_err_rsp **err_buf);
>  extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
>                      u64 persistent_fid, u64 volatile_fid, u32 opcode,
> -                    bool is_fsctl, char *in_data, u32 indatalen,
> +                    bool is_fsctl, bool use_ipc,
> +                    char *in_data, u32 indatalen,
>                      char **out_data, u32 *plen /* returned data len */);
>  extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
