From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: fix nouser_xattr description
Date: Mon,  8 Jul 2013 09:09:11 -0400
Message-ID: <1373288951-16517-1-git-send-email-jlayton@samba.org>
Cc: domfe-IWqWACnzNjyonA0d6jMUrA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The manpage erroneously states that nouser_xattr is the default, when
it's actually the reverse.

Reported-by: Dome <domfe-IWqWACnzNjyonA0d6jMUrA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 8334f98..2643145 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -475,7 +475,7 @@ for more information\&.
 .PP
 nouser_xattr
 .RS 4
-(default) Do not allow getfattr/setfattr to get/set xattrs, even if server would support it otherwise\&.
+Do not allow getfattr/setfattr to get/set xattrs, even if server would support it otherwise. The default is for xattr support to be enabled.
 .RE
 .PP
 rsize=\fIbytes\fR
-- 
1.8.1.4
