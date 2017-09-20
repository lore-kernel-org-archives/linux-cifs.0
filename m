From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: show 'soft' in the mount options for !hard mounts
Date: Wed, 20 Sep 2017 13:09:23 +1000
Message-ID: <20170920030923.23453-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 180b3356ff86..a864e6575309 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -461,6 +461,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",nocase");
 	if (tcon->retry)
 		seq_puts(s, ",hard");
+	else
+		seq_puts(s, ",soft");
 	if (tcon->use_persistent)
 		seq_puts(s, ",persistenthandles");
 	else if (tcon->use_resilient)
-- 
2.13.3
