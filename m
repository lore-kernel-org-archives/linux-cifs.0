Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB62512F1
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744561; cv=none; b=gjVBYCfwF5my2msMPj7ccZTKNPEYFeo9CWQXW2l2NgKmOP1Qgag2M+vOcjqf7ajNmuDlebo4nEUrSNo5b8HKQ5UZVEtdkM5zovaEnPN4Mg1BvvibBJe0U6HhXMdVDHgUDor2dpiCtTbyx6chelPKlSYgqBKnrGWnwylr73uYmtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744561; c=relaxed/simple;
	bh=oaQLobloany7lXaTv0DSLmFVJwQy7a/unXqPJIiycCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArIPhNglZG5TORShDmhhcucNQhmIrzaBoO3D9vUjtpc+igoTPt4LIFTZDwSuq04H7xpWR8RCtmeCSaRJyigbhSJoxF0RZ3mQsxtEiAWIwyNfv6HzV57DCSl0fw+TOf9yoMhDgcNi0lCs81xgBD/7KwXEp9LorpDSHNf9xnBfGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xEshcazz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xEshcazz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=82K39P93ZKlEblRQ1wLJjpukXt45mcqQnp0DUsAADX8=; b=xEshcazzY2bcRSvMGedgjp8rc2
	UkmST4FN842gUISzctCe8cJHGAoKJlkVg8QK2asTi7DyVjJZuBgzCZvGui+0SorGqrvrk/82a45+d
	2RY4k7sBXMw0Xg4V9fxdWrwVG/saEKz7eeEy9lCdP42Hic6c4knvzwjqKNj4DsuyOmkZzVKJMCCoP
	q4LN4de7uvZpDUSTMbhdp7CkRcV2XxhTtiXApfpsr0+r+TAFGv+1x13CISQiwGu48j+rmOAW4d98U
	NFSd1o00e7TYBnjQz0RBKvNJdOeKH+kH10dSU5UyygFUM2pyaMdp77ycWtp71l9OJhLZIGZF6E18o
	ZlqfKIoIHeqBYvMKewMF20dJXGX3Zbr+q5fui2PmmMVW0NpzWX+tY69Pq5z6D7ORgDl/AgqKbleQT
	4uKsxnT/a8ZPkjGXjvgknaMzXPpuuXxL5Qy+xjXvIxJqmWvmZWn7IvMmQ5g0fiYbEZ9Nzakfk2vyW
	pA3A7vp/V1QQjMjGiFXUJKGp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Em-00BcDl-2T;
	Wed, 29 Oct 2025 13:29:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 069/127] smb: client: make use of smbdirect_map_sges_from_iter()
Date: Wed, 29 Oct 2025 14:20:47 +0100
Message-ID: <576bc3235599f0ca1cd21fb5091e1aa581443e65.1761742839.git.metze@samba.org>
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

This is basically a copy of smb_extract_iter_to_rdma() moved
to common code.

Before we had the inconsistency we called ib_dma_unmap_single(),
while we mapped using ib_dma_map_page() in smb_set_sge().

Now ib_dma_unmap_page() is used for consistency.

It doesn't really matter as ib_dma_unmap_single() and
ib_dma_unmap_page() both operate
on dma_addr_t and dma_unmap_single_attrs() is just an
alias for dma_unmap_page_attrs().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 241 +-------------------------------------
 1 file changed, 5 insertions(+), 236 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 689b691557c2..19971f7c4670 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -32,17 +32,6 @@ static int smbd_post_send_empty(struct smbdirect_socket *sc);
 static void destroy_mr_list(struct smbdirect_socket *sc);
 static int allocate_mr_list(struct smbdirect_socket *sc);
 
-struct smb_extract_to_rdma {
-	struct ib_sge		*sge;
-	unsigned int		nr_sge;
-	unsigned int		max_sge;
-	struct ib_device	*device;
-	u32			local_dma_lkey;
-	enum dma_data_direction	direction;
-};
-static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
-					struct smb_extract_to_rdma *rdma);
-
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
 #define SMBD_PORT	5445
