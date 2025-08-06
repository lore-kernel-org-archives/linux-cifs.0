Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D841FF7B4
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512652; cv=none; b=IGlNFd0/24bSXkeXD6OqXsFBdvONCFs6NQUI+AGXVek/yCh/8r8PP/SQeshiGih6CsEr1WRInD5XQxvc2yC8XOGVT1GlxwFsiUt8cMs9V8PKOt/o5G9YcqjiWM8DsRR//ZjJtWN0AnkmOFL2mFFSvz92KrSJocHNQIVATanjm5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512652; c=relaxed/simple;
	bh=IxfYgpq4zI1Te11jMIH8dX44DMx4OX/xULaiW/AQDpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtCHvPnc3s8/WOqJUysGvAVlvI3jvs6efQJCsJx7FFk3hDQklxVq9QiNOm/8dAcBYAjLcq6RHm0q046+Rlh7dF1rVu/ShssOxwikFIIy6cemLW2iq0ENBMgRN3rrKhKLOgYhFvkfeCm3hXajJGChp6TjCGjGhDpAxJQ9BCXdNNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eaKYabJA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eaKYabJA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754512649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8je+m+XOI8RLg+bFiBwLQKIpAh8fOcOUNT1OPWucvo=;
	b=eaKYabJAxPbCwNXCvzycPo9hnJUXIOqll0VEyoxIA5YQKtNbtX5zQq0TQLXc890l3yCU5+
	WtG1hDJI9omq+B1LbhoWo84iq6e+stIEQu1jpM/VF4BxHlzWejmGJzIszpOwsHSomsjrJI
	mhMn/xR405PLDFekVcP5QFGEvcFb6Hc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-kGr1uHtwOcOlY7cxv64jkA-1; Wed,
 06 Aug 2025 16:37:25 -0400
X-MC-Unique: kGr1uHtwOcOlY7cxv64jkA-1
X-Mimecast-MFC-AGG-ID: kGr1uHtwOcOlY7cxv64jkA_1754512644
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE71E1955EC7;
	Wed,  6 Aug 2025 20:37:23 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 019A319560AD;
	Wed,  6 Aug 2025 20:37:20 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/31] iov_iter: Add a segmented queue of bio_vec[]
Date: Wed,  6 Aug 2025 21:36:23 +0100
Message-ID: <20250806203705.2560493-3-dhowells@redhat.com>
In-Reply-To: <20250806203705.2560493-1-dhowells@redhat.com>
References: <20250806203705.2560493-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add a segmented queue of bio_vec[].  This allows an indefinite quantity of
elements to be handled.  A rolling buffer can also be implemented over them
where new bio_vecs can be added to the leading edge and spent bio_vecs can
be cleared from the trailing edge.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/bvec.h       |  13 ++
 include/linux/uio.h        |  11 ++
 lib/iov_iter.c             | 325 ++++++++++++++++++++++++++++++++++++-
 lib/tests/kunit_iov_iter.c | 196 ++++++++++++++++++++++
 4 files changed, 543 insertions(+), 2 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa20..7986c9019fa0 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -298,4 +298,17 @@ static inline phys_addr_t bvec_phys(const struct bio_vec *bvec)
 	return page_to_phys(bvec->bv_page) + bvec->bv_offset;
 }
 
+/*
+ * Segmented bio_vec queue.  These can be linked together to form messages of
+ * indefinite length and iterated over with an ITER_BVECQ iterator.
+ */
+struct bvecq {
+	struct bvecq	*next;		/* Next bvec in the list or NULL */
+	struct bvecq	*prev;		/* Prev bvec in the list or NULL */
+	u16		max_segs;	/* Number of elements allocated in bv[] */
+	u16		nr_segs;	/* Number of elements in bv[] used */
+	u16		cleared;	/* Number of elements used in bv[] cleared */
+	struct bio_vec	bv[] __counted_by(max_segs);
+};
+
 #endif /* __LINUX_BVEC_H */
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2e86c653186c..2c04646be91a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -27,6 +27,7 @@ enum iter_type {
 	ITER_BVEC,
 	ITER_KVEC,
 	ITER_FOLIOQ,
+	ITER_BVECQ,
 	ITER_XARRAY,
 	ITER_DISCARD,
 };
