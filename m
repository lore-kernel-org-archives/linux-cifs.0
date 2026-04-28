Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E527147DD7C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382373; cv=none; b=LYMhxbN7iW7fH0PzQuHRTMNeyzqwA95DrQxlKtOx7IjDZvBxEDPOy8Ojox+cMsaQouRjGfxp9ovdVjjSlSgyUzDQoRzzESz5n2uC4L76M5roCZ7WDfTp59Vjx4Fi/OQhwrNiTMhaymrouKqx3NNVwJ/4VXHjxLFpAX8xWW4Xe7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382373; c=relaxed/simple;
	bh=6aS16OhU7wJB8E9ZvNzMBoTTc64B5xcaExT2qrf2F8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIYNPbnbPP03gJKi4GsWugE68ihKgwJKvuZOaPhOLSe1rBAXm7rIBP1jqTMAeh5kCUUVADKBHJDx/dVa61Syxyy74GZtvhEeRBpGcJz1SgwLjq8Jrxwwy0M+yIAvl0KVoNBhDo92p7A1RxTM10xdkMK25oBsfuYpF1A4DjzF36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PoK3+Ude; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PoK3+Ude"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHSQahnA7js1P4paGsZUSZ9WNRs6QCvVJJSxiV11wQI=;
	b=PoK3+Udej8Hpqibeltoe9U6qxEQ2eo/0TpB8AR01gIsB5+A7kVEcVMzXV65N7k8ZGCkmzI
	p29ScDih9LqR3MXEi6Zj5rRSZ/pV/4jjQrVqOO2VTzxKrPVBRXNcPgdiISiZkZZi47t5KK
	mA06ev1UFZuTwoc82fd7MwjOpQ6NmJI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-4t6aizAbP86H_MufK2aZGw-1; Tue,
 28 Apr 2026 09:19:24 -0400
X-MC-Unique: 4t6aizAbP86H_MufK2aZGw-1
X-Mimecast-MFC-AGG-ID: 4t6aizAbP86H_MufK2aZGw_1777382362
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BC10186057E;
	Tue, 28 Apr 2026 13:18:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5653019560AB;
	Tue, 28 Apr 2026 13:18:44 +0000 (UTC)
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
Subject: [PATCH v5 09/24] netfs: Fix overrun check in netfs_extract_user_iter()
Date: Tue, 28 Apr 2026 14:17:39 +0100
Message-ID: <20260428131756.922303-10-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
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
 fs/netfs/iterator.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index adca78747f23..932f745fa3b5 100644
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