@@ -1025,9 +1014,9 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	/* Fill in the data payload to find out how much data we can add */
 	if (iter) {
-		struct smb_extract_to_rdma extract = {
-			.nr_sge		= request->num_sge,
-			.max_sge	= SMBDIRECT_SEND_IO_MAX_SGE,
+		struct smbdirect_map_sges extract = {
+			.num_sge	= request->num_sge,
+			.max_sge	= ARRAY_SIZE(request->sge),
 			.sge		= request->sge,
 			.device		= sc->ib.dev,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
@@ -1036,12 +1025,11 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		size_t payload_len = umin(*_remaining_data_length,
 					  sp->max_send_size - sizeof(*packet));
 
-		rc = smb_extract_iter_to_rdma(iter, payload_len,
-					      &extract);
+		rc = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
 		if (rc < 0)
 			goto err_dma;
 		data_length = rc;
-		request->num_sge = extract.nr_sge;
+		request->num_sge = extract.num_sge;
 		*_remaining_data_length -= data_length;
 	} else {
 		data_length = 0;
@@ -2397,222 +2385,3 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 	if (!kref_put(&mr->kref, smbd_mr_free_locked))
 		mutex_unlock(&mr->mutex);
 }
-
-static bool smb_set_sge(struct smb_extract_to_rdma *rdma,
-			struct page *lowest_page, size_t off, size_t len)
-{
-	struct ib_sge *sge = &rdma->sge[rdma->nr_sge];
-	u64 addr;
-
-	addr = ib_dma_map_page(rdma->device, lowest_page,
-			       off, len, rdma->direction);
-	if (ib_dma_mapping_error(rdma->device, addr))
-		return false;
-
-	sge->addr   = addr;
-	sge->length = len;
-	sge->lkey   = rdma->local_dma_lkey;
-	rdma->nr_sge++;
-	return true;
-}
-
-/*
- * Extract page fragments from a BVEC-class iterator and add them to an RDMA
- * element list.  The pages are not pinned.
- */
-static ssize_t smb_extract_bvec_to_rdma(struct iov_iter *iter,
-					struct smb_extract_to_rdma *rdma,
-					ssize_t maxsize)
-{
-	const struct bio_vec *bv = iter->bvec;
-	unsigned long start = iter->iov_offset;
-	unsigned int i;
-	ssize_t ret = 0;
-
-	for (i = 0; i < iter->nr_segs; i++) {
-		size_t off, len;
-
-		len = bv[i].bv_len;
-		if (start >= len) {
-			start -= len;
-			continue;
-		}
-
-		len = min_t(size_t, maxsize, len - start);
-		off = bv[i].bv_offset + start;
-
-		if (!smb_set_sge(rdma, bv[i].bv_page, off, len))
-			return -EIO;
-
-		ret += len;
-		maxsize -= len;
-		if (rdma->nr_sge >= rdma->max_sge || maxsize <= 0)
-			break;
-		start = 0;
-	}
-
-	if (ret > 0)
-		iov_iter_advance(iter, ret);
-	return ret;
-}
-
-/*
- * Extract fragments from a KVEC-class iterator and add them to an RDMA list.
- * This can deal with vmalloc'd buffers as well as kmalloc'd or static buffers.
- * The pages are not pinned.
- */
-static ssize_t smb_extract_kvec_to_rdma(struct iov_iter *iter,
-					struct smb_extract_to_rdma *rdma,
-					ssize_t maxsize)
-{
-	const struct kvec *kv = iter->kvec;
-	unsigned long start = iter->iov_offset;
-	unsigned int i;
-	ssize_t ret = 0;
-
-	for (i = 0; i < iter->nr_segs; i++) {
-		struct page *page;
-		unsigned long kaddr;
-		size_t off, len, seg;
-
-		len = kv[i].iov_len;
-		if (start >= len) {
-			start -= len;
-			continue;
-		}
-
-		kaddr = (unsigned long)kv[i].iov_base + start;
-		off = kaddr & ~PAGE_MASK;
-		len = min_t(size_t, maxsize, len - start);
-		kaddr &= PAGE_MASK;
-
-		maxsize -= len;
-		do {
-			seg = min_t(size_t, len, PAGE_SIZE - off);
-
-			if (is_vmalloc_or_module_addr((void *)kaddr))
-				page = vmalloc_to_page((void *)kaddr);
-			else
-				page = virt_to_page((void *)kaddr);
-
-			if (!smb_set_sge(rdma, page, off, seg))
-				return -EIO;
-
-			ret += seg;
-			len -= seg;
-			kaddr += PAGE_SIZE;
-			off = 0;
-		} while (len > 0 && rdma->nr_sge < rdma->max_sge);
-
-		if (rdma->nr_sge >= rdma->max_sge || maxsize <= 0)
-			break;
-		start = 0;
-	}
-
-	if (ret > 0)
-		iov_iter_advance(iter, ret);
-	return ret;
-}
-
-/*
- * Extract folio fragments from a FOLIOQ-class iterator and add them to an RDMA
- * list.  The folios are not pinned.
- */
-static ssize_t smb_extract_folioq_to_rdma(struct iov_iter *iter,
-					  struct smb_extract_to_rdma *rdma,
-					  ssize_t maxsize)
-{
-	const struct folio_queue *folioq = iter->folioq;
-	unsigned int slot = iter->folioq_slot;
-	ssize_t ret = 0;
-	size_t offset = iter->iov_offset;
-
-	BUG_ON(!folioq);
-
-	if (slot >= folioq_nr_slots(folioq)) {
-		folioq = folioq->next;
-		if (WARN_ON_ONCE(!folioq))
-			return -EIO;
-		slot = 0;
-	}
-
-	do {
-		struct folio *folio = folioq_folio(folioq, slot);
-		size_t fsize = folioq_folio_size(folioq, slot);
-
-		if (offset < fsize) {
-			size_t part = umin(maxsize, fsize - offset);
-
-			if (!smb_set_sge(rdma, folio_page(folio, 0), offset, part))
-				return -EIO;
-
-			offset += part;
-			ret += part;
-			maxsize -= part;
-		}
-
-		if (offset >= fsize) {
-			offset = 0;
-			slot++;
-			if (slot >= folioq_nr_slots(folioq)) {
-				if (!folioq->next) {
-					WARN_ON_ONCE(ret < iter->count);
-					break;
-				}
-				folioq = folioq->next;
-				slot = 0;
-			}
-		}
-	} while (rdma->nr_sge < rdma->max_sge && maxsize > 0);
-
-	iter->folioq = folioq;
-	iter->folioq_slot = slot;
-	iter->iov_offset = offset;
-	iter->count -= ret;
-	return ret;
-}
-
-/*
- * Extract page fragments from up to the given amount of the source iterator
- * and build up an RDMA list that refers to all of those bits.  The RDMA list
- * is appended to, up to the maximum number of elements set in the parameter
- * block.
- *
- * The extracted page fragments are not pinned or ref'd in any way; if an
- * IOVEC/UBUF-type iterator is to be used, it should be converted to a
- * BVEC-type iterator and the pages pinned, ref'd or otherwise held in some
- * way.
- */
-static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
-					struct smb_extract_to_rdma *rdma)
-{
-	ssize_t ret;
-	int before = rdma->nr_sge;
-
-	switch (iov_iter_type(iter)) {
-	case ITER_BVEC:
-		ret = smb_extract_bvec_to_rdma(iter, rdma, len);
-		break;
-	case ITER_KVEC:
-		ret = smb_extract_kvec_to_rdma(iter, rdma, len);
-		break;
-	case ITER_FOLIOQ:
-		ret = smb_extract_folioq_to_rdma(iter, rdma, len);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EIO;
-	}
-
-	if (ret < 0) {
-		while (rdma->nr_sge > before) {
-			struct ib_sge *sge = &rdma->sge[rdma->nr_sge--];
-
-			ib_dma_unmap_single(rdma->device, sge->addr, sge->length,
-					    rdma->direction);
-			sge->addr = 0;
-		}
-	}
-
-	return ret;
-}
-- 
2.43.0

