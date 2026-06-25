Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980CC34041B
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396468; cv=none; b=WE4WEeQ+ngPlO53JgeopDnJcFmUKwg6IJJ+WBFQabVt7NoUO3okgDoXNNrTmdRssX2QxNzWSGRbVFbb0yN2zOJe59lLdLQP40OUUdhEpCZIR6TR1UlzP5lo3Y2jQzkZGQwCN1wgdiwzZdxC1+naolP63cyDNOX+B6nCxN5Oz/nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396468; c=relaxed/simple;
	bh=LlyerzgyX+5L/7rCJl1ktSyZ72E37ZcqdGfNCyxOLPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNy7voYd+Y6Vecklz7rhmSZKMc1wZN2V9d8+RYZYUEDI0FD4b/sFIeCC4tAh8oLdyO/dTNjgNsiuPcx7mbBWCOrjdQ7jKX7VoPOkL5/2gTWXxTU5fEzVH1OXYqGPzFEiGnXsLdXjP2qoDLgw3Sag8049iLalqQFtkOslUVRhW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SF1PFX7Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SF1PFX7Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tBSa5TnPIcX9KUvKuQ/n5zPtisGuhCJFsXdMJvHXniA=;
	b=SF1PFX7YkSQsGqN9AL2byfTjui5aee0z9YsP+lGe99CGVh49Nl9MuHBTAZdoc3HvE7kojE
	NNd/s6xWVSGNzxMONCmmOhw1Mo+Ns8cVC2rJOfje1slBBX5xSgDzM6odgiC+kvULdJDeXM
	zJCOIzUzSYpC2pN//wMxdT6FqbCwdUg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-f0dUR1UtO_CXJr-IHLRHlw-1; Thu,
 25 Jun 2026 10:07:41 -0400
X-MC-Unique: f0dUR1UtO_CXJr-IHLRHlw-1
X-Mimecast-MFC-AGG-ID: f0dUR1UtO_CXJr-IHLRHlw_1782396459
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C55E1873129;
	Thu, 25 Jun 2026 14:07:38 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE9E319560AB;
	Thu, 25 Jun 2026 14:07:34 +0000 (UTC)
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
	Ming Lei <ming.lei@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 08/15] iov_iter: Remove unused variable in kunit_iov_iter.c
Date: Thu, 25 Jun 2026 15:06:26 +0100
Message-ID: <20260625140640.3116900-9-dhowells@redhat.com>
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Remove the no longer used variable 'b' from iov_kunit_copy_to_bvec().  The
variable is initialised and incremented, but nothing now makes use of the
value.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ming Lei <ming.lei@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/tests/kunit_iov_iter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/tests/kunit_iov_iter.c b/lib/tests/kunit_iov_iter.c
index f02f7b7aa796..e7e154f94f66 100644
--- a/lib/tests/kunit_iov_iter.c
+++ b/lib/tests/kunit_iov_iter.c
@@ -275,7 +275,7 @@ static void __init iov_kunit_copy_to_bvec(struct kunit *test)
 	struct page **spages, **bpages;
 	u8 *scratch, *buffer;
 	size_t bufsize, npages, size, copied;
-	int i, b, patt;
+	int i, patt;
 
 	bufsize = 0x100000;
 	npages = bufsize / PAGE_SIZE;
@@ -298,10 +298,9 @@ static void __init iov_kunit_copy_to_bvec(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, iter.nr_segs, 0);
 
 	/* Build the expected image in the scratch buffer. */
-	b = 0;
 	patt = 0;
 	memset(scratch, 0, bufsize);
-	for (pr = bvec_test_ranges; pr->from >= 0; pr++, b++) {
+	for (pr = bvec_test_ranges; pr->from >= 0; pr++) {
 		u8 *p = scratch + pr->page * PAGE_SIZE;
 
 		for (i = pr->from; i < pr->to; i++)

