Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D22D3EE0
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690862; cv=none; b=iYAjplgYZzmqaLrXQT1t0LRmIaR3l211DFsAXjJmR1rZpva5VqF+2ga56IM9RYH7rdAsZM7fgHr1XGelaD/qbqIQQ9T6nii/7Ep6mCG74T2GOdT46T7E5gUMMbvg4JeAHNizf4Vwtd2kzqgY7dsZRclgr+cLjbsZJbZfwvwWFX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690862; c=relaxed/simple;
	bh=CjX26dHKR3o3Fa7F8XrzqNNhWDzdKttza6bC16IEK2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaQHo3kjats8hVkxQIfElF/ImeH5+Kk40BCUr5ai4FhQSQ093gkBHxLqJ3BadPxI0m7cqqA6H9xSWEfgqbMfN7fJYxgu20eED3iPlkOJb6kIFvypyfOfSElWuXpOd69LF4CCXYaVpOkL50/l5gcueii3neJZFAROkoyVeT7Udwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iynT5OuM; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iynT5OuM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUKub55LO4pkScjbYvCh6eTwpk6yIxN5nwficBztYac=;
	b=iynT5OuM+vPpdZUfN046Vd/q+M8/5CO1ziaPSlxBLHaR+5z732bhzufs8974spJA4Rqc+c
	FFcySELVTwYAG1RcPKiMqKWQ3Oi2VZze9HYrVHKgTjNyH6IjBjgNezIBJUNgR3B+n45R1L
	bnBd1K7nsOQlPsqO7CJtkpfICTJHm5w=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/6] smb/server: fix return value of smb2_read()
Date: Fri, 17 Oct 2025 16:46:05 +0800
Message-ID: <20251017084610.3085644-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

STATUS_END_OF_FILE maps to the linux error -ENODATA. Perhaps in the future
we can move client/smb2maperror.c into common/ and then call
map_smb2_to_linux_error() to get the linux error.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68a..83d8a325b9ea 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6842,7 +6842,7 @@ int smb2_read(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_END_OF_FILE;
 		smb2_set_err_rsp(work);
 		ksmbd_fd_put(work, fp);
-		return 0;
+		return -ENODATA,;
 	}
 
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
-- 
2.43.0

