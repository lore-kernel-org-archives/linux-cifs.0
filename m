From: Ryan Johnson <chaplier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix =?utf-8?b?TlRfU1RBVFVTX0FDQ0VTUw==?= for moutn with prefixpath option
Date: Wed, 23 Apr 2014 19:27:05 +0000 (UTC)
Message-ID: <loom.20140423T205057-232@post.gmane.org>
References: <CAD4ZOMwcYFut0o8Krw-Z+tiGwz9VNvy4jRvwMcXv42P60pJxbg@mail.gmail.com> <1314306285-3787-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastry@...> writes:

> 
> Reorganize code and make it send qpath info request only for a full
> path (//server/share/prefixpath) rather than request for every path
> compoment. In this case we end up with negative dentries for all
> components except full one and we will instantiate them later if
> such a mount is requested.
> 
> Signed-off-by: Pavel Shilovsky <piastry@...>
> ---
>  fs/cifs/cifsfs.c  |  123
+++++++++++++++++++++++++++++++----------------------
>  fs/cifs/cifsfs.h  |    3 +-
>  fs/cifs/inode.c   |    7 ++-
>  fs/cifs/readdir.c |    9 +++-
>  4 files changed, 85 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 0435bb9..33a2e1e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
>  <at>  <at>  -95,14 +95,13  <at>  <at>  mempool_t *smb2_mid_poolp;
>  static struct kmem_cache *smb2_mid_cachep;
>  #endif /* CONFIG_CIFS_SMB2 */
> 
> -static int
> +static void
>  cifs_read_super(struct super_block *sb)
>  {
> -	struct inode *inode;
> -	struct cifs_sb_info *cifs_sb;
> -	int rc = 0;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> 
> -	cifs_sb = CIFS_SB(sb);
> +	/* BB should we make this contingent on mount parm? */
> +	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
> 
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
>  		sb->s_flags |= MS_POSIXACL;
>  <at>  <at>  -120,26 +119,6  <at>  <at>  cifs_read_super(struct
super_block *sb)
>  	sb->s_bdi = &cifs_sb->bdi;
>  	sb->s_blocksize = CIFS_MAX_MSGSIZE;
>  	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
> -	inode = cifs_root_iget(sb);
> -
> -	if (IS_ERR(inode)) {
> -		rc = PTR_ERR(inode);
> -		inode = NULL;
> -		goto out_no_root;
> -	}
> -
> -	sb->s_root = d_alloc_root(inode);
> -
> -	if (!sb->s_root) {
> -		rc = -ENOMEM;
> -		goto out_no_root;
> -	}
> -
> -	/* do that *after* d_alloc_root() - we want NULL ->d_op for root here */
> -	if (cifs_sb_master_tcon(cifs_sb)->nocase)
> -		sb->s_d_op = &cifs_ci_dentry_ops;
> -	else
> -		sb->s_d_op = &cifs_dentry_ops;
> 
>  #ifdef CIFS_NFSD_EXPORT
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>  <at>  <at>  -148,14 +127,7  <at>  <at>  cifs_read_super(struct
super_block *sb)
>  	}
>  #endif /* CIFS_NFSD_EXPORT */
> 
> -	return 0;
> -
> -out_no_root:
> -	cERROR(1, "cifs_read_super: get root inode failed");
> -	if (inode)
> -		iput(inode);
> -
> -	return rc;
> +	sb->s_flags |= MS_ACTIVE;
>  }
> 
>  static void cifs_kill_sb(struct super_block *sb)
>  <at>  <at>  -529,6 +501,17  <at>  <at>  static const struct
super_operations cifs_super_ops = {
>  #endif
>  };
> 
> +static struct dentry *
> +cifs_alloc_root(struct super_block *sb)
> +{
> +	struct qstr q;
> +
> +	q.name = "/";
> +	q.len = 1;
> +	q.hash = full_name_hash(q.name, q.len);
> +	return d_alloc_pseudo(sb, &q);
> +}
> +
>  /*
>   * Get root dentry from superblock according to prefix path mount option.
>   * Return dentry with refcount + 1 on success and NULL otherwise.
>  <at>  <at>  -536,8 +519,10  <at>  <at>  static const struct
super_operations cifs_super_ops = {
>  static struct dentry *
>  cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  {
> -	struct dentry *dentry;
> +	struct dentry *dentry, *found;
> +	struct inode *inode;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> +	struct qstr q;
>  	char *full_path = NULL;
>  	char *s, *p;
>  	char sep;
>  <at>  <at>  -550,13 +535,29  <at>  <at>  cifs_get_root(struct smb_vol
*vol, struct super_block *sb)
> 
>  	cFYI(1, "Get root dentry for %s", full_path);
> 
> +	if (!sb->s_root) {
> +		sb->s_root = cifs_alloc_root(sb);
> +		if (IS_ERR(sb->s_root)) {
> +			dentry = ERR_PTR(-ENOMEM);
> +			goto out;
> +		}
> +
> +		/*
> +		 * do that *after* cifs_alloc_root() - we want NULL ->d_op for
> +		 * root here
> +		 */
> +		if (cifs_sb_master_tcon(cifs_sb)->nocase)
> +			sb->s_d_op = &cifs_ci_dentry_ops;
> +		else
> +			sb->s_d_op = &cifs_dentry_ops;
> +	}
> +
>  	xid = GetXid();
>  	sep = CIFS_DIR_SEP(cifs_sb);
>  	dentry = dget(sb->s_root);
>  	p = s = full_path;
> 
>  	do {
> -		struct inode *dir = dentry->d_inode;
>  		struct dentry *child;
> 
>  		/* skip separators */
>  <at>  <at>  -569,16 +570,45  <at>  <at>  cifs_get_root(struct smb_vol
*vol, struct super_block *sb)
>  		while (*s && *s != sep)
>  			s++;
> 
> -		mutex_lock(&dir->i_mutex);
> -		child = lookup_one_len(p, dentry, s - p);
> -		mutex_unlock(&dir->i_mutex);
> +		q.name = p;
> +		q.len = s - p;
> +		if (dentry->d_flags & DCACHE_OP_HASH)
> +			dentry->d_op->d_hash(dentry, dentry->d_inode, &q);
> +		else
> +			q.hash = full_name_hash(q.name, q.len);
> +
> +		child = d_lookup(dentry, &q);
> +		if (!child) {
> +			child = d_alloc(dentry, &q);
> +			if (IS_ERR(child)) {
> +				dput(dentry);
> +				dentry = ERR_CAST(child);
> +				break;
> +			}
> +			d_rehash(child);
> +		}
>  		dput(dentry);
>  		dentry = child;
> -		if (!dentry->d_inode) {
> +	} while (!IS_ERR(dentry));
> +
> +	if (IS_ERR(dentry))
> +		goto out;
> +
> +	if (!dentry->d_inode) {
> +		inode = cifs_mntroot_iget(sb, full_path);
> +		if (IS_ERR(inode)) {
>  			dput(dentry);
> -			dentry = ERR_PTR(-ENOENT);
> +			dentry = ERR_CAST(inode);
> +			goto out;
>  		}
> -	} while (!IS_ERR(dentry));
> +
> +		found = d_instantiate_unique(dentry, inode);
> +		if (found) {
> +			dput(dentry);
> +			dentry = dget(found);
> +		}
> +	}
> +out:
>  	_FreeXid(xid);
>  	kfree(full_path);
>  	return dentry;
>  <at>  <at>  -646,16 +676,7  <at>  <at>  cifs_do_mount(struct
file_system_type *fs_type,
>  		cifs_umount(cifs_sb);
>  	} else {
>  		sb->s_flags = flags;
> -		/* BB should we make this contingent on mount parm? */
> -		sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
> -
> -		rc = cifs_read_super(sb);
> -		if (rc) {
> -			root = ERR_PTR(rc);
> -			goto out_super;
> -		}
> -
> -		sb->s_flags |= MS_ACTIVE;
> +		cifs_read_super(sb);
>  	}
> 
>  	root = cifs_get_root(volume_info, sb);
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 3145c18..47d9ec9 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
>  <at>  <at>  -43,7 +43,8  <at>  <at>  extern const struct
address_space_operations cifs_addr_ops_smallbuf;
> 
>  /* Functions related to inodes */
>  extern const struct inode_operations cifs_dir_inode_ops;
> -extern struct inode *cifs_root_iget(struct super_block *);
> +extern struct inode *cifs_mntroot_iget(struct super_block *sb,
> +				       const char *full_path);
>  extern int cifs_create(struct inode *, struct dentry *, int,
>  		       struct nameidata *);
>  extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index aee0c0b..dedfed3 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
>  <at>  <at>  -931,7 +931,7  <at>  <at>  retry_iget5_locked:
>  }
> 
>  /* gets root inode */
> -struct inode *cifs_root_iget(struct super_block *sb)
> +struct inode *cifs_mntroot_iget(struct super_block *sb, const char
*full_path)
>  {
>  	int xid;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  <at>  <at>  -941,9 +941,10  <at>  <at>  struct inode
*cifs_root_iget(struct super_block *sb)
> 
>  	xid = GetXid();
>  	if (tcon->unix_ext)
> -		rc = cifs_get_inode_info_unix(&inode, "", sb, xid);
> +		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
>  	else
> -		rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
> +		rc = cifs_get_inode_info(&inode, full_path, NULL, sb, xid,
> +					 NULL);
> 
>  	if (!inode) {
>  		inode = ERR_PTR(rc);
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 75e8b5c..7475cba 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
>  <at>  <at>  -708,6 +708,7  <at>  <at>  int cifs_readdir(struct file
*file, void *direntry, filldir_t filldir)
>  	char *tmp_buf = NULL;
>  	char *end_of_smb;
>  	unsigned int max_len;
> +	ino_t ino;
> 
>  	xid = GetXid();
> 
>  <at>  <at>  -732,8 +733,12  <at>  <at>  int cifs_readdir(struct file
*file, void *direntry, filldir_t filldir)
>  		}
>  		file->f_pos++;
>  	case 1:
> -		if (filldir(direntry, "..", 2, file->f_pos,
> -		     parent_ino(file->f_path.dentry), DT_DIR) < 0) {
> +		if (!file->f_path.dentry->d_parent->d_inode) {
> +			cFYI(1, "parent dir is negative, filling as current");
> +			ino = file->f_path.dentry->d_inode->i_ino;
> +		} else
> +			ino = parent_ino(file->f_path.dentry);
> +		if (filldir(direntry, "..", 2, file->f_pos, ino, DT_DIR) < 0) {
>  			cERROR(1, "Filldir for parent dir failed");
>  			rc = -ENOMEM;
>  			break;


Hi Pavel & CIFS developers,

Thank you for this patch. Presently, this is the the only way I can access
certain shares (on a windows server) at my organization. It is a
security-concerned organization so permissions are denied for any directory
where they are not explicitly needed, which leads to this issue.

Most of the Linux and Mac users at my organization now use Windows VMs or
older kernel/OS versions to access these shares. I have been using your
patch and modifying it to work with each Linux (Ubuntu) kernel version.

I thought I might as well post my latest modification of your patch, which
has worked for me for kernels 3.11 and 3.13. Is there any chance that this
issue will be addressed in an official version of CIFS in the future?

Here is the patch:

<BEGIN PATCH>
diff -uNr a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c	2014-01-19 11:10:51.000000000 -0500
+++ b/fs/cifs/cifsfs.c	2014-01-14 14:33:30.137967187 -0500
@@ -115,15 +115,14 @@
 		deactivate_super(sb);
 }
 
-static int
+static void
 cifs_read_super(struct super_block *sb)
 {
-	struct inode *inode;
-	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	int rc = 0;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cifs_sb = CIFS_SB(sb);
+	/* BB should we make this contingent on mount parm? */
+	sb->s_flags |= MS_NODIRATIME | MS_NOATIME;
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
@@ -142,23 +141,6 @@
 	sb->s_bdi = &cifs_sb->bdi;
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
-	inode = cifs_root_iget(sb);
-
-	if (IS_ERR(inode)) {
-		rc = PTR_ERR(inode);
-		goto out_no_root;
-	}
-
-	if (tcon->nocase)
-		sb->s_d_op = &cifs_ci_dentry_ops;
-	else
-		sb->s_d_op = &cifs_dentry_ops;
-
-	sb->s_root = d_make_root(inode);
-	if (!sb->s_root) {
-		rc = -ENOMEM;
-		goto out_no_root;
-	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
@@ -167,11 +149,7 @@
 	}
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
 
-	return 0;
-
-out_no_root:
-	cifs_dbg(VFS, "%s: get root inode failed\n", __func__);
-	return rc;
+	sb->s_flags |= MS_ACTIVE;
 }
 
 static void cifs_kill_sb(struct super_block *sb)
@@ -556,6 +534,17 @@
 #endif
 };
 
+static struct dentry *
+cifs_alloc_root(struct super_block *sb)
+{
+	struct qstr q;
+
+	q.name = "/";
+	q.len = 1;
+	q.hash = full_name_hash(q.name, q.len);
+	return d_alloc_pseudo(sb, &q);
+}
+
 /*
  * Get root dentry from superblock according to prefix path mount option.
  * Return dentry with refcount + 1 on success and NULL otherwise.
@@ -563,8 +552,10 @@
 static struct dentry *
 cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 {
-	struct dentry *dentry;
+	struct dentry *dentry, *found;
+	struct inode *inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct qstr q;
 	char *full_path = NULL;
 	char *s, *p;
 	char sep;
@@ -576,25 +567,30 @@
 
 	cifs_dbg(FYI, "Get root dentry for %s\n", full_path);
 
+	if (!sb->s_root) {
+		sb->s_root = cifs_alloc_root(sb);
+		if (IS_ERR(sb->s_root)) {
+			dentry = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+
+		/*
+		 * do that *after* cifs_alloc_root() - we want NULL ->d_op for
+		 * root here
+		 */
+		if (cifs_sb_master_tcon(cifs_sb)->nocase)
+			sb->s_d_op = &cifs_ci_dentry_ops;
+		else
+			sb->s_d_op = &cifs_dentry_ops;
+	}
+
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
 	p = s = full_path;
 
 	do {
-		struct inode *dir = dentry->d_inode;
 		struct dentry *child;
 
-		if (!dir) {
-			dput(dentry);
-			dentry = ERR_PTR(-ENOENT);
-			break;
-		}
-		if (!S_ISDIR(dir->i_mode)) {
-			dput(dentry);
-			dentry = ERR_PTR(-ENOTDIR);
-			break;
-		}
-
 		/* skip separators */
 		while (*s == sep)
 			s++;
@@ -605,12 +601,44 @@
 		while (*s && *s != sep)
 			s++;
 
-		mutex_lock(&dir->i_mutex);
-		child = lookup_one_len(p, dentry, s - p);
-		mutex_unlock(&dir->i_mutex);
+		q.name = p;
+		q.len = s - p;
+		if (dentry->d_flags & DCACHE_OP_HASH)
+			dentry->d_op->d_hash(dentry, &q);
+		else
+			q.hash = full_name_hash(q.name, q.len);
+
+		child = d_lookup(dentry, &q);
+		if (!child) {
+			child = d_alloc(dentry, &q);
+			if (IS_ERR(child)) {
+				dput(dentry);
+				dentry = ERR_CAST(child);
+				break;
+			}
+			d_rehash(child);
+		}
 		dput(dentry);
 		dentry = child;
 	} while (!IS_ERR(dentry));
