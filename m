From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] manpage: add decription about matching superblock to wsize= option
Date: Fri, 27 May 2011 12:07:03 +0400
Message-ID: <1306483623-8392-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...according to shared superblock capability merged into cifs-2.6
git tree recently.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 mount.cifs.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 1b6a958..dbfa13c 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -396,7 +396,7 @@ default network read size (usually 16K)\&. The client currently can not use rsiz
 .PP
 wsize=\fIbytes\fR
 .RS 4
-Maximum amount of data that the kernel will send in a write request in bytes. Prior to kernel 2\&.6\&.40, the default and maximum was 57344 (14 * 4096 pages). As of 2\&.6\&.40, the default is 1M, and the maximum allowed is 16M. Note that this value is just a starting point for negotiation in 2\&.6\&.40 and up. The client and server may negotiate this size downward according to the server's capabilities. In kernels prior to 2\&.6\&.40, no negotiation is performed.
+Maximum amount of data that the kernel will send in a write request in bytes\&. Prior to kernel 2\&.6\&.40, the default and maximum was 57344 (14 * 4096 pages)\&. As of 2\&.6\&.40, the default is 1M, and the maximum allowed is 16M\&. Note that this value is just a starting point for negotiation in 2\&.6\&.40 and up\&. The client and server may negotiate this size downward according to the server's capabilities\&. In kernels prior to 2\&.6\&.40, no negotiation is performed\&. It can end up with an existing superblock if this value isn't specified or it's greater or equal than the existing one\&.
 .RE
 .PP
 fsc
-- 
1.7.1
