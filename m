From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: handle cifs_get_tcon() errors properly
Date: Mon, 15 Nov 2010 18:15:23 +0530
Message-ID: <1289825123-13716-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_get_tcon() could return any of the following errors:
-ENOMEM/-ENODEV/EREMOTEIO. We should follow the DFS referral code path only
when we get -EREMOTEIO (STATUS_PATH_NOT_COVERED) from the server and not
otherwise.

Compile-tested only.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/connect.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251a17c..c3a2323 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2780,7 +2780,10 @@ try_mount_again:
 	if (IS_ERR(tcon)) {
 		rc = PTR_ERR(tcon);
 		tcon = NULL;
-		goto remote_path_check;
+		if (rc == -EREMOTEIO)
+			goto remote_path_check;
+		else
+			goto mount_fail_check;
 	}
 
 	/* do not care if following two calls succeed - informational */
