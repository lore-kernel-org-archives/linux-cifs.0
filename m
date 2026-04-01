Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B5F33ADAD
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065391; cv=none; b=lTvsyYyIA0kHBZ5eEFMpudFK9/Xf/0Z/YEC5qjxJI/rQ2+N2WimctTi+MPsxKUcY4aNUKH6ckAQh1F2BeFhh1sGnzBE71IhmTCf/3hkzKipy7VRGhkp3wDQv3zLoZrA2AXFe2duFmeDJp0GevZ27K4M7nPgqHV2zyKeahBliF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065391; c=relaxed/simple;
	bh=0ovmGX+k53TALqc7hdk5MH6wzH7QwfyqYv8foZPBUmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ThM0WMwhhgDZL/qFSr9+Y6me/TplJCccQH5q5Wi54omF1rf7lZKKgD6nevxOXa09EkTdaPz1Yv1P1/O8GNBCQrNcLcwGVkYgr2cpn/1yP/eZK4EMFHpViLIDvnQbaToSbXYGPlKg3Lc0x6KXxucYEPlfIv0sVPYsAH+BdCQUd0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=KtmwwJZP; arc=none smtp.client-ip=195.121.94.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="KtmwwJZP"
X-KPN-MessageId: 3ab2477f-2df2-11f1-969c-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 3ab2477f-2df2-11f1-969c-005056abbe64;
	Wed, 01 Apr 2026 19:43:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=aIgMXO1nYZEvchqQnA8WvV6en+uopyGZ80Wqy48vRF8=;
	b=KtmwwJZPVqedmo2XyQPL6Tlu1tGKRXMc3qPu1ZKN4r0DBBeuJiK7qhrkjQr0xdXVD36IAUJYVdSGq
	 0EgrNVWZwH8+FlZbAM0MNHb8QDRctEsniidAs3OrReIEmVOhmyYYq2Or2ArbwcD58tmfd5IPq7zH4M
	 StU8m/yCFmXOXAXoUuZe9Q67Ynw6ES9h1A2R5whRpSIFFwvIHEi73Q1ECG/E6UzEnFEh86jwgf9s3p
	 ON43wpUzZht5dPumNNhwR2JI3scpmocQiwg2Do0x+PnUc/D7lrHymkeLSrPnPheHDTxsAVNdtwRiQS
	 eQTtrLK1T9cwmR1AxxjZPOusttqai2w==
X-KPN-MID: 33|yvLE8dsE6EV8/cTCziX/cWMS+j3Um1jSLCeAhChZuzon8acsf7qFvLZ7I1ba4cC
 FqW7+KBnl/P3n7R6RAz8jSYcXc5cJ4ojm4n8LWuCqhzc=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|hLP8He2XqolwjK+0JJ4RhcOEpAT9ER1METPCi0SFBVph9NDu03fWiX2Hu6KinBG
 3L2HlKjeBPxoW1H7hlnL1hQ==
Received: from daedalus.home (unknown [178.227.141.37])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 37899aba-2df2-11f1-bdad-005056ab1411;
	Wed, 01 Apr 2026 19:43:01 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	linux-kernel@vger.kernel.org (open list),
	linux-cifs@vger.kernel.org (open list:KERNEL SMB3 SERVER (KSMBD))
Subject: [PATCH v2] vfs: replace ints with enum component_type for LAST_XXX
Date: Wed,  1 Apr 2026 19:43:03 +0200
Message-ID: <20260401174307.3887296-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several functions in namei.c take an "int *type" parameter, such as
filename_parentat(). To know what values this can take you have to find
the anonymous struct that defines the LAST_XXX values. I would argue
that the readability of the code is improved by making this an explicit
type.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>

---

v2: move back to LAST_XXX and change int to component_type in
fs/smb/server/vfs.c.

