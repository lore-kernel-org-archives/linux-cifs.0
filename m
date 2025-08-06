Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C5C21C179
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512652; cv=none; b=HhkBVIHTb/ns+jArIOg+BygjAnD+fB9+e/Z3v133nV7TcO511rRwGHqzTJS1FLJpdIvhMS0WvQKa+FCn2QA7lYc/8qg3dfMHhPH/i7byZw04xMXDtf4xWSNzDfkp3DWF7Ls3B7r24sujbwEqT1dSoHo7a0Agsl0YfSO25/zKBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512652; c=relaxed/simple;
	bh=iwlGvKhOI+i6VMNnthS81ctLD77v4aMMHF6SciyVTrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo2eRMzaUeASUWGSPkQVW0Pwv6xulW0IUVSikY+ExgI3gC28Tkv7r8UOxGiyDqs7vVZeAIAESfHiwRoWikQgjj+qVZFpP9KiM43+QZ1BNkiEz8yv8Wz3W9TQAefhgNkmKJ9TGK8JYdH8YPIo5vGgpPCP83aTwurAaTfTU9c2Vqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ieFnWq7I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ieFnWq7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754512649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWtz3qSueBra8NkVdEcoiYIsFsfLvyAM7VI8XyjxQXc=;
	b=ieFnWq7ID5fTVIMHRrkbn5SeM6lsZ5jwKIzcVZ1oI3gnB+EXnRiHHibI5PtuRQUh9TrXdE
	i48NYvAvc7fsZ93josMTS8wYRlNyKzLLJmbcKQw+9YJXjYRVaHNB6M4G4ENMQ4w+LwFcdw
	9xsveb32WrHAZm4+mI2RAc8M3X4UNkM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-zdZ0tj3ZOWm2-1A-aEehfw-1; Wed,
 06 Aug 2025 16:37:24 -0400
X-MC-Unique: zdZ0tj3ZOWm2-1A-aEehfw-1
X-Mimecast-MFC-AGG-ID: zdZ0tj3ZOWm2-1A-aEehfw_1754512639
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F19E180034A;
	Wed,  6 Aug 2025 20:37:19 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A294D1800447;
	Wed,  6 Aug 2025 20:37:16 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/31] iov_iter: Move ITER_DISCARD and ITER_XARRAY iteration out-of-line
Date: Wed,  6 Aug 2025 21:36:22 +0100
Message-ID: <20250806203705.2560493-2-dhowells@redhat.com>
In-Reply-To: <20250806203705.2560493-1-dhowells@redhat.com>
References: <20250806203705.2560493-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Move ITER_DISCARD and ITER_XARRAY iteration out-of-line in preparation of
adding other iteration types which will also be out-of-line.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/iov_iter.h | 77 +++-----------------------------------
 lib/iov_iter.c           | 81 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 72 deletions(-)

