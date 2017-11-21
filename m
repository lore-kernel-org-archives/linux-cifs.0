From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2] CIFS: don't log STATUS_NOT_FOUND errors for DFS
Date: Tue, 21 Nov 2017 14:47:56 +0100
Message-ID: <20171121134756.25201-1-aaptel@suse.com>
References: <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA@mail.gmail.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs.ko makes DFS queries regardless of the type of the server and
non-DFS servers are common. This often results in superfluous logging of
non-critical errors.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
v2: instead of always logging at FYI level, only log non-ENOENT errors
    at VFS level

 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0dafdbae1f8c..3aa9f46c51e3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1387,7 +1387,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	} while (rc == -EAGAIN);
 
 	if (rc) {
-		cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
+		if (rc != -ENOENT)
+			cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
 		goto out;
 	}
 
-- 
2.12.3
