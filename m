From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 2/2] cifs: Use smb 2 - 3 and cifsacl mount options setacl
 function
Date: Sat, 8 Jul 2017 16:47:28 +0000
Message-ID: <CY4PR21MB01351461C337213BCAF1A13BB6AB0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <1498707452-8745-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498707452-8745-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-06-28 20:37 GMT-07:00  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Added set acl function. Very similar to set cifs acl function for smb1.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>  fs/cifs/smb2ops.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++=
++----
>  1 file changed, 61 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 6b1ef79..490737c 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1369,6 +1369,63 @@ static bool smb2_set_sparse(const unsigned int xid=
, struct cifs_tcon *tcon,
>         return pntsd;
>  }
>
> +#ifdef CONFIG_CIFS_ACL
> +int
> +set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
> +               struct inode *inode, const char *path, int aclflag)
> +{
> +       u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> +       unsigned int xid;
> +       int rc, access_flags, create_options =3D 0;
> +       struct cifs_tcon *tcon;
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +       struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> +       struct cifs_fid fid;
> +       struct cifs_open_parms oparms;
> +       __le16 *utf16_path;
> +
> +       cifs_dbg(FYI, "set smb3 acl for path %s\n", path);
> +       if (IS_ERR(tlink))
> +               return PTR_ERR(tlink);
> +
> +       tcon =3D tlink_tcon(tlink);
> +       xid =3D get_xid();
> +
> +       if (backup_cred(cifs_sb))
> +               oparms.create_options |=3D CREATE_OPEN_BACKUP_INTENT;

The above should be fixed to oparms.create_options =3D CREATE_OPEN_BACKUP_I=
NTENT for the backup cred case and initialized to 0 otherwise.

> +
> +       if (aclflag =3D=3D CIFS_ACL_OWNER || aclflag =3D=3D CIFS_ACL_GROU=
P)
> +               access_flags =3D WRITE_OWNER;
> +       else
> +               access_flags =3D WRITE_DAC;
> +
> +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (!utf16_path)
> +               return -ENOMEM;
> +
> +       oparms.tcon =3D tcon;
> +       oparms.desired_access =3D access_flags;
> +       oparms.create_options =3D create_options;
> +       oparms.disposition =3D FILE_OPEN;
> +       oparms.path =3D path;
> +       oparms.fid =3D &fid;
> +       oparms.reconnect =3D false;
> +
> +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
> +       kfree(utf16_path);
> +       if (!rc) {
> +               rc =3D SMB2_set_acl(xid, tlink_tcon(tlink), fid.persisten=
t_fid,
> +                           fid.volatile_fid, pnntsd, acllen, aclflag);
> +               SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fi=
d);
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
> @@ -2495,7 +2552,7 @@ struct smb_version_operations smb20_operations =3D =
{
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> -/*     .set_acl =3D set_smb3_acl, */
> +       .set_acl =3D set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2584,7 +2641,7 @@ struct smb_version_operations smb21_operations =3D =
{
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> -/*     .set_acl =3D set_smb3_acl, */
> +       .set_acl =3D set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2683,7 +2740,7 @@ struct smb_version_operations smb30_operations =3D =
{
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> -/*     .set_acl =3D set_smb3_acl, */
> +       .set_acl =3D set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>
> @@ -2783,7 +2840,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>  #ifdef CONFIG_CIFS_ACL
>         .get_acl =3D get_smb2_acl,
>         .get_acl_by_fid =3D get_smb2_acl_by_fid,
> -/*     .set_acl =3D set_smb3_acl, */
> +       .set_acl =3D set_smb2_acl,
>  #endif /* CIFS_ACL */
>  };
>  #endif /* CIFS_SMB311 */
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Other than the comment above, the patch looks correct.

--
Best regards,
Pavel Shilovsky
