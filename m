Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F2635C6AB;
	Wed, 30 Sep 2026 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790738912; cv=none; b=RQIcjyUbdboKjBXjdQiMmkEPiXRW46epCzDfZJ+OZ7FpDH17NF+/1JVa/h3qWAq+FlrCSWDOvD0nL6hDaaTK+aCoJFCPC530sqJYX//a7nn+U2em/1Plux6SjKfcPIR73sywh/TxmpWQCQEe9migjZyVMQ2Sw5EZOIY4vHIpK+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790738912; c=relaxed/simple;
	bh=ppalraxO26trslZIUDM35/foWuygljZZkPxf+ZVRZRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFZUo26oGovrd19sJ4cYsygZb0dJVc3xDgsHH1aTk6v4HyLUOl7hex000q0mMPz++eybVL7JHCkkYrhR+s/KVDF0pwcBb2yaQRCJqdH4brIQhzLlPcypPwWVcFqV1dKR+oeqPVXn2Wp0BChXWqAS0g+aZvsEQORM5grv0oT+xlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=gVaWxqps; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="gVaWxqps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=kmshqEMkI/3l8T1I8iyPPxLD8jzpS/KS0BMjuQQLDfk=; b=gVaWxqps36hNVb/SqVS9+Dcn9s
	XCGCMGXY2wIx343SJ9ON/sOvIGyueg7pNFLAOK23jIcnyYFHwBEuFZ5oE5tH4P9CtXWAMlC36GJTC
	ZYB/E5hT08kHgIv7eBNfnTpB6LbpwWlyZ77suYU6u713ODtIolLNmnLo+fKTI0G/c6xVbAeoPRsnM
	8wCNoZb6gthv0MwYyrvBSrZCJ+nYFux1v8EeuPFce7mHPLTPevNFwyBevKMOZ7USBCbrLLnvpHIs1
	FHnvRQUvUGz0X+RWF7cOYy6Bb+4Vw0tOqmokzKcC+kW/K4GAaTaBJ16SUCOFxEvGeyZiVCpLfPl0R
	0oAIlgOA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBkzY-00000002as5-1GtA;
	Wed, 30 Sep 2026 00:28:24 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 03/15] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Wed, 30 Sep 2026 00:28:10 -0300
Message-ID: <20260930032822.1835287-4-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930032822.1835287-1-pc@manguebit.org>
References: <20260930032822.1835287-1-pc@manguebit.org>
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
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
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
index 1ada1c0a728d..849cfd2de705 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3560,8 +3560,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
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

