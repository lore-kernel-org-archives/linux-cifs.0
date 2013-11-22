From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 6/9] fallback to CIFSSMBQPathInfoBasic()/Standard() in cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 11:26:55 +0100
Message-ID: <1385116018-14068-7-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 smb1ops.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/smb1ops.c b/smb1ops.c
index 635b1e5..a12e370 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -540,11 +540,23 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		     FILE_ALL_INFO *data, bool *adjustTZ)
 {
 	int rc;
+	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	/* could do find first instead but this returns more info */
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      cifs_sb->local_nls, remap);
+
+	if (rc == -EIO) {
+		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
+					   (FILE_BASIC_INFO*)data,
+					   cifs_sb->local_nls, remap);
+		if (!rc) {
+			rc = CIFSSMBQPathInfoStandard(xid, tcon, full_path,
+						      (void*)data + sizeof(FILE_BASIC_INFO),
+						      cifs_sb->local_nls, remap);
+		}
+	}
+
 	/*
 	 * BB optimize code so we do not make the above call when server claims
 	 * no NT SMB support and the above call failed at least once - set flag
@@ -552,9 +564,7 @@ cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, data,
-					 cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->local_nls, remap);
 		*adjustTZ = true;
 	}
 	return rc;
-- 
1.7.9.5
