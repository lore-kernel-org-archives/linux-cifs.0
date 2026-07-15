Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA7632C94A
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123774; cv=none; b=e6LOoWXAq+iZBWg+rUyTmTq/tC43W8KW869ohDfrmJAeBXzw4ab9D5MaoGLUfwQpmTLRc2YTYePb5yetD4ETBXYLZtXUOmxx6ha42OkIpG2F3cJaYU8l2j410JDZ4w3Lqc8Z6o0o0SdBZ77u0w1h7PfUGtrRQB8J+1S+2WYkcVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123774; c=relaxed/simple;
	bh=g8u5rJv6jpS863xpaHDRfSwyc4RyZssJRP6Mb0KsN3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egwwG3VlqgqoThseZaWREy3oLc9yC3129V54V/h2J4Rh5ZHuM/nuMPA8DcAX7F23iOIM2u8MWuEItmT6Vq8AJlhEXjE2+ilfhZMQyJHzaHx0wY8Ybba5DxgsCK0JUbT2Gn7ug465EV3GLZPCRTp7dH0AlhSZ8ThX9tf11t+fj60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=sOKt3JkJ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="sOKt3JkJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784123763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjfpfmjCrx0sfu2tTqAXkKWmTg8GQuzQUxpp6MbSxHo=;
	b=sOKt3JkJnFDC58wjWmIVv64CcS4yAcuijX828op1LPuLNuyWdaXfcxd7FC5XDtSDMbx61c
	UlEZGnORwQKdKSQP5EeXrNnumLdYJgxYMLAmvnXe8CGEPqEwDmudx4X+/TXiadVWm2fGfo
	dnACY/pA/SEwwQlLU8gz5mGHC2qlJM0RB/4bw/i3Is3wvlY6nbIR3Vt2EYTndE70+Vktta
	q/kiHqB3WN1UwIyR4nyl6g2E5JhOCrQtB3HUDpounQSppr3Sp22rYL+U/2cXGrMXWXdwsf
	gBQv+EBCy3r1yhZJ+75/F+D6na4BxYWHuoVtWxE2JcllcwVn8vejazpRWRudcw==
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
Subject: [PATCH 2/3] smb/server: cancel async requests when closing connection
Date: Wed, 15 Jul 2026 13:55:12 +0000
Message-ID: <20260715135513.667260-3-chenxiaosong@chenxiaosong.com>
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

An async request may still be waiting when a connection is closed.
This can stop the connection from closing.

Cancel active async requests before waiting for them to finish.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 9e8fdb39e5a2..54b9672d7c70 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -291,6 +291,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	wake_up_all(&conn->req_running_q);
 }
 
+static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
+{
+	struct ksmbd_work *work;
+
+	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
+	spin_lock(&conn->request_lock);
+	list_for_each_entry(work, &conn->async_requests,
+			    async_request_entry) {
+		if (work->state != KSMBD_WORK_ACTIVE)
+			continue;
+
+		ksmbd_debug(CONN, "Cancel async request id %d\n",
+			    work->async_id);
+		work->state = KSMBD_WORK_CANCELLED;
+		if (work->cancel_fn)
+			work->cancel_fn(work->cancel_argv);
+	}
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_lock(struct ksmbd_conn *conn)
 {
 	mutex_lock(&conn->srv_mutex);
@@ -564,6 +584,7 @@ int ksmbd_conn_handler_loop(void *p)
 	}
 
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
-- 
2.54.0

