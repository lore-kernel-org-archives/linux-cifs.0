From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: add FL_CLOSE to fl_flags mask in cifs_read_flock
Date: Thu, 13 Sep 2012 16:38:11 -0400
Message-ID: <1347568691-24628-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, abokovoy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FL_CLOSE is quite common when you close a file on which you hold a
lock. The spurious "Unknown lock flags" message in cFYI is
confusing in this case.

Reported-by: Alexander Bokovoy <abokovoy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 093f5a3..33158cd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1173,7 +1173,8 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 	if (flock->fl_flags & FL_LEASE)
 		cFYI(1, "Lease on file - not implemented yet");
 	if (flock->fl_flags &
-	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
+	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP |
+	       FL_ACCESS | FL_LEASE | FL_CLOSE)))
 		cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
 
 	*type = server->vals->large_lock_type;
-- 
1.7.11.4
