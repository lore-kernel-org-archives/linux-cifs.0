From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/2] cifs: Add support for reading attributes on SMB2+
Date: Tue, 29 Aug 2017 22:15:17 +0000
Message-ID: <CY4PR21MB0135E73524AAD28CBDB15371B69F0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20170824012456.10977-1-lsahlber@redhat.com>
 <20170824012456.10977-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824012456.10977-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-23 18:24 GMT-07:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> SMB1 already has support to read attributes. This adds similar support
> to SMB2+.
>
> With this patch, tools such as 'getfattr' will now work with SMB2+ shares=
.
>
> RH-bz: 1110709
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c   | 144 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/cifs/smb2pdu.c   |  12 +++++
>  fs/cifs/smb2pdu.h   |  10 ++++
>  fs/cifs/smb2proto.h |   3 ++
>  4 files changed, 169 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index cfacf2c97e94..78516d3a133c 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -426,6 +426,138 @@ smb2_query_file_info(const unsigned int xid, struct=
 cifs_tcon *tcon,
>         return rc;
>  }
>
> +static ssize_t
> +move_smb2_ea_to_cifs(char *dst, size_t dst_size,
> +                    struct smb2_file_full_ea_info *src, size_t src_size,
> +                    const unsigned char *ea_name)
> +{
> +       int rc =3D 0;
> +       unsigned int ea_name_len =3D ea_name ? strlen(ea_name) : 0;
> +       char *name, *value;
> +       size_t name_len, value_len, user_name_len;
> +
> +       while (src_size > 0) {
> +               name =3D &src->ea_data[0];
> +               name_len =3D (size_t)src->ea_name_length;
> +               value =3D &src->ea_data[src->ea_name_length + 1];
> +               value_len =3D (size_t)le16_to_cpu(src->ea_value_length);
> +
> +               if (name_len =3D=3D 0) {
> +                       break;
> +               }
> +
> +               if (src_size < 8 + name_len + 1 + value_len) {
> +                       cifs_dbg(FYI, "EA entry goes beyond length of lis=
t\n");
> +                       rc =3D -EIO;
> +                       goto out;
> +               }
> +
> +               if (ea_name) {
> +                       if (ea_name_len =3D=3D name_len &&
> +                           memcmp(ea_name, name, name_len) =3D=3D 0) {
> +                               rc =3D value_len;
> +                               if (dst_size =3D=3D 0)
> +                                       goto out;
> +                               if (dst_size < value_len) {
> +                                       rc =3D -ERANGE;
> +                                       goto out;
> +                               }
> +                               memcpy(dst, value, value_len);
> +                               goto out;
> +                       }
> +               } else {
> +                       /* 'user.' plus a terminating null */
> +                       user_name_len =3D 5 + 1 + name_len;
> +
> +                       rc +=3D user_name_len;
> +
> +                       if (dst_size >=3D user_name_len) {
> +                               dst_size -=3D user_name_len;
> +                               memcpy(dst, "user.", 5);
> +                               dst +=3D 5;
> +                               memcpy(dst, src->ea_data, name_len);
> +                               dst +=3D name_len;
> +                               *dst =3D 0;
> +                               ++dst;
> +                       } else if (dst_size =3D=3D 0) {
> +                               /* skip copy - calc size only */
> +                       } else {
> +                               /* stop before overrun buffer */
> +                               rc =3D -ERANGE;
> +                               break;
> +                       }
> +               }
> +
> +               if (!src->next_entry_offset)
> +                       break;
> +
> +               if (src_size < le32_to_cpu(src->next_entry_offset)) {
> +                       /* stop before overrun buffer */
> +                       rc =3D -ERANGE;
> +                       break;
> +               }
> +               src_size -=3D le32_to_cpu(src->next_entry_offset);
> +               src =3D (void *)((char *)src +
> +                              le32_to_cpu(src->next_entry_offset));
> +       }
> +
> +       /* didn't find the named attribute */
> +       if (ea_name)
> +               rc =3D -ENODATA;
> +
> +out:
> +       return (ssize_t)rc;
> +}
> +
> +static ssize_t
> +smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
> +              const unsigned char *path, const unsigned char *ea_name,
> +              char *ea_data, size_t buf_size,
> +              struct cifs_sb_info *cifs_sb)
> +{
> +       int rc;
> +       __le16 *utf16_path;
> +       __u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> +       struct cifs_open_parms oparms;
> +       struct cifs_fid fid;
> +       struct smb2_file_full_ea_info *smb2_data;
> +
> +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return -ENOMEM;
> +
> +       oparms.tcon =3D tcon;
> +       oparms.desired_access =3D FILE_READ_EA;
> +       oparms.disposition =3D FILE_OPEN;
> +       oparms.create_options =3D 0;
> +       oparms.fid =3D &fid;
> +       oparms.reconnect =3D false;
> +
> +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (rc) {
> +               cifs_dbg(FYI, "open failed rc=3D%d\n", rc);
> +               return rc;
> +       }
> +
> +       smb2_data =3D kzalloc(SMB2_MAX_EA_BUF, GFP_KERNEL);
> +       if (smb2_data =3D=3D NULL) {
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
> +               return -ENOMEM;
> +       }
> +
> +       rc =3D SMB2_query_eas(xid, tcon, fid.persistent_fid, fid.volatile=
_fid,
> +                           smb2_data);
> +       SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +
> +       if (!rc)
> +               rc =3D move_smb2_ea_to_cifs(ea_data, buf_size, smb2_data,
> +                                         SMB2_MAX_EA_BUF, ea_name);
> +
> +       kfree(smb2_data);
> +       return rc;
> +}
> +
>  static bool
>  smb2_can_echo(struct TCP_Server_Info *server)
>  {
> @@ -2572,6 +2704,9 @@ struct smb_version_operations smb20_operations =3D =
{
>         .dir_needs_close =3D smb2_dir_needs_close,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_XATTR
> +       .query_all_EAs =3D smb2_query_eas,
> +#endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> @@ -2662,6 +2797,9 @@ struct smb_version_operations smb21_operations =3D =
{
>         .enum_snapshots =3D smb3_enum_snapshots,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_XATTR
> +       .query_all_EAs =3D smb2_query_eas,
> +#endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> @@ -2762,6 +2900,9 @@ struct smb_version_operations smb30_operations =3D =
{
>         .receive_transform =3D smb3_receive_transform,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_XATTR
> +       .query_all_EAs =3D smb2_query_eas,
> +#endif /* CIFS_XATTR */
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> @@ -2863,6 +3004,9 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .receive_transform =3D smb3_receive_transform,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_XATTR
> +       .query_all_EAs =3D smb2_query_eas,
> +#endif /* CIFS_XATTR */
>  };
>  #endif /* CIFS_SMB311 */
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5fb2fc2d0080..30ef93e459a9 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2140,6 +2140,18 @@ query_info(const unsigned int xid, struct cifs_tco=
n *tcon,
>         return rc;
>  }
>
> +int SMB2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
> +       u64 persistent_fid, u64 volatile_fid,
> +       struct smb2_file_full_ea_info *data)
> +{
> +       return query_info(xid, tcon, persistent_fid, volatile_fid,
> +                         FILE_FULL_EA_INFORMATION, SMB2_O_INFO_FILE, 0,
> +                         SMB2_MAX_EA_BUF,
> +                         sizeof(struct smb2_file_full_ea_info),
> +                         (void **)&data,
> +                         NULL);
> +}
> +
>  int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
>         u64 persistent_fid, u64 volatile_fid, struct smb2_file_all_info *=
data)
>  {
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 18700fd25a0b..efe258c3b562 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -1178,6 +1178,16 @@ struct smb2_file_link_info { /* encoding of reques=
t for level 11 */
>         char   FileName[0];     /* Name to be assigned to new link */
>  } __packed; /* level 11 Set */
>
> +#define SMB2_MAX_EA_BUF 2048
> +
> +struct smb2_file_full_ea_info { /* encoding of response for level 15 */
> +       __le32 next_entry_offset;
> +       __u8   flags;
> +       __u8   ea_name_length;
> +       __le16 ea_value_length;
> +       char   ea_data[0]; /* \0 terminated name plus value */
> +} __packed; /* level 15 Set */
> +
>  /*
>   * This level 18, although with struct with same name is different from =
cifs
>   * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 1cadaf9f3c58..183389bfc8f6 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -132,6 +132,9 @@ extern int SMB2_close(const unsigned int xid, struct =
cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
>  extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
>                       u64 persistent_file_id, u64 volatile_file_id);
> +extern int SMB2_query_eas(const unsigned int xid, struct cifs_tcon *tcon=
,
> +                         u64 persistent_file_id, u64 volatile_file_id,
> +                         struct smb2_file_full_ea_info *data);
>  extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tco=
n,
>                            u64 persistent_file_id, u64 volatile_file_id,
>                            struct smb2_file_all_info *data);
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
