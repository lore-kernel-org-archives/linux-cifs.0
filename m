From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] cifs: ensure full_path is free'd on error exit path
Date: Fri, 20 Apr 2018 14:15:19 +0100
Message-ID: <20180420131519.30510-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        samba-technical@lists.samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check on the mode flags that returns -EPERM is leaking
full_path on the error exit return. Fix this by kfree'ing it before
the return.

Detected by CoverityScan, CID#1468029 ("Resource Leak")

Fixes: 49162bfde140 ("cifs: do not allow creating sockets except with SMB1 posix exensions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f0a759dd6817..207883b39362 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -684,8 +684,10 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		goto mknod_out;
 	}
 
-	if (!S_ISCHR(mode) && !S_ISBLK(mode))
+	if (!S_ISCHR(mode) && !S_ISBLK(mode)) {
+		kfree(full_path);
 		return -EPERM;
+	}
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
 		goto mknod_out;
-- 
2.17.0
