Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D93DA5A0
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304910; cv=none; b=OLE9jXybmwx5rQ4XK0FRiYV5QB7Cv7PduPnH7mPy18qpAmbHoVIMKpFbT+NRZYpmhU1LxDJ615DMwm1JhDnZpEWS9jEx65GCa/4Emv+od0/PvqSd5pPc+TutDQtCpJCllbnqkRJH5lu7JdogaYXvNWMXlRUTpRxnKji9I4oghyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304910; c=relaxed/simple;
	bh=c5oDArXQJh7y60M1cLms/vcgi7TX/3O0SYtvfxSNmhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB6F+Yxm+4mZswlwiEZEeUD99fCGLwefzPTTR2H3yloswGMtN4p7YymVVEGP1bOvTL266eFNId7JKWKnLCHQ/ULYco0pKx42pKVcv1Tm+olB5lbvnnGGv0mZ3cC96fpCUTxA1Zee2G8UDIgi6aBx9Bbwy2cZw9unRzqR44JG5vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgxWJDTP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgxWJDTP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QS/xrleH5AOpAKSiASxQWMXbrc7cAq+mCszoPIawfWE=;
	b=bgxWJDTPMESklPqNtXQBQ1JsbTgM9n8EudZXAi4+4FgmOdbTz/AllzeMO9hbe3HIQoj6uX
	kIoVxc2Ntaxq5MKDQEvL2N+zDX5Y8EoL7g0YhcekSOrks0SKbBcDHKasT0RI6e7ExDqOHE
	lJGQKWZ62bnbJ624I6DUx5iXwiIhntg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-BivbckB5P8qzrdjjQiZmnA-1; Mon,
 27 Apr 2026 11:48:24 -0400
X-MC-Unique: BivbckB5P8qzrdjjQiZmnA-1
X-Mimecast-MFC-AGG-ID: BivbckB5P8qzrdjjQiZmnA_1777304903
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A28F19560AF;
	Mon, 27 Apr 2026 15:48:23 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6ADFB1800347;
	Mon, 27 Apr 2026 15:48:20 +0000 (UTC)
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
Subject: [PATCH v4 21/22] netfs, afs: Fix write skipping in dir/link writepages
Date: Mon, 27 Apr 2026 16:46:36 +0100
Message-ID: <20260427154639.180684-22-dhowells@redhat.com>
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

Fix netfs_write_single() and afs_single_writepages() to better handle a
write that would be skipped due to lock contention and WB_SYNC_NONE by
returning 1 from netfs_write_single() if it skipped and making
afs_single_writepages() skip also.

This is really only theoretical for directories in netfs_write_single() as
the only path to that is through afs_single_writepages() that takes the
->validate_lock around it, thereby serialising it.

Fixes: 6dd80936618c ("afs: Use netfslib for directories")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/dir.c           | 8 +++++++-
 fs/netfs/write_issue.c | 5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index aaaa55878ffd..3379d01c72fb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -2206,7 +2206,11 @@ int afs_single_writepages(struct address_space *mapping,
 	/* Need to lock to prevent the folio queue and folios from being thrown
 	 * away.
 	 */
-	down_read(&dvnode->validate_lock);
+	if (!down_read_trylock(&dvnode->validate_lock)) {
+		if (wbc->sync_mode == WB_SYNC_NONE)
+			return 0;
+		down_read(&dvnode->validate_lock);
+	}
 
 	if (is_dir ?
 	    test_bit(AFS_VNODE_DIR_VALID, &dvnode->flags) :
@@ -2214,6 +2218,8 @@ int afs_single_writepages(struct address_space *mapping,
 		iov_iter_folio_queue(&iter, ITER_SOURCE, dvnode->directory, 0, 0,
 				     i_size_read(&dvnode->netfs.inode));
 		ret = netfs_writeback_single(mapping, wbc, &iter);
+		if (ret == 1)
+			ret = 0; /* Skipped write due to lock conflict. */
 	}
 
 	up_read(&dvnode->validate_lock);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index b0e9690bb90c..60525cf6e679 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -819,6 +819,9 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
  *
  * Write a monolithic, non-pagecache object back to the server and/or
  * the cache.
+ *
+ * Return: 0 if successful; 1 if skipped due to lock conflict and WB_SYNC_NONE;
+ * or a negative error code.
  */
 int netfs_writeback_single(struct address_space *mapping,
 			   struct writeback_control *wbc,
@@ -836,7 +839,7 @@ int netfs_writeback_single(struct address_space *mapping,
 	if (!mutex_trylock(&ictx->wb_lock)) {
 		if (wbc->sync_mode == WB_SYNC_NONE) {
 			netfs_stat(&netfs_n_wb_lock_skip);
-			return 0;
+			return 1;
 		}
 		netfs_stat(&netfs_n_wb_lock_wait);
 		mutex_lock(&ictx->wb_lock);

