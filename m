From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/5] tlock: munmap missed before close
Date: Wed,  6 Aug 2014 16:01:08 +0400
Message-ID: <1407326472-13853-2-git-send-email-pshilovsky@samba.org>
References: <1407326472-13853-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407326472-13853-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

test13 mmaps the testfile, but doesn't munmap it before returning.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 lock/tlock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lock/tlock.c b/lock/tlock.c
index 39a6ad9..6e19a3d 100644
--- a/lock/tlock.c
+++ b/lock/tlock.c
@@ -1509,6 +1509,7 @@ test13()
 			FATAL);
 		test(13, 4, F_TLOCK, (off_t)mappedlen - 2, (off_t)END,
 			lock1err, WARN);
+		testmunmap();
 		close_testfile(DO_UNLINK);
 
 		childfree(0);
-- 
1.8.1.2
