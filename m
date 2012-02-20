From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: update wsize= entry to account for change in default wsize
Date: Mon, 20 Feb 2012 09:04:06 -0500
Message-ID: <1329746646-20398-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 74aa061..1f07d2c 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -457,7 +457,9 @@ Maximum amount of data that the kernel will request in a read request in bytes.
 .PP
 wsize=\fIbytes\fR
 .RS 4
-Maximum amount of data that the kernel will send in a write request in bytes\&. Prior to kernel 3\&.0\&.0, the default and maximum was 57344 (14 * 4096 pages)\&. As of 3\&.0\&.0, the default is 1M, and the maximum allowed is 16M\&. Note that this value is just a starting point for negotiation in 3\&.0\&.0 and up\&. The client and server may negotiate this size downward according to the server's capabilities\&. In kernels prior to 3\&.0\&.0, no negotiation is performed\&. It can end up with an existing superblock if this value isn't specified or it's greater or equal than the existing one\&.
+Maximum amount of data that the kernel will send in a write request in bytes\&. Prior to kernel 3\&.0\&.0, the default and maximum was 57344 (14 * 4096 pages)\&. As of 3\&.0\&.0, the default depends on whether the client and server negotiate large writes via POSIX extensions. If they do, then the default is 1M, and the maximum allowed is 16M\&. If they do not, then the default is 65536 and the maximum allowed is 131007.
+.PP
+Note that this value is just a starting point for negotiation in 3\&.0\&.0 and up\&. The client and server may negotiate this size downward according to the server's capabilities\&. In kernels prior to 3\&.0\&.0, no negotiation is performed\&. It can end up with an existing superblock if this value isn't specified or it's greater or equal than the existing one\&.
 .RE
 .PP
 fsc
-- 
1.7.7.6
