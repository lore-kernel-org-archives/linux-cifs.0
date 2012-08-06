From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 09/15] cifs: remove the kmap size limit from wsize
Date: Mon,  6 Aug 2012 07:31:06 -0400
Message-ID: <1344252672-15244-10-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we're not kmapping so much at once, there's no need to cap
the wsize at the amount that can be simultaneously kmapped.

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb1ops.c | 3 ---
 fs/cifs/smb2ops.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f6c7a1c..8727ef7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -442,9 +442,6 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
-	/* limit to the amount that we can kmap at once */
-	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
-
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3a8c682..a621d61 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -187,9 +187,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	 */
 	wsize = min_t(unsigned int, wsize, 2 << 15);
 
-	/* limit to the amount that we can kmap at once */
-	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
-
 	return wsize;
 }
 
-- 
1.7.11.2
