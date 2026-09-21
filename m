Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758654B7A5C;
	Mon, 21 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005813; cv=none; b=dUo3ai+6HhdeH6nC50Jk3aohhBZQ4PBoeVIGxgFGvBBhebfie/szbaT6v/NUNNTi4LtGqoDGSlXPh+q9c4EgvtjDK97etG8unOGXE4g5C4xwcRH1x0mk/UWXDTlhu97zH8ZrrmoOUnWEmsNtiWSS14RmSVBmdbKwjbFNuvpj8Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005813; c=relaxed/simple;
	bh=tZCiSXccff9yVSXUgBPchL5CNH0LDHPUvqZEacBMYJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Q8CsI7l3pLwZwZTBaUf57hnE3bPJMAKbbPCfqwMHSS21io5EbSGtJ1XM/dfMLJgIYMEeTc7YXRJbWTPxPi31hsIcSkAQ7g3mQI1Ufkl0EKEjP8rISYqabH1YHSm2SRRdhVaFwCBPo/PFRQrzffQzRl2x4SeDH98X/+K8fGQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hk2UKBF/; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hk2UKBF/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=9LIEc5LhQIKxXcjbkcMEXr9BWvYzk7IN1k8L5D+GvgE=; b=hk2UKBF/uMkVcqMB83AMMfW3ya
	SpuiCWmJqYZSZGF5CNE6iTKER4vQw1ljijYj/9HthpjsjLLMGpTGXGowp1J32HCJLnwD9rKE1sogc
	iSSwUBldId7Kcz3Sv4lPaGk7lMV9/S+SPxR0JN1RVdHL2PlQ8xvfE9cyeGeTc8UOXkSmaVws0SSS8
	JtgHrAz6wn9RAb8mJYIPU3cMjl/JXKsUIbQCRJDqG9wHb+ETIPkl7V+HDz1NNwouG8ZfWtRWOW4yp
	7UG1BlwVAtrjghhw1U1L1DlRjMQkij2aIF77WQXpzaPiiay0wCQw9pivQ/wYRBdO2szslGJI/1+4y
	OLqN5hVg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8gHG-00000001wC8-3evF;
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
Subject: [PATCH 2/5] smb: client: discard post-EOF pagecache when extending a file via truncate
Date: Mon, 21 Sep 2026 12:49:54 -0300
Message-ID: <20260921154957.903891-2-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154957.903891-1-pc@manguebit.org>
References: <20260921154957.903891-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_setsize() relied on pagecache_isize_extended() to zero the tail of
the folio straddling the old EOF, but that helper is a no-op on CIFS
(i_blkbits is 14), so data dirtied past EOF through an mmap survived and
became visible once the file was extended.

Drop that call and lower the truncate_pagecache() boundary to the smaller
of the old and new sizes, which is block-size independent and reliably
discards the pagecache beyond the old EOF.

Fixes: c510edb9734a ("cifs: call pagecache_isize_extended() in cifs_setsize() when extending")
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
 fs/smb/client/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1fe0ef0a95db..d79a9d80ef34 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3071,9 +3071,13 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (offset > old_size)
-		pagecache_isize_extended(inode, old_size, offset);
-	truncate_pagecache(inode, offset);
+	/*
+	 * Drop the pagecache beyond the smaller of the old and new size so that
+	 * data written past the old EOF through an mmap is not exposed once the
+	 * file is extended.  pagecache_isize_extended() can't be used here as
+	 * it is a no-op when the block size is >= PAGE_SIZE, as on CIFS.
+	 */
+	truncate_pagecache(inode, min(offset, old_size));
 	netfs_wait_for_outstanding_io(inode);
 }
 
-- 
2.55.0

