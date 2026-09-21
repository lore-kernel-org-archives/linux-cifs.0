Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB23F39D1;
	Mon, 21 Sep 2026 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032083; cv=none; b=GiGKG/yyK7O2+yRjlyAGAAfqRjoM1h6nEdbAWMD85PE/7Xw/yGKAWNsOzakhVf1VpeqGGSuxMBw+pW1Wxnqv7DG7c4CfiXs83P+Sfr0TdCiowduEP/aaETuoCUMdmXxzIJjpIDR9acku5fRhMi/xatGQfuE4nSYSmnR7R443p0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032083; c=relaxed/simple;
	bh=PRbAzBr8GDExZ/uK3wzEWr92TsZMQPffoP2R79OrMpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9t03UDI7Tz7yRhuOM+b3SPKPlom9NVFDiUcoAjnJWqWbUT2P9Lz4BtDm2Liz41tJEnmN5FSwjsoojLpVvxBRHE6jiDLkk+CbguFw64nG9B6HT+vj7qu27gKp8e+77iBW+9S3ULc6oBMajrsZnffQF00dM3EFPr2RbhC1a7FgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=mgyOtoN/; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="mgyOtoN/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=qQ/AAEyMjOzO/VHuplu/nzyZcEXtt7b889yubhsKacA=; b=mgyOtoN/Rqq/jdm7TUBGxkiMgo
	h8N/BF+mgsTavZzxj9o0dLlmF0iqoCI4eBjW9mFKSdgAHZo8mlrcdA7wZDiLNNgDbT5tGnnHSzGET
	hc7/ZLrx99kNTHUDDoNFSV7HETzK82WtbIJhriBEI5+8WY4RsCp8C+4vddiWF6BMEu6rw/6p+MvNp
	OKzkHpcrva2BERfSABTMbgV5nL2sUwAV9ZMTmvpjnKomhb7MWUYT3gdFQ6BfgfO6BBrB6J0yV4Tbg
	fdCqKy9n+DGGhtliCTuBwgFa23qL6+GEaFrlAjJVbhZDKdTfc5InU8iUIgSxRmL7bUu6V8J2UwLIC
	o6sOi1/Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8n77-00000001xp9-0FKQ;
	Mon, 21 Sep 2026 20:07:57 -0300
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
Subject: [PATCH v2 3/5] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Mon, 21 Sep 2026 20:07:53 -0300
Message-ID: <20260921230755.1133425-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921230755.1133425-1-pc@manguebit.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
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
 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3464470d3297..7282ed916470 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3558,8 +3558,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
-- 
2.55.0

