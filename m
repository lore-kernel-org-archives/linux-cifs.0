From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] cifs: dir: fix memory leak in cifs_mknod
Date: Fri, 20 Apr 2018 08:19:19 -0500
Message-ID: <20180420131919.GA1766@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Free allocated memory for full_path and xid before return.

Addresses-Coverity-ID: 1468029 ("Resource leak")
Fixes: 49162bfde140 ("cifs: do not allow creating sockets except with
SMB1 posix exensions")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/cifs/dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f0a759d..71e32d9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -684,8 +684,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		goto mknod_out;
 	}
 
-	if (!S_ISCHR(mode) && !S_ISBLK(mode))
+	if (!S_ISCHR(mode) && !S_ISBLK(mode)) {
+		kfree(full_path);
+		free_xid(xid);
 		return -EPERM;
+	}
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
 		goto mknod_out;
-- 
2.7.4
