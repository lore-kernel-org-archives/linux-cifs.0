From: Thomas Witt <pyromaniac-k5O9xmZG+kVAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mount.cifs: Remove data_blob.h include
Date: Wed, 15 Mar 2017 20:20:44 +0000
Message-ID: <20170315202044.28670-1-pyromaniac@exherbo.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

data_blob.h includes talloc.h from libtalloc, but that is only marked as
a dependency for cifs.upcall. No symbols from that header are used by
cifs.mount, so remove it to avoid the libtalloc dependency

Signed-off-by: Thomas Witt <pyromaniac-k5O9xmZG+kVAfugRpC6u6w@public.gmane.org>
---
 mount.cifs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 13b71ef..2612feb 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -61,7 +61,6 @@
 #include "mount.h"
 #include "util.h"
 #include "resolve_host.h"
-#include "data_blob.h"
 
 #ifndef MS_MOVE 
 #define MS_MOVE 8192 
-- 
2.12.0
