Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1235E940
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396457; cv=none; b=HgBeIK/Ph+duNd1AJwOUR4M66mEbcc3EMqRJnE7Z4A+M20T54wDLJIP1w1OE5gTpRIDrdrMdubzcN+BfD2n2DYbGwK6u8n7yRZs2cfVGTxl5Gya5PSNn/rgoSbZ8tc52ivgm7M+nV54fmprDJtNXtXelseqF0gJ5RajH7k2VcAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396457; c=relaxed/simple;
	bh=4YO0schpHrytBbCwQ3FkwrvdrFR4G2LcBxtQ244E8Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgSFaKGzJmufFZIXSLDKnZXR1E31xGjbVGxfYTq3s6i6o1yZX/qQWXVuzBQO2eG1rDPwC5Pxi9fw/VKGh8Fuw+tzcz0vwzk3pe2em+9sjI8wI0D+ScvY49AwFVkr7IUgqPAtG24loMWZ3nVhZY9Jhw24/WsjYZty0xB54tiPI+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OXsHC0BX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OXsHC0BX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ci/Uz32uQ+cQbDj0d+4HQoRx3PoMzfw96v2ECR7IWxY=;
	b=OXsHC0BXyhr+rk0YHEnWtASbslSbP1IWGpeSpO1pfHsfT3oaTvykOZdMOYw/injGr52dCU
	U8dhbthR92K7i8WJ70ScFhTyRFbvXjxOIcBdJmo6W+hQL/I5rgkBCZVvYR3CfuJhzE0qmM
	3r/hivc9NphS+W0goaE+2qE8unO+J6k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-7AmamCDjOd6K7lyN0TYIlQ-1; Thu,
 25 Jun 2026 10:07:29 -0400
X-MC-Unique: 7AmamCDjOd6K7lyN0TYIlQ-1
X-Mimecast-MFC-AGG-ID: 7AmamCDjOd6K7lyN0TYIlQ_1782396448
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 555ED180AD7B;
	Thu, 25 Jun 2026 14:07:27 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3978E3189;
	Thu, 25 Jun 2026 14:07:23 +0000 (UTC)
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
Subject: [PATCH v3 06/15] iov_iter: Fix missing alloc fail check in iov_iter_extract_bvec_pages()
Date: Thu, 25 Jun 2026 15:06:24 +0100
Message-ID: <20260625140640.3116900-7-dhowells@redhat.com>
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
index 5f60733f3280..1661c237b643 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1637,6 +1637,8 @@ static ssize_t iov_iter_extract_bvec_pages(struct iov_iter *i,
 	bi.bi_bvec_done = skip;
 
 	maxpages = want_pages_array(pages, maxsize, skip, maxpages);
+	if (!maxpages)
+		return -ENOMEM;
 
 	while (bi.bi_size && bi.bi_idx < i->nr_segs) {
 		struct bio_vec bv = bvec_iter_bvec(i->bvec, bi);

