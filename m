From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/8] cifs: fix allocation in cifs_write_allocate_pages
Date: Fri,  3 Feb 2012 09:32:57 -0500
Message-ID: <1328279581-21889-5-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The gfp flags are currently set to __GPF_HIGHMEM, which doesn't allow
for any reclaim. Make this more resilient by or'ing that with
GFP_KERNEL. Also, get rid of the goto and unify the exit codepath.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index febf32e..6afa40f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2001,7 +2001,7 @@ cifs_write_allocate_pages(struct page **pages, unsigned long num_pages)
 	unsigned long i;
 
 	for (i = 0; i < num_pages; i++) {
-		pages[i] = alloc_page(__GFP_HIGHMEM);
+		pages[i] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
 		if (!pages[i]) {
 			/*
 			 * save number of pages we have already allocated and
@@ -2009,15 +2009,14 @@ cifs_write_allocate_pages(struct page **pages, unsigned long num_pages)
 			 */
 			num_pages = i;
 			rc = -ENOMEM;
-			goto error;
+			break;
 		}
 	}
 
-	return rc;
-
-error:
-	for (i = 0; i < num_pages; i++)
-		put_page(pages[i]);
+	if (rc) {
+		for (i = 0; i < num_pages; i++)
+			put_page(pages[i]);
+	}
 	return rc;
 }
 
-- 
1.7.7.6
