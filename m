Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D610A339B41
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782919383; cv=none; b=cmUo8UWQDNAseFA39CMsnK6q2GAecARC/ilp5dYj9NTYg7rMjjY+kImqfFs2/OKHc155pSojozIfPXaDV8XPNnVsEM7rev1s/59HGGoKb4+hXbEBzcy5Bg06KetoW3uFWAH/a/OwWjaO7LNklOMMCpa1VHt9sqVEt0lOUqnLvx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782919383; c=relaxed/simple;
	bh=5WbRNYkkC4np3HVWqn4yYUjaZwQvhKHcsGocLi+IsvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBRk5MBUwVEsgz3zvh7h14v4qVw+3bfCczwuLNTyZgHlLCKRDphZkVy80O0NHB7BlFTToEAYud7OzidSx/Pg1ZajFsUyNEwxzRiLFqxnammCnXJiCYw6YLc56La9Vqew/NGjDByz8LT8D3Ukh0UNYR59h1i+ZgZMVZvZRKuP3Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fYiCaPmm; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fYiCaPmm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782919379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8VMGtv1dpWbZ0icWVqTSCgJcSo6KH96y4oAsih/Bgjc=;
	b=fYiCaPmm1KUaWy1q2HMPDJYX1gfW3stWP31Nud/rtMFPauacqPB186HVFs/k4oW6PUVNli
	t+vvQ8B/NS28c3nXuQeM887agrw2ygNS49FmFbwh4dipIFKE3iVlpU4QaubvfAxcN09Sjp
	mMqAeQgvGRUgnyKii/KniKtxcD6/JvQ=
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
Subject: [PATCH v6 5/5] smb/server: map SET_INFO ENOSPC to disk full
Date: Wed,  1 Jul 2026 23:21:57 +0800
Message-ID: <20260701152157.822207-6-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-1-huiwen.he@linux.dev>
References: <20260701152157.822207-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

FILE_ALLOCATION_INFORMATION can call vfs_fallocate(). If the allocation
cannot be satisfied, vfs_fallocate() returns -ENOSPC.

smb2_set_info() did not map -ENOSPC, so ksmbd returned a generic SMB error
and the client reported EIO instead of ENOSPC. This makes the ENOSPC step
in xfstests generic/213 fail.

Map -ENOSPC and -EFBIG to STATUS_DISK_FULL in the SET_INFO error path.

Tested with xfstests generic/213 on ksmbd.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5859fa68bb84..8bd8f348d0e3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7077,6 +7077,8 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
 	else if (rc == -EMSGSIZE)
 		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
+	else if (rc == -ENOSPC || rc == -EFBIG)
+		rsp->hdr.Status = STATUS_DISK_FULL;
 	else if (rc == -ESHARE)
 		rsp->hdr.Status = STATUS_SHARING_VIOLATION;
 	else if (rc == -ENOENT)
-- 
2.43.0

