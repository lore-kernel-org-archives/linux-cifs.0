From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Use smb 2 - 3 and cifsacl mount options getacl functions
Date: Fri, 23 Jun 2017 02:33:23 -0500
Message-ID: <CAH2r5muwqxCCY_9MboAjUZpfog7z1rmRp5nWbZQmWB-1rf67pg@mail.gmail.com>
References: <1498189925-4864-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498189925-4864-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Thu, Jun 22, 2017 at 10:52 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Fill in smb2/3 query acl functions in ops structures and use them.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>  fs/cifs/smb2ops.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c586918..6b1ef79 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1288,6 +1288,107 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> +static struct cifs_ntsd *
> +get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
> +               const struct cifs_fid *cifsfid, u32 *pacllen)
> +{
> +       struct cifs_ntsd *pntsd = NULL;
> +       unsigned int xid;
> +       int rc = -EOPNOTSUPP;
> +       struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> +
> +       if (IS_ERR(tlink))
> +               return ERR_CAST(tlink);
> +
> +       xid = get_xid();
> +       cifs_dbg(FYI, "trying to get acl\n");
> +
> +       rc = SMB2_query_acl(xid, tlink_tcon(tlink), cifsfid->persistent_fid,
> +                           cifsfid->volatile_fid, (void **)&pntsd, pacllen);
> +       free_xid(xid);
> +
> +       cifs_put_tlink(tlink);
> +
> +       cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
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
> +       struct cifs_ntsd *pntsd = NULL;
> +       u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
> +       unsigned int xid;
> +       int rc;
> +       struct cifs_tcon *tcon;
> +       struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> +       struct cifs_fid fid;
> +       struct cifs_open_parms oparms;
> +       __le16 *utf16_path;
> +
> +       cifs_dbg(FYI, "get smb3 acl for path %s\n", path);
> +       if (IS_ERR(tlink))
> +               return ERR_CAST(tlink);
> +
> +       tcon = tlink_tcon(tlink);
> +       xid = get_xid();
> +
> +       if (backup_cred(cifs_sb))
> +               oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
> +       else
> +               oparms.create_options = 0;
> +
> +       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return ERR_PTR(-ENOMEM);
> +
> +       oparms.tcon = tcon;
> +       oparms.desired_access = READ_CONTROL;
> +       oparms.disposition = FILE_OPEN;
> +       oparms.fid = &fid;
> +       oparms.reconnect = false;
> +
> +       rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (!rc) {
> +               rc = SMB2_query_acl(xid, tlink_tcon(tlink), fid.persistent_fid,
> +                           fid.volatile_fid, (void **)&pntsd, pacllen);
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +       }
> +
> +       cifs_put_tlink(tlink);
> +       free_xid(xid);
> +
> +       cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
> +       if (rc)
> +               return ERR_PTR(rc);
> +       return pntsd;
> +}
> +
> +/* Retrieve an ACL from the server */
> +static struct cifs_ntsd *
> +get_smb2_acl(struct cifs_sb_info *cifs_sb,
> +                                     struct inode *inode, const char *path,
> +                                     u32 *pacllen)
> +{
> +       struct cifs_ntsd *pntsd = NULL;
> +       struct cifsFileInfo *open_file = NULL;
> +
> +       if (inode)
> +               open_file = find_readable_file(CIFS_I(inode), true);
> +       if (!open_file)
> +               return get_smb2_acl_by_path(cifs_sb, path, pacllen);
> +
> +       pntsd = get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen);
> +       cifsFileInfo_put(open_file);
> +       return pntsd;
> +}
> +
> +
>  static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>                             loff_t offset, loff_t len, bool keep_size)
>  {
> @@ -2391,6 +2492,11 @@ struct smb_version_operations smb20_operations = {
>         .dir_needs_close = smb2_dir_needs_close,
>         .get_dfs_refer = smb2_get_dfs_refer,
>         .select_sectype = smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl = get_smb2_acl,
> +       .get_acl_by_fid = get_smb2_acl_by_fid,
> +/*     .set_acl = set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  struct smb_version_operations smb21_operations = {
> @@ -2475,6 +2581,11 @@ struct smb_version_operations smb21_operations = {
>         .enum_snapshots = smb3_enum_snapshots,
>         .get_dfs_refer = smb2_get_dfs_refer,
>         .select_sectype = smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl = get_smb2_acl,
> +       .get_acl_by_fid = get_smb2_acl_by_fid,
> +/*     .set_acl = set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  struct smb_version_operations smb30_operations = {
> @@ -2569,6 +2680,11 @@ struct smb_version_operations smb30_operations = {
>         .receive_transform = smb3_receive_transform,
>         .get_dfs_refer = smb2_get_dfs_refer,
>         .select_sectype = smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl = get_smb2_acl,
> +       .get_acl_by_fid = get_smb2_acl_by_fid,
> +/*     .set_acl = set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>
>  #ifdef CONFIG_CIFS_SMB311
> @@ -2664,6 +2780,11 @@ struct smb_version_operations smb311_operations = {
>         .receive_transform = smb3_receive_transform,
>         .get_dfs_refer = smb2_get_dfs_refer,
>         .select_sectype = smb2_select_sectype,
> +#ifdef CONFIG_CIFS_ACL
> +       .get_acl = get_smb2_acl,
> +       .get_acl_by_fid = get_smb2_acl_by_fid,
> +/*     .set_acl = set_smb3_acl, */
> +#endif /* CIFS_ACL */
>  };
>  #endif /* CIFS_SMB311 */
>
> --
> 1.9.1
>



-- 
Thanks,

Steve
