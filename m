From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] retrieving CIFS ACLs when mounted with SMB2 fails,
 dropping session
Date: Sun, 2 Feb 2014 22:41:54 -0600
Message-ID: <CAH2r5mtSAZfiqCZ9_=wvLCmFO-m0Zz90wTNy301BSLeCZY1tbQ@mail.gmail.com>
References: <CAH2r5msK3t2atR5TcaYJcst91HdTPVZnof9N9_byEt4VR6aVHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msK3t2atR5TcaYJcst91HdTPVZnof9N9_byEt4VR6aVHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish noted the following general suggestion about the way we check
for protocol specific operations

"Another idea would be perhaps to have a get_cifs_acl/set_cifs_acl ops
for respective smb version and them returning EOPNOSUPP error
until they are coded, so an if check for any op could be saved/skipped."

(This could apply to any protocol specific operation)

On Sun, Feb 2, 2014 at 10:40 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From 1c8b653d63c451a57a41a8134d3d07b9210e1d16 Mon Sep 17 00:00:00 2001
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Sun, 2 Feb 2014 22:25:41 -0600
> Subject: [PATCH] [CIFS] retrieving CIFS ACLs when mounted with SMB2 fails
>  dropping session
>
> The get/set ACL xattr support for CIFS ACLs attempts to send old
> cifs dialect protocol requests even when mounted with SMB2 or later
> dialects.  So e.g. mounting with cifacl and vers=2.1 will hang until
> the server drops the session due to the illegal request the
> client sends.
>
> This patch makes CIFS ACL operations protocol specific to fix that.
>
> Attempting to query/set CIFS ACLs for SMB2 will now return
> EOPNOTSUPP (until we add worker routines for sending query
> ACL requests via SMB2) instead of sending invalid (cifs)
> requests.
>
> A separate followon patch will be done to fix cifs_acl_to_fattr
> (which takes a cifs specific u16 fid so can't be abstracted
> to work with SMB2 until that is changed).
>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c  | 28 ++++++++++++++++++++++++----
>  fs/cifs/cifsglob.h |  4 ++++
>  fs/cifs/smb1ops.c  |  4 ++++
>  fs/cifs/xattr.c    | 15 +++++++++++----
>  4 files changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 8f9b4f7..7efdb7f 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1043,15 +1043,30 @@ id_mode_to_cifs_acl(struct inode *inode, const
> char *path, __u64 nmode,
>      __u32 secdesclen = 0;
>      struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
>      struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
> +    struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> +    struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> +    struct cifs_tcon tcon;
> +
> +    if (IS_ERR(tlink))
> +        return PTR_ERR(tlink);
> +    tcon = tlink_tcon(tlink);
>
>      cifs_dbg(NOISY, "set ACL from mode for %s\n", path);
>
>      /* Get the security descriptor */
> -    pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
> +
> +    if (tcon->ses->server->ops->get_acl == NULL) {
> +        cifs_put_tlink(tlink);
> +        return -EOPNOTSUPP;
> +    }
> +
> +    pntsd = tcon->ses->server->ops->get_acl(cifs_sb, inode, path,
> +                        &secdesclen);
>      if (IS_ERR(pntsd)) {
>          rc = PTR_ERR(pntsd);
>          cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
> -        goto out;
> +        cifs_put_tlink(tlink);
> +        return rc;
>      }
>
>      /*
> @@ -1064,6 +1079,7 @@ id_mode_to_cifs_acl(struct inode *inode, const
> char *path, __u64 nmode,
>      pnntsd = kmalloc(secdesclen, GFP_KERNEL);
>      if (!pnntsd) {
>          kfree(pntsd);
> +        cifs_put_tlink(tlink);
>          return -ENOMEM;
>      }
>
> @@ -1072,14 +1088,18 @@ id_mode_to_cifs_acl(struct inode *inode, const
> char *path, __u64 nmode,
>
>      cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
>
> +    if (tcon->ses->server->ops->set_acl == NULL)
> +        rc = -EOPNOTSUPP;
> +
>      if (!rc) {
>          /* Set the security descriptor */
> -        rc = set_cifs_acl(pnntsd, secdesclen, inode, path, aclflag);
> +        rc = tcon->ses->server->ops->set_acl(pnntsd, secdesclen, inode,
> +                             path, aclflag);
>          cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
>      }
> +    cifs_put_tlink(tlink);
>
>      kfree(pnntsd);
>      kfree(pntsd);
> -out:
>      return rc;
>  }
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a245d18..a18391f 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -395,6 +395,10 @@ struct smb_version_operations {
>      int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
>              const char *, const void *, const __u16,
>              const struct nls_table *, int);
> +    int (*get_acl)(struct cifs_sb_info *, struct inode *, const char *,
> +            u32 *);
> +    int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
> +            int);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 3e4ff79..bfd66d8 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -1071,6 +1071,10 @@ struct smb_version_operations smb1_operations = {
>      .query_all_EAs = CIFSSMBQAllEAs,
>      .set_EA = CIFSSMBSetEA,
>  #endif /* CIFS_XATTR */
> +#ifdef CONFIG_CIFS_ACL
> +    .get_acl = get_cifs_acl,
> +    .set_acl = set_cifs_acl,
> +#endif /* CIFS_ACL */
>  };
>
>  struct smb_version_values smb1_values = {
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 95c43bb..b163dca 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -176,8 +176,12 @@ int cifs_setxattr(struct dentry *direntry, const
> char *ea_name,
>              rc = -ENOMEM;
>          } else {
>              memcpy(pacl, ea_value, value_size);
> -            rc = set_cifs_acl(pacl, value_size,
> -                direntry->d_inode, full_path, CIFS_ACL_DACL);
> +            if (pTcon->ses->server->ops->set_acl)
> +                rc = pTcon->set->server->ops->set_acl(pacl,
> +                        value_size, direntry->d_inode,
> +                        full_path, CIFS_ACL_DACL);
> +            else
> +                rc = -EOPNOTSUPP;
>              if (rc == 0) /* force revalidate of the inode */
>                  CIFS_I(direntry->d_inode)->time = 0;
>              kfree(pacl);
> @@ -323,8 +327,11 @@ ssize_t cifs_getxattr(struct dentry *direntry,
> const char *ea_name,
>              u32 acllen;
>              struct cifs_ntsd *pacl;
>
> -            pacl = get_cifs_acl(cifs_sb, direntry->d_inode,
> -                        full_path, &acllen);
> +            if (pTcon->ses->server->ops->get_acl == NULL)
> +                goto get_ea_exit; /* rc already EOPNOTSUPP */
> +
> +            pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
> +                    direntry->d_inode, full_path, &acllen);
>              if (IS_ERR(pacl)) {
>                  rc = PTR_ERR(pacl);
>                  cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
> --
> 1.8.5.3
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