diff --git a/include/linux/iov_iter.h b/include/linux/iov_iter.h
index c4aa58032faf..0c47933df517 100644
--- a/include/linux/iov_iter.h
+++ b/include/linux/iov_iter.h
@@ -17,6 +17,9 @@ typedef size_t (*iov_step_f)(void *iter_base, size_t progress, size_t len,
 typedef size_t (*iov_ustep_f)(void __user *iter_base, size_t progress, size_t len,
 			      void *priv, void *priv2);
 
+size_t __iterate_and_advance2(struct iov_iter *iter, size_t len, void *priv,
+			      void *priv2, iov_ustep_f ustep, iov_step_f step);
+
 /*
  * Handle ITER_UBUF.
  */
@@ -195,72 +198,6 @@ size_t iterate_folioq(struct iov_iter *iter, size_t len, void *priv, void *priv2
 	return progress;
 }
 
-/*
- * Handle ITER_XARRAY.
- */
-static __always_inline
-size_t iterate_xarray(struct iov_iter *iter, size_t len, void *priv, void *priv2,
-		      iov_step_f step)
-{
-	struct folio *folio;
-	size_t progress = 0;
-	loff_t start = iter->xarray_start + iter->iov_offset;
-	pgoff_t index = start / PAGE_SIZE;
-	XA_STATE(xas, iter->xarray, index);
-
-	rcu_read_lock();
-	xas_for_each(&xas, folio, ULONG_MAX) {
-		size_t remain, consumed, offset, part, flen;
-
-		if (xas_retry(&xas, folio))
-			continue;
-		if (WARN_ON(xa_is_value(folio)))
-			break;
-		if (WARN_ON(folio_test_hugetlb(folio)))
-			break;
-
-		offset = offset_in_folio(folio, start + progress);
-		flen = min(folio_size(folio) - offset, len);
-
-		while (flen) {
-			void *base = kmap_local_folio(folio, offset);
-
-			part = min_t(size_t, flen,
-				     PAGE_SIZE - offset_in_page(offset));
-			remain = step(base, progress, part, priv, priv2);
-			kunmap_local(base);
-
-			consumed = part - remain;
-			progress += consumed;
-			len -= consumed;
-
-			if (remain || len == 0)
-				goto out;
-			flen -= consumed;
-			offset += consumed;
-		}
-	}
-
-out:
-	rcu_read_unlock();
-	iter->iov_offset += progress;
-	iter->count -= progress;
-	return progress;
-}
-
-/*
- * Handle ITER_DISCARD.
- */
-static __always_inline
-size_t iterate_discard(struct iov_iter *iter, size_t len, void *priv, void *priv2,
-		      iov_step_f step)
-{
-	size_t progress = len;
-
-	iter->count -= progress;
-	return progress;
-}
-
 /**
  * iterate_and_advance2 - Iterate over an iterator
  * @iter: The iterator to iterate over.
@@ -306,9 +243,7 @@ size_t iterate_and_advance2(struct iov_iter *iter, size_t len, void *priv,
 		return iterate_kvec(iter, len, priv, priv2, step);
 	if (iov_iter_is_folioq(iter))
 		return iterate_folioq(iter, len, priv, priv2, step);
-	if (iov_iter_is_xarray(iter))
-		return iterate_xarray(iter, len, priv, priv2, step);
-	return iterate_discard(iter, len, priv, priv2, step);
+	return __iterate_and_advance2(iter, len, priv, priv2, ustep, step);
 }
 
 /**
@@ -370,9 +305,7 @@ size_t iterate_and_advance_kernel(struct iov_iter *iter, size_t len, void *priv,
 		return iterate_kvec(iter, len, priv, priv2, step);
 	if (iov_iter_is_folioq(iter))
 		return iterate_folioq(iter, len, priv, priv2, step);
-	if (iov_iter_is_xarray(iter))
-		return iterate_xarray(iter, len, priv, priv2, step);
-	return iterate_discard(iter, len, priv, priv2, step);
+	return __iterate_and_advance2(iter, len, priv, priv2, NULL, step);
 }
 
 #endif /* _LINUX_IOV_ITER_H */
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f9193f952f49..53e58903fe75 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1928,3 +1928,84 @@ ssize_t iov_iter_extract_pages(struct iov_iter *i,
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(iov_iter_extract_pages);
+
+/*
+ * Handle ITER_XARRAY.
+ */
+static __always_inline
+size_t iterate_xarray(struct iov_iter *iter, size_t len, void *priv, void *priv2,
+		      iov_step_f step)
+{
+	struct folio *folio;
+	size_t progress = 0;
+	loff_t start = iter->xarray_start + iter->iov_offset;
+	pgoff_t index = start / PAGE_SIZE;
+	XA_STATE(xas, iter->xarray, index);
+
+	rcu_read_lock();
+	xas_for_each(&xas, folio, ULONG_MAX) {
+		size_t remain, consumed, offset, part, flen;
+
+		if (xas_retry(&xas, folio))
+			continue;
+		if (WARN_ON(xa_is_value(folio)))
+			break;
+		if (WARN_ON(folio_test_hugetlb(folio)))
+			break;
+
+		offset = offset_in_folio(folio, start + progress);
+		flen = min(folio_size(folio) - offset, len);
+
+		while (flen) {
+			void *base = kmap_local_folio(folio, offset);
+
+			part = min_t(size_t, flen,
+				     PAGE_SIZE - offset_in_page(offset));
+			remain = step(base, progress, part, priv, priv2);
+			kunmap_local(base);
+
+			consumed = part - remain;
+			progress += consumed;
+			len -= consumed;
+
+			if (remain || len == 0)
+				goto out;
+			flen -= consumed;
+			offset += consumed;
+		}
+	}
+
+out:
+	rcu_read_unlock();
+	iter->iov_offset += progress;
+	iter->count -= progress;
+	return progress;
+}
+
+/*
+ * Handle ITER_DISCARD.
+ */
+static __always_inline
+size_t iterate_discard(struct iov_iter *iter, size_t len, void *priv, void *priv2,
+		      iov_step_f step)
+{
+	size_t progress = len;
+
+	iter->count -= progress;
+	return progress;
+}
+
+/*
+ * Out of line iteration for iterator types that don't need such fast handling.
+ */
+size_t __iterate_and_advance2(struct iov_iter *iter, size_t len, void *priv,
+			      void *priv2, iov_ustep_f ustep, iov_step_f step)
+{
+	if (iov_iter_is_discard(iter))
+		return iterate_discard(iter, len, priv, priv2, step);
+	if (iov_iter_is_xarray(iter))
+		return iterate_xarray(iter, len, priv, priv2, step);
+	WARN_ON(1);
+	return 0;
+}
+EXPORT_SYMBOL(__iterate_and_advance2);

