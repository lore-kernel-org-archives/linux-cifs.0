From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/8] CIFS: Use common error handling code in cifs_mknod()
Date: Sun, 20 Aug 2017 18:38:04 +0200
Message-ID: <cb83ea97-f6f8-9f07-0eba-dd338557e716@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 16:30:06 +0200

Add a jump target so that a bit of exception handling can be better reused
in this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/cifs/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index b43e535ced8a..41039ab12643 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -687,8 +687,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	if (buf == NULL) {
 		kfree(full_path);
 		rc = -ENOMEM;
-		free_xid(xid);
-		return rc;
+		goto free_id;
 	}
 
 	if (backup_cred(cifs_sb))
@@ -744,8 +743,9 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 mknod_out:
 	kfree(full_path);
 	kfree(buf);
-	free_xid(xid);
 	cifs_put_tlink(tlink);
+free_id:
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.14.0
