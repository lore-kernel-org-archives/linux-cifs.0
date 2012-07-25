From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 8/9] cifs: remove the kmap size limit from wsize
Date: Wed, 25 Jul 2012 11:54:11 -0400
Message-ID: <1343231652-10459-9-git-send-email-jlayton@redhat.com>
References: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343231652-10459-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we're not kmapping so much at once, there's no need to cap
the wsize at the amount that can be simultaneously kmapped.

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a828a8c..c4d5285 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3352,9 +3352,6 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
-	/* limit to the amount that we can kmap at once */
-	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
-
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
 
-- 
1.7.11.2
