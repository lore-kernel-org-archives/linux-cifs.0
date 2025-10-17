Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7C2D5C6C
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690868; cv=none; b=NbHLvBhYG+H2kWpGtv96aaOWZQp1DkL/utlDCL7gxQ51cS29v3M+TKn/9gpPfi471zjJ1KJg2uTy9H005COFEB/GZs+8BWnGzeUVjtWdo3yeKiBUOs/Y7uIjan7O46av5CsohsJUnjq1ac+5yr+xNGU7/cxnUF8uQQlJNOH27c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690868; c=relaxed/simple;
	bh=J5jDEy6dWJfTdezTDyrpSiK9Q8q9P9729q0PqTXGExw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFfQ9Jbd7MKb8rcwitXCSm/dUpDEwhPnPEwZnBp81Pk32LdkbnySNLUpm5ZyO/UW4IGs2kLXkEDmWqSwsVcGgXVWs01VWC2rh3wE4Tm8rj4YjU9tHxBv6fJ5O1cONnpB/9U07/mBRtSFcwEGVgf3hL+GYu9+W07vNk7NTfZpFH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xAstrqe5; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xAstrqe5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OHBOYirulXGWUGklwoehPzY2gRDp6I8e8rVR26YDppo=;
	b=xAstrqe5Lgs/P5vHfrAgiKg78f4uTFQd7ZQpEfZaoKPAZS0k0/CzAl+dt/ybOYAMnbdwQ2
	UxFTVO8cqBqeRliJVcRDBMqSnMHov4nZ9f14MtRaFiaLqsEL8mRrWhGJ+deGLaTZVv61bi
	HVYmgFBY0PLHeNPZ4Paa8lJs5TyZM6g=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 3/6] smb/server: fix return value of smb2_query_dir()
Date: Fri, 17 Oct 2025 16:46:07 +0800
Message-ID: <20251017084610.3085644-4-chenxiaosong.chenxiaosong@linux.dev>
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

__process_request() will not print error messages if smb2_query_dir()
always returns 0.

Fix this by returning the correct value at the end of function.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c040df0a2073..dabc3a49bd15 100644
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