+
+	if (IS_ERR(dentry))
+		goto out;
+
+	if (!dentry->d_inode) {
+		inode = cifs_mntroot_iget(sb, full_path);
+		if (IS_ERR(inode)) {
+			dput(dentry);
+			dentry = ERR_CAST(inode);
+			goto out;
+ 		}
+		found = d_instantiate_unique(dentry, inode);
+		if (found) {
+			dput(dentry);
+			dentry = dget(found);
+		}
+	}
+out:
 	kfree(full_path);
 	return dentry;
 }
@@ -680,13 +708,8 @@
 		cifs_dbg(FYI, "Use existing superblock\n");
 		cifs_umount(cifs_sb);
 	} else {
-		rc = cifs_read_super(sb);
-		if (rc) {
-			root = ERR_PTR(rc);
-			goto out_super;
-		}
-
-		sb->s_flags |= MS_ACTIVE;
+		sb->s_flags = flags;
+		cifs_read_super(sb);
 	}
 
 	root = cifs_get_root(volume_info, sb);
diff -uNr a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h	2013-09-02 16:46:10.000000000 -0400
+++ b/fs/cifs/cifsfs.h	2014-01-14 13:22:23.865874718 -0500
@@ -47,7 +47,7 @@
 
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
-extern struct inode *cifs_root_iget(struct super_block *);
+extern struct inode *cifs_mntroot_iget(struct super_block *sb, const char
*full_path);
 extern int cifs_create(struct inode *, struct dentry *, umode_t,
 		       bool excl);
 extern int cifs_atomic_open(struct inode *, struct dentry *,
diff -uNr a/fs/cifs/inode.c b/fs/cifs/inode.c
--- a/fs/cifs/inode.c	2013-09-02 16:46:10.000000000 -0400
+++ b/fs/cifs/inode.c	2014-01-14 13:22:23.865874718 -0500
@@ -883,7 +883,7 @@
 }
 
 /* gets root inode */
