From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 6/8] cifs: fix up get_numpages
Date: Fri,  3 Feb 2012 09:32:59 -0500
Message-ID: <1328279581-21889-7-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use DIV_ROUND_UP. Also, PAGE_SIZE is more appropriate here since these
aren't pagecache pages.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6afa40f..264e99c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2027,9 +2027,7 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 	size_t clen;
 
 	clen = min_t(const size_t, len, wsize);
-	num_pages = clen / PAGE_CACHE_SIZE;
-	if (clen % PAGE_CACHE_SIZE)
-		num_pages++;
+	num_pages = DIV_ROUND_UP(clen, PAGE_SIZE);
 
 	if (cur_len)
 		*cur_len = clen;
-- 
1.7.7.6
