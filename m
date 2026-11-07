Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=Qw07r+y02/MxfFxg94C/d2zyfVXmzf758cVzsATMIhiqAsH/MCM5PKZnX9bjeJjtmOZF
	 Ib7H2vdYJYGsx9u46i9zFIVvRVaBzipBp3yuUOhsHutoGMEQWoPeIMMShADcE235J/ynR
	 peo9WziQUdhz77LaLhTEci2TH31o4z9bF1Ng9UijJjbigIN6DwsN6iU9g7RDyf4JQGK4h
	 f1zSohDLj09CDtdPxUhYK+MlusBGNBhZT2NqWwArOn9Pp8CJ1+cdixT0MnOnuuEF/c9vN
	 rZIyG513WnDfzpzOK7RTiNxoiB4SyeI2GTJ+kW/EI7tunS5vQfLP5MwlALnkCd2IXbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=;
	b=lgVBWH1XuuTpPv17DHlMANre5c2J3RVsbJQHDvrWqYXfuZd72SqqdggtpZdLIltv4gIM
	 +oBAgq1rrGrR80Qcqf3aZJpSv1cwLu+KBFmdh6XoqLIm4YS/ivv6RCrft+yBrCyNy1XV0
	 Jk0GNKMITzyaUbGWq0iznJhHDREtlMJJP25jSMgP8a+5I5JblYwRPiQ3OHXJlVz3g5Ejo
	 IPsE1GBD+b3t1emsMo4aHPX/qtr8jRqMJB8yB8n0qTfvxVa+Nt3/2Idz3CQINDE9erzrC
	 eU6c7mEYrlFS0jCu5+yoU5XXJFlhCp3brHb9GWz+7XQro5ErEh6JksFj8FijoM40r7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=xAI1YZc+;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51029606D804;
	Sat,  7 Nov 2026 04:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51029606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=xAI1YZc+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Ou/xKQ4DknQm01m4CCWFME78lWod5GyjBbGuJ5Btxkg=; b=xAI1YZc+3PBAiJnCAi+S06+Ui+
	jhyrqsPunwnegYgmh72rr0nGR0dymaq3IIS4HMXKinL5ZOQjdkDu0tPrtNfPTUT4k6U+pfdhT7ray
	9IqCYmhMZCvPrtOABaYsDBKhcIIZ8WoY/N2mVwyrQnC13OARGYFwwKg+FLB6nfyiTtLZXJWlWUAf/
	4UUbcyqX/X6NGdT+aCqV2DxLxhIeu3YJ197ezQh/3Lj8hOdXWfT30mnGTE62Hwf6bt/UO759sDP9F
	XEz81F0IMhV8DFLNlDOQ9bSkiUKBmBC3WDGkA7u5lmMWriNsScwEmcJ+lR6T6sStS+kz9rXXozBEG
	dqh7i7/g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkO-000000015Nc-2ARf;
	Sat, 07 Nov 2026 01:09:45 -0300
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
Subject: [PATCH v8 13/19] smb: client: don't block dying tasks waiting for writeback on fsync
Date: Sat,  7 Nov 2026 01:09:34 -0300
Message-ID: <20261107040940.2692656-14-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
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

