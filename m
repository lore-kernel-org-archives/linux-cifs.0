From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] cifs: remove redundant return in cifs_creation_time_get
Date: Wed,  7 Jun 2017 00:33:45 +0100
Message-ID: <20170606233345.5980-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

There is a redundant return in function cifs_creation_time_get
that appears to be old vestigial code than can be removed. So
remove it.

Detected by CoverityScan, CID#1361924 ("Structurally dead code")

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/cifs/xattr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 3cb5c9e2d4e7..de50e749ff05 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -188,8 +188,6 @@ static int cifs_creation_time_get(struct dentry *dentry, struct inode *inode,
 	pcreatetime = (__u64 *)value;
 	*pcreatetime = CIFS_I(inode)->createtime;
 	return sizeof(__u64);
-
-	return rc;
 }
 
 
-- 
2.11.0
