Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E6CC32774
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbiHWQ1x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244479AbiHWQ1a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:27:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBEE4D4F3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:53:50 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MBnvM20DTzkWK5;
        Tue, 23 Aug 2022 20:03:59 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 20:07:27 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 1/2] cifs: Add release function to cifs_writedata
Date:   Tue, 23 Aug 2022 21:06:36 +0800
Message-ID: <20220823130637.1164764-2-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
References: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The release function is determined when init the cifs_writedata,
so add it to the struct cifs_writedata.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/cifsproto.h |  6 +++--
 fs/cifs/file.c      | 57 ++++++++++++++++++++++++---------------------
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f15d7b0c123d..19223df189d0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1459,6 +1459,7 @@ struct cifs_readdata {
 /* asynchronous write support */
 struct cifs_writedata {
 	struct kref			refcount;
+	void				(*release)(struct kref *arg);
 	struct list_head		list;
 	struct completion		done;
 	enum writeback_sync_modes	sync_mode;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3bc94bcc7177..10890c0c0910 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -577,9 +577,11 @@ int cifs_async_writev(struct cifs_writedata *wdata,
 		      void (*release)(struct kref *kref));
 void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
-						work_func_t complete);
+					    work_func_t complete,
+					    void (*release)(struct kref *));
 struct cifs_writedata *cifs_writedata_direct_alloc(struct page **pages,
-						work_func_t complete);
+						work_func_t complete,
+						void (*release)(struct kref *));
 void cifs_writedata_release(struct kref *refcount);
 int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa738adc031f..56d1b28fb476 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2327,7 +2327,9 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 			tailsz = rest_len - (nr_pages - 1) * PAGE_SIZE;
 		}
 
-		wdata2 = cifs_writedata_alloc(nr_pages, cifs_writev_complete);
+		wdata2 = cifs_writedata_alloc(nr_pages,
+					      cifs_writev_complete,
+					      cifs_writedata_release);
 		if (!wdata2) {
 			rc = -ENOMEM;
 			break;
@@ -2355,8 +2357,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 				rc = -EBADF;
 		} else {
 			wdata2->pid = wdata2->cfile->pid;
-			rc = server->ops->async_writev(wdata2,
-						       cifs_writedata_release);
+			rc = server->ops->async_writev(wdata2, wdata2->release);
 		}
 
 		for (j = 0; j < nr_pages; j++) {
@@ -2368,7 +2369,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 			}
 		}
 
-		kref_put(&wdata2->refcount, cifs_writedata_release);
+		kref_put(&wdata2->refcount, wdata2->release);
 		if (rc) {
 			if (is_retryable_error(rc))
 				continue;
@@ -2389,7 +2390,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 
 	if (rc != 0 && !is_retryable_error(rc))
 		mapping_set_error(inode->i_mapping, rc);
-	kref_put(&wdata->refcount, cifs_writedata_release);
+	kref_put(&wdata->refcount, wdata->release);
 }
 
 void
@@ -2422,28 +2423,31 @@ cifs_writev_complete(struct work_struct *work)
 	}
 	if (wdata->result != -EAGAIN)
 		mapping_set_error(inode->i_mapping, wdata->result);
-	kref_put(&wdata->refcount, cifs_writedata_release);
+	kref_put(&wdata->refcount, wdata->release);
 }
 
 struct cifs_writedata *
-cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
+cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete,
+		     void (*release)(struct kref *))
 {
 	struct page **pages =
 		kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 	if (pages)
-		return cifs_writedata_direct_alloc(pages, complete);
+		return cifs_writedata_direct_alloc(pages, complete, release);
 
 	return NULL;
 }
 
 struct cifs_writedata *
-cifs_writedata_direct_alloc(struct page **pages, work_func_t complete)
+cifs_writedata_direct_alloc(struct page **pages, work_func_t complete,
+			    void (*release)(struct kref *))
 {
 	struct cifs_writedata *wdata;
 
 	wdata = kzalloc(sizeof(*wdata), GFP_NOFS);
 	if (wdata != NULL) {
 		wdata->pages = pages;
+		wdata->release = release;
 		kref_init(&wdata->refcount);
 		INIT_LIST_HEAD(&wdata->list);
 		init_completion(&wdata->done);
@@ -2519,7 +2523,8 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
 	struct cifs_writedata *wdata;
 
 	wdata = cifs_writedata_alloc((unsigned int)tofind,
-				     cifs_writev_complete);
+				     cifs_writev_complete,
+				     cifs_writedata_release);
 	if (!wdata)
 		return NULL;
 
@@ -2630,8 +2635,7 @@ wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
 	if (wdata->cfile->invalidHandle)
 		rc = -EAGAIN;
 	else
-		rc = wdata->server->ops->async_writev(wdata,
-						      cifs_writedata_release);
+		rc = wdata->server->ops->async_writev(wdata, wdata->release);
 
 	return rc;
 }
