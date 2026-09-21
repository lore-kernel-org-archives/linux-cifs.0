Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D994B486E;
	Mon, 21 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005814; cv=none; b=RVRT2hgdVTwq7543pCjDIfZRjzoMKG5ZY/GKAlb3UJDArK/MJiUJSVZWaRt7F34VXiW5/kAWr+vOTLh2556mUsfdC5/Z6vNElNaqTMO59BGJfVcJzGY8oHZQZPcJg1NAQRJseMlSRct3j/CblGJyCbIOcXvZSTv6iOWz/e1N2XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005814; c=relaxed/simple;
	bh=h/DQbfjTtfFTSbNwOwyU0D7XWZhOG5qEFV7cZ907rAs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TZFPcePAykKaxaVgs+DPF19PJzGSh9efIJrkJ7wpxDOlTuu4OygZpUzLkowxz/95IXmHrIdzYH8SR4+P2AMmvCu7iN2ASQW7JmSYrDXUjgwZFYGuq7nfZmXIqBI66pEMsIoho711gaYNstNDmP9YZLCKfRUcTqS8gZ3chaM3rS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=eXHU707t; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="eXHU707t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=suLhaDLFIjE//W0ohz+Wzhj3ikVrx3mM1jMVGoLq60A=; b=eXHU707t+ExtQlIS8Zt530VkA6
	v2DIBtrJQZVQE92jIxDE5CzbSUnKLA3cPudzH9Tki5gO3jJ1AkQuL/9SmzDqBclVZQzNRGWmlysIR
	0qeug//CU0+RicImiD05Ip697UNjR5ZJFX4BTKWFYwacwE5HRFXcyW85GQ0prX3WGlchGosOi3D54
	7Yc/m42E28z2UpLbwbBGkssNeSuzdeE48DaeSqgveoWt//blBDwC/n+8Bx6nbSJ3nWJJQ8n2uKQZk
	4Y0p/oxxB953N2bbvdEh7TccTU/fGg0na1SQTpDp7f+x12CT+2uVKmp0l7WOdeIfea4U6FspDAxgX
	DGUksyYQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8gHG-00000001wC1-2EM8;
	Mon, 21 Sep 2026 12:49:58 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/5] netfs: discard post-EOF pagecache when extending a file via write
Date: Mon, 21 Sep 2026 12:49:53 -0300
Message-ID: <20260921154957.903891-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix netfs to erase the contents of a hole created after the EOF by an
ordinary write if dirty data has been previously left there by writes
through an mmapped region.  Neither the buffered nor the
unbuffered/DIO write path drops that stale pagecache.

Discard it with truncate_pagecache() before an extending write, which
zeroes the folio straddling the EOF and drops the folios beyond it
while preserving the data below.

Fixes: 938e13a73b24 ("netfs: Implement buffered write API")
Fixes: 153a9961b551 ("netfs: Implement unbuffered/DIO write support")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/netfs/buffered_write.c | 4 ++++
 fs/netfs/direct_write.c   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 2cdb68e6b16f..62849fd44313 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -469,6 +469,7 @@ ssize_t netfs_buffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *fr
 					 struct netfs_group *netfs_group)
 {
 	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
 	ssize_t ret;
 
 	trace_netfs_write_iter(iocb, from);
@@ -481,6 +482,9 @@ ssize_t netfs_buffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *fr
 	if (ret)
 		return ret;
 
+	if (iocb->ki_pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
 	return netfs_perform_write(iocb, from, netfs_group);
 }
 EXPORT_SYMBOL(netfs_buffered_write_iter_locked);
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 2361277416c7..4268a4ee376a 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -359,6 +359,10 @@ ssize_t netfs_unbuffered_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_update_time(file);
 	if (ret < 0)
 		goto out;
+
+	if (iocb->ki_pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/* We could block if there are any pages in the range. */
 		ret = -EAGAIN;
-- 
2.55.0

