From: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: update README
Date: Fri, 30 Jul 2010 18:01:17 +0530
Message-ID: <1280493077.19538.5.camel@jay-t60p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/2] cifs: update README

Update the README file to reflect that now DebugData shows all
the features enabled.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
 fs/cifs/README |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index a727b7c..a7081ee 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -568,8 +568,9 @@ module can be displayed via modinfo.
 Misc /proc/fs/cifs Flags and Debug Info
 =======================================
 Informational pseudo-files:
-DebugData		Displays information about active CIFS sessions
-			and shares, as well as the cifs.ko version.
+DebugData		Displays information about active CIFS sessions and
+			shares, features enabled as well as the cifs.ko
+			version.
 Stats			Lists summary resource usage information as well as per
 			share statistics, if CONFIG_CIFS_STATS in enabled
 			in the kernel configuration.
