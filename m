Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528D4303A0A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674247; cv=none; b=urFaLrbbbeAtLj3Kjev6/dnpQ4kZj8Dh0ozxN/b/957MLuX5WtbaVlsD+CY0+rZRL0hnHn5/OYPy61XpqmLWtnWcLYbtU0LZRRkW3vsf/ZSkeDF6784EDv3zMHaSZIXqSLVXEGNZ6zkeOV0tGj9H8xe9VEGzS5+ReSMMHL0+7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674247; c=relaxed/simple;
	bh=JE6CsI55nIe/za2bQ2wM//e11Vro+GT7jie6/v4Wuw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7VaxQ359ZjfN3S8KNCnuIe3Gx9qT2Iov0EvmGVIcS1wtKMbWbjK2XCRwFgRF7d+JQW8s7TpgDTD5RwJg6icyXAXPE1xYGnz2EXD9vvigm+bqhjq+CGWoez1bTQ64Wn3kVofXgmVR9AifU7U7skB3OxAY4eGD/JqN6Hz5xpNjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAAfxSn/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAAfxSn/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776674245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ksxJg5s1e4rqCiU0anjwW0Drg+bXTRaHFQWcy6sTuKQ=;
	b=LAAfxSn/3rU9Ivd58Hr6n1neexlCNwrE6inWPwdIFr1pHxnSRlNuuWj0eTLk96qosLeKDi
	zdCTuLvLa0QLqY8FJKWO8BAIQz3Dgoyckg4BksmXbIN9VXJITPFLO7nDEYij+xD4j7LC8i
	WIWg9CVy8q3gtTtDM3d6MIeEd62hNIg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-tjVoit6wNru8srkOeHIZeQ-1; Mon,
 20 Apr 2026 04:37:21 -0400
X-MC-Unique: tjVoit6wNru8srkOeHIZeQ-1
X-Mimecast-MFC-AGG-ID: tjVoit6wNru8srkOeHIZeQ_1776674239
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83B9018005A8;
	Mon, 20 Apr 2026 08:37:19 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 247B3195608E;
	Mon, 20 Apr 2026 08:37:14 +0000 (UTC)
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
	Steve French <sfrench@samba.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 01/11] netfs: Fix early put of sink folio in netfs_read_gaps()
Date: Mon, 20 Apr 2026 09:36:52 +0100
Message-ID: <20260420083705.1009074-2-dhowells@redhat.com>
In-Reply-To: <20260420083705.1009074-1-dhowells@redhat.com>
References: <20260420083705.1009074-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_read_gaps() to release the sink page it uses after waiting for
the request to complete.  The way the sink page is used is that an
ITER_BVEC-class iterator is created that has the gaps from the target folio
at either end, but has the sink page tiled over the middle so that a single
read op can fill in both gaps.

The bug was found by KASAN detecting a UAF on the generic/075 xfstest in
the cifsd kernel thread that handles reception of data from the TCP socket:

 BUG: KASAN: use-after-free in _copy_to_iter+0x48a/0xa20
 Write of size 885 at addr ffff888107f92000 by task cifsd/1285
 CPU: 2 UID: 0 PID: 1285 Comm: cifsd Not tainted 7.0.0 #6 PREEMPT(lazy)
 Call Trace:
  dump_stack_lvl+0x5d/0x80
  print_report+0x17f/0x4f1
  kasan_report+0x100/0x1e0
  kasan_check_range+0x10f/0x1e0
  __asan_memcpy+0x3c/0x60
  _copy_to_iter+0x48a/0xa20
  __skb_datagram_iter+0x2c9/0x430
  skb_copy_datagram_iter+0x6e/0x160
  tcp_recvmsg_locked+0xce0/0x1130
  tcp_recvmsg+0xeb/0x300
  inet_recvmsg+0xcf/0x3a0
  sock_recvmsg+0xea/0x100
  cifs_readv_from_socket+0x3a6/0x4d0 [cifs]
  cifs_read_iter_from_socket+0xdd/0x130 [cifs]
  cifs_readv_receive+0xaad/0xb10 [cifs]
  cifs_demultiplex_thread+0x1148/0x1740 [cifs]
  kthread+0x1cf/0x210

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Steve French <sfrench@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index c23173a061e8..dc50690fdd44 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -459,9 +459,6 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	netfs_read_to_pagecache(rreq, NULL);
 
-	if (sink)
-		folio_put(sink);
-
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
 		folio_detach_private(folio);
@@ -471,6 +468,9 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
+
+	if (sink)
+		folio_put(sink);
 	folio_unlock(folio);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;

