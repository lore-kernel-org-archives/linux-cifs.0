Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C54246BB9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744286; cv=none; b=YaHWtJ82o0bKQ+yeQ7JMKdsKnkYve4aiNAYzjU34h3pTN2LPSGcblKV89g2Gl6rkVeRT2oFDeJ+sFJbV/k+GXaa2ex7t+iVrcrT/kwb9hYSGMq760AuSK2zbAKikbE/w9oWSr121GWxNhetylA+i/QjlBdCPVYWSQJjB18KZVYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744286; c=relaxed/simple;
	bh=1Xr0KxrjuR+51cFwnllOC40xDTyN/iMSwuBE24szn7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwGNupNJ2PevIYJdGoj/seiXj9spKhAedUJnd7wiMHJr+wwVh3yzrtk14EkCQi1OlRcwpF8kx8Ozs1z8ghrxbDxC7ztt6rhgXhJXYHI9+WV4A8e54BRlus2jxloARnKF7JPRDWTnPp3Pa9FVzUILz6vTUCqewtrI5LoiKvwccQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dtb+t6RP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dtb+t6RP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DT/7e7WfE45l2kdVJz0AY3K1U8amTgllYg4kqgZWwZs=; b=dtb+t6RPY2ZENfeVkiR2CvZVUB
	RushGkvYGfRFujqkYzyxelQ+xjDNg3zd73YPPH18mgdE+GZlc/0v9OdvyofVD/+lpeBJCpLSAZdbf
	QZww0AAAlf5O5AdlLHd7IhCTUPytEsomEwjhWW38QCT7JWPdW8okppCr4t8tLk7QEVnk2MRqZBcxF
	CJOu6WiZvkUTDK+WRV5fG7KEz8LwqlBhc8O7O4GibIgnIXRrcrpZkPTHlfxPqV+RO0TQnXE1Y2kUF
	WSbckpsNayVW/82eFPZ5htVqouiz0c40KAJ47JrDffHf+iN56+3zBam5u/mO21SFmz9KzMnNtb5ZM
	lad3rgD1hVY/R7svSfZUAv5nYKAOD6HFj2ukAOKkIJ8pAOSpMHXLr1YEvI3uBcvyx/pzmqSzO3rYx
	g5erDgumVkkKlG6K3kFchw+gMtU0eoezfWtw0SUH6NCAhwtj6cg/xYeN8m2lWynPpTARS7znbNjyh
	0nhguTxcks1zoiqbwfVpgCnL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6AL-00BbXN-2V;
	Wed, 29 Oct 2025 13:24:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 022/127] smb: smbdirect: introduce smbdirect_map_sges_from_iter() and helper functions
Date: Wed, 29 Oct 2025 14:20:00 +0100
Message-ID: <1f3540d2048ec15e54b5c2a28eab416696ebd04b.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are basically copies of smb_extract_iter_to_rdma() and its helpers
in the client, which will be replaced in the next steps.

The goal is to use them also in the server, which will simplify a lot.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 255 ++++++++++++++++++
 1 file changed, 255 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index dedc47916e0e..1113a7e9d575 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -5,6 +5,19 @@
  */
 
 #include "smbdirect_internal.h"
