From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/3] CIFS: Fix directory rename error
Date: Fri, 22 Aug 2014 13:32:09 +0400
Message-ID: <1408699931-22515-2-git-send-email-pshilovsky@samba.org>
References: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408699931-22515-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

CIFS servers process nlink counts differently for files and directories.
In cifs_rename() if we the request fails on the existing target, we
try to remove it through cifs_unlink() but this is not what we want
to do for directories. As the result the following sequence of commands

mkdir {1,2}; mv -T 1 2; rmdir {1,2}; mkdir {1,2}; echo foo > 2/bar

and XFS test generic/023 fail with -ENOENT error. That's why the second
mkdir reuses the existing inode (target inode of the mv -T command) with
S_DEAD flag.

Fix this by checking whether the target is directory or not and
calling cifs_rmdir() rather than cifs_unlink() for directories.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 949ec90..7899a40 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1720,7 +1720,10 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 unlink_target:
 	/* Try unlinking the target dentry if it's not negative */
 	if (target_dentry->d_inode && (rc == -EACCES || rc == -EEXIST)) {
-		tmprc = cifs_unlink(target_dir, target_dentry);
+		if (d_is_dir(target_dentry))
+			tmprc = cifs_rmdir(target_dir, target_dentry);
+		else
+			tmprc = cifs_unlink(target_dir, target_dentry);
 		if (tmprc)
 			goto cifs_rename_exit;
 		rc = cifs_do_rename(xid, source_dentry, from_name,
-- 
1.9.1
