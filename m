From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 PATCH] CIFS: Fix incorrect max RFC1002 write size value
Date: Fri,  7 Oct 2011 23:27:31 +0400
Message-ID: <1318015651-18764-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

..the length field has only 17 bits.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..1a645ee 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2807,10 +2807,10 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 
 /*
  * When the server doesn't allow large posix writes, only allow a wsize of
- * 128k minus the size of the WRITE_AND_X header. That allows for a write up
+ * 2^17-1 minus the size of the WRITE_AND_X header. That allows for a write up
  * to the maximum size described by RFC1002.
  */
-#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
 
 /*
  * The default wsize is 1M. find_get_pages seems to return a maximum of 256
-- 
1.7.1
