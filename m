From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: add a deprecation warning to CIFS_IOC_CHECKUMOUNT ioctl
Date: Fri, 27 Apr 2012 06:11:53 -0400
Message-ID: <1335521513-836-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This was used by an ancient version of umount.cifs and in nowhere else
that I'm aware of. Let's add a warning now and dump it for 3.7.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/ioctl.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 4221b5e..6d2667f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -51,7 +51,15 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	cifs_sb = CIFS_SB(inode->i_sb);
 
 	switch (command) {
+		static bool warned = false;
 		case CIFS_IOC_CHECKUMOUNT:
+			if (!warned) {
+				warned = true;
+				cERROR(1, "the CIFS_IOC_CHECKMOUNT ioctl will "
+					  "be deprecated in 3.7. Please "
+					  "migrate away from the use of "
+					  "umount.cifs");
+			}
 			cFYI(1, "User unmount attempted");
 			if (cifs_sb->mnt_uid == current_uid())
 				rc = 0;
-- 
1.7.7.6
