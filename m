From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: on CONFIG_HIGHMEM machines, limit the rsize/wsize to the kmap space
Date: Wed, 11 Jul 2012 09:09:35 -0400
Message-ID: <1342012176-14783-2-git-send-email-jlayton@redhat.com>
References: <1342012176-14783-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342012176-14783-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We currently rely on being able to kmap all of the pages in an async
read or write request. If you're on a machine that has CONFIG_HIGHMEM
set then that kmap space is limited, sometimes to as low as 512 slots.

With 512 slots, we can only support up to a 2M r/wsize, and that's
assuming that we can get our greedy little hands on all of them. There
are other users however, so it's possible we'll end up stuck with a
size that large.

Since we can't handle a rsize or wsize larger than that currently, cap
those options at the number of kmap slots we have. We could consider
capping it even lower, but we currently default to a max of 1M. Might as
well allow those luddites on 32 bit arches enough rope to hang
themselves.

A more robust fix would be to teach the send and receive routines how
to contend with an array of pages so we don't need to marshal up a kvec
array at all. That's a fairly significant overhaul though, so we'll need
this limit in place until that's ready.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 278ca0e..e8c3e6b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3445,6 +3445,18 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
 #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
 
+/*
+ * On hosts with high memory, we can't currently support wsize/rsize that are
+ * larger than we can kmap at once. Cap the rsize/wsize at
+ * LAST_PKMAP * PAGE_SIZE. We'll never be able to fill a read or write request
+ * larger than that anyway.
+ */
+#ifdef CONFIG_HIGHMEM
+#define CIFS_KMAP_SIZE_LIMIT	(LAST_PKMAP * PAGE_CACHE_SIZE)
+#else /* CONFIG_HIGHMEM */
+#define CIFS_KMAP_SIZE_LIMIT	(1<<24)
+#endif /* CONFIG_HIGHMEM */
+
 static unsigned int
 cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 {
@@ -3475,6 +3487,9 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
+	/* limit to the amount that we can kmap at once */
+	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
+
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
 
@@ -3516,6 +3531,9 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	if (!(server->capabilities & CAP_LARGE_READ_X))
 		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
 
+	/* limit to the amount that we can kmap at once */
+	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
+
 	/* hard limit of CIFS_MAX_RSIZE */
 	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
 
-- 
1.7.7.6
