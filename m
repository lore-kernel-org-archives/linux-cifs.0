Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2FE3EC839
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 07:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445460; cv=none; b=qF19d0HFC7WVbmHG70+AokBmMygVpGnyp4q55RPBFiLVHcbdtgzfES5dDpUu6rRfhpJjRIRo7f6U2g8XqnIjG3zVWPabpl/ka2m53SJbxTW+P5sAWy7K3OdS79rJx4u3B4rl2WJ5PaxFwkkofn1RTT0rppwZpYbzlJo9acCzFvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445460; c=relaxed/simple;
	bh=T54JJA+5Ow8ICg2lW4ppIawijxKWyfTSwHlKUS9F4U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbViw4XIFOenTtYVA0b/xl4rw4SCCxckBABxeE5oH8H421f6DElqbn4KN/bIWa7TXfSaSegyrI2clzrDSVbBDhG60DDiwUA87ceq/Cpv1v3CkS05uznCInI00h8lxvqhmroY48MjxjM7Y8sBGqdmXDXJFGljtTsZOwA/6AOf5v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIaaU9vH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIaaU9vH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791445457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wedgX4WrevLpzNepJP3YUsqGE7leHUHTlWrP39pl1QI=;
	b=NIaaU9vHkAEzCagXCRZyKL+6dAGmQPHLfF9qKXlTbVdPJhjOQUGeKo6bnIYGk9mPnlsSn5
	vx2EAeFKC5dFGLAgvlFcg46sNSQTtHhLuzsGteSFbnuJP7U2ixgehRZEdoM36ndPAvbHSV
	cpoGdoAkEktgGE/p4BICenviUJNapnw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-LA6CNxijMFqAJOsh2ry3Rg-1; Thu,
 08 Oct 2026 03:44:14 -0400
X-MC-Unique: LA6CNxijMFqAJOsh2ry3Rg-1
X-Mimecast-MFC-AGG-ID: LA6CNxijMFqAJOsh2ry3Rg_1791445452
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 001C1195FD2C;
	Thu,  8 Oct 2026 07:44:12 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D716F1800446;
	Thu,  8 Oct 2026 07:44:06 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v15 2/8] netfs: Add a function to extract from an iter into a bvecq
Date: Thu,  8 Oct 2026 08:43:38 +0100
Message-ID: <20261008074346.936909-3-dhowells@redhat.com>
In-Reply-To: <20261008074346.936909-1-dhowells@redhat.com>
References: <20261008074346.936909-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add a function to extract a slice of data from an iterator of any type into
a bvec queue chain.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/iterator.c   | 143 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/netfs.h |   3 +
 2 files changed, 146 insertions(+)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 31748526d568..8cf2efe0cd6c 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -13,6 +13,149 @@
 #include <linux/netfs.h>
 #include "internal.h"
 
