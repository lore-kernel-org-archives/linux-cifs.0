Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067433195FC
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698041; cv=none; b=ghYDsfBtSGGtLUdKDOdMm9QvqMyAT/m7WxO20RuTWRXCFvyYDQoN88+9ndX3kCyIKtEGuN6SyZBiEUxOs9hpppRuIJRe9wD8Fp/pSjBruxs3Cvhj2yKyOG15a+WNlpxJTclpEfL5TXEFrkAvn3jtdkL9gP7/cQSbeTf2RRCLOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698041; c=relaxed/simple;
	bh=VqJHVOFZ5DJNwWqt0hUqYv/FSyzj6l3KwrSTbGbdmVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSIdoaULfelD61uV9hMSTT8fWGf6n2Ap1xrLKf+UOMsXrjf4Y767np7rwJJxiIauWgF9fYS5UYOnvslQngioor2cG5K3htSuzaJHsS+ESMK93yVnMq7jpV9mPnvlvQyTbR2Ap0mqF/dqxND8jFcdH+AD4p3MakfB+nUA7LsGu2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZOMJ6MMv; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZOMJ6MMv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760698038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5EtpvT+zBTCFB3awZnIjhy/RC7yn8lCbwKpgPvLVjg=;
	b=ZOMJ6MMvGMXc6k1+8GQSSCLZ9aA4IVXq3IWIljq9BWs9J0VwP4/JKtYsspzYjtyG3NoPH8
	77ed11ZBruo1wappBJKpXoDfiKaucI8oI0Kg5BHwIPYphwbuvNLtP59nb1wPpxX8uENwM8
	eWovRUSy5MzlEWErStaLbKkSjFJTgeE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/6] smb/server: fix return value of smb2_query_dir()
Date: Fri, 17 Oct 2025 18:46:09 +0800
Message-ID: <20251017104613.3094031-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

__process_request() will not print error messages if smb2_query_dir()
always returns 0.

Fix this by returning the correct value at the end of function.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5b5f25a2eb8a..ff264249f405 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4560,7 +4560,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 	smb2_set_err_rsp(work);
 	ksmbd_fd_put(work, dir_fp);
 	ksmbd_revert_fsids(work);
-	return 0;
+	return rc;
 }
 
 /**
-- 
2.43.0

