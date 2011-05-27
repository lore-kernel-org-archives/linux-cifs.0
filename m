From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] manpage: add entry for rwpidforward option
Date: Fri, 27 May 2011 12:25:24 +0400
Message-ID: <1306484724-8648-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 mount.cifs.8 |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index dbfa13c..d58135c 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -225,6 +225,11 @@ strictcache
 Use for switching on strict cache mode\&. In this mode the client reads from the cache all the time it has Oplock Level II, otherwise - read from the server\&. As for write - the client stores a data in the cache in Exclusive Oplock case, otherwise - write directly to the server\&.
 .RE
 .PP
+rwpidforward
+.RS 4
+Forward pid of a process who opened a file to any read or write operation on that file\&. This prevent applications like WINE from failing on read and write if we use mandatory brlock style\&.
+.RE
+.PP
 mapchars
 .RS 4
 Translate six of the seven reserved characters (not backslash, but including the colon, question mark, pipe, asterik, greater than and less than characters) to the remap range (above 0xF000), which also allows the CIFS client to recognize files created with such characters by Windows\'s POSIX emulation\&. This can also be useful when mounting to most versions of Samba (which also forbids creating and opening files whose names contain any of these seven characters)\&. This has no effect if the server does not support Unicode on the wire\&. Please note that the files created with mapchars mount option may not be accessible if the share is mounted without that option\&.
-- 
1.7.1
