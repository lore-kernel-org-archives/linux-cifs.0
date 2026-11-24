Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.242
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527021;
	b=dpukvJJp5OKcR6bDNLD9pAyp/lV75feyHxheNPE5qw7TSGtyBWDhAzraCtAz2XSFTGd8
	 ypAkyTKnG8H5/tHC/XD+82IMAtVysUwWJ/qk3AR7SF35FwjQ53utIMmLOkmdyD6KxZ8Re
	 x+JFF7K4U5TNZGCE6/U6BjeE5yQ+joCwG87y+dAVi8zxor69mviwThmUEAD0ojAmTwlug
	 BcrrqZ4SnHdUepMJ2edpr9ZDMeEqmueY9+wKZ84QaCEkXuZ1qzz2C5Tiku4Jjyfsc5Bu/
	 1i9rRDBI7dtg31v2qysicwqLLhj7uJkPTafcdXZVLp7xulInKs2uO7etcI5kNAA+rJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527021;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bDJJmsywtw1ziyz8T+jZo04gCYo92QdTpz8Ri8SxZ9A=;
	b=5Lv/FlT5eLH1+p757xKVgTILU95WDhosBGBBYD9YPKYSW/pXeAPg37WIE02zbt52HiKi
	 odK2bGB/GRKaQtkHN6zb8XtBLLMU2pHvsq+ZSr5mbZ0w+6bioiDH05UOiE89Y0cOwXp7d
	 qNM+uFMB4bB3AjX58X7l8/Z/iPHy0w/GrHGjzNd1sZkzhgUiDx/PfyKadlOSm2NQtUwjk
	 ptfTbjb1sXcXF1XtpxuK1UAc3rkxQWq2kTJofanIlp28jItcsYQb1JM6Od7/ru9AoCJre
	 ArUi66aywCT+iQKSiCxXO1B9Qnyte9bn+GMcmPo4PcwKU8xhdY4jS9NEMQOmFkCBgdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H7Tlr71N;
	arc=none smtp.remote-ip=91.218.175.242
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EC3606A321
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 13:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47EC3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H7Tlr71N
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fEevxZaFt4kz3qPtLNmR563MRhb5YI7SUck20cuGz8k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795527018; v=1; x=1796131818;
 b=H7Tlr71NOVOs1IB9xmTKeB40DmuO8M6r0T+tCcrnKNZROq17H5q0lx/2m2OAmTOYAFLG7yJR
 zF5VyC/lu2KZwq66ejkxdL0cTo+3V6F8UmMlRd7B6ppDCkZi5HtlK8LpZY47HuMPjY/3Jmlmp/g
 39cYQd3kLuVd/mtEUnygyt+M=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7628e9cfa8d793d2;
	Tue, 24 Nov 2026 13:30:17 +0000
X-Mizu-Trace-ID: 7628e9cfa8d793d2
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: send READ payloads with MSG_SPLICE_PAGES
Date: Tue, 24 Nov 2026 21:25:53 +0800
Message-ID: <20261124132554.1185817-2-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124132554.1185817-1-huiwen.he@linux.dev>
References: <20261124132554.1185817-1-huiwen.he@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

kernel_read() fills the READ response buffer with file data. TCP then
copies the same data into an skb when sending the reply.

For plain, standalone READs, put the payload in private pages and the
header in a page fragment. Pass both to TCP with MSG_SPLICE_PAGES so
it can attach the pages directly to an skb.

Tested with fio sequential reads (16 jobs, QD32 per job) from a
4-vCPU virtio-net guest. The Xeon Gold 6430 host had 128 logical CPUs
and served a tmpfs share over SMB3.1.1.

