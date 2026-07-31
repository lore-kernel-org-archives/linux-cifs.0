Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24693EC824
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498687; cv=none; b=npbSXNY4zh0f1kXeIn+0Kb9cDc+nXsn8c2X91BsA2wf40M3YT58IAlOtlFJXGfmPTIzkZktaH6GaA1VPCfTr/3L2WQUu4uYQ3XTWNyjhu1zwxVDcgqJ6/hajfdOBv/8AeYATHBaE/XlOef42irjf6lFzYGV1XoD+0jqdm2l6mQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498687; c=relaxed/simple;
	bh=CKZWt5jyPIQqLZjyXZZt0zO4JsWowHNpOwOmOLEUJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek6RI3ZmxNond/1pg6O3bP4jcNosnkrp43kqbm+N0eq6VzLJoKIWsY0fTlzAYRFucOkcGHbztbVoAIdSzbGEFBItm5+JsVLUdKMABJkqpDGOUZagffJ6yHeMpLknHfjKm0bwto8YUd/fNz9Lqr7yXdhPq4LH3wPIEsnkkxCem4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v5z5dAby; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v5z5dAby"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NT2a2DC16QV78szZFV0YiOymX+BArOf+J7Vg7GUrkdk=;
	b=v5z5dAbyABWK9c9/DloY3Fh4H7u28SjDE8QxHjLnmFjc14XlNA5Zg0N+yEi9Bv6DH+qghz
	pWi6t8WRILKCgaQtz5ZK7chS3eSvIBD2IKnyTBzItolAlyyBcy31OKGk2W2bkAkIr0ta2Y
	MtAWuSP0DQ54u0ox9m35pMt9tqN73mI=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 5/6] smb/server: call ksmbd_proc_cleanup() on module init failure
Date: Fri, 31 Jul 2026 11:50:07 +0000
Message-ID: <20260731115008.111211-6-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

When a later initializer fails, the unwind chain releases resources
created after procfs and then jumps directly to class_unregister().
Returning an error from module_init() leaves the proc tree and its
per-CPU counters allocated.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/server.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 19630ac53235..0ccd123ba418 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -630,11 +630,11 @@ static int __init ksmbd_server_init(void)
 
 	ret = server_conf_init();
 	if (ret)
-		goto err_unregister;
+		goto err_proc_cleanup;
 
 	ret = ksmbd_work_pool_init();
 	if (ret)
-		goto err_unregister;
+		goto err_proc_cleanup;
 
 	ret = ksmbd_init_file_cache();
 	if (ret)
@@ -680,6 +680,8 @@ static int __init ksmbd_server_init(void)
 	ksmbd_exit_file_cache();
 err_destroy_work_pools:
 	ksmbd_work_pool_destroy();
+err_proc_cleanup:
+	ksmbd_proc_cleanup();
 err_unregister:
 	class_unregister(&ksmbd_control_class);
 
-- 
2.54.0

