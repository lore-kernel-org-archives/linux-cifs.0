From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: update the description of the wsize= option
Date: Tue, 24 May 2011 15:03:53 -0400
Message-ID: <1306263833-29016-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...to account for the changes in the async write patchset.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index ddecb2a..1299725 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -394,9 +394,9 @@ rsize=\fIarg\fR
 default network read size (usually 16K)\&. The client currently can not use rsize larger than CIFSMaxBufSize\&. CIFSMaxBufSize defaults to 16K and may be changed (from 8K to the maximum kmalloc size allowed by your kernel) at module install time for cifs\&.ko\&. Setting CIFSMaxBufSize to a very large value will cause cifs to use more memory and may reduce performance in some cases\&. To use rsize greater than 127K (the original cifs protocol maximum) also requires that the server support a new Unix Capability flag (for very large read) which some newer servers (e\&.g\&. Samba 3\&.0\&.26 or later) do\&. rsize can be set from a minimum of 2048 to a maximum of 130048 (127K or CIFSMaxBufSize, whichever is smaller)
 .RE
 .PP
-wsize=\fIarg\fR
+wsize=\fIbytes\fR
 .RS 4
-default network write size (default 57344) maximum wsize currently allowed by CIFS is 57344 (fourteen 4096 byte pages)
+Maximum amount of data that the kernel will send in a write request in bytes. Prior to kernel 2\&.6\&.40, the default and maximum was 57344 (14 * 4096 pages). As of 2\&.6\&.40, the default is 1M, and the maximum allowed is 16M. Note that this value is just a starting point. The client and server may negotiate this size downward according to the server's capabilities.
 .RE
 .PP
 fsc
-- 
1.7.4.4
