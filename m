Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B3E3D7D8F
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304887; cv=none; b=RaPR/OugEyYAhwM4nSSRINvM3kct2rqvbDc6lnq5CIXmkBCKeFmK3kkNUfJjqmKMS13X2Ayvbh7KAj7T9FW0ZrMA09AIIbN2id9XgbHmlV8R3Z0FvaboMsVqddV7fcasHyHBwin57g9hwrJmO05MD/Xzf+LW5zydpXGEEBJwATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304887; c=relaxed/simple;
	bh=umEY6z5FzhVe9OfppsXVNGpeV9bgYr7l964IDKNxAUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4fxYhC8FWjE4UlrZkr7uAJ+TCYC5Vc9cJ4TNPs9V4GpACacnVoBR+upsJbAA6JvkaFu2RNAW5JN16cGK7l0ItcCQ3RinI4oM57Js4HNlIdVyPYl2GSS9RrLJtMsOESkDOz372fvyNtcFv8oT++xmPgM7Nt0FBT+S+40AHxsYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZClL2hr3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZClL2hr3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zeNaf4Kz9zRtxWGIdVhluWxRyogCAQk408/i+Kq5848=;
	b=ZClL2hr3Dg3hs8LMrVeGHek7XMVSR8l5akYE/z6kzpViJClFnxRnthkrvGEyVkIaam4MdE
	gjl/LMPFlFTxoGVL4Q5Qbduo/4biWWJFaWPvrTCk388H1kqFFEgPxJBhp0FbuiIVvmooiU
	RiUa2z7MjxMOd1aRj6hzrHplksFFCmw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-Z6d3-rsPMmqEEZ6z9RTFzA-1; Mon,
 27 Apr 2026 11:48:02 -0400
X-MC-Unique: Z6d3-rsPMmqEEZ6z9RTFzA-1
X-Mimecast-MFC-AGG-ID: Z6d3-rsPMmqEEZ6z9RTFzA_1777304880
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4870419560BB;
	Mon, 27 Apr 2026 15:48:00 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 078451800348;
	Mon, 27 Apr 2026 15:47:56 +0000 (UTC)
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
Subject: [PATCH v4 16/22] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
Date: Mon, 27 Apr 2026 16:46:31 +0100
Message-ID: <20260427154639.180684-17-dhowells@redhat.com>
In-Reply-To: <20260427154639.180684-1-dhowells@redhat.com>
References: <20260427154639.180684-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
index 71ab81b3f609..ec576d840594 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -675,7 +675,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 		ret = PTR_ERR(rreq);
 		goto error;
 	}
-	rreq->no_unlock_folio	= folio->index;
+	rreq->no_unlock_folio	= folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 
 	ret = netfs_begin_cache_read(rreq, ctx);
@@ -741,7 +741,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 		goto error;
 	}
 
-	rreq->no_unlock_folio = folio->index;
+	rreq->no_unlock_folio = folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 	ret = netfs_begin_cache_read(rreq, ctx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index f6b87a22c290..5847796b54ec 100644
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
index 6e5e0da88290..92ed17a83c3d 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -290,7 +290,7 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 			struct folio *folio = folioq_folio(p, slot);
 
 			if (folio && !folioq_is_marked2(p, slot)) {
-				if (folio->index == rreq->no_unlock_folio &&
+				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
 					_debug("no unlock");
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 59f35d2eeb2e..eaf75543b64c 100644
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

