From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/2] CIFS: use tcon_ipc instead of use_ipc parameter of SMB2_ioctl
Date: Fri, 19 Jan 2018 16:36:22 -0800
Message-ID: <CAKywueRY1G5GQznKtSiOuU8dtE6248h5+OfK7gC3154VwjSeaQ@mail.gmail.com>
References: <20180117172200.3221-1-aaptel@suse.com> <20180119171258.14244-1-aaptel@suse.com>
 <20180119171258.14244-3-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180119171258.14244-3-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2018-01-19 9:12 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Since IPC now has a tcon object, the caller can just pass it. This
> allows domain-based DFS requests to work with smb2+.
>
> Link: https://bugzilla.samba.org/show_bug.cgi?id=12917
> Fixes: 9d49640a21bf ("CIFS: implement get_dfs_refer for SMB2+")
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2file.c  |  2 +-
>  fs/cifs/smb2ops.c   | 53 ++++++++++++++++++++++-------------------------------
>  fs/cifs/smb2pdu.c   |  4 +---
>  fs/cifs/smb2proto.h |  3 +--
>  4 files changed, 25 insertions(+), 37 deletions(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index b4b1f0305f29..12af5dba742b 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -74,7 +74,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>                 nr_ioctl_req.Reserved = 0;
>                 rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
>                         fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
>                         NULL, NULL /* no return info */);
>                 if (rc == -EOPNOTSUPP) {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index ed88ab8a4774..1d9907da96f4 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -283,7 +283,6 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>
>         rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                         FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
> -                       false /* use_ipc */,
>                         NULL /* no data input */, 0 /* no data input */,
>                         (char **)&out_buf, &ret_data_len);
>         if (rc != 0)
> @@ -782,7 +781,6 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
> -                       false /* use_ipc */,
>                         NULL, 0 /* no input */,
>                         (char **)&res_key, &ret_data_len);
>
> @@ -848,8 +846,7 @@ smb2_copychunk_range(const unsigned int xid,
>                 /* Request server copy to target from src identified by key */
>                 rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>                         trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
> -                       true /* is_fsctl */, false /* use_ipc */,
> -                       (char *)pcchunk,
> +                       true /* is_fsctl */, (char *)pcchunk,
>                         sizeof(struct copychunk_ioctl), (char **)&retbuf,
>                         &ret_data_len);
>                 if (rc == 0) {
> @@ -1006,7 +1003,7 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
> -                       true /* is_fctl */, false /* use_ipc */,
> +                       true /* is_fctl */,
>                         &setsparse, 1, NULL, NULL);
>         if (rc) {
>                 tcon->broken_sparse_sup = true;
> @@ -1077,7 +1074,7 @@ smb2_duplicate_extents(const unsigned int xid,
>         rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>                         trgtfile->fid.volatile_fid,
>                         FSCTL_DUPLICATE_EXTENTS_TO_FILE,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&dup_ext_buf,
>                         sizeof(struct duplicate_extents_to_file),
>                         NULL,
> @@ -1112,7 +1109,7 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
>         return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SET_INTEGRITY_INFORMATION,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&integr_info,
>                         sizeof(struct fsctl_set_integrity_information_req),
>                         NULL,
> @@ -1132,7 +1129,7 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
>         rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SRV_ENUMERATE_SNAPSHOTS,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         NULL, 0 /* no input data */,
>                         (char **)&retbuf,
>                         &ret_data_len);
> @@ -1351,16 +1348,20 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>         cifs_dbg(FYI, "smb2_get_dfs_refer path <%s>\n", search_name);
>
>         /*
> -        * Use any tcon from the current session. Here, the first one.
> +        * Try to use the IPC tcon, otherwise just use any
>          */
> -       spin_lock(&cifs_tcp_ses_lock);
> -       tcon = list_first_entry_or_null(&ses->tcon_list, struct cifs_tcon,
> -                                       tcon_list);
> -       if (tcon)
> -               tcon->tc_count++;
> -       spin_unlock(&cifs_tcp_ses_lock);
> +       tcon = ses->tcon_ipc;
> +       if (tcon == NULL) {
> +               spin_lock(&cifs_tcp_ses_lock);
> +               tcon = list_first_entry_or_null(&ses->tcon_list,
> +                                               struct cifs_tcon,
> +                                               tcon_list);
> +               if (tcon)
> +                       tcon->tc_count++;
> +               spin_unlock(&cifs_tcp_ses_lock);
> +       }
>
> -       if (!tcon) {
> +       if (tcon == NULL) {
>                 cifs_dbg(VFS, "session %p has no tcon available for a dfs referral request\n",
>                          ses);
>                 rc = -ENOTCONN;
> @@ -1389,20 +1390,11 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>         memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
>
>         do {
> -               /* try first with IPC */
>                 rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                                 FSCTL_DFS_GET_REFERRALS,
> -                               true /* is_fsctl */, true /* use_ipc */,
> +                               true /* is_fsctl */,
>                                 (char *)dfs_req, dfs_req_size,
>                                 (char **)&dfs_rsp, &dfs_rsp_size);
> -               if (rc == -ENOTCONN) {
> -                       /* try with normal tcon */
> -                       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> -                                       FSCTL_DFS_GET_REFERRALS,
> -                                       true /* is_fsctl */, false /*use_ipc*/,
> -                                       (char *)dfs_req, dfs_req_size,
> -                                       (char **)&dfs_rsp, &dfs_rsp_size);
> -               }

Is it safe to try IPC share only and not retry with any normal tcon in
the case of ENOTCONN like the current code does?

Best regards,
Pavel Shilovsky
