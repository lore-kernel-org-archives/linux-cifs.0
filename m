Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746826;
	b=wXx3QHs8/YVZeAE/6zsa2j9eVpEC4aOEA4TK1dek0R+U+sYaIW22JXIr4/K5bdnEbRRJ
	 RDMXapwo2SyWslGcDJigV9XTMei3y6ftimLNmk8xutoQLCyQkD+o49paaaAx+u6mJaS17
	 Ii8HJBQo1aXHZYvCtH0vgaL4WAtjSoMuHhLGRccfqmtyC97BM6VYfO0v1U/+PFU+5nWZ/
	 ONfTIruNlv087j0vahViwhdmDGPRwvDyZM4lRaiM0o/bw994Y6+GtovdiHWc6WuN5bhQR
	 mBN1kTkQR52KDaRLxq/qTjWy6arHdStXvpmBc+u2tyL70wBC8MNG16Xc4soypCv54vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746826;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IjjbBLRfxb/6VhbeuauPy+ODILnCduBQekZFtaj1jyg=;
	b=gdgQDnWnKS3lDYaT62Qb6NZj8KTGRXiIThEKEg++kqND1dUVtZtVWNdalxJEwLFkETgn
	 7Wf9LLuAN6qDhrf/tHiUYOqzzY3BQpnJ9jSJwfw+3ijJzgdt4r4Ue1zMaoqVAjMI4ik7d
	 1jFoIwLq1dkYRAWE9vU2fpU/BJSIZbU70fQH8aW9YSrZi+CiucoCkAVtsghBc30RMxLYf
	 4v24C5rtLVIWz1I0bWG6xK/hGlDK+mY5OSQzzILeFZmSgOOLyziyN+h59+6EkbQXSgcoY
	 njJMedEol7HPQ/ATs0TgTV563j04jJWciCK0Y/Z9Bq7UQiGWG74aHjIm48i1FqDvdHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="W/GIOesI";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5521606A335;
	Tue,  3 Nov 2026 23:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5521606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=W/GIOesI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=IjjbBLRfxb/6VhbeuauPy+ODILnCduBQekZFtaj1jyg=; b=W/GIOesI0a3Z9Hgfr+9H3TU3aX
	u1CfiK4njOXybQqslY9ZJrvocrOIo7wXixwOlf/N23Ge8Qmev7Iuufu2YaUYtr4ld/nVtN4Vd+fce
	MLJCG7LGfdubLgTgxjh8tQaJ7CaNsPx4sLafx6vgQzCfdBTQBpoyPsJD9Z1no/9nddF0SvmryUP97
	PqVtrTX4RLTa2gOdAf7SAXplVQxHpDlz5MTCIMhrScx02DsrJgfrNLSpTscyBNmvUSqmFu44bAPtZ
	L6CPtPO+WBWsQYqPfWqe3Gb8szOxFy39KoCkRNbXLWIVr0WKi7+JKjeg31MIAKFmDnejJII7vs2Zl
	Ygg799cg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUN-00000000kO8-0eOs;
	Tue, 03 Nov 2026 20:00:24 -0300
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
Subject: [PATCH v3 11/16] smb: client: don't block dying tasks waiting for writeback on fsync
Date: Tue,  3 Nov 2026 20:00:15 -0300
Message-ID: <20261103230020.1617748-12-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
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
index d6ed06dbe476..5d8b3f25ccf9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3022,6 +3022,45 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
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
@@ -3033,7 +3072,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	unsigned int xid;
 	int rc;
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(inode->i_ino, rc);
 		return rc;
@@ -3065,7 +3104,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file_inode(file);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
-	rc = file_write_and_wait_range(file, start, end);
+	rc = cifs_file_write_and_wait_killable(file, start, end);
 	if (rc) {
 		trace_cifs_fsync_err(file_inode(file)->i_ino, rc);
 		return rc;
@@ -3100,25 +3139,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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
@@ -3131,7 +3151,7 @@ int cifs_flush(struct file *file, fl_owner_t id)
 
 	if (file->f_mode & FMODE_WRITE) {
 		rc = filemap_fdatawrite(mapping);
-		if (cifs_wait_writeback_killable(mapping))
+		if (cifs_wait_writeback_killable(mapping, 0, LLONG_MAX))
 			return 0;
 		rc2 = filemap_check_errors(mapping);
 		if (!rc)
-- 
2.56.0

