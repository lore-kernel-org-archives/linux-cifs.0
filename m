From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix possible use of uninitialized variable
Date: Tue,  1 Feb 2011 14:24:49 -0500
Message-ID: <1296588289-8485-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible to "goto return_i" in this function at several points
before line_buf is set. At that point, the NULL pointer check won't
work correctly and we can end up with a SIGSEGV.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 5f29761..3a2b539 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -636,7 +636,7 @@ parsing_err:
 static int open_cred_file(char *file_name,
 			struct parsed_mount_info *parsed_info)
 {
-	char *line_buf;
+	char *line_buf = NULL;
 	char *temp_val = NULL;
 	FILE *fs = NULL;
 	int i;
-- 
1.7.3.5
