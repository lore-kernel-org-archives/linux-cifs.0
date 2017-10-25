From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: check MaxPathNameComponentLength != 0 before using it
Date: Thu, 26 Oct 2017 09:31:32 +1100
Message-ID: <20171025223132.10046-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e702d48bd023..513ff2986c97 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -204,7 +204,8 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
 	int i;
 
-	if (unlikely(direntry->d_name.len >
+	if (unlikely(tcon->fsAttrInfo.MaxPathNameComponentLength &&
+		     direntry->d_name.len >
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
 
-- 
2.13.3
