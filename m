From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH Backport for 3.4.x] cifs: when CONFIG_HIGHMEM is set, serialize the read/write kmaps
Date: Fri, 20 Jul 2012 10:04:36 -0400
Message-ID: <1342793076-18280-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a backport of commit 3cf003c08be785af4bee9ac05891a15bcbff856a
for 3.4-stable.

The async read code was broadened to include uncached reads in 3.5, so
the mainline patch did not apply directly. This patch is just a backport
to account for that change.

Original patch description follows:

Jian found that when he ran fsx on a 32 bit arch with a large wsize the
process and one of the bdi writeback kthreads would sometimes deadlock
with a stack trace like this:

crash> bt
PID: 2789   TASK: f02edaa0  CPU: 3   COMMAND: "fsx"
 #0 [eed63cbc] schedule at c083c5b3
 #1 [eed63d80] kmap_high at c0500ec8
 #2 [eed63db0] cifs_async_writev at f7fabcd7 [cifs]
 #3 [eed63df0] cifs_writepages at f7fb7f5c [cifs]
 #4 [eed63e50] do_writepages at c04f3e32
 #5 [eed63e54] __filemap_fdatawrite_range at c04e152a
 #6 [eed63ea4] filemap_fdatawrite at c04e1b3e
 #7 [eed63eb4] cifs_file_aio_write at f7fa111a [cifs]
 #8 [eed63ecc] do_sync_write at c052d202
 #9 [eed63f74] vfs_write at c052d4ee
#10 [eed63f94] sys_write at c052df4c
#11 [eed63fb0] ia32_sysenter_target at c0409a98
    EAX: 00000004  EBX: 00000003  ECX: abd73b73  EDX: 012a65c6
    DS:  007b      ESI: 012a65c6  ES:  007b      EDI: 00000000
    SS:  007b      ESP: bf8db178  EBP: bf8db1f8  GS:  0033
    CS:  0073      EIP: 40000424  ERR: 00000004  EFLAGS: 00000246

Each task would kmap part of its address array before getting stuck, but
not enough to actually issue the write.

This patch fixes this by serializing the marshal_iov operations for
async reads and writes. The idea here is to ensure that cifs
aggressively tries to populate a request before attempting to fulfill
another one. As soon as all of the pages are kmapped for a request, then
we can unlock and allow another one to proceed.

There's no need to do this serialization on non-CONFIG_HIGHMEM arches
however, so optimize all of this out when CONFIG_HIGHMEM isn't set.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.4.x
Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6b79efd..3a75ee5 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -89,6 +89,32 @@ static struct {
 /* Forward declarations */
 static void cifs_readv_complete(struct work_struct *work);
 
+#ifdef CONFIG_HIGHMEM
+/*
+ * On arches that have high memory, kmap address space is limited. By
+ * serializing the kmap operations on those arches, we ensure that we don't
+ * end up with a bunch of threads in writeback with partially mapped page
+ * arrays, stuck waiting for kmap to come back. That situation prevents
+ * progress and can deadlock.
+ */
+static DEFINE_MUTEX(cifs_kmap_mutex);
+
+static inline void
+cifs_kmap_lock(void)
+{
+	mutex_lock(&cifs_kmap_mutex);
+}
+
+static inline void
+cifs_kmap_unlock(void)
+{
+	mutex_unlock(&cifs_kmap_mutex);
+}
+#else /* !CONFIG_HIGHMEM */
+#define cifs_kmap_lock() do { ; } while(0)
+#define cifs_kmap_unlock() do { ; } while(0)
+#endif /* CONFIG_HIGHMEM */
+
 /* Mark as invalid, all open files on tree connections since they
    were closed when session to server was lost */
 static void mark_open_files_invalid(struct cifs_tcon *pTcon)
@@ -1557,6 +1583,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
 	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
 
+	cifs_kmap_lock();
 	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
 		if (remaining >= PAGE_CACHE_SIZE) {
 			/* enough data to fill the page */
@@ -1606,6 +1633,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			page_cache_release(page);
 		}
 	}
+	cifs_kmap_unlock();
 
 	/* issue the read if we have any iovecs left to fill */
 	if (rdata->nr_iov > 1) {
@@ -2194,7 +2222,9 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	 * and set the iov_len properly for each one. It may also set
 	 * wdata->bytes too.
 	 */
+	cifs_kmap_lock();
 	wdata->marshal_iov(iov, wdata);
+	cifs_kmap_unlock();
 
 	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
 
-- 
1.7.10.4
