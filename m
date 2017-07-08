From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Use smb 2 - 3 and cifsacl mount options setacl function
Date: Sat, 8 Jul 2017 17:25:05 -0500
Message-ID: <CAH2r5msNMnRQMkQwnQ3-q4J2Yj0WiU=p52X7UQFQWSQ20B8_kg@mail.gmail.com>
References: <1498707452-8745-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498707452-8745-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

Note I had to fixup a compile warning ("static" was missing on
set_smb2_acl function)

On Wed, Jun 28, 2017 at 10:37 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Added set acl function. Very similar to set cifs acl function for smb1.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>  fs/cifs/smb2ops.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 6b1ef79..490737c 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1369,6 +1369,63 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>         return pntsd;
>  }
>
> +#ifdef CONFIG_CIFS_ACL
> +int
> +set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
> +               struct inode *inode, const char *path, int aclflag)
> +{
> +       u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
> +       unsigned int xid;
> +       int rc, access_flags, create_options = 0;
> +       struct cifs_tcon *tcon;
> +       struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> +       struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> +       struct cifs_fid fid;
> +       struct cifs_open_parms oparms;
> +       __le16 *utf16_path;
> +
> +       cifs_dbg(FYI, "set smb3 acl for path %s\n", path);
> +       if (IS_ERR(tlink))
> +               return PTR_ERR(tlink);
> +
> +       tcon = tlink_tcon(tlink);
> +       xid = get_xid();
> +
> +       if (backup_cred(cifs_sb))
> +               oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
> +       if (aclflag == CIFS_ACL_OWNER || aclflag == CIFS_ACL_GROUP)
> +               access_flags = WRITE_OWNER;
> +       else
> +               access_flags = WRITE_DAC;
> +
> +       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return -ENOMEM;
> +
> +       oparms.tcon = tcon;
> +       oparms.desired_access = access_flags;
> +       oparms.create_options = create_options;
> +       oparms.disposition = FILE_OPEN;
> +       oparms.path = path;
> +       oparms.fid = &fid;
> +       oparms.reconnect = false;
> +
> +       rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (!rc) {
> +               rc = SMB2_set_acl(xid, tlink_tcon(tlink), fid.persistent_fid,
> +                           fid.volatile_fid, pnntsd, acllen, aclflag);
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> +       }
> +
> +       cifs_put_tlink(tlink);
> +       free_xid(xid);
> +
> +       return rc;
> +}
> +#endif /* CIFS_ACL */
> +
>  /* Retrieve an ACL from the server */
>  static struct cifs_ntsd *
>  get_smb2_acl(struct cifs_sb_info *cifs_sb,
> @@ -2495,7 +2552,7 @@ struct smb_version_operations smb20_operations = {
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl = get_smb2_acl,
>         .get_acl_by_fid = get_smb2_acl_by_fid,
> -/*     .set_acl = set_smb3_acl, */
> +       .set_acl = set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2584,7 +2641,7 @@ struct smb_version_operations smb21_operations = {
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl = get_smb2_acl,
>         .get_acl_by_fid = get_smb2_acl_by_fid,
> -/*     .set_acl = set_smb3_acl, */
> +       .set_acl = set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2683,7 +2740,7 @@ struct smb_version_operations smb30_operations = {
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl = get_smb2_acl,
>         .get_acl_by_fid = get_smb2_acl_by_fid,
> -/*     .set_acl = set_smb3_acl, */
> +       .set_acl = set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2783,7 +2840,7 @@ struct smb_version_operations smb311_operations = {
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl = get_smb2_acl,
>         .get_acl_by_fid = get_smb2_acl_by_fid,
> -/*     .set_acl = set_smb3_acl, */
> +       .set_acl = set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>  #endif /* CIFS_SMB311 */
> --
> 1.9.1
>



-- 
Thanks,

Steve
