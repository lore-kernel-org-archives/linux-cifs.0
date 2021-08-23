Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFF6C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC0461371
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhHWPPk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhHWPPk (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561AB61037;
        Mon, 23 Aug 2021 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731697;
        bh=sLgMSCU4TQEzDtl/ILh1EL/mNuK6PgjWt62QMIFXwyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4xOOY6+rKq8dtCwiLijZo8PchOupqZ6WlfkGasoXAltUkCpWw2CGeD4B+vNKyEuH
         jaUygl9iqWp8FO10ktz38s8dUwkl115+Cwobs1BO6of3Aeiifb9/E9pTuRLIWsORFB
         Mgtreatll8zBD+t6wz1xJOZEltMDYkSK+W7RaAHNlDELNlTWo8GedxYgHj0wGJbazu
         fwbeqFzg5L8aR2X7eEB4MoxauNRFVEA+yhNPpvdUNKzOini5vzT8iKMOYgelfgNFgQ
         YrYQFUJCJrTrJHa0ZdpECnSfZsJa52US+QUBz2WMSRHZqGJFx/jaEftOZpLCgLUuY8
         zKdt/FxB3S04Q==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 01/11] ksmbd: fix lookup on idmapped mounts
Date:   Mon, 23 Aug 2021 17:13:47 +0200
Message-Id: <20210823151357.471691-2-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10041; h=from:subject; bh=mLriL+uL5lvahZFk/oIqiDKHVUxUwYyPQwqwdcPD8AM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zbQXnRXsvRGseN2H51jUlPMuUWuPboguN+98dDj+zE3 1V1WdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk2JjhD/+ijdZTWTMehewufSXIvz MywuBw4gPWZ9eXeq8I36nlwc3wP2y1wdf3KV59vw/sNVKzPJ/kcm7T7IuTfxj47XUSlkkI5gUA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

It's great that the new in-kernel ksmbd server will support idmapped
mounts out of the box! However, lookup is currently broken. Lookup
helpers such as lookup_one_len() call inode_permission() internally to
ensure that the caller is privileged over the inode of the base dentry
they are trying to lookup under. So the permission checking here is
currently wrong.

Linux v5.15 will gain a new lookup helper lookup_one() that does take
idmappings into account. I've added it as part of my patch series to
make btrfs support idmapped mounts. The new helper is in linux-next as
part of David's (Sterba) btrfs for-next branch as commit
c972214c133b ("namei: add mapping aware lookup helper").

I've said it before during one of my first reviews: I would very much
recommend adding fstests to [1]. It already seems to have very
rudimentary cifs support. There is a completely generic idmapped mount
testsuite that supports idmapped mounts.

[1]: https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
- Colin Ian King <colin.king@canonical.com>:
  - Fix uninitialized variable warning.
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++++-------
 fs/ksmbd/vfs.c     | 43 ++++++++++++++++++++++++-------------------
 fs/ksmbd/vfs.h     |  3 ++-
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index d329ea49fa14..a400dd292af1 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3543,9 +3543,9 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			return -EINVAL;
 
 		lock_dir(priv->dir_fp);
-		dent = lookup_one_len(priv->d_info->name,
-				      priv->dir_fp->filp->f_path.dentry,
-				      priv->d_info->name_len);
+		dent = lookup_one(user_ns, priv->d_info->name,
+				  priv->dir_fp->filp->f_path.dentry,
+				  priv->d_info->name_len);
 		unlock_dir(priv->dir_fp);
 
 		if (IS_ERR(dent)) {
@@ -5246,7 +5246,9 @@ int smb2_echo(struct ksmbd_work *work)
 	return 0;
 }
 
