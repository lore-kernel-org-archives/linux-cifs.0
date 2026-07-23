Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF983537CD
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784779954; cv=none; b=UHQ1KbDhVfAnsnbxtm3EtLk3iOd/xNJb/nmHfLweNYnuhY6j66pAT9s6XgJTzBiRtYIfwMDGTh8pGhZ7qI2YB8SJNNA37/kh0eEgG3bBDTvTrYwOOI1H0NDHGryWJToc4MomgMB13WSOIW1+lA6PTo6PFlMkixDs2uAAFOEY8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784779954; c=relaxed/simple;
	bh=gmrogdQbicZMN45sMOq1TtBRAbr0ZRkmQoO0Z5QZInw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeByv3iU36YRfooZdbpPyJ4AwfhOEFiWbuVw2r/gnfBLxixZLXuOzcB0YHcWo6TjQ3tl7iELyTzPiyNbnQqtzMOR5II7xv3tlSf2UN6on9ShNkx2waNPJHHV1qvEs9Z3bo3KHrR8TYFTpLHWZ8jc3SVLCT8chPSDy0ugvZlytQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=uhMFnM5D; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="uhMFnM5D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784779929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGx6UV6+gA9xd8hoZVw9lgweWesBd4atmQllqKlNq98=;
	b=uhMFnM5DoITJFXp/oR6g0oeQ22VYg+xSnvVLfB96vkbYiE8WIfiEVYSFNgjEL2crqqZRzw
	LpyTxsiCmeR3nnFasRSD7M7v3WVkrbQoeb04FGCAGoDOielpNV548mzfxQUp4yemKIAXbo
	DwdYMTgkJg6jIjAI1O1aDdH7mSwJDjm6rsjXkJiGvmcsqBhu+JEQ5mQpG4zvMBlU9ahiy6
	SI/1Eli6E8xl5FdbBa8ik3YMGMa2mdfPhl9FK7L3YVjR2B3wAp/OCsW9UWeKJzvIcnzXnw
	bhYpcygk07Afkk7eJahCymEmp933/pXNQwmBuZJPk7EGGXf5rnicF3EPD4MWVw==
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
Subject: [PATCH v3 3/3] smb/server: stop new async work when closing connection
Date: Thu, 23 Jul 2026 04:11:31 +0000
Message-ID: <20260723041131.313321-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
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
index 54327f8362db..0680222a8da4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1001,21 +1001,27 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
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

