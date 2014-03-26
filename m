From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix actimeo=0 corner case when cifs_i->time == jiffies
Date: Wed, 26 Mar 2014 07:24:23 -0700
Message-ID: <1395843863-12038-1-git-send-email-jlayton@redhat.com>
Cc: penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

actimeo=0 is supposed to be a special case that ensures that inode
attributes are always refetched from the server instead of trusting the
cache. The cifs code however uses time_in_range() to determine whether
the attributes have timed out. In the case where cifs_i->time equals
jiffies, this leads to the cifs code not refetching the inode attributes
when it should.

Fix this by explicitly testing for actimeo=0, and handling it as a
special case.

Reported-and-Tested-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index aadc2b68678b..a22d667f1069 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1737,6 +1737,9 @@ cifs_inode_needs_reval(struct inode *inode)
 	if (cifs_i->time == 0)
 		return true;
 
+	if (!cifs_sb->actimeo)
+		return true;
+
 	if (!time_in_range(jiffies, cifs_i->time,
 				cifs_i->time + cifs_sb->actimeo))
 		return true;
-- 
1.8.5.3
