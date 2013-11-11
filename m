From: Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 2/7] Fscache: Implement uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:24 +0800
Message-ID: <57f79ce8b28f2f0e3837f66c3aa99eb078bc5bf7.1384183054.git.liwang@ubuntukylin.com>
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

Similar to the routine for multiple pages except
that it takes page * as input rather than list head *.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/fscache/page.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 7f5c658..0c69f72 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -721,6 +721,14 @@ nobufs:
 }
 EXPORT_SYMBOL(__fscache_alloc_page);
 
+void __fscache_readpage_cancel(struct fscache_cookie *cookie,
+			       struct page *page)
+{
+	if (PageFsCache(page))
+		__fscache_uncache_page(cookie, page);
+}
+EXPORT_SYMBOL(__fscache_readpage_cancel);
+
 /*
  * Unmark pages allocate in the readahead code path (via:
  * fscache_readpages_or_alloc) after delegating to the base filesystem
-- 
1.7.9.5

