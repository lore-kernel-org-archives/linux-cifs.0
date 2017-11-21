From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] CIFS: decrease log level of smb2 DFS error
Date: Tue, 21 Nov 2017 12:14:29 +0100
Message-ID: <20171121111429.14496-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0dafdbae1f8c..59d18a7d550d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1387,7 +1387,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	} while (rc == -EAGAIN);
 
 	if (rc) {
-		cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
+		cifs_dbg(FYI, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
 		goto out;
 	}
 
-- 
2.12.3