@@ -69,6 +70,7 @@ struct iov_iter {
 				const struct kvec *kvec;
 				const struct bio_vec *bvec;
 				const struct folio_queue *folioq;
+				const struct bvecq *bvecq;
 				struct xarray *xarray;
 				void __user *ubuf;
 			};
@@ -78,6 +80,7 @@ struct iov_iter {
 	union {
 		unsigned long nr_segs;
 		u8 folioq_slot;
+		u16 bvecq_slot;
 		loff_t xarray_start;
 	};
 };
@@ -150,6 +153,11 @@ static inline bool iov_iter_is_folioq(const struct iov_iter *i)
 	return iov_iter_type(i) == ITER_FOLIOQ;
 }
 
+static inline bool iov_iter_is_bvecq(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_BVECQ;
+}
+
 static inline bool iov_iter_is_xarray(const struct iov_iter *i)
 {
 	return iov_iter_type(i) == ITER_XARRAY;
@@ -300,6 +308,9 @@ void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t count);
 void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
 			  const struct folio_queue *folioq,
 			  unsigned int first_slot, unsigned int offset, size_t count);
+void iov_iter_bvec_queue(struct iov_iter *i, unsigned int direction,
+			 const struct bvecq *bvecq,
+			 unsigned int first_slot, unsigned int offset, size_t count);
 void iov_iter_xarray(struct iov_iter *i, unsigned int direction, struct xarray *xarray,
 		     loff_t start, size_t count);
 ssize_t iov_iter_get_pages2(struct iov_iter *i, struct page **pages,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 53e58903fe75..aefd41f689b7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -559,6 +559,39 @@ static void iov_iter_folioq_advance(struct iov_iter *i, size_t size)
 	i->folioq = folioq;
 }
 
+static void iov_iter_bvecq_advance(struct iov_iter *i, size_t by)
+{
+	const struct bvecq *bq = i->bvecq;
+	unsigned int slot = i->bvecq_slot;
+
+	if (!i->count)
+		return;
+	i->count -= by;
+
+	if (slot >= bq->nr_segs) {
+		bq = bq->next;
+		slot = 0;
+	}
+
+	by += i->iov_offset; /* From beginning of current segment. */
+	do {
+		size_t len = bq->bv[slot].bv_len;
+
+		if (likely(by < len))
+			break;
+		by -= len;
+		slot++;
+		if (slot >= bq->nr_segs && bq->next) {
+			bq = bq->next;
+			slot = 0;
+		}
+	} while (by);
+
+	i->iov_offset = by;
+	i->bvecq_slot = slot;
+	i->bvecq = bq;
+}
+
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(i->count < size))
@@ -573,6 +606,8 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		iov_iter_bvec_advance(i, size);
 	} else if (iov_iter_is_folioq(i)) {
 		iov_iter_folioq_advance(i, size);
+	} else if (iov_iter_is_bvecq(i)) {
+		iov_iter_bvecq_advance(i, size);
 	} else if (iov_iter_is_discard(i)) {
 		i->count -= size;
 	}
@@ -605,6 +640,32 @@ static void iov_iter_folioq_revert(struct iov_iter *i, size_t unroll)
 	i->folioq = folioq;
 }
 
