Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E8737DAA2
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589315; cv=none; b=Yp2RrX7b9pWary5YXftrfoJkrE2XXOUJHPyRuz8BFTr7UTCQB0wpX5yNZPknDsVCdZFhiQi+NrAPCKQVvatS1wP/QwmpQNuSL/eNakg9slYuUC1/qNC7lEFIz6HwN7WuVkTrYxhWbNMvBTx08NYiipmmhMIink3Ve7vkjNZRJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589315; c=relaxed/simple;
	bh=3YvfC4SFqq5CAax8989wspHy9qRmH43JzGvB3HLN65o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvFo7kq+yJn/qyryt0Fd1ih1i4dgsbTaGYFFPKG2ygJa1wVhIBh2QWLHwlVCdnojKB89tDMHuOa3AEktsGVVQWL+fHrN5+xPq6H9bNQy2hQGcst5mcl4l1S2BIvmn66xoo8AccIXhcfccpQczQamGcd3UksXwXZHdxXkVjqmgyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aq6D3tT4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aq6D3tT4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqTDgxS92higoqL65+640Zno11P+YXpAqTm+1gBq9A0=;
	b=aq6D3tT4D+RCQ+7zsP5NDacFt5ZVsJYpSohbR773QHl/hCQ00LkGJOhXxSAZYwLmx+zrA5
	N/NnqbYdSXVfyfe7iOGIi61YzQ69v9Sax2snwdUX+jx7SYcjqUVKx6iBHryXbPIyIQD7ef
	AYBIEHxBxuC6lGbQFvJnkVyDSHbOaR4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-r0kVuVHoNG68j78FkHt2fg-1; Tue,
 12 May 2026 08:35:01 -0400
X-MC-Unique: r0kVuVHoNG68j78FkHt2fg-1
X-Mimecast-MFC-AGG-ID: r0kVuVHoNG68j78FkHt2fg_1778589299
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85F6B195607B;
	Tue, 12 May 2026 12:34:59 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF68419560A2;
	Tue, 12 May 2026 12:34:56 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 10/24] netfs: Fix overrun check in netfs_extract_user_iter()
Date: Tue, 12 May 2026 13:33:47 +0100
Message-ID: <20260512123404.719402-11-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix netfs_extract_user_iter() so that if iov_iter_extract_pages() overfills
pages[], then those pages don't get included in the iterator constructed at
the end of the function.  If there was an overfill, memory corruption has
already happened.

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Closes: https://sashiko.dev/#/patchset/20260427154639.180684-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/iterator.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 429e4396e1b0..b375567e0520 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -72,21 +72,24 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 			break;
 		}
 
-		if (ret > count) {
-			pr_err("get_pages rc=%zd more than %zu\n", ret, count);
+		if (WARN(ret > count,
+			 "%s: extract_pages overrun %zd > %zu bytes\n",
+			 __func__, ret, count)) {
+			ret = -EIO;
 			break;
 		}
 
-		count -= ret;
-		ret += offset;
-		cur_npages = DIV_ROUND_UP(ret, PAGE_SIZE);
-
-		if (npages + cur_npages > max_pages) {
-			pr_err("Out of bvec array capacity (%u vs %u)\n",
-			       npages + cur_npages, max_pages);
+		cur_npages = DIV_ROUND_UP(offset + ret, PAGE_SIZE);
+		if (WARN(cur_npages > max_pages - npages,
+			 "%s: extract_pages overrun %u > %u pages\n",
+			 __func__, npages + cur_npages, max_pages)) {
+			ret = -EIO;
 			break;
 		}
 
+		count -= ret;
+		ret += offset;
+
 		for (i = 0; i < cur_npages; i++) {
 			len = ret > PAGE_SIZE ? PAGE_SIZE : ret;
 			bvec_set_page(bv + npages + i, *pages++, len - offset, offset);
@@ -97,6 +100,11 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 		npages += cur_npages;
 	}
 
+	/* Note: Don't try to clean up after EIO.  Either we got no pages, so
+	 * nothing to clean up, or we got a buffer overrun, memory corruption
+	 * and can't trust the stuff in the buffer (a WARN was emitted).
+	 */
+
 	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
 		for (i = 0; i < npages; i++)
 			unpin_user_page(bv[i].bv_page);

