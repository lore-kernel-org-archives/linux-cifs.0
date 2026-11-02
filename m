Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632538;
	b=5YOvil5s5jRYjP7SDHdLFt7M1kwXyjo/VPczmqvhtea+bTj2YSZDK+lt2gSzwlfZxqa4
	 b2clYKvELW3PjWxulQMjCnFl3+ZCkNTYT3LYsHcwSeihMEA5XrVQCSbzsB2l+u75HqaCb
	 11y3SmOn1et5A1o+f1Jg2ieeXslaaKyfRgfLMl+vwl60sQi4F+2C1JNIiG9C7vECAr+4S
	 S1X8wNMIIuci4ok+5paJfEYeaJDLgxcuRS3XG612wXC59tXyoOG6SJbC22uXxg5/05dN3
	 a0S3RfQY+4W/1SeOpKW0bxD/NtlV5dBxvShuv2O6eTgUyWU7CK19gTVx8VTxKXoJ8Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632538;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SbZuvZpSDfBvx6nBMg8Lenn64Rk64WDX0s+Xf4HrX4A=;
	b=yQhYe0yVOo/jD589YTRj2g/N4Frid12Zz+np8q3qrxSK5Fdv4xoZxpHBQ42iTQ7bCLp/
	 GeIWW/yZIV/icQx2nkP2bPAdbhJ76gEUvINPKOa0i7u5kyfq1hmKbxyEzlGFFN6IvFEGQ
	 QbexugLrxHj4mW3Lp5tZuiGLh8COCvNxwP1w6WqhhrFpxtUAG9FJHr6TK7/w5wF39sYiD
	 hJo+NYPva9khyKbX7IJtT9HCqFAPVPJgWwNLAL0hboeRJHn0m46s4SxFT620iWix0BHL6
	 zcbS5JadQ1jqGKOLV0FOIqjL2mWHrVlCNMHnAOIBWN8lGcwftpI5ufkXGZYK+VVr1sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=JyDPWnl5;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A36607B784;
	Mon,  2 Nov 2026 15:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49A36607B784
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=JyDPWnl5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=SbZuvZpSDfBvx6nBMg8Lenn64Rk64WDX0s+Xf4HrX4A=; b=JyDPWnl5YPBWfJYB7XIa916oBE
	CgNekm5qIFajn0+fBRA4MoCsrHYgth01K2a8KaVfjUW9aFiDU5g7XJXrl8onQkl79glwchgxkL7JF
	+mvcbwujMhLzRzDrFG3wk4z57ETvqvcY/QPbmBqEWsfj6GD0xWDtWUF+73kvE8L+f1gsBs0rtiy52
	f6x+rv76AQGgY+c+zANg17Vgcnofn/UyTaOskeaF8EdT5Xg10JQ8lJRVmLcXHqRIbbm5FCkHNcxqz
	HIYN1vIxhSl65AFmsfUHU/QEtHVi8IBkBlEMLGl3O3Ee4Jx68sUSuo1y7w0HqX3yQFrNewegPuTOT
	9fMVN73g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtku-00000000aSi-3eaq;
	Mon, 02 Nov 2026 12:15:30 -0300
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
Subject: [PATCH 12/15] smb: client: don't block dying tasks waiting for writeback on fsync
Date: Mon,  2 Nov 2026 12:15:22 -0300
Message-ID: <20261102151525.925058-13-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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
index 7e45498a4057..f5deedb5902d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3013,6 +3013,45 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
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
@@ -3024,7 +3063,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	unsigned int xid;
 	int rc;
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(inode->i_ino, rc);
 		return rc;
@@ -3056,7 +3095,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(file_inode(file)->i_ino, rc);
 		return rc;
@@ -3091,25 +3130,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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
@@ -3122,7 +3142,7 @@ int cifs_flush(struct file *file, fl_owner_t id)
 
 	if (file->f_mode & FMODE_WRITE) {
 		rc = filemap_fdatawrite(mapping);
-		if (cifs_wait_writeback_killable(mapping))
+		if (cifs_wait_writeback_killable(mapping, 0, LLONG_MAX))
 			return 0;
 		rc2 = filemap_check_errors(mapping);
 		if (!rc)
-- 
2.56.0

