From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: request oplock when doing open on lookup
Date: Fri,  3 Feb 2012 07:14:12 -0500
Message-ID: <1328271252-19146-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, it's always set to 0 (no oplock requested).

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index df8fecb..63a196b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	__u32 oplock = 0;
+	__u32 oplock = enable_oplocks ? REQ_OPLOCK : 0;
 	__u16 fileHandle = 0;
 	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;
-- 
1.7.7.6
