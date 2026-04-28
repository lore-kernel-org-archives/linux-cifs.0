Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5C47887B
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382400; cv=none; b=ab19HT3UcRuxawqttBH0PNjDPyC8rsg9LoZg6tlkDlA1ZOMB0um6vl+dbd68Qrvp1i2XbUirtgeCBIDmkaUmaCPbnucDsOO1s+dLH6VdypZjAKOCsoxELl8bLwIERpk2N4YDCzIiN3R6w38EZkIdKrat81QKbLo9nDpZ+0V6xfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382400; c=relaxed/simple;
	bh=hhlZHzVkZGgNw65TAqSXoZn8aY9+h0Opjd6qveHBrl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjBGg/tsLAgoBGrDqc8xm0IuS69edwNo9xpYtethys2RpOEagBVFqYESROXrwKerBgmh+0IIu+UOG+N5z3ENNvouxoMF1KuKIiQBRaSfWeqJQf6KVeziGW5RQYfGRGHuG5befoucmI4O4JyFlAScXmRpt9m00W97CjMQnFpFB2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YWOORkMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YWOORkMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mt629XDWKB+tZOOSAJE2LdFWKC9Q9poIqsffgDORXAw=;
	b=YWOORkMXqsilqZnHqdGg2q+ILzr+Iwgj1MB2TAPofeFtz95ifEviUNENy0vqMERRGME3ec
	dK2K7HwvDsoSGRuX3k4V2bMjcKYmL2AL1jWMe2S5TgIImry0TGmks+XxCEYTAwcmf5+xpk
	vdDGr5swZJqMiMQaAl2mOUXyC2RH7Qs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-3o6WZebRMVq1RarP7C2BZg-1; Tue,
 28 Apr 2026 09:19:54 -0400
X-MC-Unique: 3o6WZebRMVq1RarP7C2BZg-1
X-Mimecast-MFC-AGG-ID: 3o6WZebRMVq1RarP7C2BZg_1777382393
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03053195605B;
	Tue, 28 Apr 2026 13:19:53 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1473F180047F;
	Tue, 28 Apr 2026 13:19:49 +0000 (UTC)
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
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH v5 23/24] netfs, afs: Fix write skipping in dir/link writepages
Date: Tue, 28 Apr 2026 14:17:53 +0100
Message-ID: <20260428131756.922303-24-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_write_single() and afs_single_writepages() to better handle a
write that would be skipped due to lock contention and WB_SYNC_NONE by
returning 1 from netfs_write_single() if it skipped and making
afs_single_writepages() skip also.  If a skip occurs, the inode must be
re-marked as the VFS may have cleared the mark.

This is really only theoretical for directories in netfs_write_single() as
the only path to that is through afs_single_writepages() that takes the
->validate_lock around it, thereby serialising it.

Fixes: 6dd80936618c ("afs: Use netfslib for directories")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/dir.c           | 11 ++++++++++-
 fs/netfs/write_issue.c |  7 ++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index aaaa55878ffd..d1542a1a50bf 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -2206,7 +2206,14 @@ int afs_single_writepages(struct address_space *mapping,
 	/* Need to lock to prevent the folio queue and folios from being thrown
 	 * away.
 	 */
-	down_read(&dvnode->validate_lock);
+	if (!down_read_trylock(&dvnode->validate_lock)) {
+		if (wbc->sync_mode == WB_SYNC_NONE) {
+			/* The VFS will have undirtied the inode. */
+			netfs_single_mark_inode_dirty(&dvnode->netfs.inode);
+			return 0;
+		}
+		down_read(&dvnode->validate_lock);
+	}
 
 	if (is_dir ?
 	    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) :
@@ -2214,6 +2221,8 @@ int afs_single_writepages(struct address_space *mapping,
 		iov_iter_folio_queue(&iter, ITER_SOURCE, dvnode->directory, 0, 0,
 				     i_size_read(&dvnode->netfs.inode));
 		ret = netfs_writeback_single(mapping, wbc, &iter);
+		if (ret == 1)
+			ret = 0; /* Skipped write due to lock conflict. */
 	}
 
 	up_read(&dvnode->validate_lock);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 0b07ebecb157..a85ec300b79a 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -823,6 +823,9 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
  *
  * Write a monolithic, non-pagecache object back to the server and/or
  * the cache.
+ *
+ * Return: 0 if successful; 1 if skipped due to lock conflict and WB_SYNC_NONE;
+ * or a negative error code.
  */
 int netfs_writeback_single(struct address_space *mapping,
 			   struct writeback_control *wbc,
@@ -839,8 +842,10 @@ int netfs_writeback_single(struct address_space *mapping,
 
 	if (!mutex_trylock(&ictx->wb_lock)) {
 		if (wbc->sync_mode == WB_SYNC_NONE) {
+			/* The VFS will have undirtied the inode. */
+			netfs_single_mark_inode_dirty(&ictx->inode);
 			netfs_stat(&netfs_n_wb_lock_skip);
-			return 0;
+			return 1;
 		}
 		netfs_stat(&netfs_n_wb_lock_wait);
 		mutex_lock(&ictx->wb_lock);