+static void iov_iter_bvecq_revert(struct iov_iter *i, size_t unroll)
+{
+	const struct bvecq *bq = i->bvecq;
+	unsigned int slot = i->bvecq_slot;
+
+	for (;;) {
+		size_t len;
+
+		if (slot == 0) {
+			bq = bq->prev;
+			slot = bq->nr_segs;
+		}
+		slot--;
+
+		len = bq->bv[slot].bv_len;
+		if (unroll <= len) {
+			i->iov_offset = len - unroll;
+			break;
+		}
+		unroll -= len;
+	}
+
+	i->bvecq_slot = slot;
+	i->bvecq = bq;
+}
+
 void iov_iter_revert(struct iov_iter *i, size_t unroll)
 {
 	if (!unroll)
@@ -639,6 +700,9 @@ void iov_iter_revert(struct iov_iter *i, size_t unroll)
 	} else if (iov_iter_is_folioq(i)) {
 		i->iov_offset = 0;
 		iov_iter_folioq_revert(i, unroll);
+	} else if (iov_iter_is_bvecq(i)) {
+		i->iov_offset = 0;
+		iov_iter_bvecq_revert(i, unroll);
 	} else { /* same logics for iovec and kvec */
 		const struct iovec *iov = iter_iov(i);
 		while (1) {
@@ -666,9 +730,12 @@ size_t iov_iter_single_seg_count(const struct iov_iter *i)
 		if (iov_iter_is_bvec(i))
 			return min(i->count, i->bvec->bv_len - i->iov_offset);
 	}
+	if (!i->count)
+		return 0;
 	if (unlikely(iov_iter_is_folioq(i)))
-		return !i->count ? 0 :
-			umin(folioq_folio_size(i->folioq, i->folioq_slot), i->count);
+		return umin(folioq_folio_size(i->folioq, i->folioq_slot), i->count);
+	if (unlikely(iov_iter_is_bvecq(i)))
+		return min(i->count, i->bvecq->bv[i->bvecq_slot].bv_len - i->iov_offset);
 	return i->count;
 }
 EXPORT_SYMBOL(iov_iter_single_seg_count);
@@ -735,6 +802,35 @@ void iov_iter_folio_queue(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_folio_queue);
 
+/**
+ * iov_iter_bvec_queue - Initialise an I/O iterator to use a segmented bvec queue
+ * @i: The iterator to initialise.
+ * @direction: The direction of the transfer.
+ * @bvecq: The starting point in the bvec queue.
+ * @first_slot: The first slot in the bvec queue to use
+ * @offset: The offset into the bvec in the first slot to start at
+ * @count: The size of the I/O buffer in bytes.
+ *
+ * Set up an I/O iterator to either draw data out of the buffers attached to an
+ * inode or to inject data into those buffers.  The pages *must* be prevented
+ * from evaporation, either by the caller.
+ */
+void iov_iter_bvec_queue(struct iov_iter *i, unsigned int direction,
+			 const struct bvecq *bvecq, unsigned int first_slot,
+			 unsigned int offset, size_t count)
+{
+	BUG_ON(direction & ~1);
+	*i = (struct iov_iter) {
+		.iter_type	= ITER_BVECQ,
+		.data_source	= direction,
+		.bvecq		= bvecq,
+		.bvecq_slot	= first_slot,
+		.count		= count,
+		.iov_offset	= offset,
+	};
+}
+EXPORT_SYMBOL(iov_iter_bvec_queue);
+
 /**
  * iov_iter_xarray - Initialise an I/O iterator to use the pages in an xarray
  * @i: The iterator to initialise.
@@ -834,6 +930,42 @@ static bool iov_iter_aligned_bvec(const struct iov_iter *i, unsigned addr_mask,
 	return true;
 }
 
+static bool iov_iter_aligned_bvecq(const struct iov_iter *iter, unsigned long addr_mask,
+				   unsigned long len_mask)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned int slot = iter->bvecq_slot;
+	size_t skip = iter->iov_offset;
+	size_t size = iter->count;
+
+	if (slot == bq->nr_segs) {
+		/* The iterator may have been extended. */
+		bq = bq->next;
+		slot = 0;
+	}
+
+	for (;;) {
+		const struct bio_vec *bvec = &bq->bv[slot];
+		size_t part;
+
+		part = umin(bvec->bv_len - skip, size);
+		if (part & len_mask)
+			return false;
+		if ((bvec->bv_offset + skip) & addr_mask)
+			return false;
+		if (part >= size)
+			return true;
+
+		size -= part;
+		skip = 0;
+		slot++;
+		if (slot == bq->nr_segs) {
+			bq++;
+			slot = 0;
+		}
+	}
+}
+
 /**
  * iov_iter_is_aligned() - Check if the addresses and lengths of each segments
  * 	are aligned to the parameters.
@@ -875,6 +1007,9 @@ bool iov_iter_is_aligned(const struct iov_iter *i, unsigned addr_mask,
 			return false;
 	}
 
+	if (iov_iter_is_bvecq(i))
+		return iov_iter_aligned_bvecq(i, addr_mask, len_mask);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(iov_iter_is_aligned);
@@ -922,6 +1057,40 @@ static unsigned long iov_iter_alignment_bvec(const struct iov_iter *i)
 	return res;
 }
 
+static unsigned long iov_iter_alignment_bvecq(const struct iov_iter *iter)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned long res = 0;
+	unsigned int slot = iter->bvecq_slot;
+	size_t skip = iter->iov_offset;
+	size_t size = iter->count;
+
+	if (slot == bq->nr_segs) {
+		/* The iterator may have been extended. */
+		bq = bq->next;
+		slot = 0;
+	}
+
+	for (;;) {
+		const struct bio_vec *bvec = &bq->bv[slot];
+		size_t part;
+
+		part = umin(bvec->bv_len - skip, size);
+		res |= bvec->bv_offset + skip;
+		res |= part;
+
+		size -= part;
+		skip = 0;
+		slot++;
+		if (slot == bq->nr_segs) {
+			bq++;
+			slot = 0;
+		}
+	}
+
+	return res;
+}
+
 unsigned long iov_iter_alignment(const struct iov_iter *i)
 {
 	if (likely(iter_is_ubuf(i))) {
@@ -941,6 +1110,8 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 	/* With both xarray and folioq types, we're dealing with whole folios. */
 	if (iov_iter_is_folioq(i))
 		return i->iov_offset | i->count;
+	if (iov_iter_is_bvecq(i))
+		return iov_iter_alignment_bvecq(i);
 	if (iov_iter_is_xarray(i))
 		return (i->xarray_start + i->iov_offset) | i->count;
 
@@ -1275,6 +1446,38 @@ static int bvec_npages(const struct iov_iter *i, int maxpages)
 	return npages;
 }
 
+static size_t iov_npages_bvecq(const struct iov_iter *iter, size_t maxpages)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned int slot = iter->bvecq_slot;
+	size_t npages = 0;
+	size_t skip = iter->iov_offset;
+	size_t size = iter->count;
+
+	if (slot == bq->nr_segs) {
+		/* The iterator may have been extended. */
+		bq = bq->next;
+		slot = 0;
+	}
+
+	do {
+		const struct bio_vec *bvec = &bq->bv[slot];
+		size_t offs = (bvec->bv_offset + skip) % PAGE_SIZE;
+		size_t part = umin(bvec->bv_len - skip, size);
+
+		npages += DIV_ROUND_UP(offs + part, PAGE_SIZE);
+
+		size -= part;
+		skip = 0;
+		slot++;
+		if (slot == bq->nr_segs) {
+			bq++;
+			slot = 0;
+		}
+	} while (npages > maxpages);
+	return umin(npages, maxpages);
+}
+
 int iov_iter_npages(const struct iov_iter *i, int maxpages)
 {
 	if (unlikely(!i->count))
@@ -1294,6 +1497,8 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages)
 		int npages = DIV_ROUND_UP(offset + i->count, PAGE_SIZE);
 		return min(npages, maxpages);
 	}
