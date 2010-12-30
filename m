From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: move time field in cifsInodeInfo
Date: Thu, 30 Dec 2010 09:57:14 -0500
Message-ID: <1293721034-31120-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and remove length qualifiers from bools.

Before:

	/* size: 1176, cachelines: 19, members: 13 */
	/* sum members: 1165, holes: 2, sum holes: 11 */
	/* bit holes: 1, sum bit holes: 4 bits */
	/* last cacheline: 24 bytes */

After:

	/* size: 1168, cachelines: 19, members: 13 */
	/* last cacheline: 16 bytes */

...savings of 8 bytes per inode.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d6433a4..701060d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -439,11 +439,11 @@ struct cifsInodeInfo {
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
-	unsigned long time;	/* jiffies of last update/check of inode */
-	bool clientCanCacheRead:1;	/* read oplock */
-	bool clientCanCacheAll:1;	/* read and writebehind oplock */
-	bool delete_pending:1;		/* DELETE_ON_CLOSE is set */
-	bool invalid_mapping:1;		/* pagecache is invalid */
+	bool clientCanCacheRead;	/* read oplock */
+	bool clientCanCacheAll;		/* read and writebehind oplock */
+	bool delete_pending;		/* DELETE_ON_CLOSE is set */
+	bool invalid_mapping;		/* pagecache is invalid */
+	unsigned long time;		/* jiffies of last update of inode */
 	u64  server_eof;		/* current file size on server */
 	u64  uniqueid;			/* server inode number */
 	u64  createtime;		/* creation time on server */
-- 
1.7.3.4
