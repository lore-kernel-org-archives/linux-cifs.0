From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] CIFS: Fix persistent handles re-opening on reconnect
Date: Tue, 11 Oct 2016 15:34:06 -0700
Message-ID: <1476225247-30177-2-git-send-email-piastryyy@gmail.com>
References: <1476225247-30177-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476225247-30177-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

openFileList of tcon can be changed while cifs_reopen_file() is called
that can lead to an unexpected behavior when we return to the loop.
Fix this by introducing a temp list for keeping all file handles that
need to be reopen.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/file.c     | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0eaed19..149ac16 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1067,6 +1067,7 @@ struct cifsFileInfo {
 	kuid_t uid;		/* allows finding which FileInfo structure */
 	__u32 pid;		/* process id who opened file */
 	struct cifs_fid fid;	/* file id from remote */
+	struct list_head rlist; /* reconnect list */
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
 	struct dentry *dentry;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 20801dc..40b015b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -763,19 +763,31 @@ int cifs_close(struct inode *inode, struct file *file)
 void
 cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 {
-	struct cifsFileInfo *open_file = NULL;
+	struct cifsFileInfo *open_file;
 	struct list_head *tmp;
 	struct list_head *tmp1;
+	struct list_head tmp_list;
+
+	cifs_dbg(FYI, "Reopen persistent handles");
+	INIT_LIST_HEAD(&tmp_list);
 
 	/* list all files open on tree connection, reopen resilient handles  */
 	spin_lock(&tcon->open_file_lock);
-	list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
+	list_for_each(tmp, &tcon->openFileList) {
 		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
-		spin_unlock(&tcon->open_file_lock);
-		cifs_reopen_file(open_file, false /* do not flush */);
-		spin_lock(&tcon->open_file_lock);
+		if (!open_file->invalidHandle)
+			continue;
+		cifsFileInfo_get(open_file);
+		list_add_tail(&open_file->rlist, &tmp_list);
 	}
 	spin_unlock(&tcon->open_file_lock);
+
+	list_for_each_safe(tmp, tmp1, &tmp_list) {
+		open_file = list_entry(tmp, struct cifsFileInfo, rlist);
+		cifs_reopen_file(open_file, false /* do not flush */);
+		list_del_init(&open_file->rlist);
+		cifsFileInfo_put(open_file);
+	}
 }
 
 int cifs_closedir(struct inode *inode, struct file *file)
-- 
2.7.4
