From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: lower default and max wsize to what 2.6.39 can handle (try #2)
Date: Wed, 13 Jul 2011 06:59:12 -0400
Message-ID: <1310554752-29240-1-git-send-email-jlayton@redhat.com>
References: <1310553637-26792-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, helge.hafting-CND4fxrytsY@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310553637-26792-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch is intended for 2.6.39-stable kernels only and is needed to
fix a regression introduced in 2.6.39. Prior to 2.6.39, when signing was
enabled on a socket the client only sent single-page writes. This
changed with commit ca83ce3, which made signed and unsigned connections
use the same codepaths for write calls.

This caused a regression when working with windows servers. Windows
machines will reject writes larger than the MaxBufferSize when signing
is active, but do not clear the CAP_LARGE_WRITE_X flag in the protocol
negotiation. The upshot is that when signing is active, windows servers
often reject large writes from the client in 2.6.39.

Because 3.0 adds support for larger wsize values, simply cherry picking
the upstream patches that fix the wsize negotiation isn't sufficient to
fix this issue. We also need to alter the maximum and default values to
something suitable for 2.6.39.

This patch also accounts for the change in field name from sec_mode to
secMode that went into 3.0.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # .39.x: f7910cb: cifs: clean up wsize negotiation and allow for larger wsize
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # .39.x: 1190f6a: cifs: fix wsize negotiation to respect max buffer size and active signing (try #4)
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 599f485..01db14c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2648,16 +2648,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
-/*
- * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not including
- * the RFC1001 length.
- *
- * Note that this might make for "interesting" allocation problems during
- * writeback however as we have to allocate an array of pointers for the
- * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
- */
-#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
+/* Prior to 3.0, cifs couldn't handle writes larger than this */
+#define CIFS_MAX_WSIZE (PAGEVEC_SIZE * PAGE_CACHE_SIZE)
 
 /*
  * When the server doesn't allow large posix writes, only allow a wsize of
@@ -2666,12 +2658,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
  */
 #define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
 
-/*
- * The default wsize is 1M. find_get_pages seems to return a maximum of 256
- * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
- * a single wsize request with a single call.
- */
-#define CIFS_DEFAULT_WSIZE (1024 * 1024)
+/* Make the default the same as the max */
+#define CIFS_DEFAULT_WSIZE CIFS_MAX_WSIZE
 
 static unsigned int
 cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)
@@ -2692,7 +2680,7 @@ cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)
 	 */
 	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
 	    (!(server->capabilities & CAP_UNIX) &&
-	     (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
+	     (server->secMode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
-- 
1.7.6
