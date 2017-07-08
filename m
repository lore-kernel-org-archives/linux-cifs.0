From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Display SMB2 error codes in the hex format
Date: Sat,  8 Jul 2017 14:17:37 -0700
Message-ID: <1499548657-112460-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2maperror.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 3030a9d..7ca9808 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2475,8 +2475,8 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 
 	/* on error mapping not found  - return EIO */
 
-	cifs_dbg(FYI, "Mapping SMB2 status code %d to POSIX err %d\n",
-		 smb2err, rc);
+	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
+		 __le32_to_cpu(smb2err), rc);
 
 	return rc;
 }
-- 
2.7.4
