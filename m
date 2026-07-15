Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AD426D4E5
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123776; cv=none; b=PBI4oq8LrEzmC1xHB3VGfiFa7SH7Evbx7JX8gSgznhdgF6B4gyJ45bZJ6VtxanBhfHXF1/ocSu970iHdXbmzBbltuXH5COj3BnxoHuudA2CyTFHCuP+vMZVfDn9UQozFnEqgJ8XRnVMZIRGsfm7sBGxiYUO4S7bkhKyhbkA58zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123776; c=relaxed/simple;
	bh=6b9/kyUrA4JWXaO7IU52Nc22GSnD/rs+kV2rvqRw0Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=se2CwI+C74vmTqj8MVfj3Lb31Z0nt75H4V0xMJYwUL0fHZQXqoUSNAVdGbzjZcE4eOx1aBykuOaLDYMjtmK6+Ct2PwfQD/cbKsKtnJRFk/I0AyvAhQPPH7zvE8aCnoMWDrG1s9pprMdivNf6TatA8TaN+Z2smKDVj9ztcDj2NBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vMM3m7QO; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vMM3m7QO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784123771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ep6uBbtPKojehm6E/Rupt3EjB7rVX9JwDe0lpVRGTk=;
	b=vMM3m7QOs+fvbXjIZb6GF5YDvmj71Vv2zQeGi0jKCFr1XLRbPti/q66doWzILA86Ywfgh4
	dtcEzhGBAa6BIiXNbAzhGheMfcKN1X6aOYDayRWb1CRolAGv259bZmJLQ+g9hNyeG8/JMN
	K7a2A3O5uKSIT/JZ779IQJGaeatLlMRl8893lfL8gl/MVA5g6cZlB6WuAFu4pJ0IvN+Vpj
	WW73n80U98lPpYztJuOTQ6ujAOKuqIJZU0kbxNN5c0Th+zjtbhl7fQ2tpUwF6LsRV9aF7c
	I7h8BLZJYLMPO6XofdeTRQd5J4Ety+NQbwIEHeLwjnBetIEveaoOZsc6x6Hf3g==
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
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 3/3] smb/server: stop new async work when closing connection
Date: Wed, 15 Jul 2026 13:55:13 +0000
Message-ID: <20260715135513.667260-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
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
index 72e1b2b0a6fe..4203771891fd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -799,21 +799,27 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
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
+		pr_err("Failed to setup async work: connection is exiting\n");
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

