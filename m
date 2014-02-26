From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow mounts with restricted intermediate paths
 (try #2)
Date: Wed, 26 Feb 2014 16:24:47 -0600
Message-ID: <CADT32e+Weu17z=zyPvxdGTdWajffty6Xb0RyktmPofs2Bn=UMw@mail.gmail.com>
References: <1393444448-10428-1-git-send-email-spargaonkar@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393444448-10428-1-git-send-email-spargaonkar-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Still not good enough for noserverino kind of server, looking into that.


On Wed, Feb 26, 2014 at 1:54 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
>
>
> Allow mounts with intermediate paths without access.
>
> Create an anonymous root dentry for a vfsmount with an inode obtained
> via path info if any of the intermediate path entries are not accessible
> with EACCES error.
>
> If this dentry becomes accessible via other mounts, splice this
> anonymous root dentry (and the subtree under it) at the appropriate
> place in that mount.
>
>
> Reference: Samba bugzilla 6950
>
> Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c | 25 +++++++++++++++++++++++--
>  fs/cifs/dir.c    | 18 ++++++++++++++----
>  fs/cifs/inode.c  |  6 ++++--
>  3 files changed, 41 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 849f613..35a7a80 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -584,9 +584,12 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>         char *full_path = NULL;
>         char *s, *p;
>         char sep;
> +       int rc;
> +       unsigned int xid;
> +       struct inode *rinode = NULL;
> +       struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>
> -       full_path = cifs_build_path_to_root(vol, cifs_sb,
> -                                           cifs_sb_master_tcon(cifs_sb));
> +       full_path = cifs_build_path_to_root(vol, cifs_sb, tcon);
>         if (full_path == NULL)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -627,6 +630,24 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>                 dput(dentry);
>                 dentry = child;
>         } while (!IS_ERR(dentry));
> +       if (IS_ERR(dentry) && (PTR_ERR(dentry) == -EACCES) && *s) {
> +               xid = get_xid();
> +               if (tcon->unix_ext) {
> +                       rc = cifs_get_inode_info_unix(&rinode, full_path,
> +                                                       sb, xid);
> +               } else {
> +                       rc = cifs_get_inode_info(&rinode, full_path, NULL,
> +                                                       sb, xid, NULL);
> +               }
> +               free_xid(xid);
> +
> +               if ((rc == 0) && (rinode != NULL)) {
> +                       dentry = d_obtain_alias(rinode);
> +                       if (IS_ERR(dentry))
> +                               iput(rinode);
> +               }
> +       }
> +
>         kfree(full_path);
>         return dentry;
>  }
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 3db0c5f..7eb8ccc 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -702,6 +702,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>         struct cifs_tcon *pTcon;
>         struct inode *newInode = NULL;
>         char *full_path = NULL;
> +       struct dentry *ret = NULL;
>
>         xid = get_xid();
>
> @@ -748,11 +749,19 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>         }
>
>         if ((rc == 0) && (newInode != NULL)) {
> -               d_add(direntry, newInode);
>                 /* since paths are not looked up by component - the parent
>                    directories are presumed to be good here */
> -               renew_parental_timestamps(direntry);
> -
> +               ret = d_splice_alias(newInode, direntry);
> +               if (!ret)
> +                       renew_parental_timestamps(direntry);
> +               else {
> +                       if (!IS_ERR(ret)) {
> +                               renew_parental_timestamps(direntry);
> +                               dput(ret);
> +                               goto lookup_out;
> +                       } else
> +                               rc = PTR_ERR(ret);
> +               }
>         } else if (rc == -ENOENT) {
>                 rc = 0;
>                 direntry->d_time = jiffies;
> @@ -764,12 +773,13 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>                 /* We special case check for Access Denied - since that
>                 is a common return code */
>         }
> +       ret = ERR_PTR(rc);
>
>  lookup_out:
>         kfree(full_path);
>         cifs_put_tlink(tlink);
>         free_xid(xid);
> -       return ERR_PTR(rc);
> +       return ret;
>  }
>
>  static int
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index aadc2b6..00006ab 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -885,8 +885,10 @@ inode_has_hashed_dentries(struct inode *inode)
>         spin_lock(&inode->i_lock);
>         hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
>                 if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
> -                       spin_unlock(&inode->i_lock);
> -                       return true;
> +                       if (!(dentry->d_flags & DCACHE_DISCONNECTED)) {
> +                               spin_unlock(&inode->i_lock);
> +                               return true;
> +                       }
>                 }
>         }
>         spin_unlock(&inode->i_lock);
> --
> 1.8.3.2
>
