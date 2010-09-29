From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: set backing_dev_info on new S_ISREG inodes
Date: Wed, 29 Sep 2010 09:49:54 -0400
Message-ID: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Testing on very recent kernel (2.6.36-rc6) made this warning pop:

    WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x65/0x70()
    Hardware name:
    Dirtiable inode bdi default != sb bdi cifs

...the following patch fixes it and seems to be the obviously correct
thing to do for cifs.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2256124..d6db805 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -853,6 +853,8 @@ retry_iget5_locked:
 			inode->i_flags |= S_NOATIME | S_NOCMTIME;
 		if (inode->i_state & I_NEW) {
 			inode->i_ino = hash;
+			if (S_ISREG(inode->i_mode))
+				inode->i_data.backing_dev_info = sb->s_bdi;
 #ifdef CONFIG_CIFS_FSCACHE
 			/* initialize per-inode cache cookie pointer */
 			CIFS_I(inode)->fscache = NULL;
-- 
1.7.2.3
