From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/8] cifs: allow caller to specify completion op when allocating writedata
Date: Fri,  3 Feb 2012 09:32:55 -0500
Message-ID: <1328279581-21889-3-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need a different set of write completion ops when not writing out
of the pagecache.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 +++-
 fs/cifs/cifssmb.c   |    6 +++---
 fs/cifs/file.c      |    3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2778605..ff528f3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -485,7 +485,9 @@ struct cifs_writedata {
 };
 
 int cifs_async_writev(struct cifs_writedata *wdata);
-struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages);
+void cifs_writev_complete(struct work_struct *work);
+struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
+						work_func_t complete);
 void cifs_writedata_release(struct kref *refcount);
 
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9525ae3..e03a650 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1990,7 +1990,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 	kref_put(&wdata->refcount, cifs_writedata_release);
 }
 
-static void
+void
 cifs_writev_complete(struct work_struct *work)
 {
 	struct cifs_writedata *wdata = container_of(work,
@@ -2020,7 +2020,7 @@ cifs_writev_complete(struct work_struct *work)
 }
 
 struct cifs_writedata *
-cifs_writedata_alloc(unsigned int nr_pages)
+cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 {
 	struct cifs_writedata *wdata;
 
@@ -2034,7 +2034,7 @@ cifs_writedata_alloc(unsigned int nr_pages)
 	wdata = kzalloc(sizeof(*wdata) +
 			sizeof(struct page *) * (nr_pages - 1), GFP_NOFS);
 	if (wdata != NULL) {
-		INIT_WORK(&wdata->work, cifs_writev_complete);
+		INIT_WORK(&wdata->work, complete);
 		kref_init(&wdata->refcount);
 	}
 	return wdata;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ffbb2b4..5e758d8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1640,7 +1640,8 @@ retry:
 		tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
 				end - index) + 1;
 
-		wdata = cifs_writedata_alloc((unsigned int)tofind);
+		wdata = cifs_writedata_alloc((unsigned int)tofind,
+					     cifs_writev_complete);
 		if (!wdata) {
 			rc = -ENOMEM;
 			break;
-- 
1.7.7.6
