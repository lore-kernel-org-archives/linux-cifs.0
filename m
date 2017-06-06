From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Improve readdir verbosity
Date: Tue,  6 Jun 2017 16:58:58 -0700
Message-ID: <1496793538-3018-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Downgrade the loglevel for SMB2 to prevent filling the log
with messages if e.g. readdir was interrupted. Also make SMB2
and SMB1 codepaths do the same logging during readdir.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb1ops.c | 9 +++++++--
 fs/cifs/smb2ops.c | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 27bc360..a723df3 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -849,8 +849,13 @@ cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_fid *fid, __u16 search_flags,
 		     struct cifs_search_info *srch_inf)
 {
-	return CIFSFindFirst(xid, tcon, path, cifs_sb,
-			     &fid->netfid, search_flags, srch_inf, true);
+	int rc;
+
+	rc = CIFSFindFirst(xid, tcon, path, cifs_sb,
+			   &fid->netfid, search_flags, srch_inf, true);
+	if (rc)
+		cifs_dbg(FYI, "find first failed=%d\n", rc);
+	return rc;
 }
 
 static int
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c586918..5972601 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -982,7 +982,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL);
 	kfree(utf16_path);
 	if (rc) {
-		cifs_dbg(VFS, "open dir failed\n");
+		cifs_dbg(FYI, "open dir failed rc=%d\n", rc);
 		return rc;
 	}
 
@@ -992,7 +992,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory(xid, tcon, fid->persistent_fid,
 				  fid->volatile_fid, 0, srch_inf);
 	if (rc) {
-		cifs_dbg(VFS, "query directory failed\n");
+		cifs_dbg(FYI, "query directory failed rc=%d\n", rc);
 		SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 	}
 	return rc;
-- 
2.7.4
