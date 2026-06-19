Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8FA233946
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878041; cv=none; b=IFHFFMRwsjt/OPXXCjAQDq7IHRb3Vyd37cBl5Aq+co6BgjFdZ4tQAHektXDucL3GPa4B7tBQEgDbEIxsWcrF7TWugLLcnudHqS+q4VQhuiAkZcgapC+A3/gB7XEiOLv9cz11fHUuPjtMISHO6jxIWQj+xC36sQBLsZkWcqiZFsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878041; c=relaxed/simple;
	bh=TFR2W+GafvydtsphvjGbQljG09UcL0/2AoDDceRw69s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buywW/k1ym461R7f037vBhRLt/j2gDf9i/IbbN6qiDiQ9SRI02YKR4irse5yw+6h830uvnp4K1CzLg1AvpWedTdyYXnrXXZN75p0LP+7EJREL9bTXU4bsac4YuxciXOcokhAZKopvXrwDqvarnjB+6ng7x+szTWrkmh5czZsEfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fBoIAsI8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fBoIAsI8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOIdAwL2gv2GsiqLW1X2cLXRfkXNtTFAAvG9rPHfrSI=;
	b=fBoIAsI8/xNm5swI69LDgaYdhDIyUarANAYallIbvM8uUKRn89Ew3uttTqSLU6wxPSOYew
	RUoEJ2CKgQ0ZU8JD3lQIN2+zXgjShZPDwphILzHcX+VG8ZdRE2g9OiJ+VerR7QNSspT7aF
	EGJ3KZJza+DIiOlZ9zT1hb1GFe3oQZk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-BJjxY9DfN5qmw8szkY6Dgw-1; Fri,
 19 Jun 2026 10:07:16 -0400
X-MC-Unique: BJjxY9DfN5qmw8szkY6Dgw-1
X-Mimecast-MFC-AGG-ID: BJjxY9DfN5qmw8szkY6Dgw_1781878034
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3C80187BE38;
	Fri, 19 Jun 2026 14:07:13 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 34FAD18005B7;
	Fri, 19 Jun 2026 14:07:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 04/11] iov_iter: Fix potential underflow in iov_iter_extract_xarray_pages()
Date: Fri, 19 Jun 2026 15:06:08 +0100
Message-ID: <20260619140646.2633762-5-dhowells@redhat.com>
In-Reply-To: <20260619140646.2633762-1-dhowells@redhat.com>
References: <20260619140646.2633762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In iov_iter_extract_xarray_pages(), if no pages are extracted because
there's a hole (or something otherwise unextractable) in the xarray, then
the calculation of maxsize at the end can go wrong if the starting offset
is not zero.

Fix this by returning 0 in such a case and freeing the page array if
allocated here rather than being passed in.

Note that in the near future, ITER_XARRAY should be removed.

Fixes: 7d58fe731028 ("iov_iter: Add a function to extract a page list from an iterator")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Link: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Mike Marshall <hubcap@omnibond.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/iov_iter.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 243662af1af7..1f5685196565 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1568,6 +1568,7 @@ static ssize_t iov_iter_extract_xarray_pages(struct iov_iter *i,
 	struct folio *folio;
 	unsigned int nr = 0, offset;
 	loff_t pos = i->xarray_start + i->iov_offset;
+	bool will_alloc = !*pages;
 	XA_STATE(xas, i->xarray, pos >> PAGE_SHIFT);
 
 	offset = pos & ~PAGE_MASK;
@@ -1595,6 +1596,14 @@ static ssize_t iov_iter_extract_xarray_pages(struct iov_iter *i,
 	}
 	rcu_read_unlock();
 
+	if (!nr) {
+		if (will_alloc) {
+			kfree(*pages);
+			*pages = NULL;
+		}
+		return 0;
+	}
+
 	maxsize = min_t(size_t, nr * PAGE_SIZE - offset, maxsize);
 	iov_iter_advance(i, maxsize);
 	return maxsize;

