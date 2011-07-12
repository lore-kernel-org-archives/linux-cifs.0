From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: cleanup - check for null direntry first
Date: Tue, 12 Jul 2011 10:02:52 -0500
Message-ID: <1310482972-3774-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Check for NULL direntry before assigning fields off of it.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail>
---
 fs/cifs/dir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 81914df..e9ea4c8 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -53,14 +53,16 @@ build_path_from_dentry(struct dentry *direntry)
 	int dfsplen;
 	char *full_path;
 	char dirsep;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
 
 	if (direntry == NULL)
 		return NULL;  /* not much we can do if dentry is freed and
 		we need to reopen the file after it was closed implicitly
 		when the server crashed */
 
+	cifs_sb = CIFS_SB(direntry->d_sb);
+	tcon = cifs_sb_master_tcon(cifs_sb);
 	dirsep = CIFS_DIR_SEP(cifs_sb);
 	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
-- 
1.6.0.2
