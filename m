Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F33F40E8E1
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785157691; cv=none; b=I4aufmUPH2O2j/AP3YDDodb6A+2MUEuYu6GlemYn03axePht5gmcdKAbipIRSRoEd4cqC6rfNsaNlP0IuAzUv2k6uMVAbHovpWU2xiFfqBUfhDMoeyBoGu6TN8Ee+DoHUBlGq526GeMe5+ABqP04lkS+mwhW/84jq0caEkc5nsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785157691; c=relaxed/simple;
	bh=oAFLvzAvCvqH+74ACE1LGBYASqPJJ/gZkoEYbTMwexk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AphSTgc9TCJtsTuNJJaAUotKeF7YfUuwFHMbypehTiDud2uaHIMz2K5MHWkOZ1+gSQ5MKTC2fgpbW6MUOzv0qOyXqfkRxwR9kSTwm7xF8wYzpf/V454bHtEcjY+c7Ke9fpdNRBx/pm9lsRYxG2sz76N02g+SCC5NxE2bODZXTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVWmR2T/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVWmR2T/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785157689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8C6bJJEtQmiVwAw0nsngdl6zXvM4+8rNe514omrJIfM=;
	b=DVWmR2T/mOsozryxAxB5f8yxb8aaJjOHH7RRfhZor2FC2rQ7V3XRANbBcj9r70w/A0kKap
	Kxa3Y3j5tRXQZPakjdt5+jCXuyj0bcno56OMR4aT++fSMVC/94bd0JpsTsIZO8YE/4YWO6
	2Pw/HEu2v2XLNMCRUarWdAI278T4J6k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-l2c_1UEJPTyeecw3yJWSGw-1; Mon,
 27 Jul 2026 09:08:03 -0400
X-MC-Unique: l2c_1UEJPTyeecw3yJWSGw-1
X-Mimecast-MFC-AGG-ID: l2c_1UEJPTyeecw3yJWSGw_1785157682
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3F6F1955D7B;
	Mon, 27 Jul 2026 13:08:01 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0D78430010C8;
	Mon, 27 Jul 2026 13:07:57 +0000 (UTC)
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
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH 2/4] netfs: handle single writeback rolling buffer allocation failure
Date: Mon, 27 Jul 2026 14:07:13 +0100
Message-ID: <20260727130716.1099906-3-dhowells@redhat.com>
In-Reply-To: <20260727130716.1099906-1-dhowells@redhat.com>
References: <20260727130716.1099906-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Yichong Chen <chenyichong@uniontech.com>

netfs_write_folio_single() takes an extra folio reference before
appending the folio to the rolling buffer.

rolling_buffer_append() can fail if it cannot allocate another
folio_queue. Check the return value and drop the extra folio reference
before returning the error.

Fixes: 49866ce7ea8d ("netfs: Add support for caching single monolithic objects such as AFS dirs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index f2761c99795a..14efe4cb9393 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -720,6 +720,7 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 	size_t iter_off = 0;
 	size_t fsize = folio_size(folio), flen;
 	loff_t fpos = folio_pos(folio);
+	ssize_t ret;
 	bool to_eof = false;
 	bool no_debug = false;
 
@@ -748,7 +749,11 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 
 	/* Attach the folio to the rolling buffer. */
 	folio_get(folio);
-	rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	ret = rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	if (ret < 0) {
+		folio_put(folio);
+		return ret;
+	}
 
 	/* Move the submission point forward to allow for write-streaming data
 	 * not starting at the front of the page.  We don't do write-streaming