-static int smb2_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
+static int smb2_rename(struct ksmbd_work *work,
+		       struct ksmbd_file *fp,
+		       struct user_namespace *user_ns,
 		       struct smb2_file_rename_info *file_info,
 		       struct nls_table *local_nls)
 {
@@ -5310,7 +5312,7 @@ static int smb2_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (rc)
 			goto out;
 
-		rc = ksmbd_vfs_setxattr(file_mnt_user_ns(fp->filp),
+		rc = ksmbd_vfs_setxattr(user_ns,
 					fp->filp->f_path.dentry,
 					xattr_stream_name,
 					NULL, 0, 0);
@@ -5624,6 +5626,7 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 			   char *buf)
 {
+	struct user_namespace *user_ns;
 	struct ksmbd_file *parent_fp;
 	struct dentry *parent;
 	struct dentry *dentry = fp->filp->f_path.dentry;
@@ -5634,11 +5637,12 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		return -EACCES;
 	}
 
+	user_ns = file_mnt_user_ns(fp->filp);
 	if (ksmbd_stream_fd(fp))
 		goto next;
 
 	parent = dget_parent(dentry);
-	ret = ksmbd_vfs_lock_parent(parent, dentry);
+	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
 	if (ret) {
 		dput(parent);
 		return ret;
@@ -5655,7 +5659,7 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 	}
 next:
-	return smb2_rename(work, fp,
+	return smb2_rename(work, fp, user_ns,
 			   (struct smb2_file_rename_info *)buf,
 			   work->sess->conn->local_nls);
 }
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index aee28ee6b19c..2bb506d1fb32 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -69,14 +69,15 @@ static void ksmbd_vfs_inherit_owner(struct ksmbd_work *work,
  *
  * the reference count of @parent isn't incremented.
  */
-int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child)
+int ksmbd_vfs_lock_parent(struct user_namespace *user_ns, struct dentry *parent,
+			  struct dentry *child)
 {
 	struct dentry *dentry;
 	int ret = 0;
 
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
-	dentry = lookup_one_len(child->d_name.name, parent,
-				child->d_name.len);
+	dentry = lookup_one(user_ns, child->d_name.name, parent,
+			    child->d_name.len);
 	if (IS_ERR(dentry)) {
 		ret = PTR_ERR(dentry);
 		goto out_err;
@@ -102,7 +103,7 @@ int ksmbd_vfs_may_delete(struct user_namespace *user_ns,
 	int ret;
 
 	parent = dget_parent(dentry);
-	ret = ksmbd_vfs_lock_parent(parent, dentry);
+	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
 	if (ret) {
 		dput(parent);
 		return ret;
@@ -137,7 +138,7 @@ int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 		*daccess |= FILE_EXECUTE_LE;
 
 	parent = dget_parent(dentry);
-	ret = ksmbd_vfs_lock_parent(parent, dentry);
+	ret = ksmbd_vfs_lock_parent(user_ns, parent, dentry);
 	if (ret) {
 		dput(parent);
 		return ret;
@@ -197,6 +198,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
  */
 int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 {
+	struct user_namespace *user_ns;
 	struct path path;
 	struct dentry *dentry;
 	int err;
@@ -210,16 +212,16 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 		return err;
 	}
 
+	user_ns = mnt_user_ns(path.mnt);
 	mode |= S_IFDIR;
-	err = vfs_mkdir(mnt_user_ns(path.mnt), d_inode(path.dentry),
-			dentry, mode);
+	err = vfs_mkdir(user_ns, d_inode(path.dentry), dentry, mode);
 	if (err) {
 		goto out;
 	} else if (d_unhashed(dentry)) {
 		struct dentry *d;
 
-		d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
-				   dentry->d_name.len);
+		d = lookup_one(user_ns, dentry->d_name.name, dentry->d_parent,
+			       dentry->d_name.len);
 		if (IS_ERR(d)) {
 			err = PTR_ERR(d);
 			goto out;
@@ -582,6 +584,7 @@ int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id)
  */
 int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 {
+	struct user_namespace *user_ns;
 	struct path path;
 	struct dentry *parent;
 	int err;
@@ -601,8 +604,9 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 		return err;
 	}
 
+	user_ns = mnt_user_ns(path.mnt);
 	parent = dget_parent(path.dentry);
-	err = ksmbd_vfs_lock_parent(parent, path.dentry);
+	err = ksmbd_vfs_lock_parent(user_ns, parent, path.dentry);
 	if (err) {
 		dput(parent);
 		path_put(&path);
@@ -616,14 +620,12 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, char *name)
 	}
 
 	if (S_ISDIR(d_inode(path.dentry)->i_mode)) {
-		err = vfs_rmdir(mnt_user_ns(path.mnt), d_inode(parent),
-				path.dentry);
+		err = vfs_rmdir(user_ns, d_inode(parent), path.dentry);
 		if (err && err != -ENOTEMPTY)
 			ksmbd_debug(VFS, "%s: rmdir failed, err %d\n", name,
 				    err);
 	} else {
-		err = vfs_unlink(mnt_user_ns(path.mnt), d_inode(parent),
-				 path.dentry, NULL);
+		err = vfs_unlink(user_ns, d_inode(parent), path.dentry, NULL);
 		if (err)
 			ksmbd_debug(VFS, "%s: unlink failed, err %d\n", name,
 				    err);
@@ -748,7 +750,8 @@ static int __ksmbd_vfs_rename(struct ksmbd_work *work,
 	if (ksmbd_override_fsids(work))
 		return -ENOMEM;
 
-	dst_dent = lookup_one_len(dst_name, dst_dent_parent, strlen(dst_name));
+	dst_dent = lookup_one(dst_user_ns, dst_name, dst_dent_parent,
+			      strlen(dst_name));
 	err = PTR_ERR(dst_dent);
 	if (IS_ERR(dst_dent)) {
 		pr_err("lookup failed %s [%d]\n", dst_name, err);
@@ -779,6 +782,7 @@ static int __ksmbd_vfs_rename(struct ksmbd_work *work,
 int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 			char *newname)
 {
+	struct user_namespace *user_ns;
 	struct path dst_path;
 	struct dentry *src_dent_parent, *dst_dent_parent;
 	struct dentry *src_dent, *trap_dent, *src_child;
@@ -808,8 +812,9 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	trap_dent = lock_rename(src_dent_parent, dst_dent_parent);
 	dget(src_dent);
 	dget(dst_dent_parent);
-	src_child = lookup_one_len(src_dent->d_name.name, src_dent_parent,
-				   src_dent->d_name.len);
+	user_ns = file_mnt_user_ns(fp->filp);
+	src_child = lookup_one(user_ns, src_dent->d_name.name, src_dent_parent,
+			       src_dent->d_name.len);
 	if (IS_ERR(src_child)) {
 		err = PTR_ERR(src_child);
 		goto out_lock;
@@ -823,7 +828,7 @@ int ksmbd_vfs_fp_rename(struct ksmbd_work *work, struct ksmbd_file *fp,
 	dput(src_child);
 
 	err = __ksmbd_vfs_rename(work,
-				 file_mnt_user_ns(fp->filp),
+				 user_ns,
 				 src_dent_parent,
 				 src_dent,
 				 mnt_user_ns(dst_path.mnt),
@@ -1109,7 +1114,7 @@ int ksmbd_vfs_unlink(struct user_namespace *user_ns,
 {
 	int err = 0;
 
-	err = ksmbd_vfs_lock_parent(dir, dentry);
+	err = ksmbd_vfs_lock_parent(user_ns, dir, dentry);
 	if (err)
 		return err;
 	dget(dentry);
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index cb0cba0d5d07..85db50abdb24 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -107,7 +107,8 @@ struct ksmbd_kstat {
 	__le32			file_attributes;
 };
 
-int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
+int ksmbd_vfs_lock_parent(struct user_namespace *user_ns, struct dentry *parent,
+			  struct dentry *child);
 int ksmbd_vfs_may_delete(struct user_namespace *user_ns, struct dentry *dentry);
 int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 				   struct dentry *dentry, __le32 *daccess);
-- 
2.30.2

