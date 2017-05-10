From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cifsacl: Use a temporary ops variable to reduce
 code length
Date: Tue, 9 May 2017 23:26:25 -0500
Message-ID: <CADT32eKcAAa9ORxf1OLL-+ju_XhSevb5d44=N7m6ngsbwuZ_rQ@mail.gmail.com>
References: <35756168f871fb4f8149153f6e5b85352de3166b.1494145833.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35756168f871fb4f8149153f6e5b85352de3166b.1494145833.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, May 7, 2017 at 3:31 AM, Joe Perches via samba-technical
<samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org> wrote:
> Create an ops variable to store tcon->ses->server->ops and cache
> indirections and reduce code size a trivial bit.
>
> $ size fs/cifs/cifsacl.o*
>    text    data     bss     dec     hex filename
>    5338     136       8    5482    156a fs/cifs/cifsacl.o.new
>    5371     136       8    5515    158b fs/cifs/cifsacl.o.old
>
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 15bac390dff9..b98436f5c7c7 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1135,20 +1135,19 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>         u32 acllen = 0;
>         int rc = 0;
>         struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> -       struct cifs_tcon *tcon;
> +       struct smb_version_operations *ops;
>
>         cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
>
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
> -       tcon = tlink_tcon(tlink);
>
> -       if (pfid && (tcon->ses->server->ops->get_acl_by_fid))
> -               pntsd = tcon->ses->server->ops->get_acl_by_fid(cifs_sb, pfid,
> -                                                         &acllen);
> -       else if (tcon->ses->server->ops->get_acl)
> -               pntsd = tcon->ses->server->ops->get_acl(cifs_sb, inode, path,
> -                                                       &acllen);
> +       ops = tlink_tcon(tlink)->ses->server->ops;
> +
> +       if (pfid && (ops->get_acl_by_fid))
> +               pntsd = ops->get_acl_by_fid(cifs_sb, pfid, &acllen);
> +       else if (ops->get_acl)
> +               pntsd = ops->get_acl(cifs_sb, inode, path, &acllen);
>         else {
>                 cifs_put_tlink(tlink);
>                 return -EOPNOTSUPP;
> @@ -1181,23 +1180,23 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
>         struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
>         struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>         struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> -       struct cifs_tcon *tcon;
> +       struct smb_version_operations *ops;
>
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
> -       tcon = tlink_tcon(tlink);
> +
> +       ops = tlink_tcon(tlink)->ses->server->ops;
>
>         cifs_dbg(NOISY, "set ACL from mode for %s\n", path);
>
>         /* Get the security descriptor */
>
> -       if (tcon->ses->server->ops->get_acl == NULL) {
> +       if (ops->get_acl == NULL) {
>                 cifs_put_tlink(tlink);
>                 return -EOPNOTSUPP;
>         }
>
> -       pntsd = tcon->ses->server->ops->get_acl(cifs_sb, inode, path,
> -                                               &secdesclen);
> +       pntsd = ops->get_acl(cifs_sb, inode, path, &secdesclen);
>         if (IS_ERR(pntsd)) {
>                 rc = PTR_ERR(pntsd);
>                 cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
> @@ -1224,13 +1223,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
>
>         cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
>
> -       if (tcon->ses->server->ops->set_acl == NULL)
> +       if (ops->set_acl == NULL)
>                 rc = -EOPNOTSUPP;
>
>         if (!rc) {
>                 /* Set the security descriptor */
> -               rc = tcon->ses->server->ops->set_acl(pnntsd, secdesclen, inode,
> -                                                    path, aclflag);
> +               rc = ops->set_acl(pnntsd, secdesclen, inode, path, aclflag);
>                 cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
>         }
>         cifs_put_tlink(tlink);
> --
> 2.10.0.rc2.1.g053435c
>
>
