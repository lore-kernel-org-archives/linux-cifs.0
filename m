Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0AA35AC32
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396471; cv=none; b=Ggsy6ys7RRj/xb6Ji1quqIWz6w2o0ou/DcnO+/MMGM2j0+6OH9f8KJKC6VWYzKLQenOPjYtHBlRyptG7kvoz7czthmsJr8Fmam1P51wXRTOUh2HeimOUnDae1I6S2WWQxQlirz2/1E2t7fmkLamqXiD307AWVSXvomo4fHEU/kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396471; c=relaxed/simple;
	bh=XeKZjskD6VOpKhK4DCHRe6/r4KKjrrJrcuXfBF9rrj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWwflmoHRiSbB+ef2me1c/cZTmHcWyzPBtgjUrGttpK2iIrIX02i/Cf/osF7b7695BVVeAHNEOmdCElKSJ9jyFrpCOa2tlBFefJJSJ8Ika5fMyLbwzwUvLSX9K6ruTSfwjaReEakG9n47J4GWWJTua+8btrsS6nmyfNX2c6WVnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzUUP/3w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzUUP/3w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZAdgt5Q5ecGnX+0eAge9E84oY2tNl0RIvK/bRkloIk=;
	b=gzUUP/3wGmAUTRsKHPpwkOiYpqCpO2vc9EjFEpn9Yvw4J4tc7v9zEjsB8T+lmxFL/uab1D
	cphrBOyQDBVgkkj3KDgCWuxQs+N58Iqdm3K5TQ14YnGiKdK48xQgyht44B+Om04qXrU2fG
	gfwTdtdPgzVDzowYVanTWeKe/dlXu6E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-dhqG_OpHODyzbYpseqLEMQ-1; Thu,
 25 Jun 2026 10:07:42 -0400
X-MC-Unique: dhqG_OpHODyzbYpseqLEMQ-1
X-Mimecast-MFC-AGG-ID: dhqG_OpHODyzbYpseqLEMQ_1782396453
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34B38197730D;
	Thu, 25 Jun 2026 14:07:33 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0D1C33189;
	Thu, 25 Jun 2026 14:07:28 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 07/15] iov_iter: Fix a memory leak in iov_iter_extract_user_pages()
Date: Thu, 25 Jun 2026 15:06:25 +0100
Message-ID: <20260625140640.3116900-8-dhowells@redhat.com>
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

There's a potential memory leak in callers of iov_iter_extract_user_pages()
whereby if a pages array is allocated in function, it isn't freed before
returning of an error or 0.

Now, it's not a leak per se in iov_iter_extract_user_pages() as, if an
array is allocated, it's returned through *pages, so it's incumbent on the
caller to free it.  However, not all callers do.

Fix this by freeing the table and clearing *pages before returning an error
or 0.  Note that iov_iter_extract_pages() and its subfunctions are allowed
to return 0 without returning an array (for instance if the iterator count
is 0).

Fixes: 7d58fe731028 ("iov_iter: Add a function to extract a page list from an iterator")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/iov_iter.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1661c237b643..5a6434709716 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1756,6 +1756,7 @@ static ssize_t iov_iter_extract_user_pages(struct iov_iter *i,
 	unsigned long addr;
 	unsigned int gup_flags = 0;
 	size_t offset;
+	bool will_alloc = !*pages;
 	int res;
 
 	if (i->data_source == ITER_DEST)
@@ -1772,8 +1773,14 @@ static ssize_t iov_iter_extract_user_pages(struct iov_iter *i,
 	if (!maxpages)
 		return -ENOMEM;
 	res = pin_user_pages_fast(addr, maxpages, gup_flags, *pages);
-	if (unlikely(res <= 0))
+	if (unlikely(res <= 0)) {
+		if (will_alloc) {
+			kvfree(*pages);
+			*pages = NULL;
+		}
 		return res;
+	}
+
 	maxsize = min_t(size_t, maxsize, res * PAGE_SIZE - offset);
 	iov_iter_advance(i, maxsize);
 	return maxsize;

