From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH] CIFS: Fix missing of oplock_read value in smb30_values structure
Date: Wed,  6 Mar 2013 19:38:36 +0400
Message-ID: <1362584316-32111-1-git-send-email-piastry@etersoft.ru>
Cc: stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index dc38434..22aef1d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -746,4 +746,5 @@ struct smb_version_values smb30_values = {
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
+	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 };
-- 
1.8.1.5
