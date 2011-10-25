From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix compile warnings
Date: Tue, 25 Oct 2011 12:24:46 +0400
Message-ID: <1319531086-10987-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 3adfd73..f689361 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -191,9 +191,7 @@ smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 void
 move_smb2_info_to_cifs(FILE_ALL_INFO *dst, FILE_ALL_INFO_SMB2 *src)
 {
-	memcpy(dst, src,
-		(unsigned long long)(&src->CurrentByteOffset) -
-		(unsigned long long)src);
+	memcpy(dst, src, (size_t)(&src->CurrentByteOffset) - (size_t)src);
 	dst->CurrentByteOffset = src->CurrentByteOffset;
 	dst->Mode = src->Mode;
 	dst->AlignmentRequirement = src->AlignmentRequirement;
-- 
1.7.1
