Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1B233946
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878050; cv=none; b=pa2XaiOyEhpM8CwvsRzVQzcLsdKA+U73sS7kfKQAIUgt3/lgyznzFhk3cEsWKbYAA0LESw2/eldG2M9pZIa6hT4iiXjbR6/jaYz0cYFudZjC7oLtSfAZRvP6Wvs1WSVkSPhS3XFCyv7G/uX4wtUB9zrXtIzi7rcELlKDStdnAcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878050; c=relaxed/simple;
	bh=XnWYPrVI8cNorTEcQAEJuZpfx5DyouR5NqzTu7dlSY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZUYrBTgm7RopXABVQY1YeTRj3w7Y2JnVYXM7zzI4SH2kPINelok0J7fkeNNhs1dyfcpAi7xAq7Gbd+uAuauVBBnGWWM/ECY/fJxYRJdYQuJQX6x5PxKIug9WNjj+Ay5NfPBjPOjkXpC0i94vNgwhLY0hd4ttYajSdV5NfpMLes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4BOB0Gz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4BOB0Gz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l63xVWmxFghczsjUorcVyNKhDjwn0yMtCv9CCvtK00c=;
	b=a4BOB0GzG5+do03YTNLl1th4vN03wwXoQrnFArIpsgTIp4AiYj3QPniz2ZdiOCxL64BiEq
	oFYNQ1QVdGpKYpKhw3VNTkEMxjQYJjWQT2R6qDqCIKMt7ZY9t7Y778+Vx2LGKRK9GBA+di
	fXEM9Si/wNZ/BxxUDKoc4S8QwVwcndg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-m8EcS-O4OWW48TdCTkcbcQ-1; Fri,
 19 Jun 2026 10:07:21 -0400
X-MC-Unique: m8EcS-O4OWW48TdCTkcbcQ-1
X-Mimecast-MFC-AGG-ID: m8EcS-O4OWW48TdCTkcbcQ_1781878039
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC1FF180ACC9;
	Fri, 19 Jun 2026 14:07:19 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 507471800361;
	Fri, 19 Jun 2026 14:07:15 +0000 (UTC)
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
	Ming Lei <ming.lei@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/11] iov_iter: Fix missing alloc fail check in iov_iter_extract_bvec_pages()
Date: Fri, 19 Jun 2026 15:06:09 +0100
Message-ID: <20260619140646.2633762-6-dhowells@redhat.com>
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

Fix iov_iter_extract_bvec_pages() to check if want_pages_array() fails and,
if so, return -ENOMEM appropriately.

Fixes: e4e535bff2bc ("iov_iter: don't require contiguous pages in iov_iter_extract_bvec_pages")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ming Lei <ming.lei@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/iov_iter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1f5685196565..5c62860e3ded 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1637,6 +1637,8 @@ static ssize_t iov_iter_extract_bvec_pages(struct iov_iter *i,
 	bi.bi_bvec_done = skip;
 
 	maxpages = want_pages_array(pages, maxsize, skip, maxpages);
+	if (!maxpages)
+		return -ENOMEM;
 
 	while (bi.bi_size && bi.bi_idx < i->nr_segs) {
 		struct bio_vec bv = bvec_iter_bvec(i->bvec, bi);

