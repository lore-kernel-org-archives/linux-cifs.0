Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AD47D95A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382361; cv=none; b=ncxYcoica3BXCnnALTYsr665p4h4enMPWsvfdzP4A0bc9BV5JAb59/oMi1RrSNLQLSBiN9T8zY1GSDObFaGcVdRpYvRU6P6Y8ZRf6N25OaFAPcIBhva7ZN3f6dduzgNvdqvdCNVf6D1sywGWCwey8Xokqi96rxi2HsxHI1LLEUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382361; c=relaxed/simple;
	bh=fxR0HRvSv22xXvXZ87M+p66ej2r+Sv2DAKvy6zA3uPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVsMsFswJqopM6+BxgOizOs2tiBwif45nMYw2H29Dcnzf3S6B9hP9E2KOAbqz0dJWZ2OdfWaOBMWnXoSgXxtZw/b7/xYUC1GjuuJub+AaaYEOKd5Kk+aTTaEhktalkSJmitEjS8oMijOm6MQsttxkxJxIJZJeRzNOs8UobwkgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNppWkId; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNppWkId"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VAlXvNFC3a/D86PNh8eSdyFG14ll2LJIPxlUeY75MuY=;
	b=eNppWkIdH+qdCD9GsTMdyw9prOHSiR5BwGqw1cBq3goS+MXIVJ+MtWveFMkhWO9VUsydJy
	ZKgtGbi6bj49XyGY36Ye3Xx7+P3TenbwhzvwTks8TgLX2Uj4INdQkfdKUQzOu5Q5JxdUKm
	DieShET+D3wYxMLO7F2vDfigKDzFVRY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-DFDOW-0ZOJKBfmUktfd99Q-1; Tue,
 28 Apr 2026 09:19:13 -0400
X-MC-Unique: DFDOW-0ZOJKBfmUktfd99Q-1
X-Mimecast-MFC-AGG-ID: DFDOW-0ZOJKBfmUktfd99Q_1777382351
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF94C18AB432;
	Tue, 28 Apr 2026 13:18:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B34761800446;
	Tue, 28 Apr 2026 13:18:48 +0000 (UTC)
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
Subject: [PATCH v5 10/24] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
Date: Tue, 28 Apr 2026 14:17:40 +0100
Message-ID: <20260428131756.922303-11-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In netfs_extract_user_iter(), if it's given a zero-length iterator, it will
fall through the loop without setting ret, and so the error handling
behaviour will be undefined, depending on whether ret happens to be
negative.  The value of ret then propagates back up the callstack.

Fix this by presetting ret to 0.

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/iterator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 932f745fa3b5..8b70d9567739 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -43,7 +43,7 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
 	unsigned int max_pages;
 	unsigned int npages = 0;
 	unsigned int i;
-	ssize_t ret;
+	ssize_t ret = 0;
 	size_t count = orig_len, offset, len;
 	size_t bv_size, pg_size;
 

