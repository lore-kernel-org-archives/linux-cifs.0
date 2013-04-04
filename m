From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] CIFS: fix error return code in cifs_atomic_open()
Date: Thu, 4 Apr 2013 14:16:21 +0800
Message-ID: <CAPgLHd-3rC7ZJz+SWnd-Gt1C9RxtPs58OCCMgOeHvgdT3TFj5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 fs/cifs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 46e455e..5699b50 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -457,8 +457,10 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		 inode, direntry->d_name.name, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
 		goto out_free_xid;
+	}
 
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
