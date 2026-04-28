Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADB247DD6C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382372; cv=none; b=il7bTX54tsggaMewGG1xoDs4kHyYJI4qAX24eWaXNJ1KTRAneBtpMXTGxXLq9+mw2SqMtBhv92jOpCkf5cSG6cqHF67YYxXUwbIFoQgIfDpC6mbeSaKSAOYu2QIqTix4M6QJvjl9BkFXJIwp2sowUlA8su9asvsok11JGNzrqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382372; c=relaxed/simple;
	bh=J6xbkiUXEBxqGua30Ly2BO3cTSDIQVPMlA1JsgMbaAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e262ga+ucg4QSYQH/eRG2MF+N6AUlHviRksa+JMY6FhnGDluOnMXFQG91Q68yx3/wAbnRR7h3VMxh80ABUmKAlkg0rd67UxesahYdBu/DIPq40dH5FRizdUNiCeOekJRp1+murA0ntSjHbQSWOBXdR5lfsSZDDqARmbVPEL+AJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KSanz9Wp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KSanz9Wp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPw8vG2tI8x7LyUiAgQo8fFB7ZuQxgP71N5NQ3zP9Ok=;
	b=KSanz9Wp+A9ypRMVQM6BulZHNRXdwDEsR23r6pOQ6HZ2QC1ErSakf6vyJPrUE7Icbu2Zbl
	DqnZVne6AXydq9fMAt/YHfFjF3WzU7K5udTkRnQndM4NdMVJBUWrI9ylsQooFIh8oz6+zA
	2tvbw/hZy2CA7U/YwUoWaKf4GM6SDkY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-KETjkhGDMKu4F8BaFxma3A-1; Tue,
 28 Apr 2026 09:19:27 -0400
X-MC-Unique: KETjkhGDMKu4F8BaFxma3A-1
X-Mimecast-MFC-AGG-ID: KETjkhGDMKu4F8BaFxma3A_1777382365
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F46F1955F25;
	Tue, 28 Apr 2026 13:19:25 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC3251955F21;
	Tue, 28 Apr 2026 13:19:21 +0000 (UTC)
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
Subject: [PATCH v5 17/24] netfs: Fix early put of sink folio in netfs_read_gaps()
Date: Tue, 28 Apr 2026 14:17:47 +0100
Message-ID: <20260428131756.922303-18-dhowells@redhat.com>
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
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index c0a7f9e60f0c..18c8e00626c9 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -457,9 +457,6 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	netfs_read_to_pagecache(rreq, NULL);
 
-	if (sink)
-		folio_put(sink);
-
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
 		if (group)
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

