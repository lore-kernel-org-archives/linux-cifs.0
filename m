From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix wrong buffer pointer usage in smb_set_file_info
Date: Wed, 28 Nov 2012 15:27:54 +0400
Message-ID: <1354102074-24841-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 6bdf6dbd662176c0da5c3ac8ed10ac94e7776c85 caused a regression
in setattr codepath that leads to files with wrong attributes.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb1ops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 77295f2..561547f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -735,7 +735,6 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
-	FILE_BASIC_INFO info_buf;
 
 	/* if the file is already open for write, just use that fileid */
 	open_file = find_writable_file(cinode, true);
@@ -787,7 +786,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	netpid = current->tgid;
 
 set_via_filehandle:
-	rc = CIFSSMBSetFileInfo(xid, tcon, &info_buf, netfid, netpid);
+	rc = CIFSSMBSetFileInfo(xid, tcon, buf, netfid, netpid);
 	if (!rc)
 		cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
 
-- 
1.7.10.4