+/**
+ * netfs_extract_iter - Extract virtually contiguous pages from an iterator into a bvecq
+ * @orig: The original iterator
+ * @max_len: Maximum number of bytes to extract
+ * @max_pages: Maximum number of pages to extract
+ * @_bvecq_head: Where to cache the bvec queue
+ * @extraction_flags: Flags to qualify the request
+ * @gfp: Allocation mode for bvecq structs.
+ *
+ * Extract virtually contiguous page fragments from the source iterator up to
+ * the given maxima and build bvec queue that refers to all of those bits.
+ * This allows the original iterator to disposed of.
+ *
+ * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA
+ * be allowed on the pages extracted.
+ *
+ * On success or partial success, the amount of data in the bvec is returned,
+ * the original iterator will have been advanced by the amount extracted.
+ *
+ * If an error occurs and no pages are extracted, an error will be returned and
+ * any allocated bvecq will be freed.  If there is no data to be extracted (or
+ * @max_len or @max_pages are zero), a single empty bvecq will be returned.
+ *
+ * The bvecq segments are marked with indications on how to get clean up the
+ * extracted fragments.
+ */
+ssize_t netfs_extract_iter(struct iov_iter *orig, size_t max_len, size_t max_pages,
+			   struct bvecq **_bvecq_head,
+			   iov_iter_extraction_t extraction_flags, gfp_t gfp)
+{
+	struct bvecq *bq_tail = NULL, *bq;
+	ssize_t ret = 0;
+	size_t extracted = 0;
+
+	_enter("{%u,%zx},%zx", orig->iter_type, orig->count, max_len);
+
+	*_bvecq_head = NULL;
+	if (max_len > orig->count)
+		max_len = orig->count;
+	if (!max_len || !max_pages)
+		goto alloc_empty;
+	if (WARN_ON_ONCE(max_pages > INT_MAX))
+		max_pages = INT_MAX; /* Protect iov_iter_npages(). */
+
+	max_pages = iov_iter_npages(orig, max_pages);
+	if (!max_pages)
+		goto alloc_empty;
+
+	do {
+		bq = bvecq_alloc_one(min(max_pages, BVECQ_4KB_SLOTS), gfp, false);
+		if (!bq) {
+			ret = -ENOMEM;
+			break;
+		}
+		if (user_backed_iter(orig))
+			bq->mem_type = iov_iter_extract_will_pin(orig) ?
+				BVECQ_MEM_GUP : BVECQ_MEM_EXTERNAL;
+
+		if (bq_tail)
+			bvecq_append(bq_tail, bq);
+		else
+			*_bvecq_head = bq;
+		bq_tail = bq;
+
+		struct bio_vec *bv = bq->bv;
+		unsigned int slot = 0;
+		do {
+			struct page **pages;
+			ssize_t got;
+			size_t offset;
+			size_t space = bq->max_slots - slot;
+			size_t bv_size = array_size(bq->max_slots, sizeof(*bv));
+			size_t pg_size = array_size(space, sizeof(*pages));
+
+			/* Put the page list at the end of the bvec list
+			 * storage.  bvec elements are larger than page
+			 * pointers, so as long as we work 0->last, we should
+			 * be fine.
+			 */
+			pages = (void *)bv + bv_size - pg_size;
+
+			got = iov_iter_extract_pages(orig, &pages, max_len,
+						     min(space, max_pages),
+						     extraction_flags, &offset);
+			if (got < 0) {
+				ret = got;
+				goto out;
+			}
+
+			if (got == 0) {
+				pr_err("extract_pages gave nothing from %zx, %zx\n",
+				       extracted, max_len);
+				ret = -EIO;
+				goto out;
+			}
+
+			if (WARN(got > max_len,
+				 "%s: extract_pages overrun %zx > %zx bytes\n",
+				 __func__, got, max_len)) {
+				/* Abandon what we got as very likely the
+				 * overrun corrupted memory.
+				 */
+				ret = -EIO;
+				goto out;
+			}
+
+			extracted += got;
+			max_len -= got;
+
+			do {
+				size_t len = umin(got, PAGE_SIZE - offset);
+
+				BUG_ON(slot >= bq->max_slots);
+
+				bvec_set_page(&bq->bv[slot], *pages++, len, offset);
+				slot++;
+				max_pages--;
+				got -= len;
+				offset = 0;
+			} while (got > 0);
+
+			bvecq_filled_to(bq, slot);
+		} while (max_len > 0 && max_pages > 0 && !bvecq_is_full(bq));
+
+	} while (max_len > 0 && max_pages > 0);
+
+out:
+	if (extracted || ret == 0)
+		return extracted;
+	bvecq_put(*_bvecq_head);
+	*_bvecq_head = NULL;
+	return ret;
+
+alloc_empty:
+	bq = bvecq_alloc_one(1, gfp, false);
+	if (!bq)
+		return -ENOMEM;
+	*_bvecq_head = bq;
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(netfs_extract_iter);
+
 /**
  * netfs_extract_user_iter - Extract the pages from a user iterator into a bvec
  * @orig: The original iterator
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index b0dd92d12a97..aca192bc5675 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -454,6 +454,9 @@ void netfs_get_subrequest(struct netfs_io_subrequest *subreq,
 			  enum netfs_sreq_ref_trace what);
 void netfs_put_subrequest(struct netfs_io_subrequest *subreq,
 			  enum netfs_sreq_ref_trace what);
+ssize_t netfs_extract_iter(struct iov_iter *orig, size_t max_len, size_t max_pages,
+			   struct bvecq **_bvecq_head,
+			   iov_iter_extraction_t extraction_flags, gfp_t gfp);
 ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 				struct iov_iter *new,
 				iov_iter_extraction_t extraction_flags);

