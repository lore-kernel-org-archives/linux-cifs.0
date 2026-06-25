Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792EF3B14D1
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403367; cv=none; b=lnAj6NdmIh+yVjENF2i2tn1k8/TgwYhpVccnmpUIjSoB1BR2jmMncYDFmRoYhfc9BXyN/MrSo4iHU+aixaxFzbgdfhVS7giIO1of6LuN7bqqQL0oM5ITJHrIklfx+wom69X3ZDY0dIDnbYdGs1qoPlc6BR6dEA8tHwgZVqvChqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403367; c=relaxed/simple;
	bh=cttK5TRfeFGbtbJD9YkmuwbKD+L361sn/s4bvl0H4h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdadTOTSp4UAo3swjwQaHifV1JIckj0JS1KAepKeHlaKnhcJkthyzuSrLsRL+snUecgAJ4nXgP63cWAutYtAEBEeMpWJM0EFMmdFkOSb98+EQCr6lfc3z5f7UUlf2XzwD9D5Cr6M7gXDhzfHM7i5uFJE6KRsRxRANsvF3WhuQVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J8p42mLl; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J8p42mLl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782403358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwfMunD6/jnKVQF7zCul1buOKbXpGCRaC33eBDCxZL8=;
	b=J8p42mLl5Z6oGWO0RAmttYMzIOO/p3SXNrSaARvZ2HtJ7pUppJ4l1QK2zf2yAcqAuRTwf+
	Vkfx8aR91bGhFJoeCG4EQi8PzpjajKM5X1c3zoULs6phsFa4vWmoy1proSFZRpbO90wBij
	Xv+RpVUcp9OWn3sCOj1X2PzYx4AMZ5Q=
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
Subject: [PATCH v3 1/9] smb/client: name the default fallocate mode
Date: Fri, 26 Jun 2026 00:01:46 +0800
Message-ID: <20260625160154.104450-2-huiwen.he@linux.dev>
In-Reply-To: <20260625160154.104450-1-huiwen.he@linux.dev>
References: <20260625160154.104450-1-huiwen.he@linux.dev>
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

