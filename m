From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] manpage: make serverino and noserverino option descriptions clear
Date: Thu, 19 May 2011 13:33:58 +0400
Message-ID: <1305797638-7063-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 mount.cifs.8 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 2ebe19d..ddecb2a 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -363,12 +363,12 @@ When the CIFS Unix Extensions are not negotiated, attempt to create device files
 .PP
 serverino
 .RS 4
-Use inode numbers (unique persistent file identifiers) returned by the server instead of automatically generating temporary inode numbers on the client\&. Although server inode numbers make it easier to spot hardlinked files (as they will have the same inode numbers) and inode numbers may be persistent (which is userful for some sofware), the server does not guarantee that the inode numbers are unique if multiple server side mounts are exported under a single share (since inode numbers on the servers might not be unique if multiple filesystems are mounted under the same shared higher level directory)\&. Note that not all servers support returning server inode numbers, although those that support the CIFS Unix Extensions, and Windows 2000 and later servers typically do support this (althou
 gh not necessarily on every local server filesystem)\&. Parameter has no effect if the server lacks support for returning inode numbers or equivalent\&.
+Use inode numbers (unique persistent file identifiers) returned by the server instead of automatically generating temporary inode numbers on the client\&. Although server inode numbers make it easier to spot hardlinked files (as they will have the same inode numbers) and inode numbers may be persistent (which is userful for some sofware), the server does not guarantee that the inode numbers are unique if multiple server side mounts are exported under a single share (since inode numbers on the servers might not be unique if multiple filesystems are mounted under the same shared higher level directory)\&. Note that not all servers support returning server inode numbers, although those that support the CIFS Unix Extensions, and Windows 2000 and later servers typically do support this (althou
 gh not necessarily on every local server filesystem)\&. Parameter has no effect if the server lacks support for returning inode numbers or equivalent\&. This behavior is enabled by default\&.
 .RE
 .PP
 noserverino
 .RS 4
-Client generates inode numbers (rather than using the actual one from the server) by default\&.
+Client generates inode numbers itself rather than using the actual ones from the server\&.
 .sp
 See section
 \fIINODE NUMBERS\fR
-- 
1.7.1
