Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165613B8920
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498676; cv=none; b=EME69E+GyiXEG+9foS/oxGKPfw6QJsS5G6YFcm0e8E6a3erQ0oeDCmM40GQnBX3XLK3wegx04gooQHk7flo/B3SL1WgwkcNCA8hKQNEliYGAcXQ6IRze6oDpmAkiWfcKp4LYyqiNMjDH4JHjODbm+UCDtBcqoN2SsBczswBw0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498676; c=relaxed/simple;
	bh=DG8Aoo8tB8NsMOn562IQzJHRP6eOSuAYRILKBWEMAN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBJYYkadbSDWuQSlQSp+J2a4E9v6svhhBfk8Eq7cJUIsWnriBLk3t6NHAp1LWjWHGpdtfbECRLF083PdI29YUNUP7wo/UMzjnpoHLAq8k6FToM04q7S9ZUzopx6qz7nsrWkezxA8acfGV+fgopAMg7RBGsFcbOg9IA+r02m1ooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IsUdfAOg; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IsUdfAOg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WQy/XTMUzaNNoYL0lvp5ZWVq+rJUND7SixGVYZG7z5c=;
	b=IsUdfAOgWeVs2bIsmWX6RfO1bNZUlC/GZam8087SbB57jUEUNDC8lr+zR9x1M8S4yTKukV
	EJtGrY9VNbZPBGOy+ZgqTsSH4sYHrO6G6u8dzglUoVH0OSofnfUpqeEgDjxxqRDAEJPK1p
	zIixh9xOx1nJ5F1E0vW/+yl/zQUHoDY=
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
Subject: [PATCH 3/6] smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()
Date: Fri, 31 Jul 2026 11:50:05 +0000
Message-ID: <20260731115008.111211-4-zhang.guodong@linux.dev>
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

See the procedure below:

  ksmbd_launch_ksmbd_durable_scavenger
    durable_scavenger_running = true
    server_conf.dh_task = kthread_run() // fail, dh_task is an ERR_PTR()

  server_ctrl_handle_reset
    ksmbd_stop_durable_scavenger
    kthread_stop(server_conf.dh_task) // invalid pointer

Fixes: d484d621d40f ("ksmbd: add durable scavenger timer")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs_cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 5acd06020d42..a35df2ab59c9 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1618,9 +1618,12 @@ void ksmbd_launch_ksmbd_durable_scavenger(void)
 
 	server_conf.dh_task = kthread_run(ksmbd_durable_scavenger,
 				     (void *)NULL, "ksmbd-durable-scavenger");
-	if (IS_ERR(server_conf.dh_task))
+	if (IS_ERR(server_conf.dh_task)) {
 		pr_err("cannot start conn thread, err : %ld\n",
 		       PTR_ERR(server_conf.dh_task));
+		server_conf.dh_task = NULL;
+		durable_scavenger_running = false;
+	}
 	mutex_unlock(&durable_scavenger_lock);
 }
 
-- 
2.54.0

