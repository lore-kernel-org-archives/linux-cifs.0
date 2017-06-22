From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 2/2] cifs: Use smb 2 - 3 and cifsacl mount options getacl
 functions
Date: Thu, 22 Jun 2017 22:33:05 +0000
Message-ID: <CY4PR21MB0135C9BFE562AC78D4357FAAB6DB0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <1496292624-8818-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496292624-8818-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-05-31 21:50 GMT-07:00  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Fill in smb2/3 query acl functions in ops structures and use them.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>  fs/cifs/smb2ops.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 121 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c586918..7157f52 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1288,6 +1288,107 @@ static bool smb2_set_sparse(const unsigned int xi=
d, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static struct cifs_ntsd *
> +get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
> +               const struct cifs_fid *cifsfid, u32 *pacllen)
> +{
> +       struct cifs_ntsd *pntsd =3D NULL;
> +       unsigned int xid;
> +       int rc =3D -EOPNOTSUPP;
> +       struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> +
> +       if (IS_ERR(tlink))
> +               return ERR_CAST(tlink);
> +
> +       xid =3D get_xid();
> +       cifs_dbg(VFS, "trying to get acl\n");

This should be FYI debug level.

> +
> +       rc =3D SMB2_query_acl(xid, tlink_tcon(tlink), cifsfid->persistent=
_fid,
> +                           cifsfid->volatile_fid, (void **)&pntsd, pacll=
en);
> +       free_xid(xid);
> +
> +       cifs_put_tlink(tlink);
> +
> +       cifs_dbg(FYI, "%s: rc =3D %d ACL len %d\n", __func__, rc, *paclle=
n);
> +       if (rc)
> +               return ERR_PTR(rc);
> +       return pntsd;
> +
> +}
> +
> +static struct cifs_ntsd *
> +get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
> +               const char *path, u32 *pacllen)
> +{
> +       struct cifs_ntsd *pntsd =3D NULL;
> +       u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> +       unsigned int xid;
> +       int rc;
> +       struct cifs_tcon *tcon;
> +       struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> +       struct cifs_fid fid;
> +       struct cifs_open_parms oparms;
> +       __le16 *utf16_path;
> +
> +       cifs_dbg(FYI, "get smb3 acl for path %s\n", path);
> +       if (IS_ERR(tlink))
> +               return ERR_CAST(tlink);
> +
> +       tcon =3D tlink_tcon(tlink);
> +       xid =3D get_xid();
> +
> +       if (backup_cred(cifs_sb))
> +               oparms.create_options |=3D CREATE_OPEN_BACKUP_INTENT;
> +       else
> +               oparms.create_options =3D 0;
> +
> +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return ERR_PTR(-ENOMEM);
> +
> +       oparms.tcon =3D tcon;
> +       oparms.desired_access =3D READ_CONTROL;
> +       oparms.disposition =3D FILE_OPEN;
> +       oparms.fid =3D &fid;
> +       oparms.reconnect =3D false;
> +
> +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (!rc) {
> +               rc =3D SMB2_query_acl(xid, tlink_tcon(tlink), fid.persist=
ent_fid,
> +                           fid.volatile_fid, (void **)&pntsd, pacllen);
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
> +       }
> +
> +       cifs_put_tlink(tlink);
> +       free_xid(xid);
> +
> +       cifs_dbg(FYI, "%s: rc =3D %d ACL len %d\n", __func__, rc, *paclle=
n);
> +       if (rc)
> +               return ERR_PTR(rc);
> +       return pntsd;
> +}
> +
> +/* Retrieve an ACL from the server */
> +static struct cifs_ntsd *
> +get_smb2_acl(struct cifs_sb_info *cifs_sb,
> +                                     struct inode *inode, const char *pa=
th,
> +                                     u32 *pacllen)
> +{
> +       struct cifs_ntsd *pntsd =3D NULL;
> +       struct cifsFileInfo *open_file =3D NULL;
> +
> +       if (inode)
> +               open_file =3D find_readable_file(CIFS_I(inode), true);
> +       if (!open_file)
> +               return get_smb2_acl_by_path(cifs_sb, path, pacllen);
> +
> +       pntsd =3D get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen);
> +       cifsFileInfo_put(open_file);
> +       return pntsd;
> +}
> +
> +
>  static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>                             loff_t offset, loff_t len, bool keep_size)
>  {
> @@ -2391,6 +2492,11 @@ struct smb_version_operations smb20_operations =3D=
 {
>         .dir_needs_close =3D smb2_dir_needs_close,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl =3D get_smb2_acl,
> +       .get_acl_by_fid =3D get_smb2_acl_by_fid,
> +/*     .set_acl =3D set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  struct smb_version_operations smb21_operations =3D {
> @@ -2475,6 +2581,11 @@ struct smb_version_operations smb21_operations =3D=
 {
>         .enum_snapshots =3D smb3_enum_snapshots,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl =3D get_smb2_acl,
> +       .get_acl_by_fid =3D get_smb2_acl_by_fid,
> +/*     .set_acl =3D set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  struct smb_version_operations smb30_operations =3D {
> @@ -2569,6 +2680,11 @@ struct smb_version_operations smb30_operations =3D=
 {
>         .receive_transform =3D smb3_receive_transform,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl =3D get_smb2_acl,
> +       .get_acl_by_fid =3D get_smb2_acl_by_fid,
> +/*     .set_acl =3D set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  #ifdef CONFIG_CIFS_SMB311
> @@ -2664,6 +2780,11 @@ struct smb_version_operations smb311_operations =
=3D {
>         .receive_transform =3D smb3_receive_transform,
>         .get_dfs_refer =3D smb2_get_dfs_refer,
>         .select_sectype =3D smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl =3D get_smb2_acl,
> +       .get_acl_by_fid =3D get_smb2_acl_by_fid,
> +/*     .set_acl =3D set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>  #endif /* CIFS_SMB311 */
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Other than the notice above the patch looks right.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
