From: Chengyu Song <csong84@gatech.edu>
Subject: [PATCH 1/1] cifs: potential missing check for posix_lock_file_wait
Date: Tue, 24 Mar 2015 20:18:49 -0400
Message-ID: <1427242729-11515-1-git-send-email-csong84@gatech.edu>
Cc: taesoo@gatech.edu, changwoo@gatech.edu, sanidhya@gatech.edu,
	blee@gatech.edu, csong84@gatech.edu
To: sfrench@samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

posix_lock_file_wait may fail under certain circumstances, and its result is
usually checked/returned. But given the complexity of cifs, I'm not sure if
the result is intentially left unchecked and always expected to succeed.

Signed-off-by: Chengyu Song <csong84@gatech.edu>
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a94b3e6..beef67b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1553,8 +1553,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		rc = server->ops->mand_unlock_range(cfile, flock, xid);
 
 out:
-	if (flock->fl_flags & FL_POSIX)
-		posix_lock_file_wait(file, flock);
+	if (flock->fl_flags & FL_POSIX && !rc)
+		rc = posix_lock_file_wait(file, flock);
 	return rc;
 }
 
-- 
2.1.0
