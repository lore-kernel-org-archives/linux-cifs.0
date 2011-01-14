From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: fix the SEE ALSO section
Date: Fri, 14 Jan 2011 15:43:43 -0500
Message-ID: <1295037823-9683-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It references umount.cifs(8) which is no longer shipped as part of
cifs-utils. Replace it with a reference to cifs.upcall(8) instead.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 469440d..d8ad9f0 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -495,7 +495,7 @@ This man page is correct for version 1\&.52 of the cifs vfs filesystem (roughly
 .PP
 Documentation/filesystems/cifs\&.txt and fs/cifs/README in the linux kernel source tree may contain additional options and information\&.
 .PP
-\fBumount.cifs\fR(8)
+\fBcifs.upcall\fR(8)
 .SH "AUTHOR"
 .PP
 Steve French
-- 
1.7.3.4
