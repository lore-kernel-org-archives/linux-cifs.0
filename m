From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 3/5] CIFS: Fix a possible memory corruption in push locks
Date: Mon,  5 Dec 2016 13:11:09 -0800
Message-ID: <1480972271-57692-4-git-send-email-pshilov@microsoft.com>
References: <1480972271-57692-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480972271-57692-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If maxBuf is not 0 but less than a size of SMB2 lock structure
we can end up with a memory corruption.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index f9e766f..b2aff0c 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -260,7 +260,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 * and check it for zero before using.
 	 */
 	max_buf = tlink_tcon(cfile->tlink)->ses->server->maxBuf;
-	if (!max_buf) {
+	if (max_buf < sizeof(struct smb2_lock_element)) {
 		free_xid(xid);
 		return -EINVAL;
 	}
-- 
2.7.4
