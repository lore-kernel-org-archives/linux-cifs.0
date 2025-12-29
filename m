Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871C113C9C4
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766974519; cv=none; b=j4ywj2EAJTMHenhCu29+ogYphdBUi6fvTfB0EMS0SBMNvHQ5t/bNAwgfgH2MsFEoG8bR/LhcHgdqxJdJfFZ6aXaBpGjpOk6qph9FHwEPjJUGHyvIgRjKSeivGkVcDHy4je6MDKVsq9x+We6hlGBK5qIezpwBiKsWnppHGBeNM6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766974519; c=relaxed/simple;
	bh=1bCf/IdNXRKvwyR1JoSFmrZI7WoH8e/ZwBJxKevsrc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd+CIIuyz73J87q8Mhzn7MIO0OsHJP2EmEO9jjPaMAD82GPOkxJLr3DeMPsO/IhE9JIjtXZnNIcVWm1VgucxnVWFKmXwEKj/zKDZGrKsC8TUxliIm4pxLxUPHU/+2AviD8kyg+yDZIX1V4CurytGw7XEBRZ6tUlRtmRCTHSPs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R3StI716; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R3StI716"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766974515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KjB4xHIy+WMxlmbWeaHx1UEnom7v8Euj+jlegRAdGw0=;
	b=R3StI716QQBO+wDiU7oCz3TJEMzszjys5kSs7kO11IZ06CdXMXT/V99bO8gYlHecN0ynAx
	yFuY2ZGfJOLaO7P2wMiAzVGD2jbDgV/rPMD2mOHE0p0Zc2Gk+Vo9vsFL8XmzcVZcOQF5NV
	bfQvjRZcHAVsIYVKjLZqq0SQlGnSXWE=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/2] smb/server: fix refcount leak in smb2_open()
Date: Mon, 29 Dec 2025 10:13:30 +0800
Message-ID: <20251229021330.1026506-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
must be released.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a966c696f7d..ed9352753d83 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3007,8 +3007,10 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
-			if (rc)
+			if (rc) {
+				ksmbd_put_durable_fd(fp);
 				goto err_out2;
+			}
 
 			ksmbd_put_durable_fd(fp);
 			goto reconnected_fp;
-- 
2.43.0