---
 fs/namei.c            | 41 ++++++++++++++++++++++-------------------
 fs/smb/server/vfs.c   |  5 +++--
 include/linux/namei.h |  4 ++--
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9e5500dad14f..a880454a6415 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -721,15 +721,15 @@ EXPORT_SYMBOL(path_put);
 
 #define EMBEDDED_LEVELS 2
 struct nameidata {
-	struct path	path;
-	struct qstr	last;
-	struct path	root;
-	struct inode	*inode; /* path.dentry.d_inode */
-	unsigned int	flags, state;
-	unsigned	seq, next_seq, m_seq, r_seq;
-	int		last_type;
-	unsigned	depth;
-	int		total_link_count;
+	struct path		path;
+	struct qstr		last;
+	struct path		root;
+	struct inode		*inode; /* path.dentry.d_inode */
+	unsigned int		flags, state;
+	unsigned		seq, next_seq, m_seq, r_seq;
+	enum component_type	last_type;
+	unsigned		depth;
+	int			total_link_count;
 	struct saved {
 		struct path link;
 		struct delayed_call done;
@@ -2221,7 +2221,7 @@ static struct dentry *follow_dotdot(struct nameidata *nd)
 	return dget(nd->path.dentry);
 }
 
-static const char *handle_dots(struct nameidata *nd, int type)
+static const char *handle_dots(struct nameidata *nd, enum component_type type)
 {
 	if (type == LAST_DOTDOT) {
 		const char *error = NULL;
@@ -2869,7 +2869,7 @@ static int path_parentat(struct nameidata *nd, unsigned flags,
 /* Note: this does not consume "name" */
 static int __filename_parentat(int dfd, struct filename *name,
 			       unsigned int flags, struct path *parent,
-			       struct qstr *last, int *type,
+			       struct qstr *last, enum component_type *type,
 			       const struct path *root)
 {
 	int retval;
@@ -2894,7 +2894,7 @@ static int __filename_parentat(int dfd, struct filename *name,
 
 static int filename_parentat(int dfd, struct filename *name,
 			     unsigned int flags, struct path *parent,
-			     struct qstr *last, int *type)
+			     struct qstr *last, enum component_type *type)
 {
 	return __filename_parentat(dfd, name, flags, parent, last, type, NULL);
 }
@@ -2963,7 +2963,8 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
 	struct path parent_path __free(path_put) = {};
 	struct dentry *d;
 	struct qstr last;
-	int type, error;
+	enum component_type type;
+	int error;
 
 	error = filename_parentat(dfd, name, 0, &parent_path, &last, &type);
 	if (error)
@@ -3009,7 +3010,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
 	CLASS(filename_kernel, filename)(name);
 	struct dentry *d;
 	struct qstr last;
-	int type, error;
+	enum component_type type;
+	int error;
 
 	error = filename_parentat(AT_FDCWD, filename, 0, &parent_path, &last, &type);
 	if (error)
@@ -3057,7 +3059,7 @@ EXPORT_SYMBOL(kern_path);
  * @root: pointer to struct path of the base directory
  */
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last, enum component_type *type,
 			   const struct path *root)
 {
 	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
@@ -4903,7 +4905,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	bool want_dir = lookup_flags & LOOKUP_DIRECTORY;
 	unsigned int reval_flag = lookup_flags & LOOKUP_REVAL;
 	unsigned int create_flags = LOOKUP_CREATE | LOOKUP_EXCL;
-	int type;
+	enum component_type type;
 	int error;
 
 	error = filename_parentat(dfd, name, reval_flag, path, &last, &type);
@@ -5365,7 +5367,7 @@ int filename_rmdir(int dfd, struct filename *name)
 	struct dentry *dentry;
 	struct path path;
 	struct qstr last;
-	int type;
+	enum component_type type;
 	unsigned int lookup_flags = 0;
 	struct delegated_inode delegated_inode = { };
 retry:
@@ -5383,6 +5385,7 @@ int filename_rmdir(int dfd, struct filename *name)
 	case LAST_ROOT:
 		error = -EBUSY;
 		goto exit2;
+	case LAST_NORM: ; // OK
 	}
 
 	error = mnt_want_write(path.mnt);
@@ -5507,7 +5510,7 @@ int filename_unlinkat(int dfd, struct filename *name)
 	struct dentry *dentry;
 	struct path path;
 	struct qstr last;
-	int type;
+	enum component_type type;
 	struct inode *inode;
 	struct delegated_inode delegated_inode = { };
 	unsigned int lookup_flags = 0;
@@ -6074,7 +6077,7 @@ int filename_renameat2(int olddfd, struct filename *from,
 	struct renamedata rd;
 	struct path old_path, new_path;
 	struct qstr old_last, new_last;
-	int old_type, new_type;
+	enum component_type old_type, new_type;
 	struct delegated_inode delegated_inode = { };
 	unsigned int lookup_flags = 0;
 	bool should_retry = false;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d08973b288e5..b12d481f5ba9 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -56,7 +56,8 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 {
 	struct qstr last;
 	const struct path *root_share_path = &share_conf->vfs_path;
-	int err, type;
+	int err;
+	enum component_type type;
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
@@ -668,7 +669,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	struct renamedata rd;
 	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	struct ksmbd_file *parent_fp;
-	int new_type;
+	enum component_type new_type;
 	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 58600cf234bc..fa3ae87762b7 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -16,7 +16,7 @@ enum { MAX_NESTED_LINKS = 8 };
 /*
  * Type of the last component on LOOKUP_PARENT
  */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
+enum component_type {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
 
 /* pathwalk mode */
 #define LOOKUP_FOLLOW		BIT(0)	/* follow links at the end */
@@ -70,7 +70,7 @@ static inline void end_removing_path(const struct path *path , struct dentry *de
 	end_creating_path(path, dentry);
 }
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last, enum component_type *type,
 			   const struct path *root);
 int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
 		    unsigned int, struct path *);
-- 
2.53.0

