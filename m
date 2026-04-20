Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0CC3890FB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674261; cv=none; b=rhKJSQtwqtDzV9sa3kfMc0QHDYpNp0s61Y2w/pcRsvCx5v0F55NDESMuKGfmmem8FZA2sR6yKPt20VNXGDPKt+GFC3vwjDAFk9xRPAcpGS9hNP8i6Irq5vUwRHfFy5QcMI6uIMW5qwUL0bw+iZOaKVwn2SZA0/MccePkesApWok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674261; c=relaxed/simple;
	bh=ZGvl6pwK8hhI6Z7/+zjDuc7j0IK6cFQmA5My4ZDgo6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ta/cq+4WyGh16RPA9CvIpysOapkqhW2DKYevAfLikPk5PsCiJ/vqQVvWZV0cfNg97Dw8Cihfud2kr6sNYQegFpTrmUVdq/m7Yx6TEKnmynfK/btLcMT0Gtl4+2mlhRjR4RNq10K9uX90YbFG81Kfdci60KZhwmeXqaz/DDTSxMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GhsHGmUV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhsHGmUV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776674258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k8mwXPbUAnJI1Gm/W783qf7sgkpvXeGSln2ciNPV49w=;
	b=GhsHGmUVUZOPKyxFnZGaAS+SQHdsbUbjWQ0Xv2R3jdLN97XMQ7faieaeqAbXhy4/1jn0+L
	syOlxW85pXdAZZDIJLjAdnyiuHY7RtePjjmihqMjopJnilXIodg7Y+5vOnKKcJLpUQu7HZ
	md4mssQ4k6oxZeCRTvWQVgbzA/w+QrI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-666PritQM6uNZi4hHI4WUA-1; Mon,
 20 Apr 2026 04:37:37 -0400
X-MC-Unique: 666PritQM6uNZi4hHI4WUA-1
X-Mimecast-MFC-AGG-ID: 666PritQM6uNZi4hHI4WUA_1776674256
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6744D18003FC;
	Mon, 20 Apr 2026 08:37:35 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5288819560AB;
	Mon, 20 Apr 2026 08:37:32 +0000 (UTC)
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
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 04/11] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
Date: Mon, 20 Apr 2026 09:36:55 +0100
Message-ID: <20260420083705.1009074-5-dhowells@redhat.com>
In-Reply-To: <20260420083705.1009074-1-dhowells@redhat.com>
References: <20260420083705.1009074-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In netfs_extract_user_iter(), if it's given a zero-length iterator, it will
fall through the loop without setting ret, and so the error handling
behaviour will be undefined, depending on whether ret happens to be
negative.  The value of ret then propagates back up the callstack.

Fix this by presetting ret to 0.

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/iterator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index adca78747f23..429e4396e1b0 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -43,7 +43,7 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 	unsigned int max_pages;
 	unsigned int npages = 0;
 	unsigned int i;
-	ssize_t ret;
+	ssize_t ret = 0;
 	size_t count = orig_len, offset, len;
 	size_t bv_size, pg_size;
 

