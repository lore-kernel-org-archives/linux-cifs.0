Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1043334AB01
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182887; cv=none; b=sM9Bxr38pmrKEtbux9PjL1rM7Ak65ujceDCMQ+R8RaGKHwCWozbKBKW394KOYpBOaJG4U5DTIFs5uNoOgomPyp2XfkPid3EngzSIE63VslnMP7xHT1SS9F1iYKAdQF/Fdmh25Iw1ryX5R8k4poVkVK4VLapEr+iIYxdN7CuMfEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182887; c=relaxed/simple;
	bh=cttK5TRfeFGbtbJD9YkmuwbKD+L361sn/s4bvl0H4h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGodLE/zWxUT1CjvnBsvBqTIN/t/jhy1mV3V2W8l1Ah7717cJoJX4JdHsljo6mJr0wL/lyAXOW1siwHRkSO4ebcImbraUDyaovQ9n8UDKcz6YL5GOtwUBQTjPndeZqiqcqMwNgvn+McJ/DhKuCRvZh/5P/T86dtquiJTaTlRHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aaHj6clC; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aaHj6clC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwfMunD6/jnKVQF7zCul1buOKbXpGCRaC33eBDCxZL8=;
	b=aaHj6clCDa6vj7cjfvU4U4PvoGAxMvuJsCnh88A5IWhXD6lHBP3e6BNXEy7g7m6dgf+I+3
	4azIi14+29iaqxhzv6cdjbRN3ACBRGQ0hKGFaaAXKs1dk+QII0+W7xnVa/X7PSMzMxE8xv
	7PDSA24XZqwzN/hRYLqJfU44y2t+aNU=
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
Subject: [PATCH 1/7] smb/client: name the default fallocate mode
Date: Tue, 23 Jun 2026 10:46:13 +0800
Message-ID: <20260623024619.1360127-2-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-1-huiwen.he@linux.dev>
References: <20260623024619.1360127-1-huiwen.he@linux.dev>
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

