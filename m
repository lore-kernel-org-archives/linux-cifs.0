From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 15/15] cifs: remove kmap lock and rsize limit
Date: Mon,  6 Aug 2012 07:31:12 -0400
Message-ID: <1344252672-15244-16-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we aren't abusing the kmap address space, there's no need for
this lock or to impose a limit on the rsize.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  4 ----
 fs/cifs/cifsglob.h | 39 ---------------------------------------
 fs/cifs/smb1ops.c  |  3 ---
 fs/cifs/smb2ops.c  |  3 ---
 4 files changed, 49 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4dda489..3a3e2fe 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -88,10 +88,6 @@ extern mempool_t *cifs_mid_poolp;
 
 struct workqueue_struct	*cifsiod_wq;
 
-#ifdef CONFIG_HIGHMEM
-DEFINE_MUTEX(cifs_kmap_mutex);
-#endif
-
 static int
 cifs_read_super(struct super_block *sb)
 {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de98a1a..a976aa6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -637,45 +637,6 @@ get_next_mid(struct TCP_Server_Info *server)
 #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
 /*
- * On hosts with high memory, we can't currently support wsize/rsize that are
- * larger than we can kmap at once. Cap the rsize/wsize at
- * LAST_PKMAP * PAGE_SIZE. We'll never be able to fill a read or write request
- * larger than that anyway.
- */
-#ifdef CONFIG_HIGHMEM
-#define CIFS_KMAP_SIZE_LIMIT   (LAST_PKMAP * PAGE_CACHE_SIZE)
-#else /* CONFIG_HIGHMEM */
-#define CIFS_KMAP_SIZE_LIMIT   (1<<24)
-#endif /* CONFIG_HIGHMEM */
-
-#ifdef CONFIG_HIGHMEM
-/*
- * On arches that have high memory, kmap address space is limited. By
- * serializing the kmap operations on those arches, we ensure that we don't
- * end up with a bunch of threads in writeback with partially mapped page
- * arrays, stuck waiting for kmap to come back. That situation prevents
- * progress and can deadlock.
- */
-
-extern struct mutex cifs_kmap_mutex;
-
-static inline void
-cifs_kmap_lock(void)
-{
-	mutex_lock(&cifs_kmap_mutex);
-}
-
-static inline void
-cifs_kmap_unlock(void)
-{
-	mutex_unlock(&cifs_kmap_mutex);
-}
-#else /* !CONFIG_HIGHMEM */
-#define cifs_kmap_lock() do { ; } while (0)
-#define cifs_kmap_unlock() do { ; } while (0)
-#endif /* CONFIG_HIGHMEM */
-
-/*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
  */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8727ef7..ed7f955 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -483,9 +483,6 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	if (!(server->capabilities & CAP_LARGE_READ_X))
 		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
 
-	/* limit to the amount that we can kmap at once */
-	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
-
 	/* hard limit of CIFS_MAX_RSIZE */
 	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a621d61..b1dedf8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -205,9 +205,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	 */
 	rsize = min_t(unsigned int, rsize, 2 << 15);
 
-	/* limit to the amount that we can kmap at once */
-	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
-
 	return rsize;
 }
 
-- 
1.7.11.2