Channels  I/O       Throughput (MiB/s)        Host Gcycles/GiB
                   before   after change    before   after change
       1  4 KiB     288.3   287.5  -0.3%    27.347  27.850  +1.8%
       1  64 KiB   1975.3  2536.1 +28.4%     6.815   4.668 -31.5%
       1  256 KiB  2007.2  3228.5 +60.8%     7.515   4.468 -40.5%
       1  1 MiB    2058.7  3119.9 +51.5%     5.446   3.646 -33.1%
       4  4 KiB     456.2   457.3  +0.2%    23.792  23.997  +0.9%
       4  64 KiB   4260.4  4427.3  +3.9%     3.207   2.985  -6.9%
       4  256 KiB  6270.3  7026.3 +12.1%     3.418   1.948 -43.0%
       4  1 MiB    6660.0  7833.2 +17.6%     3.879   2.347 -39.5%

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 fs/smb/server/connection.c    | 18 +++++++++
 fs/smb/server/connection.h    |  1 +
 fs/smb/server/ksmbd_work.c    | 24 +++++++-----
 fs/smb/server/ksmbd_work.h    |  8 +++-
 fs/smb/server/smb2pdu.c       | 74 +++++++++++++++++++++++++++++------
 fs/smb/server/transport_tcp.c | 52 ++++++++++++++++++++++--
 fs/smb/server/transport_tcp.h |  1 +
 7 files changed, 152 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 01e5cc13a12a..87ac1126af3b 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -533,6 +533,23 @@ int ksmbd_conn_wait_idle_sess(struct ksmbd_conn *curr_conn,
 	return 0;
 }
 
+static bool ksmbd_can_splice_read(const struct ksmbd_work *work, int size)
+{
+	const struct kvec *iov = work->iov;
+	const struct smb2_read_rsp *rsp;
+
+	/* A credit error or a transform can replace the response iovs. */
+	if (!work->splice_read || work->iov_cnt != 3 ||
+	    iov[0].iov_len != sizeof(__be32) ||
+	    iov[1].iov_len != offsetof(struct smb2_read_rsp, Buffer))
+		return false;
+
+	rsp = iov[1].iov_base;
+	return !(rsp->hdr.Flags & SMB2_FLAGS_SIGNED) &&
+		iov[2].iov_len == le32_to_cpu(rsp->DataLength) &&
+		iov[0].iov_len + iov[1].iov_len + iov[2].iov_len == size;
+}
+
 static int __ksmbd_conn_write(struct ksmbd_work *work,
 			      struct ksmbd_transport_write *tx)
 {
@@ -553,6 +570,7 @@ static int __ksmbd_conn_write(struct ksmbd_work *work,
 	tx->iov = work->iov;
 	tx->iov_cnt = work->iov_cnt;
 	tx->size = get_rfc1002_len(work->iov[0].iov_base) + 4;
+	tx->splice_read = ksmbd_can_splice_read(work, tx->size);
 	tx->need_invalidate_rkey = work->need_invalidate_rkey;
 	tx->remote_key = work->remote_key;
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 6855c1ab691e..891612382d0f 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -175,6 +175,7 @@ struct ksmbd_transport_write {
 	struct kvec	*iov;
 	int		iov_cnt;
 	int		size;
+	bool		splice_read;
 	bool		need_invalidate_rkey;
 	unsigned int	remote_key;
 	int		msg_flags;
diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 6e5122e2d6fc..ad576683493f 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -65,6 +65,14 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 	return work;
 }
 
+void ksmbd_free_read_buf(void *buf, struct folio *folio)
+{
+	if (folio)
+		folio_put(folio);
+	else
+		kvfree(buf);
+}
+
 void ksmbd_free_work_struct(struct ksmbd_work *work)
 {
 	struct aux_read *ar, *tmp;
@@ -74,7 +82,7 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kvfree(work->response_buf);
 
 	list_for_each_entry_safe(ar, tmp, &work->aux_read_list, entry) {
-		kvfree(ar->buf);
+		ksmbd_free_read_buf(ar->buf, ar->folio);
 		list_del(&ar->entry);
 		kfree(ar);
 	}
@@ -151,8 +159,9 @@ static inline void __ksmbd_iov_pin(struct ksmbd_work *work, void *ib,
 	work->iov_cnt++;
 }
 
-static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
-			       void *aux_buf, unsigned int aux_size)
+int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
+			   void *aux_buf, unsigned int aux_size,
+			   struct folio *folio)
 {
 	struct aux_read *ar = NULL;
 	int need_iov_cnt = 1;
@@ -185,6 +194,7 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 		inc_rfc1001_len(work->iov[0].iov_base, aux_size);
 
 		ar->buf = aux_buf;
+		ar->folio = folio;
 		list_add(&ar->entry, &work->aux_read_list);
 	}
 
@@ -193,13 +203,7 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len)
 {
-	return __ksmbd_iov_pin_rsp(work, ib, len, NULL, 0);
-}
-
-int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
-			   void *aux_buf, unsigned int aux_size)
-{
-	return __ksmbd_iov_pin_rsp(work, ib, len, aux_buf, aux_size);
+	return ksmbd_iov_pin_rsp_read(work, ib, len, NULL, 0, NULL);
 }
 
 int allocate_interim_rsp_buf(struct ksmbd_work *work)
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 27c8705910fe..9fce93582eda 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -13,6 +13,7 @@ struct ksmbd_conn;
 struct ksmbd_session;
 struct ksmbd_tree_connect;
 struct ksmbd_file;
