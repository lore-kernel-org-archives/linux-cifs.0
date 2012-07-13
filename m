From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 14/32] CIFS: Respect SMB2 header/max header size
Date: Fri, 13 Jul 2012 11:53:27 +0400
Message-ID: <1342166025-29377-15-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Use SMB2 header size values for allocation and memset because they
are bigger and suitable for both CIFS and SMB2.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   14 ++++++++++++--
 fs/cifs/misc.c   |   25 +++++++++++++++++++------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8dc1492..5cf9299 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -48,6 +48,9 @@
 #include <linux/key-type.h>
 #include "cifs_spnego.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2pdu.h"
+#endif
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
 int cifsFYI = 0;
@@ -981,6 +984,14 @@ cifs_destroy_inodecache(void)
 static int
 cifs_init_request_bufs(void)
 {
+	size_t max_hdr_size = MAX_CIFS_HDR_SIZE;
+#ifdef CONFIG_CIFS_SMB2
+	/*
+	 * SMB2 maximum header size is bigger than CIFS one - no problems to
+	 * allocate some more bytes for CIFS.
+	 */
+	max_hdr_size = MAX_SMB2_HDR_SIZE;
+#endif
 	if (CIFSMaxBufSize < 8192) {
 	/* Buffer size can not be smaller than 2 * PATH_MAX since maximum
 	Unicode path name has to fit in any SMB/CIFS path based frames */
@@ -992,8 +1003,7 @@ cifs_init_request_bufs(void)
 	}
 /*	cERROR(1, "CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
 	cifs_req_cachep = kmem_cache_create("cifs_request",
-					    CIFSMaxBufSize +
-					    MAX_CIFS_HDR_SIZE, 0,
+					    CIFSMaxBufSize + max_hdr_size, 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
 	if (cifs_req_cachep == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 6460114..ad2538a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -29,6 +29,9 @@
 #include "smberr.h"
 #include "nterr.h"
 #include "cifs_unicode.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2pdu.h"
+#endif
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -143,17 +146,27 @@ struct smb_hdr *
 cifs_buf_get(void)
 {
 	struct smb_hdr *ret_buf = NULL;
-
-/* We could use negotiated size instead of max_msgsize -
-   but it may be more efficient to always alloc same size
-   albeit slightly larger than necessary and maxbuffersize
-   defaults to this and can not be bigger */
+	size_t buf_size = sizeof(struct smb_hdr);
+
+#ifdef CONFIG_CIFS_SMB2
+	/*
+	 * SMB2 header is bigger than CIFS one - no problems to clean some
+	 * more bytes for CIFS.
+	 */
+	buf_size = sizeof(struct smb2_hdr);
+#endif
+	/*
+	 * We could use negotiated size instead of max_msgsize -
+	 * but it may be more efficient to always alloc same size
+	 * albeit slightly larger than necessary and maxbuffersize
+	 * defaults to this and can not be bigger.
+	 */
 	ret_buf = mempool_alloc(cifs_req_poolp, GFP_NOFS);
 
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
 	if (ret_buf) {
-		memset(ret_buf, 0, sizeof(struct smb_hdr) + 3);
+		memset(ret_buf, 0, buf_size + 3);
 		atomic_inc(&bufAllocCount);
 #ifdef CONFIG_CIFS_STATS2
 		atomic_inc(&totBufAllocCount);
-- 
1.7.1
