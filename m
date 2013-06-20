From: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: using strlcpy instead of strncpy
Date: Thu, 20 Jun 2013 18:56:22 +0800
Message-ID: <51C2DFD6.5070202@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

for NUL terminated string, need alway set '\0' in the end.

Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 fs/cifs/smb2pdu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e3bc39b..2ea78a3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3738,7 +3738,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		}
 		bcc_ptr += length + 1;
 		bytes_left -= (length + 1);
-		strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
+		strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 		/* mostly informational -- no need to fail on error here */
 		kfree(tcon->nativeFileSystem);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2b95ce2..99bf768 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -792,7 +792,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
 	tcon->tid = rsp->hdr.TreeId;
-	strncpy(tcon->treeName, tree, MAX_TREE_SIZE);
+	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
-- 
1.7.1