+#include <linux/folio_queue.h>
+
+struct smbdirect_map_sges {
+	struct ib_sge *sge;
+	size_t num_sge;
+	size_t max_sge;
+	struct ib_device *device;
+	u32 local_dma_lkey;
+	enum dma_data_direction direction;
+};
+
+static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
+					    struct smbdirect_map_sges *state);
 
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error);
@@ -525,3 +538,245 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
+
+static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
+					   struct page *page, size_t off, size_t len)
+{
+	struct ib_sge *sge;
+	u64 addr;
+
+	if (state->num_sge >= state->max_sge)
+		return false;
+
+	addr = ib_dma_map_page(state->device, page,
+			       off, len, state->direction);
+	if (ib_dma_mapping_error(state->device, addr))
+		return false;
+
+	sge = &state->sge[state->num_sge++];
+	sge->addr   = addr;
+	sge->length = len;
+	sge->lkey   = state->local_dma_lkey;
+
+	return true;
+}
+
+/*
+ * Extract page fragments from a BVEC-class iterator and add them to an ib_sge
+ * list.  The pages are not pinned.
+ */
+static ssize_t smbdirect_map_sges_from_bvec(struct iov_iter *iter,
+					    struct smbdirect_map_sges *state,
+					    ssize_t maxsize)
+{
+	const struct bio_vec *bv = iter->bvec;
+	unsigned long start = iter->iov_offset;
+	unsigned int i;
+	ssize_t ret = 0;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		size_t off, len;
+		bool ok;
+
+		len = bv[i].bv_len;
+		if (start >= len) {
+			start -= len;
+			continue;
+		}
+
+		len = min_t(size_t, maxsize, len - start);
+		off = bv[i].bv_offset + start;
+
+		ok = smbdirect_map_sges_single_page(state,
+						    bv[i].bv_page,
+						    off,
+						    len);
+		if (!ok)
+			return -EIO;
+
+		ret += len;
+		maxsize -= len;
+		if (state->num_sge >= state->max_sge || maxsize <= 0)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/*
+ * Extract fragments from a KVEC-class iterator and add them to an ib_sge list.
+ * This can deal with vmalloc'd buffers as well as kmalloc'd or static buffers.
+ * The pages are not pinned.
+ */
+static ssize_t smbdirect_map_sges_from_kvec(struct iov_iter *iter,
+					    struct smbdirect_map_sges *state,
+					    ssize_t maxsize)
+{
+	const struct kvec *kv = iter->kvec;
+	unsigned long start = iter->iov_offset;
+	unsigned int i;
+	ssize_t ret = 0;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		struct page *page;
+		unsigned long kaddr;
+		size_t off, len, seg;
+
+		len = kv[i].iov_len;
+		if (start >= len) {
+			start -= len;
+			continue;
+		}
+
+		kaddr = (unsigned long)kv[i].iov_base + start;
+		off = kaddr & ~PAGE_MASK;
+		len = min_t(size_t, maxsize, len - start);
+		kaddr &= PAGE_MASK;
+
+		maxsize -= len;
+		do {
+			bool ok;
+
+			seg = min_t(size_t, len, PAGE_SIZE - off);
+
+			if (is_vmalloc_or_module_addr((void *)kaddr))
+				page = vmalloc_to_page((void *)kaddr);
+			else
+				page = virt_to_page((void *)kaddr);
+
+			ok = smbdirect_map_sges_single_page(state, page, off, seg);
+			if (!ok)
+				return -EIO;
+
+			ret += seg;
+			len -= seg;
+			kaddr += PAGE_SIZE;
+			off = 0;
+		} while (len > 0 && state->num_sge < state->max_sge);
+
+		if (state->num_sge >= state->max_sge || maxsize <= 0)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/*
+ * Extract folio fragments from a FOLIOQ-class iterator and add them to an
+ * ib_sge list.  The folios are not pinned.
+ */
+static ssize_t smbdirect_map_sges_from_folioq(struct iov_iter *iter,
+					      struct smbdirect_map_sges *state,
+					      ssize_t maxsize)
+{
+	const struct folio_queue *folioq = iter->folioq;
+	unsigned int slot = iter->folioq_slot;
+	ssize_t ret = 0;
+	size_t offset = iter->iov_offset;
+
+	if (WARN_ON_ONCE(!folioq))
+		return -EIO;
+
+	if (slot >= folioq_nr_slots(folioq)) {
+		folioq = folioq->next;
+		if (WARN_ON_ONCE(!folioq))
+			return -EIO;
+		slot = 0;
+	}
+
+	do {
+		struct folio *folio = folioq_folio(folioq, slot);
+		size_t fsize = folioq_folio_size(folioq, slot);
+
+		if (offset < fsize) {
+			size_t part = umin(maxsize, fsize - offset);
+			bool ok;
+
+			ok = smbdirect_map_sges_single_page(state,
+							    folio_page(folio, 0),
+							    offset,
+							    part);
+			if (!ok)
+				return -EIO;
+
+			offset += part;
+			ret += part;
+			maxsize -= part;
+		}
+
+		if (offset >= fsize) {
+			offset = 0;
+			slot++;
+			if (slot >= folioq_nr_slots(folioq)) {
+				if (!folioq->next) {
+					WARN_ON_ONCE(ret < iter->count);
+					break;
+				}
+				folioq = folioq->next;
+				slot = 0;
+			}
+		}
+	} while (state->num_sge < state->max_sge && maxsize > 0);
+
+	iter->folioq = folioq;
+	iter->folioq_slot = slot;
+	iter->iov_offset = offset;
+	iter->count -= ret;
+	return ret;
+}
+
+/*
+ * Extract page fragments from up to the given amount of the source iterator
+ * and build up an ib_sge list that refers to all of those bits.  The ib_sge list
+ * is appended to, up to the maximum number of elements set in the parameter
+ * block.
+ *
+ * The extracted page fragments are not pinned or ref'd in any way; if an
+ * IOVEC/UBUF-type iterator is to be used, it should be converted to a
+ * BVEC-type iterator and the pages pinned, ref'd or otherwise held in some
+ * way.
+ */
+__maybe_unused /* this is temporary while this file is included in orders */
+static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
+					    struct smbdirect_map_sges *state)
+{
+	ssize_t ret;
+	size_t before = state->num_sge;
+
+	if (WARN_ON_ONCE(iov_iter_rw(iter) != ITER_SOURCE))
+		return -EIO;
+
+	switch (iov_iter_type(iter)) {
+	case ITER_BVEC:
+		ret = smbdirect_map_sges_from_bvec(iter, state, len);
+		break;
+	case ITER_KVEC:
+		ret = smbdirect_map_sges_from_kvec(iter, state, len);
+		break;
+	case ITER_FOLIOQ:
+		ret = smbdirect_map_sges_from_folioq(iter, state, len);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+
+	if (ret < 0) {
+		while (state->num_sge > before) {
+			struct ib_sge *sge = &state->sge[state->num_sge--];
+
+			ib_dma_unmap_page(state->device,
+					  sge->addr,
+					  sge->length,
+					  state->direction);
+		}
+	}
+
+	return ret;
+}
-- 
2.43.0

