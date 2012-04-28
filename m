From: Sedat Dilek <sedat.dilek-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
Date: Sat, 28 Apr 2012 14:13:53 +0200
Message-ID: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
Cc: Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Al Viro" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	"linux-fsdevel" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For more details see <file: Documentation/filesystems/porting>.

Signed-off-by: Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..62843d9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -125,7 +125,7 @@ cifs_read_super(struct super_block *sb)
 		goto out_no_root;
 	}
 
-	/* do that *after* d_alloc_root() - we want NULL ->d_op for root here */
+	/* do that *after* d_make_root() - we want NULL ->d_op for root here */
 	if (cifs_sb_master_tcon(cifs_sb)->nocase)
 		sb->s_d_op = &cifs_ci_dentry_ops;
 	else
-- 
1.7.9.5
