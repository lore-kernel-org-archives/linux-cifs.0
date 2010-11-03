From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: trivial comment fix: tlink_tree is now a rbtree
Date: Wed, 03 Nov 2010 10:53:49 +0530
Message-ID: <4CD0F1E5.70107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Noticed while reviewing (late) the rbtree conversion patchset (which has been merged
already).

Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c9699ce..251a17c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3324,7 +3324,7 @@ tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink)
  * If the superblock doesn't refer to a multiuser mount, then just return
  * the master tcon for the mount.
  *
- * First, search the radix tree for an existing tcon for this fsuid. If one
+ * First, search the rbtree for an existing tcon for this fsuid. If one
  * exists, then check to see if it's pending construction. If it is then wait
  * for construction to complete. Once it's no longer pending, check to see if
  * it failed and either return an error or retry construction, depending on
