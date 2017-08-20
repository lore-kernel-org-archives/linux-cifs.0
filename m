From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 8/8] CIFS: One function call less in cifs_do_create() after
 error detection
Date: Sun, 20 Aug 2017 18:42:11 +0200
Message-ID: <3b7e0d4a-6707-c44f-8775-9e10a291fcd2@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <sfrench@samba.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 17:47:44 +0200

The kfree() function was called in a few cases by the
cifs_do_create() function during error handling even if
the passed variable contained a null pointer.

Add a jump target according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/cifs/dir.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 69babcf4f653..73e68aa5326e 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -258,7 +258,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				CIFSSMBClose(xid, tcon, fid->netfid);
 				iput(newinode);
 				rc = -EISDIR;
-				goto out;
+				goto free_path;
 			}
 
 			if (!S_ISREG(newinode->i_mode)) {
@@ -301,7 +301,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 			break;
 
 		default:
-			goto out;
+			goto free_path;
 		}
 		/*
 		 * fallthrough to retry, using older open call, this is case
@@ -334,13 +334,13 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 
 	if (!server->ops->open) {
 		rc = -ENOSYS;
-		goto out;
+		goto free_path;
 	}
 
 	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
-		goto out;
+		goto free_path;
 	}
 
 	/*
@@ -444,6 +444,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 
 out:
 	kfree(buf);
+free_path:
 	kfree(full_path);
 	return rc;
 
-- 
2.14.0

