From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] Display persistenthandles in /proc/mounts for SMB3 shares if enabled
Date: Wed, 30 Sep 2015 21:08:42 -0500
Message-ID: <1443665322-22306-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e739950..13302e9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -454,6 +454,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",nocase");
 	if (tcon->retry)
 		seq_puts(s, ",hard");
+	if (tcon->use_persistent)
+		seq_puts(s, ",persistenthandles");
 	if (tcon->unix_ext)
 		seq_puts(s, ",unix");
 	else
-- 
1.9.1