-struct inode *cifs_root_iget(struct super_block *sb)
+struct inode *cifs_mntroot_iget(struct super_block *sb, const char *full_path)
 {
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -893,9 +893,10 @@
 
 	xid = get_xid();
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&inode, "", sb, xid);
+		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
-		rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
+		rc = cifs_get_inode_info(&inode, full_path, NULL, sb, xid,
+					 NULL);
 
 	if (!inode) {
 		inode = ERR_PTR(rc);
diff -uNr a/fs/cifs/readdir.c b/fs/cifs/readdir.c
--- a/fs/cifs/readdir.c	2013-09-02 16:46:10.000000000 -0400
+++ b/fs/cifs/readdir.c	2014-01-18 21:01:00.644310932 -0500
@@ -794,6 +794,7 @@
 	char *tmp_buf = NULL;
 	char *end_of_smb;
 	unsigned int max_len;
+	ino_t ino;
 
 	xid = get_xid();
 
@@ -808,8 +809,30 @@
 			goto rddir2_exit;
 	}
 
-	if (!dir_emit_dots(file, ctx))
-		goto rddir2_exit;
+	//	if (!dir_emit_dots(file, ctx))
+	//	goto rddir2_exit;
+
+	//Need to edit the process in dir_emit_dots in include/linux/fs.h
+	//That function is copied here and edited. The original call to 
+	//dir_emit_dots is removed.
+
+	if (ctx->pos == 0) {
+		if (!dir_emit_dot(file, ctx))
+			goto rddir2_exit;
+		ctx->pos = 1;
+	}
+	if (ctx->pos == 1) {
+		if (!file->f_path.dentry->d_parent->d_inode) {
+			ino = file->f_path.dentry->d_inode->i_ino;
+			if(!(ctx->actor(ctx, "..", 2, ctx->pos, ino, DT_DIR) == 0))
+				goto rddir2_exit;
+		}
+		else {
+			if (!dir_emit_dotdot(file, ctx))
+				goto rddir2_exit;
+		}
+		ctx->pos = 2;
+	}
 
 	/* 1) If search is active,
 		is in current search buffer?
<END PATCH>

Thanks,

-Ryan