+struct folio;
 
 #define KSMBD_WORK_INLINE_IOVS	4
 
@@ -24,6 +25,7 @@ enum {
 
 struct aux_read {
 	void *buf;
+	struct folio *folio;
 	struct list_head entry;
 };
 
@@ -93,6 +95,8 @@ struct ksmbd_work {
 	bool                            encrypted:1;
 	/* READ response should be wrapped in a compression transform. */
 	bool                            compress_response:1;
+	/* Standalone READ payload is backed by spliceable pages. */
+	bool                            splice_read:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
 	bool                            asynchronous:1;
 	bool                            need_invalidate_rkey:1;
@@ -166,7 +170,9 @@ bool ksmbd_queue_work(struct ksmbd_work *work);
 void ksmbd_queue_io_work(struct work_struct *work);
 void ksmbd_queue_break_work(struct work_struct *work);
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
-			   void *aux_buf, unsigned int aux_size);
+			   void *aux_buf, unsigned int aux_size,
+			   struct folio *folio);
+void ksmbd_free_read_buf(void *buf, struct folio *folio);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
 int allocate_interim_rsp_buf(struct ksmbd_work *work);
 #endif /* __KSMBD_WORK_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6bd63c5e7da3..58948dd9e9ec 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -13,12 +13,14 @@
 #include <linux/statfs.h>
 #include <linux/ethtool.h>
 #include <linux/falloc.h>
+#include <linux/highmem.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/fileattr.h>
 #include <linux/math.h>
 #include <linux/timekeeping.h>
 #include <linux/unaligned.h>
+#include <linux/vmalloc.h>
 
 #include "glob.h"
 #include "../common/smbfsctl.h"
