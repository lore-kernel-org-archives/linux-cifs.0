Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E0F26A1AC;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728764; cv=none; b=tOE2AqjLN83il4FmXX+PHpVaXPZneA0Uo+PdBoF5rc+GRldmE6OVwlEtkaZERfhI8c+DxakF1C4TWNHOqw12X0graqSIQwbBgxTjk46sKip+OdTG4a4IIChj8I7qQVCGujhNUbIax2WzufuMbLLjYQMkBWYx2DsQ+WAgHFME+W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728764; c=relaxed/simple;
	bh=ppalraxO26trslZIUDM35/foWuygljZZkPxf+ZVRZRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5De30w+OFJ+8R4pWRKNelHHPYv3eBatP+BQYX1ZJAiyQBXHFK0O8k1nHIsE04kJ7rramXM5qp+0Yf0La/4YG6SmSBM14NPuMPgBnfFPQEpw+s++NPeykci8+UhyTn7sSdoR9hJFSdpXvSQL92XVqeIONyj3CzrN0YbbRMpSU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3jT7tAH6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3jT7tAH6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=kmshqEMkI/3l8T1I8iyPPxLD8jzpS/KS0BMjuQQLDfk=; b=3jT7tAH6JvvzOQU3TwKBPzYXjH
	ujls79/yIYjTlEPbdue8UCB9Db5hnwkBhn4HdFodeP4lLXgi2LEYuvTQ9HLC1xmy0iRfrN6bNGgB8
	XqXrHY/4NezW66V9nGQFcO8dNce3dGOmFikOVHY2vJkGxDIe8mW+h08XB0QlrK44YdUSAWcKmEXlK
	raVa9WvSFXpCN70gkr8qEVdMPSLLKFgsmHmX4iGkvXPUFnmBFF/UJJbuij+lSRdiA8T1TSD7aT5ng
	uu90tfHFYl3SgICfsSX0DHyeELIT4WtRqPauHQ2AwTUsO2dDUudldCK8G7sPRCVSgrcDw+NpJq/VR
	+4sAw3cA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLm-00000002aDT-0iAr;
	Tue, 29 Sep 2026 21:39:10 -0300
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
Subject: [PATCH v2 03/15] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Tue, 29 Sep 2026 21:38:56 -0300
Message-ID: <20260930003908.1703770-4-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
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

