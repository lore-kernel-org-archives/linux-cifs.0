From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH 2/2] CIFS: Fix wrong directory attributes after rename
Date: Mon, 18 Aug 2014 20:49:58 +0400
Message-ID: <1408380598-11737-2-git-send-email-pshilovsky@samba.org>
References: <1408380598-11737-1-git-send-email-pshilovsky@samba.org>
Cc: <stable@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1408380598-11737-1-git-send-email-pshilovsky@samba.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

When we requests rename we also need to update attributes
of both source and target parent directories. Not doing it
causes generic/309 xfstest to fail on SMB2 mounts. Fix this
by marking these directories for force revalidating.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
---
 fs/cifs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2029e7c..cf69c95 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1720,6 +1720,12 @@ unlink_target:
 				    target_dentry, to_name);
 	}
 
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
+
+	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
+		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(from_name);
-- 
1.8.3.2
