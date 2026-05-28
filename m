Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D36C3E121D
	for <linux-cifs@vger.kernel.org>; Thu, 28 May 2026 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779990864; cv=none; b=KAAfj/hmdzhwPhYkUq4JX/gKLNPJOHrXaCvYNzBss/Py0MRZ0UDULkeEOA73gxzvGRjnVDPJjJxj/aBTxRFtO8Lcns3f4k73Xcxyd219Tn7H4VgTiGKwx8oLchgIuZOcs+sQEpJjjJHcWAXp8JPTUs2rZIdnBqiubHxIiMMdvVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779990864; c=relaxed/simple;
	bh=mdolqdO8m/xvSLTC0VxAhX4EF3LzAMR7UIbOR9BeYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NZQaitiPMNJwJpXtPeM8Qi0FIxVIUjhSOtuNrjiW5N20a3piVFFGxl8qoYQUjV4pKuC6j9AIG2ZiZ7rLyAVysjIiSgQ4Rrko/2rOGNbC1z+aD9diE/YlJ5NYn6hlARsTaLFOR9zNdTacpndY/+F8CraCYOjmHY5yy/LTyFY6CMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=uj40eb6A; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="uj40eb6A"
X-KPN-MessageId: 3c26b4cd-5abe-11f1-bea8-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 3c26b4cd-5abe-11f1-bea8-005056992ed3;
	Thu, 28 May 2026 19:54:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=VDtJKlec+8XLDWk5UozdW8XyU7l8Ud2n71wg7ncHwJc=;
	b=uj40eb6A/HuDOMtbIFtl+9UdTOZ5fzN9O9y9LMHuoky+Dkt1y3rnSiM4RbqKJSZ/QFl2EhTzcHZuU
	 HLWypTwdS9LAD4+h0u4ZpWHPpySCRi8GPo821SfUbTDbW83eFc2DmilPq2LMZ0dP6RLErCCu6SSEz0
	 m4AN7KjI0LEqQJQKtKqGHxW/gY7i7azBQWw9Z+Wida+mjY/PcBbSDxLGhy13J3HJ6kmO9RVfE+Z5Bl
	 0EKhhbUjkX9k2lg96jjvHNDEn2E8vZ3QuKVml8XAHGeO6pPegcMqxfzCihaAbtOJBhP2EzRolQpGvD
	 DmNhp9SvnpFV1rDiZnSvaSmkSd0tPiA==
X-KPN-MID: 33|PYoiL15o0VpY92tVgUstCJ3D/f2Ug5ODrJueYn3K423JmJt+cDHmjnKbi9vblUn
 z3tecuouxA4+3tW85OEE9M3C5Tc17pO9zYImydM0kATc=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|XL2CK6q+IQh/SRqHfQ8lQRTHrs9/y5JFaDNAzW3BEcnVXWIqOZZRwfyqaEUeNj6
 YKECkDs0vja9VVTipEfbfQg==
Received: from daedalus.space.revspace.nl (83-84-7-238.cable.dynamic.v4.ziggo.nl [83.84.7.238])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 38ce410c-5abe-11f1-9c0c-00505699d6e5;
	Thu, 28 May 2026 19:54:12 +0200 (CEST)
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
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	linux-kernel@vger.kernel.org (open list),
	linux-cifs@vger.kernel.org (open list:KERNEL SMB3 SERVER (KSMBD))
Subject: [PATCH 1/2] vfs: make LAST_XXX private to fs/namei.c
Date: Thu, 28 May 2026 17:58:46 +0000
Message-ID: <20260528175854.57626-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
vfs_path_parent_lookup() but forgets the LAST_NORM check.

It does not really make sense to have vfs_path_parent_lookup() expose
the last_type because it is only needed to ensure it is LAST_NORM. So
let's do this check in vfs_path_parent_lookup() instead and keep the
LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
handled by callers of filename_parentat().

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c            | 20 ++++++++++++++++----
 fs/smb/server/vfs.c   | 15 +++------------
 include/linux/namei.h |  7 +------
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c7fac83c9a85..889792761bc2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -129,6 +129,11 @@
 static struct kmem_cache *__names_cache __ro_after_init;
 #define names_cache	runtime_const_ptr(__names_cache)
 
+/*
+ * Type of the last component on LOOKUP_PARENT
+ */
+enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
+
 void __init filename_init(void)
 {
 	__names_cache = kmem_cache_create_usercopy("names_cache", sizeof(struct filename), 0,
@@ -3051,15 +3056,22 @@ EXPORT_SYMBOL(kern_path);
  * @flags: lookup flags
  * @parent: pointer to struct path to fill
  * @last: last component
- * @type: type of the last component
  * @root: pointer to struct path of the base directory
  */
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root)
 {
-	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
-				    type, root);
+	int type;
+	int err =  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
+				       &type, root);
+	if (err)
+		return err;
+	if (unlikely(type != LAST_NORM)) {
+		path_put(parent);
+		return -EINVAL;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(vfs_path_parent_lookup);
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d08973b288e5..cd1dbca0cffb 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -19,7 +19,6 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/xacct.h>
 #include <linux/crc32c.h>
-#include <linux/namei.h>
 #include <linux/splice.h>
 
 #include "glob.h"
@@ -56,7 +55,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 {
 	struct qstr last;
 	const struct path *root_share_path = &share_conf->vfs_path;
-	int err, type;
+	int err;
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
@@ -67,17 +66,11 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
 	}
 
 	CLASS(filename_kernel, filename)(pathname);
-	err = vfs_path_parent_lookup(filename, flags,
-				     path, &last, &type,
+	err = vfs_path_parent_lookup(filename, flags, path, &last,
 				     root_share_path);
 	if (err)
 		return err;
 
-	if (unlikely(type != LAST_NORM)) {
-		path_put(path);
-		return -ENOENT;
-	}
-
 	if (for_remove) {
 		err = mnt_want_write(path->mnt);
 		if (err) {
@@ -668,7 +661,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	struct renamedata rd;
 	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	struct ksmbd_file *parent_fp;
-	int new_type;
 	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
@@ -678,8 +670,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
-				     &new_path, &new_last, &new_type,
-				     &share_conf->vfs_path);
+				     &new_path, &new_last, &share_conf->vfs_path);
 	if (err)
 		goto out1;
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 2ad6dd9987b9..3941b9f1dec7 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -13,11 +13,6 @@ enum { MAX_NESTED_LINKS = 8 };
 
 #define MAXSYMLINKS 40
 
-/*
- * Type of the last component on LOOKUP_PARENT
- */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
-
 /* pathwalk mode */
 #define LOOKUP_FOLLOW		BIT(0)	/* follow links at the end */
 #define LOOKUP_DIRECTORY	BIT(1)	/* require a directory */
@@ -67,7 +62,7 @@ static inline void end_removing_path(const struct path *path , struct dentry *de
 	end_creating_path(path, dentry);
 }
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root);
 int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
 		    unsigned int, struct path *);
-- 
2.54.0

