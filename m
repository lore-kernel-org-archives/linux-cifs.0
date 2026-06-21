Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF7936605A
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046147; cv=none; b=CFHgmMDaZ/xrTGyVGorXJlpdZdOIOo+CgizCF7KdzO9nQI9x4P55lJmMvHku7ZZiv5VCeibaddDfqFNKP1/7GKC02vPHd61APxJSaI5HT+Yc/tsOjUUbiMfPpMF5fNyVyCxkeuT96EzZALxvZ3s1BwKwvDST1nd5iVutu6o9rOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046147; c=relaxed/simple;
	bh=NkRVtfGwZl3mqXb8TIO1RzBHv2DSOFmmp5KxTcdVaVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KUg3Cn79MT1BE87wm47iUVFprtDa6AGwc1MLrLfjX7872Dy6MGYM2O4RiU3F/TVMyEcY5eH/+oE2uPWflmz/tMnspumtbUp9X1ob6sxjeV0NW/AScfZ5hKp8kgn3oVVUbX7i/0vcSoaOX2vWZyudh3L8wNPFj09RBNlfpv7lnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBvUALFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBvUALFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808F61F00A3A;
	Sun, 21 Jun 2026 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046146;
	bh=1Nh1fBw8ItXaJaOabXnP4csIc8Ig7gPsd85FBa5X5Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBvUALFVEPp7wmh5oEd7YhjPA/tmP/B0oVj/pWY/GKO8eJLiBMdjx7Gbs/Wkrm3tx
	 S8zNZggj3VXxABv4soIFvaTiRQSJxIjGF/lTKhM493wI8fI0cNINysFXt8YIoer7QD
	 xgX9ldHIHqTDj1KG+0eBbztZqQRDOo/oosG3VMxUbViNfZpbGzG7Oa0n/Ujs9QLVl3
	 WwBwex87PJODU/Wv+HjorhTIOXj80dYHAyqggE64Vu2W31PC3SdtrMlfF2nGQOVbx9
	 Q4vBqKGOjgZgIwu3fOg2Zjky+8YcS14oGCSs23b6KpHMDKQ1o+UgPY+KaIcLzzV0qM
	 1dEVK8FJXCl3w==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/29] ksmbd: deny renaming directory with open children
Date: Sun, 21 Jun 2026 21:48:23 +0900
Message-Id: <20260621124844.6235-8-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows denies renaming a directory while a file below that directory is
still open. smb2.rename.rename_dir_openfile checks this by keeping a file
handle open under the directory and then attempting to rename the directory
handle.  ksmbd did not check open children before calling vfs_rename(), so
the rename incorrectly succeeded.

For non-POSIX clients, scan the global open file table for active handles
whose dentries are below the directory being renamed.  If any child is
open, fail the rename with -EACCES so the client receives
STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c       |  6 ++++++
 fs/smb/server/vfs_cache.c | 25 +++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 32 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 80fd27752b2c..f5fa22d87603 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -700,6 +700,12 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	if (err)
 		goto out_drop_write;
 
+	if (!work->tcon->posix_extensions && d_is_dir(old_child) &&
+	    ksmbd_has_open_files(old_child)) {
+		err = -EACCES;
+		goto out3;
+	}
+
 	parent_fp = ksmbd_lookup_fd_inode(old_child->d_parent);
 	if (parent_fp) {
 		if ((parent_fp->daccess & FILE_DELETE_LE) ||
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 5a2fddadcddf..98c5bac93d63 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/dcache.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -914,6 +915,30 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
+bool ksmbd_has_open_files(struct dentry *dentry)
+{
+	struct ksmbd_file *fp;
+	unsigned int id;
+	bool ret = false;
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		struct dentry *fp_dentry = fp->filp->f_path.dentry;
+
+		if (fp->f_state != FP_INITED)
+			continue;
+		if (fp_dentry == dentry)
+			continue;
+		if (is_subdir(fp_dentry, dentry)) {
+			ret = true;
+			break;
+		}
+	}
+	read_unlock(&global_ft.lock);
+
+	return ret;
+}
+
 #define OPEN_ID_TYPE_VOLATILE_ID	(0)
 #define OPEN_ID_TYPE_PERSISTENT_ID	(1)
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 8c456484cab2..52a0e8b1f79f 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -172,6 +172,7 @@ bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
+bool ksmbd_has_open_files(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
-- 
2.25.1

