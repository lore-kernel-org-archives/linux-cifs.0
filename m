Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14EA3C141F
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304873; cv=none; b=S8eMwl8cbg8AdR3u0MfeyufMXrzEOREajwfGzshWhya1dYzO2npuOiYdmbLT+jBidT2X8qcbt2oQ1vXJwxqSA4LY/2UIFoqY9yZnKqyoHRgihTK3TRfn3zmNolCSBq8YQLsuNZ62bwlSl5XAZBRyUWPqjwgH/KoNA9jy9uS71yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304873; c=relaxed/simple;
	bh=9e/Zee3jsbyQYvRQlmBnakDHnAEM9AymBLo2/24xEPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ft7WIh3DhJuv6xZP9py2qcg57wpU9cGbpljYfrZNjdrxkKJ1h/XKFBravzV0dihyL1Fv/ICI0oLR8d8Fdz8C9NY9ZjL6r/cGpyXWsoT3jrHZWjyHs+2uNspSg/ys63/CR07LTv4J2dOO0w2OHKNnG+nNP0MVvgyoWGmZz/hoSjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0jxmKVF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0jxmKVF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5h8/9IhmPxVMQiVFJHtf2MmfhLnv0hhxcR+5vk8qZ8=;
	b=W0jxmKVFRljHB/kTCH7IV3G00KMfS78SzM1hLRMsN2VStnF4E/gn4EUilg9TwDHvQ13+gr
	rNbafr/t4EMCJfC72xkqqyHXuJl+NKWSWtJU9X2fCWFOm3Nl7Kge2CFbBY7F9gmz3cczHw
	/+IQ1jW0PJURO6g1ShIS9sjQWh86KrA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-B1v2nlguOQezFfXh3XpowA-1; Mon,
 27 Apr 2026 11:47:47 -0400
X-MC-Unique: B1v2nlguOQezFfXh3XpowA-1
X-Mimecast-MFC-AGG-ID: B1v2nlguOQezFfXh3XpowA_1777304865
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BCF819560B0;
	Mon, 27 Apr 2026 15:47:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A02D1800348;
	Mon, 27 Apr 2026 15:47:42 +0000 (UTC)
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
Subject: [PATCH v4 13/22] netfs: Fix write streaming disablement if fd open O_RDWR
Date: Mon, 27 Apr 2026 16:46:28 +0100
Message-ID: <20260427154639.180684-14-dhowells@redhat.com>
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
 fs/netfs/buffered_write.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 25571a570ac9..b782cf83fb57 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
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