@@ -2706,7 +2710,7 @@ static int cifs_writepages(struct address_space *mapping,
 		}
 
 		if (found_pages == 0) {
-			kref_put(&wdata->refcount, cifs_writedata_release);
+			kref_put(&wdata->refcount, wdata->release);
 			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
@@ -2716,7 +2720,7 @@ static int cifs_writepages(struct address_space *mapping,
 
 		/* nothing to write? */
 		if (nr_pages == 0) {
-			kref_put(&wdata->refcount, cifs_writedata_release);
+			kref_put(&wdata->refcount, wdata->release);
 			add_credits_and_wake_if(server, credits, 0);
 			continue;
 		}
@@ -2754,7 +2758,7 @@ static int cifs_writepages(struct address_space *mapping,
 			if (!is_retryable_error(rc))
 				mapping_set_error(mapping, rc);
 		}
-		kref_put(&wdata->refcount, cifs_writedata_release);
+		kref_put(&wdata->refcount, wdata->release);
 
 		if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN) {
 			index = saved_index;
@@ -3107,7 +3111,7 @@ cifs_uncached_writev_complete(struct work_struct *work)
 	complete(&wdata->done);
 	collect_uncached_write_data(wdata->ctx);
 	/* the below call can possibly free the last ref to aio ctx */
-	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
+	kref_put(&wdata->refcount, wdata->release);
 }
 
 static int
@@ -3203,7 +3207,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 				}
 #endif
 				rc = server->ops->async_writev(wdata,
-					cifs_uncached_writedata_release);
+							       wdata->release);
 			}
 		}
 
@@ -3218,7 +3222,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 	} while (rc == -EAGAIN);
 
 fail:
-	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
+	kref_put(&wdata->refcount, wdata->release);
 	return rc;
 }
 
@@ -3290,7 +3294,8 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 				(cur_len + start + PAGE_SIZE - 1) / PAGE_SIZE;
 
 			wdata = cifs_writedata_direct_alloc(pagevec,
-					     cifs_uncached_writev_complete);
+					     cifs_uncached_writev_complete,
+					     cifs_uncached_writedata_release);
 			if (!wdata) {
 				rc = -ENOMEM;
 				add_credits_and_wake_if(server, credits, 0);
@@ -3307,7 +3312,8 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		} else {
 			nr_pages = get_numpages(wsize, len, &cur_len);
 			wdata = cifs_writedata_alloc(nr_pages,
-					     cifs_uncached_writev_complete);
+					     cifs_uncached_writev_complete,
+					     cifs_uncached_writedata_release);
 			if (!wdata) {
 				rc = -ENOMEM;
 				add_credits_and_wake_if(server, credits, 0);
@@ -3362,14 +3368,12 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
 			else
-				rc = server->ops->async_writev(wdata,
-					cifs_uncached_writedata_release);
+				rc = server->ops->async_writev(wdata, wdata->release);
 		}
 
 		if (rc) {
 			add_credits_and_wake_if(server, &wdata->credits, 0);
-			kref_put(&wdata->refcount,
-				 cifs_uncached_writedata_release);
+			kref_put(&wdata->refcount, wdata->release);
 			if (rc == -EAGAIN) {
 				*from = saved_from;
 				iov_iter_advance(from, offset - saved_offset);
@@ -3444,8 +3448,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 						ctx->cfile, cifs_sb, &tmp_list,
 						ctx);
 
-					kref_put(&wdata->refcount,
-						cifs_uncached_writedata_release);
+					kref_put(&wdata->refcount, wdata->release);
 				}
 
 				list_splice(&tmp_list, &ctx->list);
@@ -3453,7 +3456,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 			}
 		}
 		list_del_init(&wdata->list);
-		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
+		kref_put(&wdata->refcount, wdata->release);
 	}
 
 	cifs_stats_bytes_written(tcon, ctx->total_len);
-- 
2.31.1