@@ -8540,7 +8542,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	rc = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 			offsetof(struct smb2_query_info_rsp, Buffer),
-			pntsd, secdesclen);
+			pntsd, secdesclen, NULL);
 err_out:
 	if (rc) {
 		rsp->OutputBufferLength = 0;
@@ -9645,7 +9647,7 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
 	err = ksmbd_iov_pin_rsp_read(work, rsp,
 				     offsetof(struct smb2_read_rsp, Buffer),
-				     aux_payload_buf, nbytes);
+				     aux_payload_buf, nbytes, NULL);
 	if (err) {
 		kvfree(aux_payload_buf);
 		goto out_put;
@@ -9969,6 +9971,53 @@ static ssize_t smb2_read_rdma(struct ksmbd_work *work,
 	return length;
 }
 
+static bool smb2_read_splice_eligible(struct ksmbd_work *work,
+				      const struct smb2_read_req *req)
+{
+	return !work->next_smb2_rcv_hdr_off && !req->hdr.NextCommand &&
+		!work->encrypted && !work->sess->sign && !work->conn->sign &&
+		!(req->hdr.Flags & SMB2_FLAGS_SIGNED) &&
+		!(req->Flags & SMB2_READFLAG_REQUEST_COMPRESSED) &&
+		req->Channel == SMB2_CHANNEL_NONE &&
+		ksmbd_transport_is_tcp(work->conn->transport);
+}
+
+static void *smb2_alloc_read_buf(size_t size, bool splice, struct folio **folio)
+{
+	if (splice) {
+		unsigned int order = get_order(size);
+		void *buf;
+
+		if (order <= MAX_PAGE_ORDER) {
+			*folio = folio_alloc(GFP_NOWAIT | __GFP_NORETRY, order);
+			if (*folio)
+				return folio_address(*folio);
+		}
+
+		buf = __vmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+		if (buf)
+			return buf;
+	}
+	return kvmalloc(size, KSMBD_DEFAULT_GFP);
+}
+
+static void smb2_set_splice_payload(struct ksmbd_work *work, void *buf,
+				    size_t length, struct folio *folio)
+{
+	if (length < PAGE_SIZE)
+		return;
+	if (folio) {
+		/* A short READ should not pin a mostly unused folio in TCP. */
+		if (get_order(length) < folio_order(folio))
+			return;
+	} else {
+		if (!is_vmalloc_addr(buf))
+			return;
+		flush_kernel_vmap_range(buf, length);
+	}
+	work->splice_read = true;
+}
+
 /**
  * smb2_read() - handler for smb2 read from file
  * @work:	smb work containing read command buffer
@@ -9987,9 +10036,11 @@ int smb2_read(struct ksmbd_work *work)
 	int err = 0;
 	int rdma_transform_len = 0;
 	bool is_rdma_channel = false, async_interim = false;
+	bool splice;
 	unsigned int max_read_size = conn->vals->max_read_size;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
-	void *aux_payload_buf;
+	void *aux_payload_buf = NULL;
+	struct folio *folio = NULL;
 
 	ksmbd_debug(SMB, "Received smb2 read request\n");
 
@@ -10102,7 +10153,9 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
 		    fp->filp, offset, length);
 
-	aux_payload_buf = kvmalloc(ALIGN(length, 8), KSMBD_DEFAULT_GFP);
+	splice = length >= PAGE_SIZE && !ksmbd_stream_fd(fp) &&
+		 smb2_read_splice_eligible(work, req);
+	aux_payload_buf = smb2_alloc_read_buf(ALIGN(length, 8), splice, &folio);
 	if (!aux_payload_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -10110,7 +10163,6 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
-		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
@@ -10125,7 +10177,7 @@ int smb2_read(struct ksmbd_work *work)
 		memset(aux_payload_buf + nbytes, 0, ALIGN(nbytes, 8) - nbytes);
 
 	if ((nbytes == 0 && length != 0) || nbytes < mincount) {
-		kvfree(aux_payload_buf);
+		ksmbd_free_read_buf(aux_payload_buf, folio);
 		rsp->hdr.Status = STATUS_END_OF_FILE;
 		smb2_set_err_rsp(work);
 		if (async_interim)
@@ -10143,7 +10195,6 @@ int smb2_read(struct ksmbd_work *work)
 							 aux_payload_buf,
 							 nbytes);
 		if (rdma_transform_len < 0) {
-			kvfree(aux_payload_buf);
 			err = rdma_transform_len;
 			goto out;
 		}
@@ -10179,11 +10230,11 @@ int smb2_read(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 				     offsetof(struct smb2_read_rsp, Buffer) +
 				     rdma_transform_len,
-				     aux_payload_buf, nbytes);
-	if (err) {
-		kvfree(aux_payload_buf);
+				     aux_payload_buf, nbytes, folio);
+	if (err)
 		goto out;
-	}
+	if (splice)
+		smb2_set_splice_payload(work, aux_payload_buf, nbytes, folio);
 	if (async_interim)
 		release_async_work(work);
 	/*
@@ -10199,6 +10250,7 @@ int smb2_read(struct ksmbd_work *work)
 	return 0;
 
 out:
+	ksmbd_free_read_buf(aux_payload_buf, folio);
 	if (async_interim)
 		release_async_work(work);
 	if (err) {
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 870f3cf0c227..ae7957ec3e04 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/freezer.h>
+#include <linux/page_frag_cache.h>
 #include <linux/uio.h>
 
 #include "smb_common.h"
@@ -46,6 +47,7 @@ struct tcp_transport {
 	unsigned int			nr_iov;
 	/* Serializes queue access and socket writes. Never taken by callbacks. */
 	struct mutex			tx_lock;
+	struct page_frag_cache		tx_frag_cache;
 	struct list_head		tx_queue;
 	struct delayed_work		tx_work;
 	size_t				tx_queued;
@@ -91,6 +93,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 		return NULL;
 	t->sock = client_sk;
 	mutex_init(&t->tx_lock);
+	page_frag_cache_init(&t->tx_frag_cache);
 	INIT_LIST_HEAD(&t->tx_queue);
 	INIT_DELAYED_WORK(&t->tx_work, ksmbd_tcp_tx_work);
 
@@ -142,6 +145,7 @@ static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 
 	ksmbd_tcp_stop_tx(t);
 	sock_release(t->sock);
+	page_frag_cache_drain(&t->tx_frag_cache);
 	kfree(t->iov);
 	kfree(t);
 }
