From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 25/45] CIFS: Add SMB2 support for cifs_iovec_write
Date: Wed, 18 Jul 2012 19:48:41 +0400
Message-ID: <1342626541-29872-26-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    2 +
 fs/cifs/cifsglob.h  |   47 +++++++++++++++++++
 fs/cifs/cifsproto.h |   18 -------
 fs/cifs/cifssmb.c   |   26 -----------
 fs/cifs/smb2ops.c   |    1 +
 fs/cifs/smb2pdu.c   |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   30 ++++++++++++
 fs/cifs/smb2proto.h |    1 +
 8 files changed, 204 insertions(+), 44 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 54d8b13..65f8b05 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -89,6 +89,8 @@ extern mempool_t *cifs_mid_poolp;
 
 struct workqueue_struct	*cifsiod_wq;
 
+DEFINE_MUTEX(cifs_kmap_mutex);
+
 static int
 cifs_read_super(struct super_block *sb)
 {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 61a013e..68eda60 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -582,6 +582,33 @@ get_next_mid(struct TCP_Server_Info *server)
 #define CIFS_KMAP_SIZE_LIMIT   (1<<24)
 #endif /* CONFIG_HIGHMEM */
 
+#ifdef CONFIG_HIGHMEM
+/*
+ * On arches that have high memory, kmap address space is limited. By
+ * serializing the kmap operations on those arches, we ensure that we don't
+ * end up with a bunch of threads in writeback with partially mapped page
+ * arrays, stuck waiting for kmap to come back. That situation prevents
+ * progress and can deadlock.
+ */
+
+extern struct mutex cifs_kmap_mutex;
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
+#define cifs_kmap_lock() do { ; } while (0)
+#define cifs_kmap_unlock() do { ; } while (0)
+#endif /* CONFIG_HIGHMEM */
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
@@ -891,6 +918,26 @@ struct cifs_readdata {
 	struct kvec			iov[1];
 };
 
+struct cifs_writedata;
+
+/* asynchronous write support */
+struct cifs_writedata {
+	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
+	enum writeback_sync_modes	sync_mode;
+	struct work_struct		work;
+	struct cifsFileInfo		*cfile;
+	__u64				offset;
+	pid_t				pid;
+	unsigned int			bytes;
+	int				result;
+	void (*marshal_iov) (struct kvec *iov,
+			     struct cifs_writedata *wdata);
+	unsigned int			nr_pages;
+	struct page			*pages[1];
+};
+
 /*
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 949be72..01d5514 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -467,24 +467,6 @@ void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
 int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
-/* asynchronous write support */
-struct cifs_writedata {
-	struct kref			refcount;
-	struct list_head		list;
-	struct completion		done;
-	enum writeback_sync_modes	sync_mode;
-	struct work_struct		work;
-	struct cifsFileInfo		*cfile;
-	__u64				offset;
-	pid_t				pid;
-	unsigned int			bytes;
-	int				result;
-	void (*marshal_iov) (struct kvec *iov,
-			     struct cifs_writedata *wdata);
-	unsigned int			nr_pages;
-	struct page			*pages[1];
-};
-
 int cifs_async_writev(struct cifs_writedata *wdata);
 void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 715781a..d27c8be 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -86,32 +86,6 @@ static struct {
 #endif /* CONFIG_CIFS_WEAK_PW_HASH */
 #endif /* CIFS_POSIX */
 
-#ifdef CONFIG_HIGHMEM
-/*
- * On arches that have high memory, kmap address space is limited. By
- * serializing the kmap operations on those arches, we ensure that we don't
- * end up with a bunch of threads in writeback with partially mapped page
- * arrays, stuck waiting for kmap to come back. That situation prevents
- * progress and can deadlock.
- */
-static DEFINE_MUTEX(cifs_kmap_mutex);
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
-#define cifs_kmap_lock() do { ; } while(0)
-#define cifs_kmap_unlock() do { ; } while(0)
-#endif /* CONFIG_HIGHMEM */
-
 /*
  * Mark as invalid, all open files on tree connections since they
  * were closed when session to server was lost.
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ba4adf2..74e8bce 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -425,6 +425,7 @@ struct smb_version_operations smb21_operations = {
 	.close = smb2_close_file,
 	.flush = smb2_flush_file,
 	.async_readv = smb2_async_readv,
+	.async_writev = smb2_async_writev,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 69646ac..c998fbe 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -33,6 +33,7 @@
 #include <linux/vfs.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
@@ -1326,3 +1327,125 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	cifs_small_buf_release(buf);
 	return rc;
 }
+
+/*
+ * Check the mid_state and signature on received buffer (if any), and queue the
+ * workqueue completion task.
+ */
+static void
+smb2_writev_callback(struct mid_q_entry *mid)
+{
+	struct cifs_writedata *wdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	unsigned int written;
+	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
+	unsigned int credits_received = 1;
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		credits_received = le16_to_cpu(rsp->hdr.CreditRequest);
+		wdata->result = smb2_check_receive(mid, tcon->ses->server, 0);
+		if (wdata->result != 0)
+			break;
+
+		written = le32_to_cpu(rsp->DataLength);
+		/*
+		 * Mask off high 16 bits when bytes written as returned
+		 * by the server is greater than bytes requested by the
+		 * client. OS/2 servers are known to set incorrect
+		 * CountHigh values.
+		 */
+		if (written > wdata->bytes)
+			written &= 0xFFFF;
+
+		if (written < wdata->bytes)
+			wdata->result = -ENOSPC;
+		else
+			wdata->bytes = written;
+		break;
+	case MID_REQUEST_SUBMITTED:
+	case MID_RETRY_NEEDED:
+		wdata->result = -EAGAIN;
+		break;
+	default:
+		wdata->result = -EIO;
+		break;
+	}
+
+	if (wdata->result)
+		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
+
+	queue_work(cifsiod_wq, &wdata->work);
+	DeleteMidQEntry(mid);
+	add_credits(tcon->ses->server, credits_received, 0);
+}
+
+/* smb2_async_writev - send an async write, and set up mid to handle result */
+int
+smb2_async_writev(struct cifs_writedata *wdata)
+{
+	int i, rc = -EACCES;
+	struct smb2_write_req *req = NULL;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	struct kvec *iov = NULL;
+
+	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
+	if (rc)
+		goto async_writev_out;
+
+	/* 1 iov per page + 1 for header */
+	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
+	if (iov == NULL) {
+		rc = -ENOMEM;
+		goto async_writev_out;
+	}
+
+	req->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
+
+	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
+	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
+	req->WriteChannelInfoOffset = 0;
+	req->WriteChannelInfoLength = 0;
+	req->Channel = 0;
+	req->Offset = cpu_to_le64(wdata->offset);
+	/* 4 for rfc1002 length field */
+	req->DataOffset = cpu_to_le16(
+				offsetof(struct smb2_write_req, Buffer) - 4);
+	req->RemainingBytes = 0;
+
+	/* 4 for rfc1002 length field and 1 for Buffer */
+	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	iov[0].iov_base = (char *)req;
+
+	/*
+	 * This function should marshal up the page array into the kvec
+	 * array, reserving [0] for the header. It should kmap the pages
+	 * and set the iov_len properly for each one. It may also set
+	 * wdata->bytes too.
+	 */
+	cifs_kmap_lock();
+	wdata->marshal_iov(iov, wdata);
+	cifs_kmap_unlock();
+
+	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
+
+	req->Length = cpu_to_le32(wdata->bytes);
+
+	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
+
+	kref_get(&wdata->refcount);
+	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
+			     NULL, smb2_writev_callback, wdata, 0);
+
+	if (rc)
+		kref_put(&wdata->refcount, cifs_writedata_release);
+
+	/* send is done, unmap pages */
+	for (i = 0; i < wdata->nr_pages; i++)
+		kunmap(wdata->pages[i]);
+
+async_writev_out:
+	cifs_small_buf_release(req);
+	kfree(iov);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d73367c..4712273 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -494,6 +494,36 @@ struct smb2_read_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+/* For write request Flags field below the following flag is defined: */
+#define SMB2_WRITEFLAG_WRITE_THROUGH 0x00000001
+
+struct smb2_write_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 49 */
+	__le16 DataOffset; /* offset from start of SMB2 header to write data */
+	__le32 Length;
+	__le64 Offset;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le32 Channel; /* Reserved MBZ */
+	__le32 RemainingBytes;
+	__le16 WriteChannelInfoOffset; /* Reserved MBZ */
+	__le16 WriteChannelInfoLength; /* Reserved MBZ */
+	__le32 Flags;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_write_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 17 */
+	__u8   DataOffset;
+	__u8   Reserved;
+	__le32 DataLength;
+	__le32 DataRemaining;
+	__u32  Reserved2;
+	__u8   Buffer[1];
+} __packed;
+
 struct smb2_echo_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f442e46..ec983be 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -98,6 +98,7 @@ extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
 			    u64 persistent_fid, u64 volatile_fid,
 			    __le64 *uniqueid);
 extern int smb2_async_readv(struct cifs_readdata *rdata);
+extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
