From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] mount.cifs: fix the conflict between rwpidforward and rw mount options
Date: Sat, 27 Aug 2011 20:21:17 +0400
Message-ID: <1314462077-6196-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Both these options are started with "rw" - that's why the first one
isn't switched on even if it is specified. Fix this by adding a length
check for "rw" option check.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 mount.cifs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index aa4581f..1e3d534 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -837,7 +837,7 @@ static int parse_opt_token(const char *token)
 		return OPT_GUEST;
 	if (strncmp(token, "ro", 2) == 0)
 		return OPT_RO;
-	if (strncmp(token, "rw", 2) == 0)
+	if (strncmp(token, "rw", 2) == 0 && strlen(token) == 2)
 		return OPT_RW;
 	if (strncmp(token, "remount", 7) == 0)
 		return OPT_REMOUNT;
-- 
1.7.1
