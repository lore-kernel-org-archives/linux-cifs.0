From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix check of error return from is_path_accessable
Date: Mon,  6 Dec 2010 21:07:33 -0500
Message-ID: <1291687653-23824-2-git-send-email-jlayton@redhat.com>
References: <1291687653-23824-1-git-send-email-jlayton@redhat.com>
Cc: robbert-C1IQQP51G3M@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291687653-23824-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This function will return 0 if everything went ok. Commit 9d002df4
however added a block of code after the following check for
rc == -EREMOTE. With that change and when rc == 0, doing the
"goto mount_fail_check" here skips that code, leaving the tlink_tree
and master_tlink pointer unpopulated. That causes an oops later
in cifs_root_iget.

Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0a203ec..cc1a860 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2839,7 +2839,7 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 		rc = is_path_accessible(xid, tcon, cifs_sb, full_path);
-		if (rc != -EREMOTE) {
+		if (rc != 0 && rc != -EREMOTE) {
 			kfree(full_path);
 			goto mount_fail_check;
 		}
-- 
1.7.3.2