+	if (iov_iter_is_bvecq(i))
+		return iov_npages_bvecq(i, maxpages);
 	if (iov_iter_is_xarray(i)) {
 		unsigned offset = (i->xarray_start + i->iov_offset) % PAGE_SIZE;
 		int npages = DIV_ROUND_UP(offset + i->count, PAGE_SIZE);
@@ -1637,6 +1842,65 @@ static ssize_t iov_iter_extract_folioq_pages(struct iov_iter *i,
 	return extracted;
 }
 
+/*
+ * Extract a list of virtually contiguous pages from an ITER_BVECQ iterator.
+ * This does not get references on the pages, nor does it get a pin on them.
+ */
+static ssize_t iov_iter_extract_bvecq_pages(struct iov_iter *i,
+					    struct page ***pages, size_t maxsize,
+					    unsigned int maxpages,
+					    iov_iter_extraction_t extraction_flags,
+					    size_t *offset0)
+{
+	const struct bvecq *bq = i->bvecq;
+	struct bvec_iter bi;
+	size_t size = 0;
+	int k = 0;
+
+	bi.bi_idx	= i->bvecq_slot;
+	bi.bi_size	= maxsize;
+	bi.bi_bvec_done	= i->iov_offset;
+
+	maxpages = want_pages_array(pages, maxsize, i->iov_offset, maxpages);
+
+	while (bi.bi_size && bi.bi_idx < bq->nr_segs) {
+		struct bio_vec bv = bvec_iter_bvec(bq->bv, bi);
+
+		/*
+		 * The iov_iter_extract_pages interface only allows an offset
+		 * into the first page.  Break out of the loop if we see an
+		 * offset into subsequent pages, the caller will have to call
+		 * iov_iter_extract_pages again for the reminder.
+		 */
+		if (k) {
+			if (bv.bv_offset)
+				break;
+		} else {
+			*offset0 = bv.bv_offset;
+		}
+
+		(*pages)[k++] = bv.bv_page;
+		size += bv.bv_len;
+
+		if (k >= maxpages)
+			break;
+
+		/*
+		 * We are done when the end of the bvec doesn't align to a page
+		 * boundary as that would create a hole in the returned space.
+		 * The caller will handle this with another call to
+		 * iov_iter_extract_pages.
+		 */
+		if (bv.bv_offset + bv.bv_len != PAGE_SIZE)
+			break;
+
+		bvec_iter_advance_single(bq->bv, &bi, bv.bv_len);
+	}
+
+	iov_iter_advance(i, size);
+	return size;
+}
+
 /*
  * Extract a list of contiguous pages from an ITER_XARRAY iterator.  This does not
  * get references on the pages, nor does it get a pin on them.
@@ -1921,6 +2185,10 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i,
 		return iov_iter_extract_folioq_pages(i, pages, maxsize,
 						     maxpages, extraction_flags,
 						     offset0);
+	if (iov_iter_is_bvecq(i))
+		return iov_iter_extract_bvecq_pages(i, pages, maxsize,
+						    maxpages, extraction_flags,
+						    offset0);
 	if (iov_iter_is_xarray(i))
 		return iov_iter_extract_xarray_pages(i, pages, maxsize,
 						     maxpages, extraction_flags,
@@ -1995,6 +2263,57 @@ size_t iterate_discard(struct iov_iter *iter, size_t len, void *priv, void *priv
 	return progress;
 }
 
+/*
+ * Handle ITER_BVECQ.
+ */
+static __always_inline
+size_t iterate_bvecq(struct iov_iter *iter, size_t len, void *priv, void *priv2,
+		     iov_step_f step)
+{
+	const struct bvecq *bq = iter->bvecq;
+	unsigned int slot = iter->bvecq_slot;
+	size_t progress = 0, skip = iter->iov_offset;
+
+	if (slot == bq->nr_segs) {
+		/* The iterator may have been extended. */
+		bq = bq->next;
+		slot = 0;
+	}
+
+	do {
+		const struct bio_vec *bvec = &bq->bv[slot];
+		struct page *page = bvec->bv_page + (bvec->bv_offset + skip) / PAGE_SIZE;
+		size_t part, remain, consumed;
+		size_t poff = (bvec->bv_offset + skip) % PAGE_SIZE;
+		void *base;
+
+		part = umin(umin(bvec->bv_len, PAGE_SIZE - poff), len);
+		base = kmap_local_page(page) + poff;
+		remain = step(base, progress, part, priv, priv2);
+		kunmap_local(base);
+		consumed = part - remain;
+		len -= consumed;
+		progress += consumed;
+		skip += consumed;
+		if (skip >= bvec->bv_len) {
+			skip = 0;
+			slot++;
+			if (slot == bq->nr_segs) {
+				bq = bq->next;
+				slot = 0;
+			}
+		}
+		if (remain)
+			break;
+	} while (len);
+
+	iter->bvecq_slot = slot;
+	iter->bvecq = bq;
+	iter->iov_offset = skip;
+	iter->count -= progress;
+	return progress;
+}
+
 /*
  * Out of line iteration for iterator types that don't need such fast handling.
  */
@@ -2003,6 +2322,8 @@ size_t __iterate_and_advance2(struct iov_iter *iter, size_t len, void *priv,
 {
 	if (iov_iter_is_discard(iter))
 		return iterate_discard(iter, len, priv, priv2, step);
+	if (iov_iter_is_bvecq(iter))
+		return iterate_bvecq(iter, len, priv, priv2, step);
 	if (iov_iter_is_xarray(iter))
 		return iterate_xarray(iter, len, priv, priv2, step);
 	WARN_ON(1);
diff --git a/lib/tests/kunit_iov_iter.c b/lib/tests/kunit_iov_iter.c
index 48342736d016..4c62b509c949 100644
--- a/lib/tests/kunit_iov_iter.c
+++ b/lib/tests/kunit_iov_iter.c
@@ -536,6 +536,200 @@ static void __init iov_kunit_copy_from_folioq(struct kunit *test)
 	KUNIT_SUCCEED(test);
 }
 
+static void iov_kunit_destroy_bvecq(void *data)
+{
+	struct bvecq *bq, *next;
+
+	for (bq = data; bq; bq = next) {
+		next = bq->next;
+		for (int i = 0; i < bq->nr_segs; i++)
+			if (bq->bv[i].bv_page)
+				put_page(bq->bv[i].bv_page);
+		kfree(bq);
+	}
+}
+
+static struct bvecq *iov_kunit_alloc_bvecq(struct kunit *test, unsigned int max_segs)
+{
+	struct bvecq *bq;
+
+	bq = kzalloc(struct_size(bq, bv, max_segs), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bq);
+	bq->max_segs = max_segs;
+	return bq;
+}
+
+static struct bvecq *iov_kunit_create_bvecq(struct kunit *test, unsigned int max_segs)
+{
+	struct bvecq *bq;
+
+	bq = iov_kunit_alloc_bvecq(test, max_segs);
+	kunit_add_action_or_reset(test, iov_kunit_destroy_bvecq, bq);
+	return bq;
+}
+
+static void __init iov_kunit_load_bvecq(struct kunit *test,
+					struct iov_iter *iter, int dir,
+					struct bvecq *bq_head,
+					struct page **pages, size_t npages)
+{
+	struct bvecq *bq = bq_head;
+	size_t size = 0;
+
+	for (int i = 0; i < npages; i++) {
+		if (bq->nr_segs >= bq->max_segs) {
+			bq->next = iov_kunit_alloc_bvecq(test, 8);
+			bq->next->prev = bq;
+			bq = bq->next;
+		}
+		bvec_set_page(&bq->bv[bq->nr_segs], pages[i], PAGE_SIZE, 0);
+		bq->nr_segs++;
+		size += PAGE_SIZE;
+	}
+	iov_iter_bvec_queue(iter, dir, bq_head, 0, 0, size);
+}
+
+#if 0
+static void dump_bvecq(const struct bvecq *bq)
+{
+	int j = 0;
+
+	printk("Dump:\n");
+	for (; bq; bq = bq->next, j++) {
+		for (int i = 0; i < bq->nr_segs; i++) {
+			const struct bio_vec *bv = &bq->bv[i];
+
+			printk("  [%x:%02x] %lx %04x %04x\n",
+			       j, i, page_to_pfn(bv->bv_page), bv->bv_offset, bv->bv_len);
+		}
+	}
+}
+#endif
+
+/*
+ * Test copying to a ITER_BVECQ-type iterator.
+ */
+static void __init iov_kunit_copy_to_bvecq(struct kunit *test)
+{
+	const struct kvec_test_range *pr;
+	struct iov_iter iter;
+	struct bvecq *bq;
+	struct page **spages, **bpages;
+	u8 *scratch, *buffer;
+	size_t bufsize, npages, size, copied;
+	int i, patt;
+
+	bufsize = 0x100000;
+	npages = bufsize / PAGE_SIZE;
+
+	bq = iov_kunit_create_bvecq(test, 8);
+
+	scratch = iov_kunit_create_buffer(test, &spages, npages);
+	for (i = 0; i < bufsize; i++)
+		scratch[i] = pattern(i);
+
+	buffer = iov_kunit_create_buffer(test, &bpages, npages);
+	memset(buffer, 0, bufsize);
+
+	iov_kunit_load_bvecq(test, &iter, READ, bq, bpages, npages);
+
+	i = 0;
+	for (pr = kvec_test_ranges; pr->from >= 0; pr++) {
+		size = pr->to - pr->from;
+		KUNIT_ASSERT_LE(test, pr->to, bufsize);
+
+		iov_iter_bvec_queue(&iter, READ, bq, 0, 0, pr->to);
+		iov_iter_advance(&iter, pr->from);
+		copied = copy_to_iter(scratch + i, size, &iter);
+
+		KUNIT_EXPECT_EQ(test, copied, size);
+		KUNIT_EXPECT_EQ(test, iter.count, 0);
+		i += size;
+		if (test->status == KUNIT_FAILURE)
+			goto stop;
+	}
+
+	/* Build the expected image in the scratch buffer. */
+	patt = 0;
+	memset(scratch, 0, bufsize);
+	for (pr = kvec_test_ranges; pr->from >= 0; pr++)
+		for (i = pr->from; i < pr->to; i++)
+			scratch[i] = pattern(patt++);
+
+	/* Compare the images */
+	for (i = 0; i < bufsize; i++) {
+		KUNIT_EXPECT_EQ_MSG(test, buffer[i], scratch[i], "at i=%x", i);
+		if (buffer[i] != scratch[i])
+			return;
+	}
+
+stop:
+	KUNIT_SUCCEED(test);
+}
+
+/*
+ * Test copying from a ITER_BVECQ-type iterator.
+ */
+static void __init iov_kunit_copy_from_bvecq(struct kunit *test)
+{
+	const struct kvec_test_range *pr;
+	struct iov_iter iter;
+	struct bvecq *bq;
+	struct page **spages, **bpages;
+	u8 *scratch, *buffer;
+	size_t bufsize, npages, size, copied;
+	int i, j;
+
+	bufsize = 0x100000;
+	npages = bufsize / PAGE_SIZE;
+
+	bq = iov_kunit_create_bvecq(test, 8);
+
+	buffer = iov_kunit_create_buffer(test, &bpages, npages);
+	for (i = 0; i < bufsize; i++)
+		buffer[i] = pattern(i);
+
+	scratch = iov_kunit_create_buffer(test, &spages, npages);
+	memset(scratch, 0, bufsize);
+
+	iov_kunit_load_bvecq(test, &iter, READ, bq, bpages, npages);
+
+	i = 0;
+	for (pr = kvec_test_ranges; pr->from >= 0; pr++) {
+		size = pr->to - pr->from;
+		KUNIT_ASSERT_LE(test, pr->to, bufsize);
+
+		iov_iter_bvec_queue(&iter, WRITE, bq, 0, 0, pr->to);
+		iov_iter_advance(&iter, pr->from);
+		copied = copy_from_iter(scratch + i, size, &iter);
+
+		KUNIT_EXPECT_EQ(test, copied, size);
+		KUNIT_EXPECT_EQ(test, iter.count, 0);
+		i += size;
+	}
+
+	/* Build the expected image in the main buffer. */
+	i = 0;
+	memset(buffer, 0, bufsize);
+	for (pr = kvec_test_ranges; pr->from >= 0; pr++) {
+		for (j = pr->from; j < pr->to; j++) {
+			buffer[i++] = pattern(j);
+			if (i >= bufsize)
+				goto stop;
+		}
+	}
+stop:
+
+	/* Compare the images */
+	for (i = 0; i < bufsize; i++) {
+		KUNIT_EXPECT_EQ_MSG(test, scratch[i], buffer[i], "at i=%x", i);
+		if (scratch[i] != buffer[i])
+			return;
+	}
+
+	KUNIT_SUCCEED(test);
+}
+
 static void iov_kunit_destroy_xarray(void *data)
 {
 	struct xarray *xarray = data;
@@ -1016,6 +1210,8 @@ static struct kunit_case __refdata iov_kunit_cases[] = {
 	KUNIT_CASE(iov_kunit_copy_from_bvec),
 	KUNIT_CASE(iov_kunit_copy_to_folioq),
 	KUNIT_CASE(iov_kunit_copy_from_folioq),
+	KUNIT_CASE(iov_kunit_copy_to_bvecq),
+	KUNIT_CASE(iov_kunit_copy_from_bvecq),
 	KUNIT_CASE(iov_kunit_copy_to_xarray),
 	KUNIT_CASE(iov_kunit_copy_from_xarray),
 	KUNIT_CASE(iov_kunit_extract_pages_kvec),

