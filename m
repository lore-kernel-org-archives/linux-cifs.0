From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] manpage: add entry for strictcache option
Date: Thu, 10 Mar 2011 11:55:18 +0300
Message-ID: <1299747318-8164-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 mount.cifs.8 |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index d8ad9f0..2ebe19d 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -220,6 +220,11 @@ directio
 Do not do inode data caching on files opened on this mount\&. This precludes mmaping files on this mount\&. In some cases with fast networks and little or no caching benefits on the client (e\&.g\&. when the application is doing large sequential reads bigger than page size without rereading the same data) this can provide better performance than the default behavior which caches reads (readahead) and writes (writebehind) through the local Linux client pagecache if oplock (caching token) is granted and held\&. Note that direct allows write operations larger than page size to be sent to the server\&. On some kernels this requires the cifs\&.ko module to be built with the CIFS_EXPERIMENTAL configure option\&.
 .RE
 .PP
+strictcache
+.RS 4
+Use for switching on strict cache mode\&. In this mode the client reads from the cache all the time it has Oplock Level II, otherwise - read from the server\&. As for write - the client stores a data in the cache in Exclusive Oplock case, otherwise - write directly to the server\&.
+.RE
+.PP
 mapchars
 .RS 4
 Translate six of the seven reserved characters (not backslash, but including the colon, question mark, pipe, asterik, greater than and less than characters) to the remap range (above 0xF000), which also allows the CIFS client to recognize files created with such characters by Windows\'s POSIX emulation\&. This can also be useful when mounting to most versions of Samba (which also forbids creating and opening files whose names contain any of these seven characters)\&. This has no effect if the server does not support Unicode on the wire\&. Please note that the files created with mapchars mount option may not be accessible if the share is mounted without that option\&.
-- 
1.7.1
