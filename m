From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 9/9] cache we have broken_qpath_info per tcon
Date: Fri, 22 Nov 2013 11:26:58 +0100
Message-ID: <1385116018-14068-10-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 cifsglob.h |    1 +
 smb1ops.c  |   26 ++++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/cifsglob.h b/cifsglob.h
index 52ca861..d3adde7 100644
--- a/cifsglob.h
+++ b/cifsglob.h
@@ -818,6 +818,7 @@ struct cifs_tcon {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool broken_qpath_info:1;
 #ifdef CONFIG_CIFS_SMB2
 	bool print:1;		/* set if connection to printer share */
 	bool bad_network_name:1; /* set if ret status STATUS_BAD_NETWORK_NAME */
diff --git a/smb1ops.c b/smb1ops.c
index 11daa28..e3798a4 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -511,7 +511,7 @@ static int
 cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
+	int rc= -EIO;
 	FILE_ALL_INFO *file_info;
 	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
@@ -519,13 +519,18 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	if (file_info == NULL)
 		return -ENOMEM;
 
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls, remap);
+	if (!tcon->broken_qpath_info) {
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
+				      0, cifs_sb->local_nls, remap);
+	}
 	if (rc == -EIO) {
-		cifs_dbg(FYI, "is_path_accessible: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)file_info,
 					   cifs_sb->local_nls, remap);
+		cifs_dbg(FYI, "is_path_accessible: FALLBACK returns %d", rc);
+		if (!rc) {
+			tcon->broken_qpath_info = true;
+		}
 	}
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
@@ -540,15 +545,16 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_sb_info *cifs_sb, const char *full_path,
 		     FILE_ALL_INFO *data, bool *adjustTZ)
 {
-	int rc;
+	int rc = -EIO;
 	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	/* could do find first instead but this returns more info */
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
-			      cifs_sb->local_nls, remap);
+	if (!tcon->broken_qpath_info) {
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0,
+				      cifs_sb->local_nls, remap);
+	}
 
 	if (rc == -EIO) {
-		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK");
 		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
 					   (FILE_BASIC_INFO*)data,
 					   cifs_sb->local_nls, remap);
@@ -557,6 +563,10 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 						      (void*)data + sizeof(FILE_BASIC_INFO),
 						      cifs_sb->local_nls, remap);
 		}
+		cifs_dbg(FYI, "cifs_query_path_info: FALLBACK returns %d", rc);
+		if (!rc) {
+			tcon->broken_qpath_info = true;
+		}
 	}
 
 	/*
-- 
1.7.9.5