@@ -613,14 +617,54 @@ static void ksmbd_tcp_stop_tx(struct tcp_transport *t)
 	wake_up_all(&t->transport.conn->req_running_q);
 }
 
+static int ksmbd_tcp_send(struct tcp_transport *t,
+			  const struct ksmbd_transport_write *tx)
+{
+	struct msghdr hdr = {
+		.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | tx->msg_flags,
+	};
+	struct kvec *iov = tx->iov;
+	struct kvec vec[2];
+	void *header;
+	size_t len;
+	int ret;
+
+	if (!tx->splice_read)
+		goto copy;
+
+	len = iov[0].iov_len + iov[1].iov_len;
+	header = page_frag_alloc(&t->tx_frag_cache, len, GFP_NOWAIT);
+	if (!header)
+		goto copy;
+
+	/*
+	 * Copy the length prefix and SMB header into a fragment
+	 * TCP can retain. The READ payload is already spliceable.
+	 */
+	memcpy(header, iov[0].iov_base, iov[0].iov_len);
+	memcpy(header + iov[0].iov_len, iov[1].iov_base, iov[1].iov_len);
+	vec[0].iov_base = header;
+	vec[0].iov_len = len;
+	vec[1] = iov[2];
+	hdr.msg_flags |= MSG_SPLICE_PAGES;
+	ret = kernel_sendmsg(t->sock, &hdr, vec, ARRAY_SIZE(vec), tx->size);
+	page_frag_free(header);
+	return ret;
+
+copy:
+	return kernel_sendmsg(t->sock, &hdr, iov, tx->iov_cnt, tx->size);
+}
+
+bool ksmbd_transport_is_tcp(struct ksmbd_transport *t)
+{
+	return t->ops == &ksmbd_tcp_transport_ops;
+}
+
 static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 			    const struct ksmbd_transport_write *tx)
 {
 	struct tcp_transport *tt = TCP_TRANS(t);
 	struct sock *sk = tt->sock->sk;
-	struct msghdr hdr = {
-		.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | tx->msg_flags,
-	};
 	struct tcp_tx *msg;
 	unsigned long deadline = jiffies + KSMBD_TCP_SEND_TIMEOUT;
 	long timeout;
@@ -659,7 +703,7 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 
 	/* Avoid an extra copy when the socket accepts the whole PDU at once. */
 	if (list_empty(&tt->tx_queue)) {
-		sent = kernel_sendmsg(tt->sock, &hdr, tx->iov, tx->iov_cnt, tx->size);
+		sent = ksmbd_tcp_send(tt, tx);
 		if (sent > 0) {
 			tt->tx_sent += sent;
 			if (sent == tx->size)
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index 1e51675ee1b2..0fdebcd47fdf 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -7,6 +7,7 @@
 #define __KSMBD_TRANSPORT_TCP_H__
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
+bool ksmbd_transport_is_tcp(struct ksmbd_transport *t);
 struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
 void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
-- 
2.43.0

