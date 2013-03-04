From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/2] cifs: call print_hex_dump instead of custom implementation
Date: Mon,  4 Mar 2013 11:41:06 +0200
Message-ID: <1362390066-4548-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362390066-4548-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362390066-4548-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index b2ddb4f..11d45ba 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -34,27 +34,10 @@
 void
 cifs_dump_mem(char *label, void *data, int length)
 {
-	int i, j;
-	int *intptr = data;
-	char *charptr = data;
-	char buf[10], line[80];
-
 	printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
 		label, length, data);
-	for (i = 0; i < length; i += 16) {
-		line[0] = 0;
-		for (j = 0; (j < 4) && (i + j * 4 < length); j++) {
-			sprintf(buf, " %08x", intptr[i / 4 + j]);
-			strcat(line, buf);
-		}
-		buf[0] = ' ';
-		buf[2] = 0;
-		for (j = 0; (j < 16) && (i + j < length); j++) {
-			buf[1] = isprint(charptr[i + j]) ? charptr[i + j] : '.';
-			strcat(line, buf);
-		}
-		printk(KERN_DEBUG "%s\n", line);
-	}
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 16, 4,
+		       data, length, true);
 }
 
 void cifs_dump_detail(void *buf)
-- 
1.8.2.rc0.22.gb3600c3
