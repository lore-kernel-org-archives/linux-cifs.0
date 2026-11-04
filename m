Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827702;
	b=n/8wNQJyANWYFJtvYK1CSO/0gBUnehXUXIatleWfChyd3Jcqih1o6B8Qghh/B3Px4tKa
	 lKbhnivTKRTgr+iJUAQmovdhNMCepuNw6yMVx4Kf+Tsp5gBywLoFuAdD+LSZzUEQGsrc+
	 ZEeWMKIGYcrbW9SUW+sCU+N4dBd03vBs4VlzsguI53MBIf0XR32blRfmOE7pLs9pMx9Ka
	 C3OtctTsdHzofwBgGDGWWImOwXtaYZ5apVytj0Dx1i/jAQEAVgrgrELlaFpv+weQXwQ53
	 aylJ1/cXMYy2M+a3csUDyky6L2szlku8MaKben2bkwIdj+nGbegqa7EmCofe/OKkByA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827702;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SeGUYU2j3Gwp0nKs6/+eaIpZ4Np7xEbON774wLqvFzY=;
	b=GqFHCz+yw+uzVe2t2adBa33rxlLmRc/bktdRsGZwg66lzzkYdD4/pK60FjZ6D6eV7IMi
	 t3awkCgXKNB/s2h2Z2zfeVXahRU2vX/ct2O4r1KcmXxw/q29BVOSinTxHRPoknG1V8rl/
	 BkMruRk96uRYMV1VNpgYuPMa3HVPij59k6IpHzOQvArsOSyenpUq7mwv16aDA1RVkGnsk
	 jBoG+wzy29QtopmtwBGWGfMA1gIK2IbjOIWg4DT7mfzPtYn086iszd4C7IcqNffleuj82
	 glTyxHhR6i+rPXjvwTNWRBYYJ81Xu6XGXGqzYAWGJefU0T6/U4UyBRvs0LI6JDpl1Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=CJOJSlXN;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E8606B2E4;
	Wed,  4 Nov 2026 21:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D6E8606B2E4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=CJOJSlXN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=SeGUYU2j3Gwp0nKs6/+eaIpZ4Np7xEbON774wLqvFzY=; b=CJOJSlXNi8/uH/T8pOlxV1jz3v
	fg0aT65fYSbEQQCevwcnGLOkGgwPzoKINxCIDnEzKIydsszOV3o4NSn1lriS44JjyRiEU9xkQBCrr
	ou1waR5N0F4ZSfk23uDCIwFb+g5SaYO7Qp4ygM6iTmP5nccGql9wX0sSx5ENn/ogPYz0dE3qljSpK
	6T0VpaiuKfTjykPHnchbNGlRyYRt38z1xaBzgDBN+PT1vLVaEuem+l2ccZpSdDp4xPZFwWYnY8UQv
	UinGIDD3Ztebr0hPRAo+FV9FYyR+IintskMiEAFXrZN/KD/W+eihtr4EGXE4VP8swl2LM0vcGD0z5
	HcHawMuw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWi-00000000rH5-0neX;
	Wed, 04 Nov 2026 18:28:13 -0300
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
Subject: [PATCH v4 07/17] smb: client: don't block dying tasks waiting for writeback on close
Date: Wed,  4 Nov 2026 18:28:00 -0300
Message-ID: <20261104212810.1935575-8-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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
index e79eacacf625..9bdcacbee8a8 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3039,17 +3039,43 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
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

