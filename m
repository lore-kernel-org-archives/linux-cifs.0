From: Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
Subject: [PATCH 3/7] Ceph: Introduce routine for uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:25 +0800
Message-ID: <a10e4947af6b0c7f5fbaa55e2eb920e9914d88fc.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Cc: ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>,
	Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1384183054.git.liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
In-Reply-To: <cover.1384183054.git.liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
References: <cover.1384183054.git.liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Introduce a routine for uncaching single no-data page, typically
in readpage().

Signed-off-by: Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
---
 fs/ceph/cache.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index ba94940..eb0ec76 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -67,6 +67,14 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return fscache_maybe_release_page(ci->fscache, page, gfp);
 }
 
+
+static inline void cpeh_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	return fscache_readpage_cancel(ci->fscache, page);
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
@@ -145,6 +153,11 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return 1;
 }
 
+static inline void ceph_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
-- 
1.7.9.5
