From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: [PATCH] Reset TreeId to zero on SMB2 TREE_CONNECT
Date: Mon, 20 Feb 2017 12:25:58 +0100
Message-ID: <1487589958-20489-1-git-send-email-glogow@fbihome.de>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the cifs module breaks the CIFS specs on reconnect as
described in http://msdn.microsoft.com/en-us/library/cc246529.aspx:

"TreeId (4 bytes): Uniquely identifies the tree connect for the
command. This MUST be 0 for the SMB2 TREE_CONNECT Request."

Signed-off-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8745722..bdd3292 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1104,6 +1104,10 @@ static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 		return -EINVAL;
 	}
 
+	/* SMB2 TREE_CONNECT request must be called with TreeId == 0 */
+	if (tcon)
+		tcon->tid = 0;
+
 	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
 	if (rc) {
 		kfree(unc_path);
-- 
1.9.1
