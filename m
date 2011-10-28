From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 30/53] CIFS: Temporarily disable set inode info for SMB2
Date: Fri, 28 Oct 2011 23:54:41 +0400
Message-ID: <1319831704-3572-31-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
---
 fs/cifs/inode.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ba175ad..a465d04 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2309,9 +2309,14 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct inode *inode = direntry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (pTcon->unix_ext)
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2)
+		return 0;
+#endif
+
+	if (tcon->unix_ext)
 		return cifs_setattr_unix(direntry, attrs);
 
 	return cifs_setattr_nounix(direntry, attrs);
-- 
1.7.1

