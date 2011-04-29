From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] CIFS: Migrate from prefixpath logic
Date: Fri, 29 Apr 2011 11:17:20 -0400
Message-ID: <20110429111720.1f3a49d8@corrin.poochiereds.net>
References: <1302850916-13947-1-git-send-email-piastry@etersoft.ru>
	<1302850916-13947-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302850916-13947-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 15 Apr 2011 11:01:55 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Now we point superblock to a server share root and set a root dentry
> appropriately. This let us share superblock between mounts like
> //server/sharename/foo/bar and //server/sharename/foo further.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    2 -
>  fs/cifs/cifsfs.c     |   95 +++++++++++++++++++++++++++++++++++-
>  fs/cifs/cifsglob.h   |   76 +++++++++++++++++++++++++++++
>  fs/cifs/cifsproto.h  |    5 +-
>  fs/cifs/connect.c    |  129 ++------------------------------------------------
>  fs/cifs/dir.c        |    7 +--
>  fs/cifs/inode.c      |   15 +++---
>  7 files changed, 186 insertions(+), 143 deletions(-)
> 
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index adecd36..a18ba37 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -58,8 +58,6 @@ struct cifs_sb_info {
>  	mode_t	mnt_file_mode;
>  	mode_t	mnt_dir_mode;
>  	unsigned int mnt_cifs_flags;
> -	int	prepathlen;
> -	char   *prepath; /* relative path under the share to mount to */
>  	char   *mountdata; /* options received at mount time or via DFS refs */
>  	struct backing_dev_info bdi;
>  	struct delayed_work prune_tlinks;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3227db6..44394c8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -434,8 +434,6 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
>  		seq_printf(s, ",nocase");
>  	if (tcon->retry)
>  		seq_printf(s, ",hard");
> -	if (cifs_sb->prepath)
> -		seq_printf(s, ",prepath=%s", cifs_sb->prepath);
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
>  		seq_printf(s, ",posixpaths");
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
> @@ -549,6 +547,92 @@ static const struct super_operations cifs_super_ops = {
>  #endif
>  };
>  
> +/*
> + * Get root dentry from superblock according to prefix path mount option.
> + * Return dentry with refcount + 1 on success and NULL otherwise.
> + */
> +static struct dentry *
> +cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> +{
> +	int xid, rc;
> +	struct inode *inode;
> +	struct qstr name;
> +	struct dentry *dparent = NULL, *dchild = NULL;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> +	unsigned int i, full_len, len;
> +	char *full_path = NULL, *pstart;
> +	char sep;
> +
> +	full_path = cifs_build_path_to_root(vol, cifs_sb,
> +					    cifs_sb_master_tcon(cifs_sb));
> +	if (full_path == NULL)
> +		return NULL;
> +
> +	cFYI(1, "Get root dentry for %s", full_path);
> +
> +	xid = GetXid();
> +	sep = CIFS_DIR_SEP(cifs_sb);
> +	dparent = dget(sb->s_root);
> +	full_len = strlen(full_path);
> +	full_path[full_len] = sep;
> +	pstart = full_path + 1;
> +
> +	for (i = 1, len = 0; i <= full_len; i++) {
> +		if (full_path[i] != sep || !len) {
> +			len++;
> +			continue;
> +		}
> +
> +		full_path[i] = 0;
> +		cFYI(1, "get dentry for %s", pstart);
> +
> +		name.name = pstart;
> +		name.len = len;
> +		name.hash = full_name_hash(pstart, len);
> +		dchild = d_lookup(dparent, &name);
> +		if (dchild == NULL) {
> +			cFYI(1, "not exists");
> +			dchild = d_alloc(dparent, &name);
> +			if (dchild == NULL) {
> +				dput(dparent);
> +				dparent = NULL;
> +				goto out;
> +			}
> +		}
> +
> +		cFYI(1, "get inode");
> +		if (dchild->d_inode == NULL) {
> +			cFYI(1, "not exists");
> +			inode = NULL;
> +			if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> +				rc = cifs_get_inode_info_unix(&inode, full_path,
> +							      sb, xid);
> +			else
> +				rc = cifs_get_inode_info(&inode, full_path,
> +							 NULL, sb, xid, NULL);
> +			if (rc) {
> +				dput(dchild);
> +				dput(dparent);
> +				dparent = NULL;
> +				goto out;
> +			}
> +			d_add(dchild, inode);
			^^^^^^
			Is this racy? Could another dentry have been
			added between the time that you did the initial
			lookup and here? I think there are functions
			that guard against that possibility.
			d_materialise_unique maybe?

> +		}
> +		cFYI(1, "parent %p, child %p", dparent, dchild);
> +
> +		dput(dparent);
> +		dparent = dchild;
> +		len = 0;
> +		pstart = full_path + i + 1;
> +		full_path[i] = sep;
> +	}
> +out:
> +	_FreeXid(xid);
> +	full_path[full_len] = 0;
	^^^ that's unnecessary, you free this just afterward.

> +	kfree(full_path);
> +	return dparent;
> +}
> +
>  static struct dentry *
>  cifs_do_mount(struct file_system_type *fs_type,
>  	      int flags, const char *dev_name, void *data)
> @@ -603,7 +687,12 @@ cifs_do_mount(struct file_system_type *fs_type,
>  
>  	sb->s_flags |= MS_ACTIVE;
>  
> -	root = dget(sb->s_root);
> +	root = cifs_get_root(volume_info, sb);
> +	if (root == NULL) {
> +		kfree(copied_data);
> +		goto err_out;
> +	}
> +	cFYI(1, "dentry root is: %p", root);
>  out:
>  	cifs_cleanup_volume_info(&volume_info);
>  	return root;

[...]

> @@ -887,16 +887,17 @@ struct inode *cifs_root_iget(struct super_block *sb)
>  	char *full_path;
>  	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>  
> -	full_path = cifs_build_path_to_root(cifs_sb, tcon);
> +	full_path = kmalloc(1, GFP_KERNEL);
>  	if (full_path == NULL)
>  		return ERR_PTR(-ENOMEM);
> +	full_path[0] = 0;
>  

Don't kmalloc 1 byte, just pass "" or do it on the stack instead.

>  	xid = GetXid();
>  	if (tcon->unix_ext)
>  		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
>  	else
> -		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
> -						xid, NULL);
> +		rc = cifs_get_inode_info(&inode, full_path, NULL, sb, xid,
> +					 NULL);
>  
>  	if (!inode) {
>  		inode = ERR_PTR(rc);


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
