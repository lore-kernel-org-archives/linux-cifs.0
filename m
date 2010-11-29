From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: trivial comment fix for cifs_invalidate_mapping
Date: Mon, 29 Nov 2010 22:39:47 +0530
Message-ID: <1291050587-9642-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Only the callers check whether the invalid_mapping flag is set and not
cifs_invalidate_mapping().

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ff7d299..669298f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1670,7 +1670,9 @@ cifs_inode_needs_reval(struct inode *inode)
 	return false;
 }
 
-/* check invalid_mapping flag and zap the cache if it's set */
+/*
+ * Zap the cache. Called when invalid_mapping flag is set.
+ */
 static void
 cifs_invalidate_mapping(struct inode *inode)
 {
