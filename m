Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83057480944
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382383; cv=none; b=rD6QiHXFrfo1piGbLgGnrtfxYbekdvh26V1g3TRvh2IA9hnTMJHcFq17g3VPzeOMDpYHNDt61hfbF2Z2N1BjsqwjGMcff3ifdUdPjet8P5wKiwQ+ZEUU2Mp6IThqvZcMKqFOL3XbEfUcwnh+EHkdQZCScLTc0CwEGmYiOh+mcMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382383; c=relaxed/simple;
	bh=MV8BsLrMSvER3VtBqtk6M+xC9GGfEG9YOInXw8Zjt00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/T/elj+72qKUY1LsmO+nM4iQY5tV4Kr8PK6ZbsPPxauSL247c1/+ElZj77mUVMRBahqQKhZeWVx2R75ZZMNsd1qlIcs+pOjcym2Pa18fhvVhZsysqj03FSQEZtX2B89VG9K8/KEPDvfqcomcDy3Ohwulh+uyO1nthsMf0JhL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d76wf011; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d76wf011"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=igkxaROK0pbIaBuU08ythplTuPEJybILP1W7N8Z9Dh0=;
	b=d76wf0114PFPUwCvXkE8YlZWTLuy86ghKLKbgPNL295xHVeLvad71pQvevhEgwCX3fHGi9
	Xj1B+pKMJGBmDwaUU4tt58RJRwQ028vdiD9Yzwwlpm4VVBcYc/HRYYTTjnM8IEQ89ey242
	mLhOoW51wmcj8kDNqvNs3nS4B2hJmAs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-1n-4cWErO22kS_BHhqIFjQ-1; Tue,
 28 Apr 2026 09:19:37 -0400
X-MC-Unique: 1n-4cWErO22kS_BHhqIFjQ-1
X-Mimecast-MFC-AGG-ID: 1n-4cWErO22kS_BHhqIFjQ_1777382374
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AFB219560BB;
	Tue, 28 Apr 2026 13:19:34 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E37A19560AB;
	Tue, 28 Apr 2026 13:19:31 +0000 (UTC)
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
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 19/24] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
Date: Tue, 28 Apr 2026 14:17:49 +0100
Message-ID: <20260428131756.922303-20-dhowells@redhat.com>
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

netfs_unlock_abandoned_read_pages(rreq) accesses the index of the folios it
is wanting to unlock and compares that to rreq->no_unlock_folio so that it
doesn't unlock a folio being read for netfs_perform_write() or
netfs_write_begin().

However, given that netfs_unlock_abandoned_read_pages() is called _after_
NETFS_RREQ_IN_PROGRESS is cleared, the one folio that it's not allowed to
dereference is the one specified by ->no_unlock_folio as ownership
immediately reverts to the caller.

Fix this by storing the folio pointer instead and using that rather than
the index.  Also fix netfs_unlock_read_folio() where the same applies.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 4 ++--
 fs/netfs/read_collect.c  | 2 +-
 fs/netfs/read_retry.c    | 2 +-
 include/linux/netfs.h    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index db279124d450..89ae5241c49c 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -670,7 +670,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 		ret = PTR_ERR(rreq);
 		goto error;
 	}
-	rreq->no_unlock_folio	= folio->index;
+	rreq->no_unlock_folio	= folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 
 	ret = netfs_begin_cache_read(rreq, ctx);
@@ -736,7 +736,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 		goto error;
 	}
 
-	rreq->no_unlock_folio = folio->index;
+	rreq->no_unlock_folio = folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 	ret = netfs_begin_cache_read(rreq, ctx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 3c9b847885c2..23660a590124 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -83,7 +83,7 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	}
 
 just_unlock:
-	if (folio->index == rreq->no_unlock_folio &&
+	if (folio == rreq->no_unlock_folio &&
 	    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags)) {
 		_debug("no unlock");
 	} else {
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index e10eb5a07332..f59a70f3a086 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -292,7 +292,7 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 			struct folio *folio = folioq_folio(p, slot);
 
 			if (folio && !folioq_is_marked2(p, slot)) {
-				if (folio->index == rreq->no_unlock_folio &&
+				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
 					_debug("no unlock");
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 1b1db8e6cdf1..9a68bee01c1a 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -252,7 +252,7 @@ struct netfs_io_request {
 	unsigned long long	collected_to;	/* Point we've collected to */
 	unsigned long long	cleaned_to;	/* Position we've cleaned folios to */
 	unsigned long long	abandon_to;	/* Position to abandon folios to */
-	pgoff_t			no_unlock_folio; /* Don't unlock this folio after read */
+	const struct folio	*no_unlock_folio; /* Don't unlock this folio after read */
 	unsigned int		direct_bv_count; /* Number of elements in direct_bv[] */
 	unsigned int		debug_id;
 	unsigned int		rsize;		/* Maximum read size (0 for none) */

