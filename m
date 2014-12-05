From: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH cifs-utils] mtab.c: include <paths.h> for _PATH_MOUNTED
Date: Fri, 5 Dec 2014 23:19:29 +0100
Message-ID: <20141205221929.GA3671@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
---
 mtab.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mtab.c b/mtab.c
index 7b365b3..a662a3c 100644
--- a/mtab.c
+++ b/mtab.c
@@ -38,6 +38,7 @@
 #include <mntent.h>
 #include <stdlib.h>
 #include <signal.h>
+#include <paths.h>
 #include "mount.h"
 #include "config.h"
 
-- 
2.0.4
