From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: demote cERROR in build_path_from_dentry to cFYI
Date: Mon,  8 Aug 2011 11:50:24 -0400
Message-ID: <1312818624-6108-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Running the cthon tests on a recent kernel caused this message to pop
occasionally:

    CIFS VFS: did not end path lookup where expected namelen is 0

Some added debugging showed that namelen and dfsplen were both 0 when
this occurred. That means that the read_seqretry returned true.

Assuming that the comment inside the if statement is true, this should
be harmless and just means that we raced with a rename. If that is the
case, then there's no need for alarm and we can demote this to cFYI.

While we're at it, print the dfsplen too so that we can see what
happened here if the message pops during debugging.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ae576fb..72d448b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -105,8 +105,8 @@ cifs_bp_rename_retry:
 	}
 	rcu_read_unlock();
 	if (namelen != dfsplen || read_seqretry(&rename_lock, seq)) {
-		cERROR(1, "did not end path lookup where expected namelen is %d",
-			namelen);
+		cFYI(1, "did not end path lookup where expected. namelen=%d "
+			"dfsplen=%d", namelen, dfsplen);
 		/* presumably this is only possible if racing with a rename
 		of one of the parent directories  (we can not lock the dentries
 		above us to prevent this, but retrying should be harmless) */
-- 
1.7.6
