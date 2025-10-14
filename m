Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BA430E0E7
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760426468; cv=none; b=hNwZeFuHZeacvVQ8kECGvtzGtKHdpSk5evrBwotqHjJGeLcA4R6tJgsif429RPmwOhyDYALBh1T44cYAdEgIB2DCAw+EqH/9kN8PSZB4Z87jI9DM3zFeLYBoRW8KS/i4qztmpsWe6ahl06dDdOSQJbO45nw079Az55hg19HwTcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760426468; c=relaxed/simple;
	bh=LzJ+/nuwdxTRfBvOPshybE9q6IX8QoFZJsWv+HEV83w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD5EW9K7mkKdoagDp5WRv20AgO/QFkspEuzQAA7WvvpK10lqxKhW4H8CtFvPzQL94XRtB5dEbo/4a3YoghpoMTSWLbxfa8yYBHuGrWIO5ezCVYvqsYhlwzMb2fqOJc6hp6bMIOKcU7ojbd36D9uMDLh9HAilPcGdhKFDa31oqiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WohUWAP9; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WohUWAP9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760426462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=daVXf+TWClFPvubEl10Mc6JK/uKVd72ihrUlJrAgzb0=;
	b=WohUWAP94aX486UmD4qSI6CFo3JT7NcnKH3FhIF1ldnu+hMwUhqy4i+Xa/RjIH667NCE1W
	QEizzT5F0xvZL5XF3zNgZsstUI03nWd6NZ4YpbxhfNSj8Ylb91+RreYADEfdgKAptaEIL2
	qRuXuxW1fqUYbj7fsuM7tdVjrMo6mUM=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 02/22] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Tue, 14 Oct 2025 15:18:57 +0800
Message-ID: <20251014071917.3004573-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Reference count of ksmbd_session will leak when session need reconnect.
Fix this by adding the missing ksmbd_user_session_put().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e81e615f322a..b731d9b09408 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1806,6 +1806,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.43.0

