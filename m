From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v3 2/3] CIFS: use tcon_ipc instead of use_ipc parameter of
 SMB2_ioctl
Date: Fri, 26 Jan 2018 22:59:03 +0000
Message-ID: <DM5PR2101MB0936AC9191E9DFB932DD3F00B6E00@DM5PR2101MB0936.namprd21.prod.outlook.com>
References: <20180117172200.3221-1-aaptel@suse.com>
 <20180124124612.21993-1-aaptel@suse.com>
 <20180124124612.21993-3-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124124612.21993-3-aaptel-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



2018-01-24 4:46 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Since IPC now has a tcon object, the caller can just pass it. This
> allows domain-based DFS requests to work with smb2+.
>
> Link: https://bugzilla.samba.org/show_bug.cgi?id=3D12917
> Fixes: 9d49640a21bf ("CIFS: implement get_dfs_refer for SMB2+")
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2file.c  |  2 +-
>  fs/cifs/smb2ops.c   | 53 ++++++++++++++++++++++-------------------------=
------
>  fs/cifs/smb2pdu.c   |  4 +---
>  fs/cifs/smb2proto.h |  3 +--
>  4 files changed, 25 insertions(+), 37 deletions(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index b4b1f0305f29..12af5dba742b 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -74,7 +74,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open=
_parms *oparms,
>                 nr_ioctl_req.Reserved =3D 0;
>                 rc =3D SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
>                         fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
>                         NULL, NULL /* no return info */);
>                 if (rc =3D=3D -EOPNOTSUPP) {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index e3393ff5d458..eb68e2fcc500 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -293,7 +293,6 @@ SMB3_request_interfaces(const unsigned int xid, struc=
t cifs_tcon *tcon)
>
>         rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                         FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fs=
ctl */,
> -                       false /* use_ipc */,
>                         NULL /* no data input */, 0 /* no data input */,
>                         (char **)&out_buf, &ret_data_len);
>         if (rc !=3D 0)
> @@ -792,7 +791,6 @@ SMB2_request_res_key(const unsigned int xid, struct c=
ifs_tcon *tcon,
>
>         rc =3D SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */=
,
> -                       false /* use_ipc */,
>                         NULL, 0 /* no input */,
>                         (char **)&res_key, &ret_data_len);
>
> @@ -858,8 +856,7 @@ smb2_copychunk_range(const unsigned int xid,
>                 /* Request server copy to target from src identified by k=
ey */
>                 rc =3D SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid=
,
>                         trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_W=
RITE,
> -                       true /* is_fsctl */, false /* use_ipc */,
> -                       (char *)pcchunk,
> +                       true /* is_fsctl */, (char *)pcchunk,
>                         sizeof(struct copychunk_ioctl), (char **)&retbuf,
>                         &ret_data_len);
>                 if (rc =3D=3D 0) {
> @@ -1020,7 +1017,7 @@ static bool smb2_set_sparse(const unsigned int xid,=
 struct cifs_tcon *tcon,
>
>         rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
> -                       true /* is_fctl */, false /* use_ipc */,
> +                       true /* is_fctl */,
>                         &setsparse, 1, NULL, NULL);
>         if (rc) {
>                 tcon->broken_sparse_sup =3D true;
> @@ -1091,7 +1088,7 @@ smb2_duplicate_extents(const unsigned int xid,
>         rc =3D SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>                         trgtfile->fid.volatile_fid,
>                         FSCTL_DUPLICATE_EXTENTS_TO_FILE,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&dup_ext_buf,
>                         sizeof(struct duplicate_extents_to_file),
>                         NULL,
> @@ -1126,7 +1123,7 @@ smb3_set_integrity(const unsigned int xid, struct c=
ifs_tcon *tcon,
>         return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SET_INTEGRITY_INFORMATION,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         (char *)&integr_info,
>                         sizeof(struct fsctl_set_integrity_information_req=
),
>                         NULL,
> @@ -1146,7 +1143,7 @@ smb3_enum_snapshots(const unsigned int xid, struct =
cifs_tcon *tcon,
>         rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid,
>                         FSCTL_SRV_ENUMERATE_SNAPSHOTS,
> -                       true /* is_fsctl */, false /* use_ipc */,
> +                       true /* is_fsctl */,
>                         NULL, 0 /* no input data */,
>                         (char **)&retbuf,
>                         &ret_data_len);
> @@ -1365,16 +1362,20 @@ smb2_get_dfs_refer(const unsigned int xid, struct=
 cifs_ses *ses,
>         cifs_dbg(FYI, "smb2_get_dfs_refer path <%s>\n", search_name);
>
>         /*
> -        * Use any tcon from the current session. Here, the first one.
> +        * Try to use the IPC tcon, otherwise just use any
>          */
> -       spin_lock(&cifs_tcp_ses_lock);
> -       tcon =3D list_first_entry_or_null(&ses->tcon_list, struct cifs_tc=
on,
> -                                       tcon_list);
> -       if (tcon)
> -               tcon->tc_count++;
> -       spin_unlock(&cifs_tcp_ses_lock);
> +       tcon =3D ses->tcon_ipc;
> +       if (tcon =3D=3D NULL) {
> +               spin_lock(&cifs_tcp_ses_lock);
> +               tcon =3D list_first_entry_or_null(&ses->tcon_list,
> +                                               struct cifs_tcon,
> +                                               tcon_list);
> +               if (tcon)
> +                       tcon->tc_count++;
> +               spin_unlock(&cifs_tcp_ses_lock);
> +       }
>
> -       if (!tcon) {
> +       if (tcon =3D=3D NULL) {
>                 cifs_dbg(VFS, "session %p has no tcon available for a dfs=
 referral request\n",
>                          ses);
>                 rc =3D -ENOTCONN;
> @@ -1403,20 +1404,11 @@ smb2_get_dfs_refer(const unsigned int xid, struct=
 cifs_ses *ses,
>         memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
>
>         do {
> -               /* try first with IPC */
>                 rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                                 FSCTL_DFS_GET_REFERRALS,
> -                               true /* is_fsctl */, true /* use_ipc */,
> +                               true /* is_fsctl */,
>                                 (char *)dfs_req, dfs_req_size,
>                                 (char **)&dfs_rsp, &dfs_rsp_size);
> -               if (rc =3D=3D -ENOTCONN) {
> -                       /* try with normal tcon */
> -                       rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_=
ID,
> -                                       FSCTL_DFS_GET_REFERRALS,
> -                                       true /* is_fsctl */, false /*use_=
ipc*/,
> -                                       (char *)dfs_req, dfs_req_size,
> -                                       (char **)&dfs_rsp, &dfs_rsp_size)=
;
> -               }
>         } while (rc =3D=3D -EAGAIN);
>
>         if (rc) {
> @@ -1435,7 +1427,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct c=
ifs_ses *ses,
>         }
>
>   out:
> -       if (tcon) {
> +       if (tcon && !tcon->ipc) {
> +               /* ipc tcons are not refcounted */
>                 spin_lock(&cifs_tcp_ses_lock);
>                 tcon->tc_count--;
>                 spin_unlock(&cifs_tcp_ses_lock);
> @@ -1727,8 +1720,7 @@ static long smb3_zero_range(struct file *file, stru=
ct cifs_tcon *tcon,
>
>         rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
> -                       true /* is_fctl */, false /* use_ipc */,
> -                       (char *)&fsctl_buf,
> +                       true /* is_fctl */, (char *)&fsctl_buf,
>                         sizeof(struct file_zero_data_information), NULL, =
NULL);
>         free_xid(xid);
>         return rc;
> @@ -1762,8 +1754,7 @@ static long smb3_punch_hole(struct file *file, stru=
ct cifs_tcon *tcon,
>
>         rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>                         cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
> -                       true /* is_fctl */, false /* use_ipc */,
> -                       (char *)&fsctl_buf,
> +                       true /* is_fctl */, (char *)&fsctl_buf,
>                         sizeof(struct file_zero_data_information), NULL, =
NULL);
>         free_xid(xid);
>         return rc;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2943adc754e4..17b7f3aed195 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -680,7 +680,6 @@ int smb3_validate_negotiate(const unsigned int xid, s=
truct cifs_tcon *tcon)
>
>         rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                 FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> -               false /* use_ipc */,
>                 (char *)&vneg_inbuf, sizeof(struct validate_negotiate_inf=
o_req),
>                 (char **)&pneg_rsp, &rsplen);
>
> @@ -1841,7 +1840,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>   */
>  int
>  SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persisten=
t_fid,
> -          u64 volatile_fid, u32 opcode, bool is_fsctl, bool use_ipc,
> +          u64 volatile_fid, u32 opcode, bool is_fsctl,
>            char *in_data, u32 indatalen,
>            char **out_data, u32 *plen /* returned data len */)
>  {
> @@ -2006,7 +2005,6 @@ SMB2_set_compression(const unsigned int xid, struct=
 cifs_tcon *tcon,
>
>         rc =3D SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
>                         FSCTL_SET_COMPRESSION, true /* is_fsctl */,
> -                       false /* use_ipc */,
>                         (char *)&fsctl_input /* data input */,
>                         2 /* in data len */, &ret_data /* out data */, NU=
LL);
>
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index e9ab5227e7a8..05287b01f596 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -125,8 +125,7 @@ extern int SMB2_open(const unsigned int xid, struct c=
ifs_open_parms *oparms,
>                      struct smb2_err_rsp **err_buf);
>  extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
>                      u64 persistent_fid, u64 volatile_fid, u32 opcode,
> -                    bool is_fsctl, bool use_ipc,
> -                    char *in_data, u32 indatalen,
> +                    bool is_fsctl, char *in_data, u32 indatalen,
>                      char **out_data, u32 *plen /* returned data len */);
>  extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
