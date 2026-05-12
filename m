Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4D43A2E16
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589346; cv=none; b=YimbJl19Xw2JQZaAjPvq10MLU7MXSv4k7VSME+ZgjttuTQ2XarcLyyn/LlvS91cbGkaqxJFzNUzENXJAxc5D1TJE3dqCZxwYKW97Xx0M9oOs5JThqn6cSLDrhfYdXB+HaYrB5UzqH1GCCumzRWW7RB0NOWRgOiVQD8DLRo64nus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589346; c=relaxed/simple;
	bh=rj2DI6YQj1WOpZcBEWurUKGYlDVO2t1wDhhzf23NyoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbHfxIvnchTzLlgJMrsPKj1OsRELBbFD+sx5aiB5VZWAVnfgbvTIQTCqaxVk0M8jFS11rFU9YEz+eNyyEOeP5i0eYQ2TXYEQNMJAL1o94iruM4Jppl+n+13tXBUckjPMvO3vaEYgOZ5A9wliAf42VrGpo4CQWDzWdRrK+I3dSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EA2dL8Vu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EA2dL8Vu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XwYo3BIaKuiKcA6D145NDy8jxIJhkEUgnVmrfuQ1EDA=;
	b=EA2dL8Vu/3/toXoaQb2RgIvaYw7grEfNbfK1fmd26wtN+UbsJ0KECivTUwvrYuMAgWtcan
	LGoQ1afu65DhGGjOMreHeGj7v9OEoxz2/pQHSxbQaonTCkYcxnlKA1CK6e+M44c5SbjRKu
	yNl7yDYwfl/hm7eppROE6roMPPWafXE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-uLVT08qzMQSQ9i0sTUn_Gg-1; Tue,
 12 May 2026 08:35:29 -0400
X-MC-Unique: uLVT08qzMQSQ9i0sTUn_Gg-1
X-Mimecast-MFC-AGG-ID: uLVT08qzMQSQ9i0sTUn_Gg_1778589328
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA9081800451;
	Tue, 12 May 2026 12:35:27 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E56781955D84;
	Tue, 12 May 2026 12:35:24 +0000 (UTC)
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
Subject: [PATCH v6 16/24] netfs: Fix write streaming disablement if fd open O_RDWR
Date: Tue, 12 May 2026 13:33:53 +0100
Message-ID: <20260512123404.719402-17-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In netfs_perform_write(), "write streaming" (the caching of dirty data in
dirty but !uptodate folios) is performed to avoid the need to read data
that is just going to get immediately overwritten.  However, this is/will
be disabled in three circumstances: if the fd is open O_RDWR, if fscache is
in use (as we need to round out the blocks for DIO) or if content
encryption is enabled (again for rounding out purposes).

The idea behind disabling it if the fd is open O_RDWR is that we'd need to
flush the write-streaming page before we could read the data, particularly
through mmap.  But netfs now fills in the gaps if ->read_folio() is called
on the page, so that is unnecessary.  Further, this doesn't actually work
if a separate fd is open for reading.

Fix this by removing the check for O_RDWR, thereby allowing streaming
writes even when we might read.

This caused a number of problems with the generic/522 xfstest, but those
are now fixed.

Fixes: c38f4e96e605 ("netfs: Provide func to copy data to pagecache for buffered write")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 991552724868..f79fb5996540 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -203,11 +203,11 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		/* Decide how we should modify a folio.  We might be attempting
-		 * to do write-streaming, in which case we don't want to a
-		 * local RMW cycle if we can avoid it.  If we're doing local
-		 * caching or content crypto, we award that priority over
-		 * avoiding RMW.  If the file is open readably, then we also
-		 * assume that we may want to read what we wrote.
+		 * to do write-streaming, as we don't want to a local RMW cycle
+		 * if we can avoid it.  If we're doing local caching or content
+		 * crypto, we award that priority over avoiding RMW.  If the
+		 * file is open readably, then we let ->read_folio() fill in
+		 * the gaps.
 		 */
 		finfo = netfs_folio_info(folio);
 		group = netfs_folio_group(folio);
@@ -283,12 +283,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		/* We don't want to do a streaming write on a file that loses
 		 * caching service temporarily because the backing store got
-		 * culled and we don't really want to get a streaming write on
-		 * a file that's open for reading as ->read_folio() then has to
-		 * be able to flush it.
+		 * culled.
 		 */
-		if ((file->f_mode & FMODE_READ) ||
-		    netfs_is_cache_enabled(ctx)) {
+		if (netfs_is_cache_enabled(ctx)) {
 			if (finfo) {
 				netfs_stat(&netfs_n_wh_wstream_conflict);
 				goto flush_content;

