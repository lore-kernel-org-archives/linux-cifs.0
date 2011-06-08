From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: trivial: add space in fsc error message
Date: Wed,  8 Jun 2011 07:35:24 -0400
Message-ID: <1307532924-10309-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2b67280..4ec9630 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1391,7 +1391,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
 		} else if (strnicmp(data, "fsc", 3) == 0) {
 #ifndef CONFIG_CIFS_FSCACHE
-			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE"
+			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE "
 				  "kernel config option set");
 			goto cifs_parse_mount_err;
 #endif
-- 
1.7.5.2
