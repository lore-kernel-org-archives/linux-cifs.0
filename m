From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 53/53] CIFS: Disable lock call for SMB2 since we don't support it
Date: Tue, 25 Oct 2011 10:12:26 +0400
Message-ID: <1319523146-2859-54-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2file.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 83ba8eb..d359ce1 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -42,7 +42,7 @@ const struct file_operations smb2_file_ops = {
 	.aio_write = cifs_file_aio_write,
 	.open = smb2_open,
 	.release = cifs_close,
-	.lock = cifs_lock,
+	/*.lock = cifs_lock,*/
 	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
@@ -61,7 +61,7 @@ const struct file_operations smb2_file_strict_ops = {
 	.aio_write = smb2_strict_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.lock = cifs_lock,
+	/*.lock = cifs_lock,*/
 	.fsync = smb2_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
@@ -81,7 +81,7 @@ const struct file_operations smb2_file_direct_ops = {
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.lock = cifs_lock,
+	/*.lock = cifs_lock, */
 	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
-- 
1.7.1
