Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728987;
	b=QTXwxM1a6wwj1GyubKXM5sKauOx88JOK/wpJtzuRDiyzTEo4FuoK5fZRkRpUA2BARVgL
	 84rdECeGOZ2EEL2dlqK1SEa7nZtUpqiKUywN8Kw/Q1hYNXSD1EiEzniB1BLT/uHodzMRx
	 1r1h+9nvnxuwqYn/V1NoxckR53lXCQ1P4GtNRUZjVkCzZzUjOKYgleXHlwnyEPF3pkrYs
	 2Ocnr44DY0fFhfmyxItu5B/o42uLmUFmzuxm+t0e41kFqZWjUezqUWQSPcqo6IlRsvwIl
	 LVdbj7uOcF9YZTtCC/xXY/bqFj0FFdjNhKOFNw4m6GAQ6DXaISmbsdcuSlFt4O+vRGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728987;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4f85V0aQrpRfdf6LMEERAWjiP2DLl6H3RfYT4M5DLpo=;
	b=ziXEWUEk0Q9AOvawvrATHD0qX1vVgCgDQujSK3KWGarDoexGihQ4W5AHCCDPgFTtQi2K
	 Qf1U47UyK5GEN14Pv5SP6kIyAV+cby3xxP/NWF+feV4Vsbv3fiMjxdQd9uuw8LPcMJM1G
	 LMAP6g3c8L6SnKWxDMoSdLM8v2RemKT3595dNyoajrrG05ynF6vUSasqIzig+LVEYo9lu
	 ElrrwTQAZPbM2X4SbvD+TxHFjqwgpnTFqSXr+hNSYHnVmGETCTMbmoCjkgFY8413KbU8W
	 fkv22TKqA5eOPDpmg7yLmIk9feiaQkIf5SMcrOYo+WdGypO4kOBzxhGbqBJEjMcnBmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LBgg96ll;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFA7606A32F;
	Tue,  3 Nov 2026 18:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CFA7606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LBgg96ll
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=4f85V0aQrpRfdf6LMEERAWjiP2DLl6H3RfYT4M5DLpo=; b=LBgg96llYX/6WHicasqGq9V/+N
	SzA8HQIduP1TJXWNZA/yeq1xFvISOM1geYuQDShrOpJw+eFsNqi/0D+8S3+Ds4u0gXVvF/uG9cZcD
	jpx6jGmtOnS8BGOfw0IkQqqiw1jqkNmmQjAIQnblDKFWF3PqTflbr9hbwu5DGNsr8lJnEeVgTDIFw
	pfXtAqStjlJjzA9I8NTX0jMQRFADOVpmek4REqkodgxYIOMvnXZAtepilRiBYgEF7RJ2yuX/z6iZ0
	wS2mP4XaG2sgoVchHverxdGCdX4dffQEJ/brGS9mzsBAHwffW4nSsn0zoU5PGiUfYU3XEs2QHK7oA
	KyhhMh1g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqX-00000000iuk-0sqE;
	Tue, 03 Nov 2026 15:02:58 -0300
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
Subject: [PATCH v2 07/16] smb: client: don't block dying tasks waiting for writeback on close
Date: Tue,  3 Nov 2026 15:02:46 -0300
Message-ID: <20261103180255.1482516-8-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
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

cifs_flush() waits uninterruptibly for the writeback it starts.  A task
that gets killed while closing a file on a hard mount with an
unresponsive server is stuck in D state until the server comes back.  It
also consumes any writeback error for a caller that is about to exit,
hiding it from everyone else.

Wait killably instead.  If the closer gets killed, stop waiting and leave
the error bits in the mapping for others to see; writeback already in
flight completes on its own.

This is also needed before letting dying tasks issue their writes from a
worker, which would otherwise make them wait for every one of them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 6744b3e2b2cc..6a1711bf89d4 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3035,17 +3035,43 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return rc;
 }
 
+static int cifs_wait_writeback_killable(struct address_space *mapping)
+{
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	int rc = 0;
+
+	folio_batch_init(&fbatch);
+	while (!rc &&
+	       filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
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
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
  */
 int cifs_flush(struct file *file, fl_owner_t id)
 {
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file_inode(file);
-	int rc = 0;
+	int rc = 0, rc2;
 
-	if (file->f_mode & FMODE_WRITE)
-		rc = filemap_write_and_wait(inode->i_mapping);
+	if (file->f_mode & FMODE_WRITE) {
+		rc = filemap_fdatawrite(mapping);
+		if (cifs_wait_writeback_killable(mapping))
+			return 0;
+		rc2 = filemap_check_errors(mapping);
+		if (!rc)
+			rc = rc2;
+	}
 
 	cifs_dbg(FYI, "Flush inode %p file %p rc %d\n", inode, file, rc);
 	if (rc) {
-- 
2.56.0

