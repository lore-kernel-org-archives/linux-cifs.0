From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] cifs: add deprecation warnings to strictcache, forcedirectio, and fsc
Date: Fri, 27 Apr 2012 06:56:17 -0400
Message-ID: <1335524179-1671-3-git-send-email-jlayton@redhat.com>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335524179-1671-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Leave them in for 2 releases and remove for 3.7.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index de967dc..604814d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1468,11 +1468,17 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->fsc = false;
 			vol->direct_io = true;
 			vol->strict_io = false;
+			cERROR(1, "The \"forcedirectio\" option will be "
+				"removed in 3.7. Please move to the cache=none "
+				"option.");
 			break;
 		case Opt_strictcache:
 			vol->fsc = false;
 			vol->direct_io = false;
 			vol->strict_io = true;
+			cERROR(1, "The \"strictcache\" option will be removed "
+				"in 3.7. Please move to the cache=strict "
+				"option.");
 			break;
 		case Opt_noac:
 			printk(KERN_WARNING "CIFS: Mount option noac not "
@@ -1488,6 +1494,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->fsc = true;
 			vol->direct_io = false;
 			vol->strict_io = false;
+			cERROR(1, "The \"fsc\" option will be removed in "
+				"3.7. Please move to the cache=fsc option.");
 			break;
 		case Opt_mfsymlinks:
 			vol->mfsymlinks = true;
-- 
1.7.7.6
