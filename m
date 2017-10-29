From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix tcon leak in cifs_atomic_open error path
Date: Mon, 30 Oct 2017 10:57:11 +1100
Message-ID: <20171029235711.13743-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 513ff2986c97..81ba6e0d88d8 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -521,7 +521,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	rc = check_name(direntry, tcon);
 	if (rc)
-		goto out_free_xid;
+		goto out;
 
 	server = tcon->ses->server;
 
-- 
2.13.3
