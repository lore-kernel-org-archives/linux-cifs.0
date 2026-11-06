Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=vWJZhCSPCtOgbnpVuNF7SK1+bQesMoPm1H9lrBNm7Y4jJc17qr1/0qs7O9zuGcOZFJE8
	 fuQxWisadGFdlwPv6BcymlAw6DNpLpkLkRRQwfmDyPrRj/YpXBFySi1GkP8HjVL2bdcxk
	 c4IJnnGpqU/8/GAoKgy/h4UI6OAPBxwyW++vZkyC0LGk2yhICH9igjSxzjR22aYd45z2n
	 5Ugbb756TUfrwQuHvO6zEcZTxqn9zGFx3ZgjBU8+iRyb8OtYN2pjc7Yhfy2L9fcdtrXyT
	 7pPjVRLJ+4PE+kkvmJkuroDS60nWgj1Exg7igMWFrFvzcjzstR7QR8YxGvdJVuBXiBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=;
	b=AZ8/Ne0BBX7GlKUNLDdS6l0P7TUcVbChHXii0x2TO6cLYDy6DZ7XJCZwg3j1qn7S/GaT
	 v2pyGoMLcfsrNrlmvqYYdhYdUBQECa1Px2lv5lhmU69xLofZbRvA5Y1QDaXM/J5aYiEIr
	 GvE3m0dT+0PDdagZSH2zRUh/UxBUvKHXXMntFx3IxLrrS0rQdhFJJMITBA0lRV9Pjw3dC
	 BLgS9DAxCeBgrzLQZjP4N4o4IynQh/RQWYVTUUbyWOcWSmriQJElpxRRpJKvBW3qqjWwv
	 Xv+wPWNDBhZfIJPnpogWhD1N6H8KnemyOxe2oI/JKfrK+T9+yhy+lUKGqo325Biozsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=QrBzNXsB;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EDD606A339;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76EDD606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=QrBzNXsB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=; b=QrBzNXsBm02Kz0EzL/t5RwMrVC
	QQhmIKARlxCdTb9NhiYNI5ZChHIgIoWhfvLUNOHNtA6WeCvXBrOG6hnw+VEOZ+aGakmAr0Xt3GtXj
	6Nsrc4EDk7HFEFIyzJi/nkl9FYXtbDRTeG016ID0QBAfWmHBS5KX2BDxLEaWrc04FsVI9lw4mF6vN
	UFBr3hWOhklsUXEJKdevPtiZESxE5lBvL22qj8E9QsBG/QRYwVfMYikBBrTy191GxM8b8ygPo47Ou
	3/hoevFBvvba0NQPTU0VYEMT9hK2MKo55MO6mkCFeis9chlw7IN6xTw3SvoCcy5kM/++IcfKJR0ZT
	KQyWfcnA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCZ-000000014Fw-1CgO;
	Fri, 06 Nov 2026 20:18:32 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 13/19] smb: client: don't block dying tasks waiting for writeback on fsync
Date: Fri,  6 Nov 2026 20:18:21 -0300
Message-ID: <20261106231827.2604956-14-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_fsync() and cifs_strict_fsync() wait uninterruptibly for writeback
through file_write_and_wait_range().  As with close, a task killed in
fsync(2) on a hard mount with an unresponsive server is stuck in D state
until the server comes back.

Wait killably instead, using the same helper as cifs_flush().  The
writeback keeps going and its errors stay in the mapping; only the dying
caller stops waiting for it.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 64 +++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index abbf6a1be9e2..0fc1f74b55b6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3026,6 +3026,45 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 	return -ENOENT;
 }
 
+static int cifs_wait_writeback_killable(struct address_space *mapping,
+					loff_t start, loff_t end)
+{
+	pgoff_t end_index = end >> PAGE_SHIFT;
+	pgoff_t index = start >> PAGE_SHIFT;
+	struct folio_batch fbatch;
+	int rc = 0;
+
+	folio_batch_init(&fbatch);
+	while (!rc &&
+	       filemap_get_folios_tag(mapping, &index, end_index,
+				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
+		for (unsigned int i = 0;
+		     !rc && i < folio_batch_count(&fbatch); i++)
+			rc = folio_wait_writeback_killable(fbatch.folios[i]);
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+	return rc;
+}
+
+static int cifs_file_write_and_wait_killable(struct file *file,
+					     loff_t start, loff_t end)
+{
+	struct address_space *mapping = file->f_mapping;
+	int rc, rc2;
+
+	if (end < start)
+		return 0;
+
+	rc = filemap_fdatawrite_range(mapping, start, end);
+	if (cifs_wait_writeback_killable(mapping, start, end))
+		return -EINTR;
+	rc2 = file_check_and_advance_wb_err(file);
+	if (!rc)
+		rc = rc2;
+	return rc;
+}
+
 /*
  * Flush data on a strict file.
  */
@@ -3037,7 +3076,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	unsigned int xid;
 	int rc;
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(inode->i_ino, rc);
 		return rc;
@@ -3069,7 +3108,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(file_inode(file)->i_ino, rc);
 		return rc;
@@ -3104,25 +3143,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return rc;
 }
 
-static int cifs_wait_writeback_killable(struct address_space *mapping)
-{
-	struct folio_batch fbatch;
-	pgoff_t index = 0;
-	int rc = 0;
-
-	folio_batch_init(&fbatch);
-	while (!rc &&
-	       filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
-				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
-		for (unsigned int i = 0;
-		     !rc && i < folio_batch_count(&fbatch); i++)
-			rc = folio_wait_writeback_killable(fbatch.folios[i]);
-		folio_batch_release(&fbatch);
-		cond_resched();
-	}
-	return rc;
-}
-
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
@@ -3135,7 +3155,7 @@ int cifs_flush(struct file *file, fl_owner_t id)
 
 	if (file->f_mode & FMODE_WRITE) {
 		rc = filemap_fdatawrite(mapping);
-		if (cifs_wait_writeback_killable(mapping))
+		if (cifs_wait_writeback_killable(mapping, 0, LLONG_MAX))
 			return 0;
 		rc2 = filemap_check_errors(mapping);
 		if (!rc)
-- 
2.56.0

