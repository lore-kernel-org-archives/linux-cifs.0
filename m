Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452432F1FE4
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267424; cv=none; b=GD2HhZJfhrX/JZ4aUGRjg2Edg5MyR9fR+v9KR5ZExsmPmYPh2F60UsUjWDsqdoYMQQ41/VDisLsEs7jmH4yMr3I9OLUAwSEUQfZ6gsYw9xjD72efEJTa/LwDpURaBV1mqpDh3fLBhDrIFkhElJEQKX3EGUAjWMmYsZJFY1AzEkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267424; c=relaxed/simple;
	bh=cttK5TRfeFGbtbJD9YkmuwbKD+L361sn/s4bvl0H4h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZvEin3umvRmgOrICgQZr6f9LrrChhn9FNJEEUZKwieDDRyBl6VOdufzhiI4o4UnYd2gHgQZXdBf049Xl0IumPg0abbQXVvmF2vs06BuDOL156wqcvSxXDoLy02IZYZgXiWkEoz++AyWofxfvqXNAv7OqyyMJ8v0fr5aS1i4cP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p/IMu//K; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p/IMu//K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwfMunD6/jnKVQF7zCul1buOKbXpGCRaC33eBDCxZL8=;
	b=p/IMu//KLaBRZQsi7pIrrEQhsAoxBFYhGyt5DsId8eHa25w8kxLOi1MDNjDqQ7fkaFXRyb
	vRW4egufxRicsALQ7xqxlyflPinQNei6B/nEeGRGxpm4MejnouG3nVBWYLAj35nxWaA7JT
	CUih9oYZL0zjetfXe8wZMpY07vIg7NI=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/9] smb/client: name the default fallocate mode
Date: Wed, 24 Jun 2026 10:15:42 +0800
Message-ID: <20260624021550.1548952-2-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

FALLOC_FL_ALLOCATE_RANGE identifies the default fallocate
allocation mode and is defined as zero.

Use the symbolic name instead of a literal zero in
smb3_fallocate() to make the mode dispatch clearer. This
does not change behavior.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a8f8feeeccb5..2964f461fc84 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4071,7 +4071,7 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 		return smb3_collapse_range(file, tcon, off, len);
 	else if (mode == FALLOC_FL_INSERT_RANGE)
 		return smb3_insert_range(file, tcon, off, len);
-	else if (mode == 0)
+	else if (mode == FALLOC_FL_ALLOCATE_RANGE)
 		return smb3_simple_falloc(file, tcon, off, len, false);
 
 	return -EOPNOTSUPP;
-- 
2.43.0

