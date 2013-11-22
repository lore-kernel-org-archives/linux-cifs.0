From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 5/9] fallback to CIFSSMBQPathInfoBasic() in cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 11:26:54 +0100
Message-ID: <1385116018-14068-6-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 smb1ops.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/smb1ops.c b/smb1ops.c
index 6094397..635b1e5 100644
--- a/smb1ops.c
+++ b/smb1ops.c
@@ -513,20 +513,23 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	FILE_ALL_INFO *file_info;
+	const int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (file_info == NULL)
 		return -ENOMEM;
 
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+			      0 /* not legacy */, cifs_sb->local_nls, remap);
+	if (rc == -EIO) {
+		rc = CIFSSMBQPathInfoBasic(xid, tcon, full_path,
+					   (FILE_BASIC_INFO*)file_info,
+					   cifs_sb->local_nls, remap);
+	}
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
 		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
-				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_MAP_SPECIAL_CHR);
+					 cifs_sb->local_nls, remap);
 	kfree(file_info);
 	return rc;
 }
-- 
1.7.9.5
