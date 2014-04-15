From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix error handling cifs_user_readv
Date: Tue, 15 Apr 2014 12:48:49 -0400
Message-ID: <1397580529-3305-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Coverity says:

*** CID 1202537:  Dereference after null check  (FORWARD_NULL)
/fs/cifs/file.c: 2873 in cifs_user_readv()
2867     		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
2868     		npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
2869
2870     		/* allocate a readdata struct */
2871     		rdata = cifs_readdata_alloc(npages,
2872     					    cifs_uncached_readv_complete);
>>>     CID 1202537:  Dereference after null check  (FORWARD_NULL)
>>>     Comparing "rdata" to null implies that "rdata" might be null.
2873     		if (!rdata) {
2874     			rc = -ENOMEM;
2875     			goto error;
2876     		}
2877
2878     		rc = cifs_read_allocate_pages(rdata, npages);

...when we "goto error", rc will be non-zero, and then we end up trying
to do a kref_put on the rdata (which is NULL). Fix this by replacing
the "goto error" with a "break".

Reported-by: <scan-admin-S5/EvlXga/RWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8616256cb93f..325b74798ef3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2872,7 +2872,7 @@ ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
 					    cifs_uncached_readv_complete);
 		if (!rdata) {
 			rc = -ENOMEM;
-			goto error;
+			break;
 		}
 
 		rc = cifs_read_allocate_pages(rdata, npages);
-- 
1.9.0
