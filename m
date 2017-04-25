From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 1/3] CIFS: Add asynchronous context to support kernel AIO
Date: Tue, 25 Apr 2017 11:52:29 -0700
Message-ID: <1493146351-124933-2-git-send-email-pshilov@microsoft.com>
References: <1493146351-124933-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493146351-124933-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the code doesn't recognize asynchronous calls passed
by io_submit() and processes all calls synchronously. This is not
what kernel AIO expects. This patch introduces a new async context
that keeps track of all issued i/o requests and moves a response
collecting procedure to a separate thread. This allows to return
to a caller immediately for async calls and call iocb->ki_complete()
once all requests are completed. For sync calls the current thread
simply waits until all requests are completed.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  16 +++++++
 fs/cifs/cifsproto.h |   3 ++
 fs/cifs/misc.c      | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 37f5a41..bb41226 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1115,6 +1115,22 @@ struct cifs_io_parms {
 	struct cifs_tcon *tcon;
 };
 
+struct cifs_aio_ctx {
+	struct kref		refcount;
+	struct list_head	list;
+	struct mutex		aio_mutex;
+	struct completion	done;
+	struct iov_iter		iter;
+	struct kiocb		*iocb;
+	struct cifsFileInfo	*cfile;
+	struct bio_vec		*bv;
+	unsigned int		npages;
+	ssize_t			rc;
+	unsigned int		len;
+	unsigned int		total_len;
+	bool			should_dirty;
+};
+
 struct cifs_readdata;
 
 /* asynchronous read support */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 97e5d23..e49958c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -535,4 +535,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct shash_desc *shash);
 enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
+struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
+void cifs_aio_ctx_release(struct kref *refcount);
+int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d3fb115..c214d77 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/mempool.h>
+#include <linux/vmalloc.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -745,3 +746,122 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	}
 	return rc;
 }
+
+struct cifs_aio_ctx *
+cifs_aio_ctx_alloc(void)
+{
+	struct cifs_aio_ctx *ctx;
+
+	ctx = kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	INIT_LIST_HEAD(&ctx->list);
+	mutex_init(&ctx->aio_mutex);
+	init_completion(&ctx->done);
+	kref_init(&ctx->refcount);
+	return ctx;
+}
+
+void
+cifs_aio_ctx_release(struct kref *refcount)
+{
+	struct cifs_aio_ctx *ctx = container_of(refcount,
+					struct cifs_aio_ctx, refcount);
+
+	cifsFileInfo_put(ctx->cfile);
+	kvfree(ctx->bv);
+	kfree(ctx);
+}
+
+#define CIFS_AIO_KMALLOC_LIMIT (1024 * 1024)
+
+int
+setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
+{
+	ssize_t rc;
+	unsigned int cur_npages;
+	unsigned int npages = 0;
+	unsigned int i;
+	size_t len;
+	size_t count = iov_iter_count(iter);
+	unsigned int saved_len;
+	size_t start;
+	unsigned int max_pages = iov_iter_npages(iter, INT_MAX);
+	struct page **pages = NULL;
+	struct bio_vec *bv = NULL;
+
+	if (iter->type & ITER_KVEC) {
+		memcpy(&ctx->iter, iter, sizeof(struct iov_iter));
+		ctx->len = count;
+		iov_iter_advance(iter, count);
+		return 0;
+	}
+
+	if (max_pages * sizeof(struct bio_vec) <= CIFS_AIO_KMALLOC_LIMIT)
+		bv = kmalloc_array(max_pages, sizeof(struct bio_vec),
+				   GFP_KERNEL);
+
+	if (!bv) {
+		bv = vmalloc(max_pages * sizeof(struct bio_vec));
+		if (!bv)
+			return -ENOMEM;
+	}
+
+	if (max_pages * sizeof(struct page *) <= CIFS_AIO_KMALLOC_LIMIT)
+		pages = kmalloc_array(max_pages, sizeof(struct page *),
+				      GFP_KERNEL);
+
+	if (!pages) {
+		pages = vmalloc(max_pages * sizeof(struct page *));
+		if (!bv) {
+			kvfree(bv);
+			return -ENOMEM;
+		}
+	}
+
+	saved_len = count;
+
+	while (count && npages < max_pages) {
+		rc = iov_iter_get_pages(iter, pages, count, max_pages, &start);
+		if (rc < 0) {
+			cifs_dbg(VFS, "couldn't get user pages (rc=%zd)\n", rc);
+			break;
+		}
+
+		if (rc > count) {
+			cifs_dbg(VFS, "get pages rc=%zd more than %zu\n", rc,
+				 count);
+			break;
+		}
+
+		iov_iter_advance(iter, rc);
+		count -= rc;
+		rc += start;
+		cur_npages = DIV_ROUND_UP(rc, PAGE_SIZE);
+
+		if (npages + cur_npages > max_pages) {
+			cifs_dbg(VFS, "out of vec array capacity (%u vs %u)\n",
+				 npages + cur_npages, max_pages);
+			break;
+		}
+
+		for (i = 0; i < cur_npages; i++) {
+			len = rc > PAGE_SIZE ? PAGE_SIZE : rc;
+			bv[npages + i].bv_page = pages[i];
+			bv[npages + i].bv_offset = start;
+			bv[npages + i].bv_len = len - start;
+			rc -= len;
+			start = 0;
+		}
+
+		npages += cur_npages;
+	}
+
+	kvfree(pages);
+	ctx->bv = bv;
+	ctx->len = saved_len - count;
+	ctx->npages = npages;
+	iov_iter_bvec(&ctx->iter, ITER_BVEC | rw, ctx->bv, npages, ctx->len);
+	return 0;
+}
-- 
2.7.4
