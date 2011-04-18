From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: guard against entries being deleted from open file list
Date: Mon, 18 Apr 2011 08:44:35 -0500
Message-ID: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


It is possible that a close can occur while a file is
being reopened which can result in list entry deleted
from the list and an oops.
Use list_for_each_entry_safe instead.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index faf5952..aa29167 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
-	struct cifsFileInfo *open_file;
+	struct cifsFileInfo *open_file, *tmpf;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
 	int rc;
@@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 
 	spin_lock(&cifs_file_list_lock);
 refind_writable:
-	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
+	list_for_each_entry_safe(open_file, tmpf, &cifs_inode->openFileList,
+									flist) {
 		if (!any_available && open_file->pid != current->tgid)
 			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
-- 
1.6.0.2
