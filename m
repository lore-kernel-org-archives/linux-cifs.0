Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5613D9DA1
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304896; cv=none; b=suN6Ax2ug3oLduvixKDceHnmtP91JR8fKTsfZoS0J5ZrWA7dW7NlsqR/H7hPQ836e0ZaSxMe37yP8WoB0xEK4nELV+Om/Jsp7oQYT0kuxrk/DCZwFECwcfPjm/PoRrNpM9d4iG9okm+CzZu2ABTXKXVr6Rwb9JHPD5EkS9UTGRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304896; c=relaxed/simple;
	bh=NWuEILu4xE6q9Mk9vp9plJM/HCqF87+ioNPLfDaVBUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjh5cH7ASvg3WJZL9KZv1r0a/H36j9+yMe5nCctJKZPePCZNXhdd30qzALhu34IyrmdJHNu9zlCHAt1DUvMEtcJb/6kNneoi5wtkIjXV3s67hRRLaSl5pn4e+WqvL7q3GDdQByLD0HuPJwnhQQH9XK+Y02dracaogjT0ILoVPvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I/M8qV7a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/M8qV7a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vdxi9UOZOtHgo5imTm/mIQ6/cjgNJUqbuly6giNT79Q=;
	b=I/M8qV7aZE4W7Zkjm4w4gVrD126K5dxs/O3JljJXNjYt+HBAhKC4vgazY5agT/Tes1zj1G
	qNapZw3h+CLefBg45sqK7Kya3kmWQj7oQt5gTH194QWDPz+KmaCMEEQAyHjhagNwXGGK/h
	Y/zPDhUiuatnAoz/6SIoEZH7Cm8Ieg0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-YVQkWbXNNeipfCuB7hO6uw-1; Mon,
 27 Apr 2026 11:48:11 -0400
X-MC-Unique: YVQkWbXNNeipfCuB7hO6uw-1
X-Mimecast-MFC-AGG-ID: YVQkWbXNNeipfCuB7hO6uw_1777304889
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 807B71800473;
	Mon, 27 Apr 2026 15:48:09 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E57A19560AB;
	Mon, 27 Apr 2026 15:48:06 +0000 (UTC)
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
Subject: [PATCH v4 18/22] netfs: Fix partial invalidation of streaming-write folio
Date: Mon, 27 Apr 2026 16:46:33 +0100
Message-ID: <20260427154639.180684-19-dhowells@redhat.com>
In-Reply-To: <20260427154639.180684-1-dhowells@redhat.com>
References: <20260427154639.180684-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In netfs_invalidate_folio(), if the region of a partial invalidation
overlaps the front (but not all) of a dirty write cached in a streaming
write page (dirty, but not uptodate, with the dirty region tracked by a
netfs_folio struct), the function modifies the dirty region - but
incorrectly as it moves the region forward by setting the start to the
start, not the end, of the invalidation region.

Fix this by setting finfo->dirty_offset to the end of the invalidation
region (iend).

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 4e91a8d75bce..094d5e8aad1a 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -255,7 +255,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 				goto erase_completely;
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
-			finfo->dirty_offset = offset;
+			finfo->dirty_offset = iend;
 			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}

