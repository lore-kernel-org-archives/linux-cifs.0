From: Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 1/7] Fscache: Introduce new API fscache_readpage_cancel()
Date: Mon, 11 Nov 2013 23:27:23 +0800
Message-ID: <ec97baea70056e5546bc8df0ba29e30edb057b76.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	Milosz Tanski <milosz@adfin.com>,
	Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Introduce a new API fscache_readpage_cancel() for uncaching one single
no-data page from fscache.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 include/linux/fscache.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 115bb81..f1ed21f 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -245,6 +245,8 @@ extern bool __fscache_maybe_release_page(struct fscache_cookie *, struct page *,
 					 gfp_t);
 extern void __fscache_uncache_all_inode_pages(struct fscache_cookie *,
 					      struct inode *);
+extern void __fscache_readpage_cancel(struct fscache_cookie *cookie,
+				      struct page *page);
 extern void __fscache_readpages_cancel(struct fscache_cookie *cookie,
 				       struct list_head *pages);
 extern void __fscache_disable_cookie(struct fscache_cookie *, bool);
@@ -633,6 +635,15 @@ int fscache_alloc_page(struct fscache_cookie *cookie,
 		return -ENOBUFS;
 }
 
+static inline
+void fscache_readpage_cancel(struct fscache_cookie *cookie,
+			     struct page *page)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_readpage_cancel(cookie, page);
+}
+
+
 /**
  * fscache_readpages_cancel - Cancel read/alloc on pages
  * @cookie: The cookie representing the inode's cache object.
-- 
1.7.9.5

