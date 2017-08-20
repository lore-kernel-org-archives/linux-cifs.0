From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/8] CIFS: Less function calls in cifs_mknod() after error
 detection
Date: Sun, 20 Aug 2017 18:39:11 +0200
Message-ID: <ad73c46d-a1a3-3ae3-7263-1e8812303809@users.sourceforge.net>
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
Date: Sun, 20 Aug 2017 16:56:18 +0200

The kfree() function was called in a few cases by the
cifs_mknod() function during error handling even if
the passed variable contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Delete an initialisation for the variables "buf" and "full_path"
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/cifs/dir.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 41039ab12643..2c9cbd8393d6 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -620,12 +620,12 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	struct cifs_io_parms io_parms;
-	char *full_path = NULL;
+	char *full_path;
 	struct inode *newinode = NULL;
 	__u32 oplock = 0;
 	struct cifs_fid fid;
 	struct cifs_open_parms oparms;
-	FILE_ALL_INFO *buf = NULL;
+	FILE_ALL_INFO *buf;
 	unsigned int bytes_written;
 	struct win_dev *pdev;
 	struct kvec iov[2];
@@ -645,7 +645,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		goto mknod_out;
+		goto put_link;
 	}
 
 	if (tcon->unix_ext) {
@@ -667,18 +667,18 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 					    cifs_sb->local_nls,
 					    cifs_remap(cifs_sb));
 		if (rc)
-			goto mknod_out;
+			goto free_path;
 
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 						inode->i_sb, xid);
 
 		if (rc == 0)
 			d_instantiate(direntry, newinode);
-		goto mknod_out;
+		goto free_path;
 	}
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		goto mknod_out;
+		goto free_path;
 
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
@@ -708,7 +708,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		oplock = 0;
 	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, buf);
 	if (rc)
-		goto mknod_out;
+		goto free_buffer;
 
 	/*
 	 * BB Do not bother to decode buf since no local inode yet to put
@@ -740,9 +740,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 
 	/* FIXME: add code here to set EAs */
 
-mknod_out:
-	kfree(full_path);
+free_buffer:
 	kfree(buf);
+free_path:
+	kfree(full_path);
+put_link:
 	cifs_put_tlink(tlink);
 free_id:
 	free_xid(xid);
-- 
2.14.0
