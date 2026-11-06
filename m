Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979439;
	b=ipj3RHYEvpQa0ra4rW2DBDKIFuBm7GL5m4LvYVP3k/FXCJl0DfJlVTiY2tY6qP2JkJba
	 XibV3AuhRARxJzgG38QXWeYN3EB80HidaS1+x1OJa3+Mx/NdUW0/k/WE6LZoFVOGQnmvK
	 Bu31UksHGrssVTwlCmrZcJGk1PkWJYvuNflNMM6dsLZs2uS+LYp6jU7ESXo6c8E2G+jfU
	 13XYki++5K4acwZuuWN05s4HKzTbbLypkT7fZS9jaZTgPLLqGKGemxFhreHUQDioKGzqs
	 mpC7R9OnVrLLPbjzuzreqAEoKrq9I/FSKq01mp74gwW1X6PKLpc3aGBgyO8haUPbXAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979439;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=;
	b=0yn84PGyrdTVY0dD9hVAu1a2CA7EYm+SZcpkVxMaLpGrKokEsUu6lYWMoRmuWXiYI08W
	 zqphq8nTQyuUVvziqN+gY3FeDXj/H3/vf7bDmIrldWxEN69+u/Szdimg7nbj6O/sQz9hI
	 jE0i1fCG9FshmQM/9ikzomVZsDJjPn/cbBhaJyOkt5b6TKj8gbPaUZCs8AcTfjQTI9x4U
	 CXQSWcTrDptBtsEIWsD4pDRuB5NFVKjQBa1JRI2teylaoRG/ThtWvrG6gahqIfKqW5hUL
	 S5fqqYW7/kK+20+Q1AnmFn4+CI/9tw3Pd5635daIZQwSP3u/A27M0YU4NCWOYCOwj3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kyh2zvRg;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C2606A32E;
	Fri,  6 Nov 2026 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C05C2606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kyh2zvRg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=; b=kyh2zvRgM3xp9Oki4nRZrOz3fy
	EBsqaCVaGxpYb+V8gKtlaw1Ba3TXdG8yffch/2Nn8PNCQxquLetSI4zpHpBnVkKaFt1vxBfLQkNrv
	+zowvrKYpGTxqv2h+ZAY2p6k986YoedD11d4X09rdBA0Vw0srSPnj1msqD1Ebf9SNsboBMgXedErs
	EUkLyXAydtPL+8v7zluB8KtNVQmB716U1SyKEHKqlfiDVeQZ5drw2GzrAqfqJhrPl+60BUjyETf7q
	nLQ/aa6AShi41V76OtiKF/FfFDBv4s/UqUo5e7OUG80dgbvbCevn6G4ywmZTff+2tJdU0HXYUJb4Y
	uzDhMrsw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPM0A-000000012aI-281U;
	Fri, 06 Nov 2026 12:37:15 -0300
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
Subject: [PATCH v6 12/18] smb: client: don't block dying tasks waiting for writeback on fsync
Date: Fri,  6 Nov 2026 12:37:04 -0300
Message-ID: <20261106153710.2498773-13-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153710.2498773-1-pc@manguebit.org>
References: <20261106153710.2498773-1-pc@manguebit.org>
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

