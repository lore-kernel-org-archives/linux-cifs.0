From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] cifs: add deprecation warnings to strictcache and forcedirectio
Date: Wed, 16 May 2012 07:55:52 -0400
Message-ID: <1337169354-19045-3-git-send-email-jlayton@redhat.com>
References: <1337169354-19045-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337169354-19045-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Leave them in for 2 releases and remove for 3.7.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cf8fe3e..2bd867f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1456,10 +1456,16 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_direct:
 			vol->direct_io = true;
 			vol->strict_io = false;
+			cERROR(1, "The \"directio\" option will be removed in "
+				  "3.7. Please switch to the \"cache=none\" "
+				  "option.");
 			break;
 		case Opt_strictcache:
 			vol->direct_io = false;
 			vol->strict_io = true;
+			cERROR(1, "The \"strictcache\" option will be removed "
+				"in 3.7. Please switch to the \"cache=strict\" "
+				"option.");
 			break;
 		case Opt_noac:
 			printk(KERN_WARNING "CIFS: Mount option noac not "
-- 
1.7.7.6
