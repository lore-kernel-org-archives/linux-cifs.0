Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55BF9463
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 00:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784160769; cv=none; b=s9lZhG+BEOwRFK9+PeUcr8+2sppdH00DtYz4Q+oFt9urba0yZld+RK+hi6/kMj7dlVsrhZwC5ajSJvbYma+fDErmQJhdM0B45jEuSI8du55iIZbZsuZZZ1PN9HzZ5wox9Er4ZRvmQhRJmLLvUEWurGC+8riKiBEVYvUf4z5f9iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784160769; c=relaxed/simple;
	bh=ZxFmzx2H+7BDAM9FW09IhJTwCypqO61YQrg+mZjlHQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih3aU2Qb4T7SwJCYTmyTYbcXVmMKJI7bU1QOpD/3nPPCSOtCfXshshWq4IgydloQsI3dmmnCrNnzPz1NFuDaH2m9S/U3m3QyZ0GWHmQ7SO6KSDVLpvZy7vU2BR+JfJaYkvixB3R4aRgO/cMKjXaQ+9hZEo2BWEyW/rf12L6Qa7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vqDwh+0O; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vqDwh+0O"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784160764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jCzaBo95bt1GRdfiIcgEOdrLsvtbMDd9hGJAySnoDo=;
	b=vqDwh+0OrV9inBIGebTqR2vI9yCzWMRWL5Xubz06mxw7JYqwOJhGigH3z7Oe4D1iFrCmly
	To6fJ+xVZk3Bj40Cv7wB2p9PqViMxZor3rmTFhIXkmbQnKBLMmKqI7zFsnJe2tSsjxDs5H
	qfkXKfmUExReX5HKjKrK4L7TOKKOWecDVwosWTl/APsSrKG6AeSemYvlvTkUyEZBeHYCqr
	LQs0RPVsKteg3PyhLugsCOu9Xe9wVLoE7hXLvAer6oQ0sjXqISh36o9NfOblM0Zgjuz/xg
	ItzN1yGL2tVApc8vpfAitv1GbW3L81IQesK9Q7z26CIM/m1uC0NgxW6L096x1Q==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/3] smb/server: stop new async work when closing connection
Date: Thu, 16 Jul 2026 00:11:56 +0000
Message-ID: <20260716001156.671587-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

A new async request may be added while a connection is closing.
The close code may miss this request and wait forever.

Check the connection state before adding the request. Return an error
and release the async ID if the connection is closing.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 966e61788422..b80f0bcf5fc1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -802,21 +802,27 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 		pr_err("Failed to alloc async message id\n");
 		return id;
 	}
-	work->asynchronous = true;
-	work->async_id = id;
 
-	ksmbd_debug(SMB,
-		    "Send interim Response to inform async request id : %d\n",
-		    work->async_id);
+	spin_lock(&conn->request_lock);
+	if (ksmbd_conn_exiting(conn) || ksmbd_conn_releasing(conn)) {
+		spin_unlock(&conn->request_lock);
+		pr_err_ratelimited("Failed to setup async work: connection is exiting\n");
+		ksmbd_release_id(&conn->async_ida, id);
+		return -ESHUTDOWN;
+	}
 
+	work->asynchronous = true;
+	work->async_id = id;
 	work->cancel_fn = fn;
 	work->cancel_argv = arg;
 
-	if (list_empty(&work->async_request_entry)) {
-		spin_lock(&conn->request_lock);
+	if (list_empty(&work->async_request_entry))
 		list_add_tail(&work->async_request_entry, &conn->async_requests);
-		spin_unlock(&conn->request_lock);
-	}
+	spin_unlock(&conn->request_lock);
+
+	ksmbd_debug(SMB,
+		    "Send interim Response to inform async request id : %d\n",
+		    work->async_id);
 
 	return 0;
 }
-- 
2.54.0

