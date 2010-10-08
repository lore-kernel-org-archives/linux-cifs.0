From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: initialize tlink_tree_lock and tlink_tree
Date: Fri,  8 Oct 2010 12:20:12 -0400
Message-ID: <1286554812-26829-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 906b098..1aca2d7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -98,6 +98,9 @@ cifs_read_super(struct super_block *sb, void *data,
 	if (cifs_sb == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&cifs_sb->tlink_tree_lock);
+	INIT_RADIX_TREE(&cifs_sb->tlink_tree, GFP_KERNEL);
+
 	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
 	if (rc) {
 		kfree(cifs_sb);
-- 
1.7.2.3
